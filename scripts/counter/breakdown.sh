#!/usr/bin/env bash
# =============================================================================
# breakdown.sh — usage.csv sidecar: top-K files per top-N symbol
# =============================================================================
#
# For diagnosing whether a high prod_usage_count reflects real usage or noise.
# Per F3 of cycle-1b panel review: without this, F0 (GPU macros), F2 (header-
# basename collision), and F-stoplist findings cannot be told apart from
# real signal.
#
# Inputs:
#   --usage FILE         usage.csv from count.sh
#   --reachable FILE     reachable.txt
#   --symbols FILE       symbols.tsv (for bare/qualified merge mapping)
#   --out FILE           breakdown.tsv: symbol \t file \t match_count
#   --top-symbols N      analyze top-N symbols by prod_usage_count (default 50)
#   --top-files K        list top-K files per symbol (default 10)
#   --grep TOOL          rg|grep (default: rg if installed, else grep)
#
# Run modes:
#   breakdown.sh --usage usage.csv --reachable reachable.txt --symbols symbols.tsv --out breakdown.tsv [options]
#   breakdown.sh --test
#   breakdown.sh -h | --help
#
# Output: TSV with three columns (symbol, file, match_count). For each of the
# top-N symbols, the top-K files contributing to its count, sorted descending.
# =============================================================================

set -u

usage() {
cat <<'EOF'
Usage:
  breakdown.sh --usage FILE --reachable FILE --symbols FILE --out FILE [opts]
  breakdown.sh --test
  breakdown.sh -h | --help

Required:
  --usage     FILE   usage.csv from count.sh
  --reachable FILE   reachable.txt
  --symbols   FILE   symbols.tsv (for ctags name-form merge)
  --out       FILE   output TSV: symbol \t file \t match_count

Optional:
  --top-symbols N    analyze top-N symbols by prod_usage_count (default 50)
  --top-files K      list top-K files per symbol  (default 10)
  --grep TOOL        rg|grep (default: rg if installed, else grep)

Output: per top-N symbol, the top-K reachable files referencing it,
sorted by match count descending. Used to diagnose whether high counts
come from real usage or from #include lines / common-noun shadowing.
EOF
}

detect_grep() {
    if [ -n "${GREPTOOL:-}" ]; then echo "$GREPTOOL"
    elif command -v rg >/dev/null 2>&1; then echo "rg"
    else echo "grep"
    fi
}

