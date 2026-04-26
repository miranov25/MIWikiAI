#!/usr/bin/env bash
# =============================================================================
# seed_join.sh — join O2DPG invocations with AliceO2 (+ O2Physics) catalogue
# =============================================================================
# Inputs:
#   --invocations FILE   TSV: script_path \t category \t binary_token
#                        (output of parse_o2dpg.sh)
#   --catalogue   FILE   TSV: binary_token \t cmake_dir \t source_path
#                        (output of resolve_proto.sh; concat O2 + O2Physics)
#
# Outputs:
#   stdout                 joined provenance, 5 cols TSV:
#                          script \t category \t binary \t cmake_dir \t source
#   --unresolved FILE      tokens in invocations but not in catalogue (1 per line)
#   --seed FILE            unique source_paths from catalogue side (the actual seed)
#   stderr                 summary stats
#
# Run modes:
#   seed_join.sh --invocations <tsv> --catalogue <tsv> [--unresolved <f>] [--seed <f>]
#   seed_join.sh --test
#   seed_join.sh -h | --help
# =============================================================================

set -u

usage() {
cat <<'EOF'
Usage:
  seed_join.sh --invocations FILE --catalogue FILE [--unresolved FILE] [--seed FILE]
  seed_join.sh --test
  seed_join.sh -h | --help

Inputs (required):
  --invocations FILE   TSV from parse_o2dpg.sh: script \t category \t binary
  --catalogue   FILE   TSV from resolve_proto.sh: binary \t cmake_dir \t source

Outputs:
  stdout               joined provenance (5 cols TSV)
  --unresolved FILE    one binary token per line, not found in catalogue
  --seed FILE          unique source paths (the seed for `reachable` stage)
  stderr               summary

Catalogue can be the concatenation of multiple resolves (O2 + O2Physics):
  cat catalogue_o2.tsv catalogue_o2physics.tsv > catalogue_all.tsv
  seed_join.sh --invocations o2dpg_invocations.tsv \
               --catalogue   catalogue_all.tsv \
               --unresolved  unresolved.txt \
               --seed        seed.txt \
             > seed_provenance.tsv
EOF
}

