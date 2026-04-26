#!/usr/bin/env bash
# =============================================================================
# parse_o2dpg.sh v3 — extract binary token invocations from O2DPG scripts
# =============================================================================
# Whitelist of file types: only .sh and .py are scanned. Everything else
# (.log, .md, .json, .xml, .C, *.dist-info/*) is noise and is skipped.
# Directories venv/, .git/, node_modules/ are pruned outright.
#
# Output (TSV, stdout): <abs_script_path>\t<category>\t<binary_token>
# Categories (first match wins): MC | QC | calibration | production | other
# Token regex: o2-[a-z][a-z0-9-]* with trailing - stripped.
# Dedupe key: (script_path, token).
#
# Run modes:
#   parse_o2dpg.sh <O2DPG_ROOT>     scan real tree
#   parse_o2dpg.sh --test           self-test
#   parse_o2dpg.sh -h | --help      usage
#
# When sourced, only functions are defined.
# =============================================================================

set -u

# extensions to scan; empty means "all files" (default)
# override via env, comma-separated, no leading dot
# example:  O2DPG_INCLUDE_EXT=sh,py ./parse_o2dpg.sh ...
O2DPG_INCLUDE_EXT="${O2DPG_INCLUDE_EXT:-}"
# directory names to prune; override via env
O2DPG_EXCLUDE_DIRS="${O2DPG_EXCLUDE_DIRS:-venv,.git,node_modules,.cache,__pycache__}"
# file glob patterns to exclude; override via env
O2DPG_EXCLUDE_GLOBS="${O2DPG_EXCLUDE_GLOBS:-*.dist-info,*.egg-info}"