breakdown() {
    local usage="$1"
    local reachable="$2"
    local symbols="$3"
    local out="$4"
    local top_n="$5"
    local top_k="$6"
    local tool="$7"

    [ -s "$usage"     ] || { echo "breakdown: empty usage.csv"   >&2; return 1; }
    [ -s "$reachable" ] || { echo "breakdown: empty reachable"   >&2; return 1; }
    [ -s "$symbols"   ] || { echo "breakdown: empty symbols.tsv" >&2; return 1; }

    local tmp
    tmp=$(mktemp -d) || return 1
    trap "rm -rf '$tmp'" RETURN

    # 1. Pick top-N symbols from usage.csv by prod_usage_count, AND
    # ALL ambiguous symbols (R-2 fix: ambiguous rows have count=-1 and so
    # never made it into the top-N picker; but ambiguous is exactly the case
    # where breakdown.tsv is most needed, so we always include them).
    # Use python for robust CSV parsing (signature column may have commas).
    python3 - "$usage" "$top_n" > "$tmp/top_symbols.tsv" <<'PYEOF'
import csv, sys
path, n = sys.argv[1], int(sys.argv[2])
rows=[]
ambig=[]
with open(path, newline='') as f:
    for r in csv.DictReader(f):
        try:    cnt = int(r['prod_usage_count'])
        except: cnt = 0
        # Track ambiguous rows separately
        if r.get('name_uniqueness','') == 'ambiguous':
            ambig.append( (cnt, r['symbol'], r['header']) )
        else:
            rows.append( (cnt, r['symbol'], r['header']) )
rows.sort(reverse=True)
selected = rows[:n] + ambig            # ambig appended; dedup not needed
                                       # since ambig != non-ambig by construction
for cnt, sym, hdr in selected:
    print(f"{sym}\t{hdr}\t{cnt}")
PYEOF

    local n_top
    n_top=$(wc -l < "$tmp/top_symbols.tsv" | awk '{print $1}')
    echo "breakdown: $n_top top symbols selected" >&2

    # 2. For each symbol, look up all ctags name-forms in symbols.tsv (so we
    # search for both bare and qualified, matching count.sh's F1 merge).
    awk -F'\t' '
        # Pass 1: top symbols (bare \t header \t count)
        FNR==NR {
            # We index by bare and accept any ctags row whose terminal ::
            # component matches. Also keep track of (bare, header) to
            # disambiguate when same bare name appears in multiple headers.
            top_bare[$1] = 1
            top_hdr[$1 "\t" $2] = $3
            next
        }
        # Pass 2: symbols.tsv (name \t kind \t parent \t file \t sig \t line)
        {
            name=$1; file=$4
            n=split(name, parts, "::")
            bare=parts[n]
            if (top_bare[bare] && (bare "\t" file) in top_hdr) {
                # Emit name-form for this top symbol
                print bare "\t" file "\t" name
            }
        }
    ' "$tmp/top_symbols.tsv" "$symbols" \
        | LC_ALL=C sort -u > "$tmp/forms.tsv"

    awk -F'\t' '{print $3}' "$tmp/forms.tsv" | LC_ALL=C sort -u > "$tmp/patterns"
    echo "breakdown: $(wc -l < "$tmp/patterns" | awk '{print $1}') patterns to search" >&2

    # 3. Run inverted-loop search: file:matched_token across reachable.
    if [ "$tool" = "rg" ]; then
        xargs -n 200 rg -wFo -f "$tmp/patterns" --no-line-number --with-filename --no-heading \
            < "$reachable" 2>/dev/null > "$tmp/raw"
    else
        xargs -n 200 grep -wFo -f "$tmp/patterns" -H \
            < "$reachable" 2>/dev/null > "$tmp/raw"
    fi

    # 4. Aggregate: (file, matched_form, count). Then map matched_form back
    # to (bare, header) via forms.tsv. Then sort and take top-K per
    # (bare, header).
    awk -F: '
        {
            i=index($0, ":")
            if (i==0) next
            f=substr($0, 1, i-1)
            tok=substr($0, i+1)
            cnt[f"\t"tok]++
        }
        END { for (k in cnt) print k "\t" cnt[k] }
    ' "$tmp/raw" > "$tmp/per_file_form"

    # Join: per_file_form (file, form, count) × forms.tsv (bare, header, form)
    # → (bare, header, file, count) excluding self-matches in defining header.
    awk -F'\t' '
        FNR==NR {
            # forms.tsv: bare \t header \t form
            key=$3; bare=$1; hdr=$2
            # Track (form -> list of (bare|hdr))
            if (key in form_target) form_target[key] = form_target[key] "\n" bare "|" hdr
            else                     form_target[key] = bare "|" hdr
            next
        }
        # per_file_form: file \t form \t count
        {
            file=$1; form=$2; cnt=$3+0
            if (!(form in form_target)) next
            n=split(form_target[form], items, "\n")
            for (i=1; i<=n; i++) {
                split(items[i], pair, "|")
                bare=pair[1]; hdr=pair[2]
                if (file == hdr) continue   # self-match in defining header
                key=bare "\t" hdr "\t" file
                agg[key] += cnt
            }
        }
        END { for (k in agg) print k "\t" agg[k] }
    ' "$tmp/forms.tsv" "$tmp/per_file_form" > "$tmp/agg"

    # 5. For each (bare, header) take top-K files.
    # Sort by (bare, header, count desc), then awk to pick top-K per group.
    LC_ALL=C sort -t$'\t' -k1,1 -k2,2 -k4,4nr "$tmp/agg" \
        | awk -F'\t' -v K="$top_k" '
            BEGIN { OFS="\t" }
            {
                key=$1 "\t" $2
                if (key != prev) { count = 0; prev = key }
                count++
                if (count <= K) print $1, $3, $4
            }
        ' > "$out"

    local n_out
    n_out=$(wc -l < "$out" | awk '{print $1}')
    echo "breakdown: $n_out (symbol, file, count) rows written to $out" >&2
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    mkdir -p "$tmp/repo/Common/MathUtils" "$tmp/repo/Detectors/TPC"

    cat > "$tmp/repo/Common/MathUtils/Foo.h" <<'EOF'
#pragma once
namespace o2 { namespace mu {
double findClosestIndices(double x);
}}
EOF

    cat > "$tmp/repo/Detectors/TPC/use1.cxx" <<'EOF'
#include "MathUtils/Foo.h"
double f() { return o2::mu::findClosestIndices(2.0); }
EOF

    cat > "$tmp/repo/Detectors/TPC/use2.cxx" <<'EOF'
#include "MathUtils/Foo.h"
using namespace o2::mu;
double g() {
    findClosestIndices(1.0);
    findClosestIndices(2.0);
    findClosestIndices(3.0);
    return 0;
}
EOF

    cat > "$tmp/repo/Common/MathUtils/Bar.h" <<'EOF'
#pragma once
namespace o2 { namespace gpu {
class Transform3D { public: void set(); };
}}
EOF
    cat > "$tmp/repo/Common/MathUtils/Baz.h" <<'EOF'
#pragma once
namespace o2 { namespace mu {
class Transform3D { public: void set(); };
}}
EOF

    cat > "$tmp/repo/Detectors/TPC/use3.cxx" <<'EOF'
#include "MathUtils/Bar.h"
void h() {
    o2::gpu::Transform3D t;
    t.set();
}
EOF

    cat > "$tmp/usage.csv" <<EOF
symbol,kind,parent_class,header,signature,line,prod_usage_count,prod_reachable,churn_12m,workflows_direct,header_basename_collision,name_uniqueness,match_confidence
findClosestIndices,p,o2::mu,$tmp/repo/Common/MathUtils/Foo.h,(double x),3,4,true,0,1,false,unique,high
Transform3D,c,o2::gpu,$tmp/repo/Common/MathUtils/Bar.h,,3,-1,true,0,-1,false,ambiguous,ambiguous
Transform3D,c,o2::mu,$tmp/repo/Common/MathUtils/Baz.h,,3,-1,true,0,-1,false,ambiguous,ambiguous
EOF

    cat > "$tmp/symbols.tsv" <<EOF
findClosestIndices	p	o2::mu	$tmp/repo/Common/MathUtils/Foo.h	(double x)	3
o2::mu::findClosestIndices	p	o2::mu	$tmp/repo/Common/MathUtils/Foo.h	(double x)	3
Transform3D	c	o2::gpu	$tmp/repo/Common/MathUtils/Bar.h		3
o2::gpu::Transform3D	c	o2::gpu	$tmp/repo/Common/MathUtils/Bar.h		3
Transform3D	c	o2::mu	$tmp/repo/Common/MathUtils/Baz.h		3
o2::mu::Transform3D	c	o2::mu	$tmp/repo/Common/MathUtils/Baz.h		3
EOF

    cat > "$tmp/reachable.txt" <<EOF
$tmp/repo/Detectors/TPC/use1.cxx
$tmp/repo/Detectors/TPC/use2.cxx
$tmp/repo/Detectors/TPC/use3.cxx
$tmp/repo/Common/MathUtils/Foo.h
$tmp/repo/Common/MathUtils/Bar.h
$tmp/repo/Common/MathUtils/Baz.h
EOF

    local tool; tool=$(detect_grep)
    breakdown "$tmp/usage.csv" "$tmp/reachable.txt" "$tmp/symbols.tsv" \
              "$tmp/breakdown.tsv" 50 10 "$tool" 2> "$tmp/stderr"

    echo "=== TEST OUTPUT ==="
    cat "$tmp/breakdown.tsv"
    echo "=== TEST STDERR ==="
    cat "$tmp/stderr"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() { if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi }

    # use2.cxx has 3 calls (bare form), use1.cxx has 1 call (qualified form).
    # Both contribute to findClosestIndices.
    check "use2.cxx contributes 3 (bare-form, 3 calls)" \
        'awk -F"\t" "\$1==\"findClosestIndices\" && \$2 ~ /use2.cxx/ {print \$3}" "$tmp/breakdown.tsv" | grep -qx "3"'

    check "use1.cxx contributes 1 (qualified-form, 1 call)" \
        'awk -F"\t" "\$1==\"findClosestIndices\" && \$2 ~ /use1.cxx/ {print \$3}" "$tmp/breakdown.tsv" | grep -qx "1"'

    # Defining header (Foo.h) MUST NOT appear (self-match excluded)
    check "defining header Foo.h excluded" \
        '! grep -q "Foo.h$(printf "\t")" "$tmp/breakdown.tsv"'

    check "rows sorted by count descending" \
        '[ "$(head -1 "$tmp/breakdown.tsv" | cut -f3)" -ge "$(tail -1 "$tmp/breakdown.tsv" | cut -f3)" ]'

    # R-2: ambiguous symbols (count=-1 in usage.csv) must still produce
    # breakdown rows. The use3.cxx file references `o2::gpu::Transform3D`
    # → 1 match. The o2::mu::Transform3D row produces 0 references.
    check "R-2: Transform3D (ambiguous) has breakdown rows" \
        'awk -F"\t" "\$1==\"Transform3D\"" "$tmp/breakdown.tsv" | grep -q .'
    check "R-2: Transform3D references use3.cxx" \
        'awk -F"\t" "\$1==\"Transform3D\" && \$2 ~ /use3.cxx/" "$tmp/breakdown.tsv" | grep -q .'

    echo
    if [ "$fail" = "0" ]; then echo "ALL TESTS PASSED"; return 0
    else echo "TESTS FAILED"; return 1; fi
}

# ---------- CLI ----------
USAGE=""; REACH=""; SYMBOLS=""; OUT=""; TOP_N=50; TOP_K=10; GREP_TOOL=""

if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
            --usage)        USAGE="$2";      shift 2 ;;
            --reachable)    REACH="$2";      shift 2 ;;
            --symbols)      SYMBOLS="$2";    shift 2 ;;
            --out)          OUT="$2";        shift 2 ;;
            --top-symbols)  TOP_N="$2";      shift 2 ;;
            --top-files)    TOP_K="$2";      shift 2 ;;
            --grep)         GREP_TOOL="$2";  shift 2 ;;
            --test)         run_test; exit $? ;;
            -h|--help)      usage; exit 0 ;;
            *)              echo "unknown: $1" >&2; usage; exit 1 ;;
        esac
    done
    if [ -z "$USAGE" ] || [ -z "$REACH" ] || [ -z "$SYMBOLS" ] || [ -z "$OUT" ]; then
        usage; exit 1
    fi
    [ -z "$GREP_TOOL" ] && GREP_TOOL=$(detect_grep)
    breakdown "$USAGE" "$REACH" "$SYMBOLS" "$OUT" "$TOP_N" "$TOP_K" "$GREP_TOOL"
fi
