#!/usr/bin/env bash
# =============================================================================
# symbols.sh — extract C++ symbols using Universal Ctags
# =============================================================================
# Reads a list of files (one absolute path per line, e.g. reachable.txt) and
# emits a TSV with one row per symbol:
#
#   symbol \t kind \t parent_class \t file \t signature \t line
#
# kind values include:
#   c  class        s  struct      g  enum         u  union
#   f  function     p  prototype   m  member       e  enumerator
#   v  variable     t  typedef     n  namespace    d  macro
#
# Inputs:
#   --files FILE       one absolute path per line (output of reachable.sh)
#   --out FILE         output TSV
#   --ctags PATH       ctags binary (default: ctags; must be Universal Ctags)
#
# Run modes:
#   symbols.sh --files FILE --out FILE [--ctags PATH]
#   symbols.sh --test
#   symbols.sh -h | --help
# =============================================================================

set -u

usage() {
cat <<'EOF'
Usage:
  symbols.sh --files FILE --out FILE [--ctags PATH]
  symbols.sh --test
  symbols.sh -h | --help

Required:
  --files FILE   List of files to scan, one absolute path per line
  --out FILE     Output TSV: symbol, kind, parent_class, file, signature, line

Optional:
  --ctags PATH   Path to Universal Ctags binary
                 (default: ctags; must be 'Universal Ctags', NOT BSD ctags)

Output columns (TAB-separated):
  symbol         e.g. doFit, ConfigurableParam
  kind           c|s|f|p|m|v|t|n|d|...  (single letter from ctags --c-kinds)
  parent_class   class/struct/namespace if applicable, empty otherwise
  file           absolute path to defining file
  signature      function signature including parameters, empty for non-funcs
  line           1-based line number where symbol is defined

The flags used: --c-kinds=+pcsfm  --c++-kinds=+pcsfm  --fields=+aSnt
  +p: prototypes  +c: classes      +s: structs       +f: functions
  +m: members     +S: signature    +n: line          +t: typeref
EOF
}

# Quick BSD-vs-Universal ctags detection.
check_ctags() {
    local ct="$1"
    if ! "$ct" --version 2>&1 | head -1 | grep -q '^Universal Ctags'; then
        echo "symbols.sh: ERROR: '$ct' is not Universal Ctags." >&2
        echo "  Install with: brew install universal-ctags  (macOS)" >&2
        echo "               sudo dnf install ctags         (Alma/RHEL 9)" >&2
        echo "  Then pass --ctags /path/to/universal-ctags if PATH still" >&2
        echo "  resolves to the BSD or older Exuberant ctags." >&2
        return 1
    fi
}

