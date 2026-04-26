#!/usr/bin/env bash
# =============================================================================
# resolve_proto.sh v2 — binary -> source resolver for AliceO2 + O2Physics
# =============================================================================
# Walks all CMakeLists.txt under the given root, parses two macros:
#
#   o2_add_executable(NAME ... [COMPONENT_NAME comp] ... [SOURCES srcs...])
#       -> binary = "o2-" + comp + "-" + NAME    (if comp present)
#                   "o2-" + NAME                 (otherwise)
#
#   o2physics_add_dpl_workflow(NAME ... [SOURCES srcs...])
#       -> binary = "o2-analysis-" + NAME
#       (COMPONENT_NAME is "Analysis" but is install-dir, not runtime prefix)
#
# Output (TSV, stdout): <binary_name>\t<cmake_dir>\t<source_path>
# (one row per source file; multi-source executables produce multiple rows)
#
# Run modes:
#   resolve_proto.sh <ROOT>     scan tree, emit TSV
#   resolve_proto.sh --test     self-test
#   resolve_proto.sh -h         usage
#
# When sourced, only the function is defined.
# =============================================================================

set -u

resolve_proto() {
    local root="$1"
    if [ ! -d "$root" ]; then
        echo "resolve_proto: not a directory: $root" >&2
        return 1
    fi
    local abs
    abs=$(cd "$root" 2>/dev/null && pwd)
    [ -n "$abs" ] || { echo "resolve_proto: cannot resolve: $root" >&2; return 1; }

    find "$abs" -type f -name CMakeLists.txt 2>/dev/null \
    | while IFS= read -r cml; do
        local cmd
        cmd=$(dirname "$cml")
        awk -v CMD="$cmd" '
        # strip CMake comments
        { sub(/[ \t]*#.*$/, "") }
        # accumulate full file
        { buf = buf " " $0 }
        END {
            s = buf
            # handle both macros; non-greedy via [^)]*
            while (match(s, /(o2_add_executable|o2physics_add_dpl_workflow)\([^)]*\)/)) {
                blk = substr(s, RSTART, RLENGTH)
                # detect which macro
                macro = "o2"
                if (blk ~ /^o2physics_add_dpl_workflow/) macro = "o2physics"
                # extract argument list between first "(" and last ")"
                lparen = index(blk, "(")
                inner = substr(blk, lparen + 1, length(blk) - lparen - 1)
                s = substr(s, RSTART + RLENGTH)
                process_block(macro, inner)
            }
        }
        function process_block(macro, b,   n, t, i, tok, name, comp, srclist,
                                            state, j, m, srcs, binary) {
            n = split(b, t, /[ \t\n\r]+/)
            name = ""; comp = ""; srclist = ""; state = "scan"
            for (i = 1; i <= n; i++) {
                tok = t[i]
                if (length(tok) == 0) continue
                if (name == "") { name = tok; continue }
                if (tok == "COMPONENT_NAME") { state = "comp"; continue }
                if (tok == "SOURCES")        { state = "src";  continue }
                # any ALL_CAPS keyword closes the prior list
                if (tok ~ /^[A-Z][A-Z0-9_]*$/) { state = "other"; continue }
                if (state == "comp" && comp == "") { comp = tok; state = "scan"; continue }
                if (state == "src") { srclist = srclist " " tok }
            }
            if (name == "") return
            if (macro == "o2physics") {
                # O2Physics: runtime binary always "o2-analysis-" + first arg
                binary = "o2-analysis-" name
            } else {
                # AliceO2: "o2-" + COMPONENT_NAME + "-" + first arg, or just "o2-" + first arg
                binary = (comp != "") ? "o2-" comp "-" name : "o2-" name
            }
            m = split(srclist, srcs, /[ \t]+/)
            if (m == 0 || (m == 1 && length(srcs[1]) == 0)) {
                printf "%s\t%s\t%s\n", binary, CMD, "(no SOURCES)"
                return
            }
            for (j = 1; j <= m; j++) {
                if (length(srcs[j]) > 0) {
                    printf "%s\t%s\t%s\n", binary, CMD, srcs[j]
                }
            }
        }
        ' "$cml"
    done
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    mkdir -p "$tmp/o2/Detectors/TPC/workflow" \
             "$tmp/o2/Detectors/Calibration" \
             "$tmp/o2physics/DPG/Tasks/AOTTrack/PID/TPC" \
             "$tmp/o2physics/Tools/PIDML"

    # AliceO2 fixtures (mirror the real conventions Marian provided)
    cat > "$tmp/o2/Detectors/TPC/workflow/CMakeLists.txt" <<'EOF'
o2_add_executable(reco-workflow
                  COMPONENT_NAME tpc
                  SOURCES src/tpc-reco-workflow.cxx
                  PUBLIC_LINK_LIBRARIES O2::TPCWorkflow)
o2_add_executable(integrate-cluster-reader-workflow
                  SOURCES src/cluster-integrator-reader.cxx
                  COMPONENT_NAME tpc
                  PUBLIC_LINK_LIBRARIES O2::TPCWorkflow)
EOF

    cat > "$tmp/o2/Detectors/Calibration/CMakeLists.txt" <<'EOF'
o2_add_executable(ccdb-populator-workflow
                  COMPONENT_NAME calibration
                  SOURCES workflow/ccdb-populator-workflow.cxx
                  PUBLIC_LINK_LIBRARIES O2::Framework)
EOF

    # O2Physics fixtures
    cat > "$tmp/o2physics/DPG/Tasks/AOTTrack/PID/TPC/CMakeLists.txt" <<'EOF'
o2physics_add_dpl_workflow(pid-tpc-qa
    SOURCES qaPIDTPC.cxx
    PUBLIC_LINK_LIBRARIES O2Physics::AnalysisCore
    COMPONENT_NAME Analysis)

o2physics_add_dpl_workflow(pid-tpc-qa-mc
    SOURCES qaPIDTPCMC.cxx
    PUBLIC_LINK_LIBRARIES O2Physics::AnalysisCore
    COMPONENT_NAME Analysis)
EOF

    cat > "$tmp/o2physics/Tools/PIDML/CMakeLists.txt" <<'EOF'
o2physics_add_dpl_workflow(pid-ml-producer
                           SOURCES pidMlProducer.cxx
                           JOB_POOL analysis
                           PUBLIC_LINK_LIBRARIES O2::Framework O2Physics::AnalysisCore
                           COMPONENT_NAME Analysis)
EOF

    local out_o2 out_o2p
    out_o2=$(resolve_proto "$tmp/o2")
    out_o2p=$(resolve_proto "$tmp/o2physics")

    echo "=== AliceO2 RESOLVE ==="
    echo "$out_o2"
    echo "=== O2Physics RESOLVE ==="
    echo "$out_o2p"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() {
        if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi
    }

    # AliceO2: binary = "o2-" + COMPONENT_NAME + "-" + name
    check "o2-tpc-reco-workflow resolves to tpc-reco-workflow.cxx" \
        'printf "%s\n" "$out_o2" | grep -qE "^o2-tpc-reco-workflow\t.*\ttpc-reco-workflow\.cxx$" || printf "%s\n" "$out_o2" | grep -qE "^o2-tpc-reco-workflow.*src/tpc-reco-workflow\.cxx$"'
    check "o2-tpc-integrate-cluster-reader-workflow resolved (SOURCES before COMPONENT_NAME)" \
        'printf "%s\n" "$out_o2" | grep -qE "^o2-tpc-integrate-cluster-reader-workflow.*cluster-integrator-reader\.cxx$"'
    check "o2-calibration-ccdb-populator-workflow resolved" \
        'printf "%s\n" "$out_o2" | grep -qE "^o2-calibration-ccdb-populator-workflow.*ccdb-populator-workflow\.cxx$"'

    # O2Physics: binary = "o2-analysis-" + name (NOT "o2-Analysis-...")
    check "o2-analysis-pid-tpc-qa resolved" \
        $'printf "%s\\n" "$out_o2p" | grep -qE \'^o2-analysis-pid-tpc-qa\t.*\tqaPIDTPC\\.cxx$\''
    check "o2-analysis-pid-tpc-qa-mc resolved" \
        $'printf "%s\\n" "$out_o2p" | grep -qE \'^o2-analysis-pid-tpc-qa-mc\t.*\tqaPIDTPCMC\\.cxx$\''
    check "o2-analysis-pid-ml-producer resolved (with JOB_POOL between SOURCES and PUBLIC_LINK_LIBRARIES)" \
        'printf "%s\n" "$out_o2p" | grep -qE "^o2-analysis-pid-ml-producer.*pidMlProducer\.cxx$"'
    check "no spurious o2-Analysis-* (uppercase) leaked from COMPONENT_NAME" \
        '! printf "%s\n" "$out_o2p" | grep -q "o2-Analysis-"'

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"; return 0
    else
        echo "TESTS FAILED"; return 1
    fi
}

usage() {
cat <<'EOF'
Usage:
  resolve_proto.sh <ROOT>     scan tree, emit TSV (binary, cmake_dir, source)
  resolve_proto.sh --test     run self-test
  resolve_proto.sh -h         this message

Handles two macros:
  o2_add_executable          (AliceO2)        binary = o2-<COMPONENT_NAME>-<name>
  o2physics_add_dpl_workflow (O2Physics)      binary = o2-analysis-<name>
EOF
}

if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    case "${1:-}" in
        "")        # back-compat: original used $ALICEO2_ROOT
                   if [ -n "${ALICEO2_ROOT:-}" ]; then
                       resolve_proto "$ALICEO2_ROOT"; exit $?
                   fi
                   usage; exit 1 ;;
        -h|--help) usage; exit 0 ;;
        --test)    run_test; exit $? ;;
        *)         resolve_proto "$1"; exit $? ;;
    esac
fi