seed_join() {
    local inv="$1"
    local cat="$2"
    local unresolved_out="${3:-}"
    local seed_out="${4:-}"

    [ -s "$inv" ] || { echo "seed_join: empty/missing invocations: $inv" >&2; return 1; }
    [ -s "$cat" ] || { echo "seed_join: empty/missing catalogue: $cat" >&2; return 1; }

    # Sort both inputs by their join key (TAB-separated).
    # Invocations: token is column 3.
    # Catalogue:   token is column 1.
    local tmp
    tmp=$(mktemp -d) || return 1
    trap "rm -rf '$tmp'" RETURN

    LC_ALL=C sort -t$'\t' -k3,3 "$inv" > "$tmp/inv.sorted"
    LC_ALL=C sort -t$'\t' -k1,1 "$cat" > "$tmp/cat.sorted"

    # Join. Emit: script, category, token, cmake_dir, source
    # -t TAB, -1 3 (invocations key), -2 1 (catalogue key)
    # -o "1.1 1.2 1.3 2.2 2.3"
    LC_ALL=C join -t$'\t' -1 3 -2 1 \
        -o '1.1,1.2,1.3,2.2,2.3' \
        "$tmp/inv.sorted" "$tmp/cat.sorted"

    # Stats + side outputs.
    # All distinct invocation tokens.
    local n_inv_total n_inv_uniq_tok n_cat_uniq_tok n_matched_tok n_unmatched_tok
    n_inv_total=$(wc -l < "$inv" | awk '{print $1}')
    n_inv_uniq_tok=$(LC_ALL=C cut -f3 "$inv" | sort -u | wc -l | awk '{print $1}')
    n_cat_uniq_tok=$(LC_ALL=C cut -f1 "$cat" | sort -u | wc -l | awk '{print $1}')

    LC_ALL=C cut -f3 "$inv" | sort -u > "$tmp/inv.tokens"
    LC_ALL=C cut -f1 "$cat" | sort -u > "$tmp/cat.tokens"
    LC_ALL=C comm -23 "$tmp/inv.tokens" "$tmp/cat.tokens" > "$tmp/unresolved.tokens"

    n_unmatched_tok=$(wc -l < "$tmp/unresolved.tokens" | awk '{print $1}')
    n_matched_tok=$((n_inv_uniq_tok - n_unmatched_tok))

    if [ -n "$unresolved_out" ]; then
        cp "$tmp/unresolved.tokens" "$unresolved_out"
    fi

    if [ -n "$seed_out" ]; then
        # Re-do the join to get cmake_dir + source columns; combine into
        # absolute path; dedupe.
        LC_ALL=C join -t$'\t' -1 3 -2 1 -o '2.2,2.3' \
            "$tmp/inv.sorted" "$tmp/cat.sorted" \
        | awk -F'\t' '{print $1 "/" $2}' \
        | sort -u > "$seed_out"
    fi

    {
        echo "=== seed_join summary ==="
        echo "invocation_rows_total=$n_inv_total"
        echo "invocation_unique_tokens=$n_inv_uniq_tok"
        echo "catalogue_unique_tokens=$n_cat_uniq_tok"
        echo "matched_tokens=$n_matched_tok"
        echo "unmatched_tokens=$n_unmatched_tok"
        if [ -n "$seed_out" ]; then
            echo "seed_unique_sources=$(wc -l < "$seed_out" | awk '{print $1}')"
            echo "seed_file=$seed_out"
        fi
        if [ -n "$unresolved_out" ]; then
            echo "unresolved_file=$unresolved_out"
        fi
    } >&2
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    # invocations: 3 real tokens + 2 noise tokens
    cat > "$tmp/inv.tsv" <<'EOF'
/x/DATA/production/async_pass.sh	production	o2-tpc-reco-workflow
/x/DATA/production/async_pass.sh	production	o2-ctf-writer-workflow
/x/DATA/production/calib/laser.sh	calibration	o2-tpc-reco-workflow
/x/DATA/production/qc-sync/its.json	production	o2-cr1-hv-aliecs
/x/DATA/common/setenv.sh	other	o2-bogus-token
EOF

    # catalogue: 3 binaries (one with 2 sources), no entries for noise
    cat > "$tmp/cat.tsv" <<'EOF'
o2-tpc-reco-workflow	/o2/Detectors/TPC/workflow	src/tpc-reco-workflow.cxx
o2-ctf-writer-workflow	/o2/Detectors/CTF/workflow	src/ctf-writer-workflow.cxx
o2-tpc-reco-workflow	/o2/Detectors/TPC/workflow	src/tpc-reco-extra.cxx
EOF

    local out unresolved seed
    out=$(seed_join "$tmp/inv.tsv" "$tmp/cat.tsv" "$tmp/unresolved.txt" "$tmp/seed.txt" 2> "$tmp/stats")
    unresolved=$(cat "$tmp/unresolved.txt")
    seed=$(cat "$tmp/seed.txt")

    echo "=== TEST OUT (joined provenance) ==="
    echo "$out"
    echo "=== TEST UNRESOLVED ==="
    echo "$unresolved"
    echo "=== TEST SEED ==="
    echo "$seed"
    echo "=== TEST STATS ==="
    cat "$tmp/stats"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() {
        if eval "$2"; then
            echo "PASS: $1"
        else
            echo "FAIL: $1"
            fail=1
        fi
    }

    # joined rows expected:
    # async_pass.sh + o2-tpc-reco-workflow x 2 sources = 2
    # async_pass.sh + o2-ctf-writer-workflow x 1 = 1
    # laser.sh      + o2-tpc-reco-workflow x 2 = 2
    # noise tokens drop entirely
    # total = 5
    local n
    n=$(printf '%s\n' "$out" | grep -c $'\t')
    check "5 joined rows (Cartesian over multi-source binary)"  '[ "$n" = "5" ]'
    check "joined contains tpc-reco from TPC dir"               'printf "%s\n" "$out" | grep -q "TPC/workflow"'
    check "joined contains ctf-writer from CTF dir"             'printf "%s\n" "$out" | grep -q "CTF/workflow"'
    check "joined drops o2-cr1-hv-aliecs (no catalogue match)"  '! printf "%s\n" "$out" | grep -q "o2-cr1-hv-aliecs"'
    check "joined drops o2-bogus-token (no catalogue match)"    '! printf "%s\n" "$out" | grep -q "o2-bogus-token"'

    # unresolved exactly { o2-cr1-hv-aliecs, o2-bogus-token }
    check "unresolved has o2-cr1-hv-aliecs"  'printf "%s\n" "$unresolved" | grep -qx "o2-cr1-hv-aliecs"'
    check "unresolved has o2-bogus-token"    'printf "%s\n" "$unresolved" | grep -qx "o2-bogus-token"'
    local nu
    nu=$(printf '%s\n' "$unresolved" | grep -c .)
    check "unresolved count = 2"             '[ "$nu" = "2" ]'

    # seed: unique absolute paths (cmake_dir + "/" + source) from joined rows
    # = 3 distinct: TPC/.../tpc-reco-workflow.cxx, TPC/.../tpc-reco-extra.cxx,
    #   CTF/.../ctf-writer-workflow.cxx
    local ns
    ns=$(printf '%s\n' "$seed" | grep -c .)
    check "seed has 3 unique absolute paths"            '[ "$ns" = "3" ]'
    check "seed paths are absolute (start with cmake_dir)"   'printf "%s\n" "$seed" | grep -q "^/o2/Detectors/TPC/workflow/src/tpc-reco-workflow\.cxx$"'

    # stats
    check "stats reports 5 invocation rows"           'grep -q "invocation_rows_total=5" "$tmp/stats"'
    check "stats reports 4 unique invocation tokens"  'grep -q "invocation_unique_tokens=4" "$tmp/stats"'
    check "stats reports 2 catalogue tokens"          'grep -q "catalogue_unique_tokens=2" "$tmp/stats"'
    check "stats reports 2 matched tokens"            'grep -q "matched_tokens=2" "$tmp/stats"'
    check "stats reports 2 unmatched tokens"          'grep -q "unmatched_tokens=2" "$tmp/stats"'

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"
        return 0
    else
        echo "TESTS FAILED"
        return 1
    fi
}

# ---------- CLI dispatch ----------
INV=""; CAT=""; UNRES=""; SEED=""
if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
            --invocations) INV="$2"; shift 2 ;;
            --catalogue)   CAT="$2"; shift 2 ;;
            --unresolved)  UNRES="$2"; shift 2 ;;
            --seed)        SEED="$2"; shift 2 ;;
            --test)        run_test; exit $? ;;
            -h|--help)     usage; exit 0 ;;
            *)             echo "unknown arg: $1" >&2; usage; exit 1 ;;
        esac
    done
    if [ -z "$INV" ] || [ -z "$CAT" ]; then
        usage; exit 1
    fi
    seed_join "$INV" "$CAT" "$UNRES" "$SEED"
fi
