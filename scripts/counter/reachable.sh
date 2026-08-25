#!/usr/bin/env bash
# =============================================================================
# reachable.sh — #include-graph closure walker
# =============================================================================
# Given a seed of source files (.cxx, one absolute path per line) and a root
# directory, walks #include directives recursively across all .h/.hpp/.cxx/
# .cpp files in the root, until no new files are reached or MAX_ITER hit.
#
# Resolution: each #include "X.h" is resolved by basename match against the
# tree's basemap. Multiple paths per basename are normal (different detectors
# share names like Cluster.h); ALL matches are kept — being conservative on
# closure is the correct error.
#
# Inputs:
#   --seed FILE        seed file (output of seed_join.sh --seed)
#   --root DIR         AliceO2 source tree (default: $ALICEO2_ROOT)
#   --max-iter N       max iterations (default: 30)
#   --out FILE         reachable file (one absolute path per line)
#   --iter-log FILE    per-iteration trace (optional)
#
# Run modes:
#   reachable.sh --seed FILE --root DIR --out FILE [--iter-log FILE] [--max-iter N]
#   reachable.sh --test
#   reachable.sh -h | --help
# =============================================================================

set -u

usage() {
cat <<'EOF'
Usage:
  reachable.sh --seed FILE --root DIR --out FILE [options]
  reachable.sh --test
  reachable.sh -h | --help

Required:
  --seed FILE        Seed file (one absolute path per line, output of
                     seed_join.sh --seed)
  --root DIR         AliceO2 source tree to walk (default: $ALICEO2_ROOT)
  --out FILE         Output: one absolute path per line, sorted

Options:
  --iter-log FILE    Per-iteration trace: iter, |frontier|, |reached|, ts
  --max-iter N       Stop after N iterations even if frontier non-empty (30)

Output:
  --out                One absolute path per line, sorted
  stderr               Summary: iters, |reachable|, elapsed, converged

EOF
}