symbols() {
    local files="$1"
    local out="$2"
    local ct="${3:-ctags}"

    [ -s "$files" ] || { echo "symbols: empty/missing file list: $files" >&2; return 1; }
    check_ctags "$ct" || return 1

    # ctags writes a tag file; we then post-process to a stable TSV.
    # u-ctags format is line-based: name\tfile\taddress;"\tkind\tfield:value\t...
    # We extract: name, kind, scope (class/struct/namespace), file, signature, line.
    local tmp
    tmp=$(mktemp -d) || return 1
    trap "rm -rf '$tmp'" RETURN

    # Read file list into an args file ctags can consume via -L.
    cp "$files" "$tmp/L"
    local nfiles
    nfiles=$(wc -l < "$tmp/L" | awk '{print $1}')
    echo "symbols: scanning $nfiles files with $ct ..." >&2

    "$ct" \
        --languages=C,C++ \
        --c-kinds=+pcsfm \
        --c++-kinds=+pcsfm \
        --fields=+aSnt \
        --extras=+q \
        --output-format=u-ctags \
        -L "$tmp/L" \
        -f "$tmp/raw.tags" 2> "$tmp/ctags.err"
    local rc=$?
    if [ "$rc" -ne 0 ]; then
        echo "symbols: ctags returned exit code $rc" >&2
        head -20 "$tmp/ctags.err" >&2
    fi

    # Post-process u-ctags output. Skip header lines beginning with '!_'.
    awk -F'\t' '
    BEGIN { OFS="\t" }
    /^!_/ { next }
    {
        name = $1; file = $2
        kind = ""; scope = ""; sig = ""; line = ""
        for (i = 4; i <= NF; i++) {
            f = $i
            if      (f ~ /^line:/)         { sub(/^line:/,      "", f); line  = f }
            else if (f ~ /^signature:/)    { sub(/^signature:/, "", f); sig   = f }
            else if (f ~ /^class:/)        { sub(/^class:/,     "", f); scope = f }
            else if (f ~ /^struct:/)       { if (scope=="") { sub(/^struct:/,    "", f); scope = f } }
            else if (f ~ /^namespace:/)    { if (scope=="") { sub(/^namespace:/, "", f); scope = f } }
            else if (f ~ /^union:/)        { if (scope=="") { sub(/^union:/,     "", f); scope = f } }
            else if (f ~ /^enum:/)         { if (scope=="") { sub(/^enum:/,      "", f); scope = f } }
            else if (length(f) > 0 && f !~ /:/) { if (kind=="") kind = f }
        }
        if (kind == "") next
        print name, kind, scope, file, sig, line
    }' "$tmp/raw.tags" > "$out"

    local n
    n=$(wc -l < "$out" | awk '{print $1}')
    echo "" >&2
    echo "=== symbols summary ===" >&2
    echo "files_scanned=$nfiles" >&2
    echo "symbols_emitted=$n" >&2
    echo "out=$out" >&2
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    mkdir -p "$tmp/repo/include/MathUtils" "$tmp/repo/include/Detectors"

    cat > "$tmp/repo/include/MathUtils/Tsallis.h" <<'EOF'
#pragma once
namespace o2 { namespace math_utils {

class Tsallis {
 public:
  Tsallis(double q, double T);
  double pdf(double x) const;
  static double normalize(double q);
 private:
  double mQ;
  double mT;
};

double tsallisPDF(double x, double q, double T);
inline double tsallisCDF(double x, double q, double T) { return 0; }

}} // namespace
EOF

    cat > "$tmp/repo/include/Detectors/Foo.h" <<'EOF'
#pragma once
struct PointXY {
  float x;
  float y;
};

void doNothing();
int compute(int a, int b, double weight = 1.0);
EOF

    # Build file list
    find "$tmp/repo" -name '*.h' > "$tmp/files"

    local ct="${CT:-ctags}"
    if ! check_ctags "$ct" 2>/dev/null; then
        echo "SKIP: Universal Ctags not available as '$ct'" >&2
        echo "      set CT=/opt/homebrew/bin/ctags ./symbols.sh --test" >&2
        return 0
    fi

    symbols "$tmp/files" "$tmp/out" "$ct" 2> "$tmp/stderr"

    echo "=== TEST OUT (sorted by name for readability) ==="
    LC_ALL=C sort "$tmp/out"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() {
        if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi
    }

    # Tsallis class
    check "Tsallis class extracted" \
        'awk -F"\t" "\$1==\"Tsallis\" && \$2==\"c\"" "$tmp/out" | grep -q .'

    # Class methods (both with and without const)
    check "Tsallis::pdf method extracted" \
        'awk -F"\t" "\$1==\"pdf\" && \$2==\"p\" || \$1==\"pdf\" && \$2==\"f\"" "$tmp/out" | grep -q .'

    # Static method
    check "Tsallis::normalize static method extracted" \
        'awk -F"\t" "\$1==\"normalize\"" "$tmp/out" | grep -q "Tsallis"'

    # Free functions in namespace
    check "tsallisPDF free function extracted with namespace scope" \
        'awk -F"\t" "\$1==\"tsallisPDF\"" "$tmp/out" | grep -q "math_utils"'
    check "tsallisCDF inline free function extracted" \
        'awk -F"\t" "\$1==\"tsallisCDF\"" "$tmp/out" | grep -q .'

    # Struct + members
    check "PointXY struct extracted" \
        'awk -F"\t" "\$1==\"PointXY\" && \$2==\"s\"" "$tmp/out" | grep -q .'
    check "PointXY::x member extracted" \
        'awk -F"\t" "\$1==\"x\" && \$2==\"m\"" "$tmp/out" | grep -q "PointXY"'

    # Free functions outside namespace
    check "doNothing free function extracted" \
        'awk -F"\t" "\$1==\"doNothing\"" "$tmp/out" | grep -q .'
    check "compute function has signature with default arg" \
        'awk -F"\t" "\$1==\"compute\"" "$tmp/out" | grep -q "weight"'

    # File path is absolute
    check "file path is absolute" \
        'awk -F"\t" "{print \$4}" "$tmp/out" | grep -qE "^/.*/Tsallis\.h$"'

    # Line number is integer
    check "line number is integer" \
        'awk -F"\t" "{print \$6}" "$tmp/out" | grep -qE "^[0-9]+$"'

    # Total symbol count >= 9 (Tsallis class + 3 methods + 2 free fns
    #                          + PointXY struct + 2 members + doNothing + compute)
    local n
    n=$(wc -l < "$tmp/out" | awk '{print $1}')
    check "at least 9 symbols extracted (got $n)" '[ "$n" -ge 9 ]'

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"; return 0
    else
        echo "TESTS FAILED"; return 1
    fi
}

# ---------- CLI ----------
FILES=""; OUT=""; CT="ctags"
if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
            --files)   FILES="$2"; shift 2 ;;
            --out)     OUT="$2";   shift 2 ;;
            --ctags)   CT="$2";    shift 2 ;;
            --test)    run_test; exit $? ;;
            -h|--help) usage; exit 0 ;;
            *)         echo "unknown arg: $1" >&2; usage; exit 1 ;;
        esac
    done
    if [ -z "$FILES" ] || [ -z "$OUT" ]; then
        usage; exit 1
    fi
    symbols "$FILES" "$OUT" "$CT"
fi