categorize_path() {
    case "$1" in
        */MC/*|MC/*)                  echo "MC" ;;
        */QC/*|QC/*)                  echo "QC" ;;
        */calib/*|*/Calib[a-zA-Z]*/*) echo "calibration" ;;
        */production/*)               echo "production" ;;
        *)                            echo "other" ;;
    esac
}

# build grep --include and --exclude-dir args from env vars
_build_grep_filters() {
    local IFS=','
    local ext
    if [ -n "$O2DPG_INCLUDE_EXT" ]; then
        for ext in $O2DPG_INCLUDE_EXT; do
            printf -- '--include=*.%s\0' "$ext"
        done
    fi
    local d
    for d in $O2DPG_EXCLUDE_DIRS; do
        printf -- '--exclude-dir=%s\0' "$d"
    done
    local g
    for g in $O2DPG_EXCLUDE_GLOBS; do
        printf -- '--exclude=%s\0' "$g"
    done
}

parse_o2dpg() {
    local root="$1"
    if [ ! -d "$root" ]; then
        echo "parse_o2dpg: not a directory: $root" >&2
        return 1
    fi
    local abs_root
    abs_root=$(cd "$root" 2>/dev/null && pwd)
    [ -n "$abs_root" ] || { echo "parse_o2dpg: cannot resolve: $root" >&2; return 1; }

    # Collect filter args via NUL-delimited mapfile-equivalent for bash 3.2 compat
    local -a filters=()
    while IFS= read -r -d '' arg; do
        filters+=("$arg")
    done < <(_build_grep_filters)

    grep -rIEHo "${filters[@]}" 'o2-[a-z][a-z0-9-]*' "$abs_root" 2>/dev/null \
    | awk '
    {
        if (!match($0, /:o2-[a-z][a-z0-9-]*$/)) next
        path = substr($0, 1, RSTART - 1)
        tok  = substr($0, RSTART + 1)
        sub(/-$/, "", tok)
        if (tok == "") next

        if      (path ~ /(^|\/)MC\//)            cat = "MC"
        else if (path ~ /(^|\/)QC\//)            cat = "QC"
        else if (path ~ /(^|\/)calib\//)         cat = "calibration"
        else if (path ~ /\/Calib[a-zA-Z]+\//)    cat = "calibration"
        else if (path ~ /(^|\/)production\//)    cat = "production"
        else                                     cat = "other"

        key = path SUBSEP tok
        if (!seen[key]++) print path "\t" cat "\t" tok
    }' \
    | sort
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp failed" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    mkdir -p "$tmp/DATA/production/configurations" \
             "$tmp/DATA/production/calib" \
             "$tmp/MC/run/ANCHOR" \
             "$tmp/MC/bin" \
             "$tmp/QC/run" \
             "$tmp/scripts" \
             "$tmp/UTILS/dfextensions" \
             "$tmp/venv/lib/python3.9/site-packages/setuptools-68.2.0.dist-info" \
             "$tmp/.git/refs"

    # KEEP: shell scripts
    cat > "$tmp/DATA/production/configurations/async_pass.sh" <<'EOF'
#!/bin/bash
o2-tpc-reco-workflow --shm-segment-size 16000000000 \
  | o2-tpcits-match-workflow --shm-segment-size 16000000000 \
  | o2-ctf-writer-workflow
EOF

    cat > "$tmp/DATA/production/calib/tpc_calib.sh" <<'EOF'
#!/bin/bash
add_W o2-tpc-vdrift-tgl-calibration-workflow
add_W o2-tpc-scdcalib-interpolation-workflow
o2-tpc-vdrift-tgl-calibration-workflow --foo
EOF

    cat > "$tmp/MC/run/ANCHOR/anchorMC.sh" <<'EOF'
#!/bin/bash
o2-sim --modules PIPE,ITS,TPC
o2-sim-digitizer-workflow
EOF

    cat > "$tmp/QC/run/qc-tpc.sh" <<'EOF'
#!/bin/bash
o2-qc --config json://qc.json
EOF

    cat > "$tmp/scripts/utils.sh" <<'EOF'
#!/bin/bash
o2-helper-tool
EOF

    cat > "$tmp/scripts/edge.sh" <<'EOF'
echo "o2-bar-baz-"
EOF

    # KEEP: Python orchestrator
    cat > "$tmp/MC/bin/o2dpg_sim_workflow.py" <<'EOF'
#!/usr/bin/env python3
# orchestrator
cmd = "o2-sim-dpl-eventgen --jobs 8"
cmd2 = "o2-tpc-chunkeddigit-merger --foo"
EOF

    # DROP: log file
    cat > "$tmp/UTILS/dfextensions/gitlog.log" <<'EOF'
commit abc123 mentions o2-noisy-log-token
old build artifact references o2-historical-tool
EOF

    # DROP: README markdown
    cat > "$tmp/MC/README.md" <<'EOF'
# Documentation
This README mentions o2-doc-noise-tool but does not invoke it.
EOF

    # DROP: JSON config (hostnames)
    cat > "$tmp/QC/run/qc-tpc.json" <<'EOF'
{
  "host": "o2-cr1-hv-aliecs",
  "fallback": "o2-cr1-qme02"
}
EOF

    # DROP: ROOT macro
    cat > "$tmp/MC/Generator.C" <<'EOF'
// run with: o2-sim --jobs 4
void Generator() {}
EOF

    # DROP: file in venv/  (Python file — would otherwise match .py whitelist)
    cat > "$tmp/venv/lib/python3.9/site-packages/setuptools-68.2.0.dist-info/RECORD" <<'EOF'
o2-venv-noise
EOF
    cat > "$tmp/venv/lib/python3.9/site-packages/something.py" <<'EOF'
# venv .py, must be skipped by --exclude-dir=venv
o2-venv-py-token
EOF

    # DROP: file in .git/
    cat > "$tmp/.git/refs/o2-thing.txt" <<'EOF'
o2-git-noise-token
EOF

    # binary file
    printf '\x00\x01o2-fake-binary\x02\x00' > "$tmp/blob.bin"

    local out
    out=$(parse_o2dpg "$tmp")

    echo "=== TEST OUTPUT ==="
    echo "$out"
    echo "=== TEST CHECKS ==="

    local fail=0
    local got_count
    got_count=$(printf '%s\n' "$out" | grep -c $'\t' || true)
    # v4 default: scan everything except venv/.git/node_modules/dist-info.
    # That means .log .md .json .C are ALL scanned now.
    # 12 prior + 2 from .log + 1 from .md + 2 from .json + 1 from .C = 18
    local expected=18
    if [ "$got_count" = "$expected" ]; then
        echo "PASS: row count = $got_count"
    else
        echo "FAIL: row count = $got_count, expected $expected"
        fail=1
    fi

    check_grep() {
        if printf '%s\n' "$out" | grep -qE "$2"; then
            echo "PASS: $1"
        else
            echo "FAIL: $1  (pattern not found: $2)"
            fail=1
        fi
    }
    check_no_grep() {
        if printf '%s\n' "$out" | grep -qE "$2"; then
            echo "FAIL: $1  (forbidden pattern found: $2)"
            fail=1
        else
            echo "PASS: $1"
        fi
    }

    # invocations preserved
    check_grep    "production category for async_pass.sh"           $'async_pass\\.sh\tproduction\to2-tpc-reco-workflow$'
    check_grep    "calibration preferred over production (nested)"  $'tpc_calib\\.sh\tcalibration\t'
    check_grep    "MC category"                                     $'anchorMC\\.sh\tMC\t'
    check_grep    "QC category from qc-tpc.sh"                      $'qc-tpc\\.sh\tQC\to2-qc$'
    check_grep    "other category for unclassified path"            $'utils\\.sh\tother\t'
    check_grep    "trailing-dash stripped: o2-bar-baz"              'o2-bar-baz$'
    check_grep    "Python orchestrator scanned: o2-sim-dpl-eventgen" $'o2dpg_sim_workflow\\.py\tMC\to2-sim-dpl-eventgen$'
    check_grep    "Python orchestrator scanned: o2-tpc-chunkeddigit" $'o2dpg_sim_workflow\\.py\tMC\to2-tpc-chunkeddigit-merger$'

    # v4: scan everything; catalogue join filters later
    check_grep    ".log file scanned (catalogue will filter)"      'gitlog\.log.*o2-noisy-log-token'
    check_grep    ".md README scanned (catalogue will filter)"     'README\.md.*o2-doc-noise-tool'
    check_grep    ".json config scanned (catalogue will filter)"   'qc-tpc\.json.*o2-cr1-'
    check_grep    ".C ROOT macro scanned (catalogue will filter)"  'Generator\.C.*o2-sim'

    # but pure-garbage directories still pruned
    check_no_grep "venv/ directory pruned"                         'o2-venv-py-token|o2-venv-noise'
    check_no_grep ".git/ directory pruned"                         'o2-git-noise-token'
    check_no_grep "binary file skipped"                            'o2-fake-binary'
    check_no_grep "no trailing-dash tokens"                        '\to2-[a-z0-9-]+-$'

    local calib_rows
    calib_rows=$(printf '%s\n' "$out" | grep -c 'tpc_calib\.sh' || true)
    if [ "$calib_rows" = "2" ]; then
        echo "PASS: tpc_calib.sh emitted 2 rows (deduped)"
    else
        echo "FAIL: tpc_calib.sh emitted $calib_rows rows, expected 2"
        fail=1
    fi

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"
        return 0
    else
        echo "TESTS FAILED"
        return 1
    fi
}

usage() {
cat <<EOF
Usage:
  parse_o2dpg.sh <O2DPG_ROOT>     scan real tree, emit TSV to stdout
  parse_o2dpg.sh --test           run self-test
  parse_o2dpg.sh -h | --help      this message

Output columns (TAB-separated):
  script_path   absolute path
  category      MC | QC | calibration | production | other
  binary_token  e.g. o2-tpc-reco-workflow

File-type whitelist:  \$O2DPG_INCLUDE_EXT  (default: empty = scan all files)
Directory blacklist:  \$O2DPG_EXCLUDE_DIRS (default: venv,.git,node_modules,.cache,__pycache__)
File-glob blacklist:  \$O2DPG_EXCLUDE_GLOBS (default: *.dist-info,*.egg-info)

Default policy: scan everything; let the AliceO2 catalogue join filter
non-existent binaries (hostnames, doc references, historical names).

Override examples:
  O2DPG_INCLUDE_EXT=sh,py ./parse_o2dpg.sh \$O2DPG_ROOT
  O2DPG_EXCLUDE_DIRS=venv,.git,build ./parse_o2dpg.sh \$O2DPG_ROOT
EOF
}

if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    case "${1:-}" in
        "")        usage; exit 1 ;;
        -h|--help) usage; exit 0 ;;
        --test)    run_test; exit $? ;;
        *)         parse_o2dpg "$1"; exit $? ;;
    esac
fi