reachable() {
    local seed="$1"
    local root="$2"
    local out="$3"
    local iter_log="${4:-}"
    local max_iter="${5:-30}"

    [ -s "$seed" ] || { echo "reachable: empty/missing seed: $seed" >&2; return 1; }
    [ -d "$root" ] || { echo "reachable: not a directory: $root"  >&2; return 1; }
    local abs
    abs=$(cd "$root" && pwd)

    local tmp
    tmp=$(mktemp -d) || return 1
    trap "rm -rf '$tmp'" RETURN

    local t0
    t0=$(date +%s)

    # 1. Build basename -> abs-path TSV for entire tree.
    echo "reachable: scanning $abs for header/source files..." >&2
    find "$abs" -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.cxx' -o -name '*.cpp' \) 2>/dev/null \
        | awk -F/ '{print $NF "\t" $0}' \
        | LC_ALL=C sort -k1,1 -t$'\t' > "$tmp/basemap"
    echo "reachable: basemap has $(wc -l < "$tmp/basemap" | awk '{print $1}') entries" >&2

    # 2. Initialize frontier from seed (only paths that exist on disk).
    : > "$tmp/frontier"
    while IFS= read -r p; do
        [ -f "$p" ] && printf '%s\n' "$p" >> "$tmp/frontier"
    done < "$seed"
    LC_ALL=C sort -u -o "$tmp/frontier" "$tmp/frontier"
    : > "$tmp/reached"
    [ -n "$iter_log" ] && : > "$iter_log"

    # 3. Iterate until frontier empty or max_iter.
    local iter=0
    while [ -s "$tmp/frontier" ] && [ "$iter" -lt "$max_iter" ]; do
        iter=$((iter+1))
        local nf
        nf=$(wc -l < "$tmp/frontier" | awk '{print $1}')
        local nr
        nr=$(wc -l < "$tmp/reached" | awk '{print $1}')
        echo "reachable: iter $iter  |frontier|=$nf  |reached|=$nr" >&2
        if [ -n "$iter_log" ]; then
            printf 'iter=%d frontier=%d reached=%d ts=%s\n' \
                "$iter" "$nf" "$nr" "$(date -u +%FT%TZ)" >> "$iter_log"
        fi

        # Extract #include directives from frontier.
        # Use while-read instead of `xargs -a -d -r` for BSD/macOS portability.
        : > "$tmp/incs"
        while IFS= read -r f; do
            [ -f "$f" ] && grep -hE '^[[:space:]]*#include[[:space:]]*[<"][^<>"]+[>"]' "$f" 2>/dev/null
        done < "$tmp/frontier" \
        | sed -E 's|^[[:space:]]*#include[[:space:]]*[<"]([^<>"]+)[>"].*|\1|' \
        | awk -F/ '{print $NF}' \
        | LC_ALL=C sort -u > "$tmp/incs"

        # Resolve include basenames -> absolute paths via basemap.
        # Keep all matches (multiple .h with same basename in different dirs).
        if [ -s "$tmp/incs" ]; then
            LC_ALL=C join -t$'\t' -1 1 -2 1 "$tmp/incs" "$tmp/basemap" 2>/dev/null \
                | awk -F'\t' '{print $2}' \
                | LC_ALL=C sort -u > "$tmp/resolved"
        else
            : > "$tmp/resolved"
        fi

        # reached := reached ∪ frontier
        LC_ALL=C sort -u "$tmp/frontier" "$tmp/reached" > "$tmp/reached.next"
        mv "$tmp/reached.next" "$tmp/reached"

        # frontier := resolved \ reached
        LC_ALL=C comm -23 "$tmp/resolved" "$tmp/reached" > "$tmp/frontier.next"
        mv "$tmp/frontier.next" "$tmp/frontier"
    done

    # Final reached file.
    LC_ALL=C sort -u "$tmp/reached" > "$out"

    local converged="YES"
    [ -s "$tmp/frontier" ] && converged="NO"
    local nout
    nout=$(wc -l < "$out" | awk '{print $1}')
    local t1
    t1=$(date +%s)
    local dt=$((t1-t0))

    echo "" >&2
    echo "=== reachable summary ===" >&2
    echo "iterations=$iter" >&2
    echo "max_iter=$max_iter" >&2
    echo "reachable_files=$nout" >&2
    echo "converged=$converged" >&2
    echo "elapsed_sec=$dt" >&2
    echo "out=$out" >&2
    [ -n "$iter_log" ] && echo "iter_log=$iter_log" >&2
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    # Synthetic O2-shaped tree:
    #
    #   src/a.cxx        includes "B.h"        (root file, in seed)
    #   src/b.cxx        includes "C.h"        (NOT in seed, must be discovered via B->b path)
    #   include/B.h      includes "C.h"
    #   include/C.h      includes "D.h" and <vector>
    #   include/D.h      includes nothing
    #   include/E.h      includes "F.h"        (NOT reachable from seed — must NOT appear)
    #   include/F.h      includes nothing       (NOT reachable from seed)
    #
    # Note: there is no automatic .cxx<->.h pairing. b.cxx is reachable only
    # if B.h includes it, which it does not. So b.cxx should NOT be in the
    # output. Real test of basename-only resolution.
    mkdir -p "$tmp/repo/src" "$tmp/repo/include"

    cat > "$tmp/repo/src/a.cxx" <<'EOF'
#include "B.h"
int a() { return 1; }
EOF
    cat > "$tmp/repo/src/b.cxx" <<'EOF'
#include "C.h"
int b() { return 2; }
EOF
    cat > "$tmp/repo/include/B.h" <<'EOF'
#pragma once
#include "C.h"
EOF
    cat > "$tmp/repo/include/C.h" <<'EOF'
#pragma once
#include "D.h"
#include <vector>
EOF
    cat > "$tmp/repo/include/D.h" <<'EOF'
#pragma once
EOF
    cat > "$tmp/repo/include/E.h" <<'EOF'
#pragma once
#include "F.h"
EOF
    cat > "$tmp/repo/include/F.h" <<'EOF'
#pragma once
EOF

    # Seed: just a.cxx
    echo "$tmp/repo/src/a.cxx" > "$tmp/seed"

    reachable "$tmp/seed" "$tmp/repo" "$tmp/out" "$tmp/iter_log" 30 2> "$tmp/stderr"

    echo "=== TEST OUT ==="
    cat "$tmp/out"
    echo "=== TEST ITER LOG ==="
    cat "$tmp/iter_log"
    echo "=== TEST STDERR (last 10 lines) ==="
    tail -10 "$tmp/stderr"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() {
        if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi
    }

    # Reached should be exactly: a.cxx, B.h, C.h, D.h
    # NOT b.cxx (no path from seed), NOT E.h, NOT F.h
    local n
    n=$(wc -l < "$tmp/out" | awk '{print $1}')
    check "exactly 4 files reached"             '[ "$n" = "4" ]'
    check "a.cxx is reachable (seed)"           'grep -qx "$tmp/repo/src/a.cxx" "$tmp/out"'
    check "B.h is reachable (1-hop)"            'grep -qx "$tmp/repo/include/B.h" "$tmp/out"'
    check "C.h is reachable (2-hop)"            'grep -qx "$tmp/repo/include/C.h" "$tmp/out"'
    check "D.h is reachable (3-hop)"            'grep -qx "$tmp/repo/include/D.h" "$tmp/out"'
    check "b.cxx NOT reachable (no inbound)"    '! grep -qx "$tmp/repo/src/b.cxx" "$tmp/out"'
    check "E.h NOT reachable (different tree)"  '! grep -qx "$tmp/repo/include/E.h" "$tmp/out"'
    check "F.h NOT reachable (transitive)"      '! grep -qx "$tmp/repo/include/F.h" "$tmp/out"'
    check "<vector> system header ignored"      '! grep -q "vector" "$tmp/out"'

    # iter log has at least 3 iterations (a -> B -> C -> D -> empty)
    local it
    it=$(wc -l < "$tmp/iter_log" | awk '{print $1}')
    check "iter_log has >=3 iterations"         '[ "$it" -ge 3 ]'

    # converged
    check "converged"                           'grep -q "converged=YES" "$tmp/stderr"'

    # ---- second sub-test: max_iter caps the walk ----
    reachable "$tmp/seed" "$tmp/repo" "$tmp/out2" "" 1 2> "$tmp/stderr2"
    check "max_iter=1 leaves NON-converged"     'grep -q "converged=NO" "$tmp/stderr2"'

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"; return 0
    else
        echo "TESTS FAILED"; return 1
    fi
}

# ---------- CLI ----------
SEED=""; ROOT="${ALICEO2_ROOT:-}"; OUT=""; ITER_LOG=""; MAX_ITER=30

if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
            --seed)     SEED="$2"; shift 2 ;;
            --root)     ROOT="$2"; shift 2 ;;
            --out)      OUT="$2"; shift 2 ;;
            --iter-log) ITER_LOG="$2"; shift 2 ;;
            --max-iter) MAX_ITER="$2"; shift 2 ;;
            --test)     run_test; exit $? ;;
            -h|--help)  usage; exit 0 ;;
            *)          echo "unknown arg: $1" >&2; usage; exit 1 ;;
        esac
    done
    if [ -z "$SEED" ] || [ -z "$ROOT" ] || [ -z "$OUT" ]; then
        usage; exit 1
    fi
    reachable "$SEED" "$ROOT" "$OUT" "$ITER_LOG" "$MAX_ITER"
fi
