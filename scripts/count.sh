#!/usr/bin/env bash
# =============================================================================
# count.sh — count symbol usage across reachable files
# =============================================================================
# For each symbol in --symbols TSV that passes --filter, computes:
#
#   prod_usage_count   whole-word matches across reachable files,
#                      excluding the defining header
#   prod_reachable     true if defining header is in reachable list
#   workflows_direct   1-hop refs in seed entry-point sources only
#   churn_12m          git log commits touching defining header in last 12 months
#
# Output: CSV with header. Resumable — re-running picks up where left off.
#
# Inputs:
#   --symbols FILE       symbols.tsv from symbols.sh
#   --reachable FILE     reachable.txt from reachable.sh
#   --seed FILE          seed file (entry-point sources) from seed_join.sh
#   --out FILE           output CSV
#   --filter EXPR        awk filter on (name, kind, parent, file, sig, line, module)
#                        default: kind ~ /^[csfp]$/ && file ~ /\/Common\/|\/DataFormats\/Detectors\/Common\//
#                                 && name !~ /^__anon/
#   --git-root DIR       AliceO2 git root for churn (default: $ALICEO2_ROOT)
#   --grep TOOL          rg | grep (default: rg if available, else grep)
#
# Run modes:
#   count.sh --symbols FILE --reachable FILE --seed FILE --out FILE [options]
#   count.sh --test
#   count.sh -h | --help
# =============================================================================

set -u

usage() {
cat <<'EOF'
Usage:
  count.sh --symbols FILE --reachable FILE --seed FILE --out FILE [options]
  count.sh --test
  count.sh -h | --help

Required:
  --symbols   FILE   symbols.tsv (output of symbols.sh)
  --reachable FILE   reachable.txt (one absolute path per line)
  --seed      FILE   seed file (entry-point .cxx, one path per line)
  --out       FILE   output CSV

Optional:
  --filter EXPR      awk filter on the symbols TSV; default keeps Common-ish
                     public API: classes/structs/functions/prototypes whose
                     defining file is under /Common/ or /DataFormats/Detectors/
                     Common/, excluding anonymous lambdas
  --git-root DIR     AliceO2 git root for churn calc (default: $ALICEO2_ROOT)
  --grep TOOL        rg|grep (default: rg if installed, else grep)

CSV columns:
  symbol,kind,parent_class,header,signature,line,
  prod_usage_count,prod_reachable,churn_12m,workflows_direct

Resumable: if --out exists, rows already written are skipped.

Note: rows are deduplicated by (symbol_name, defining_file). ctags
emits each symbol multiple times (bare name + qualified, prototype +
inline definition, etc.) — only the first occurrence per (name, file)
makes it into usage.csv. The skipped duplicates appear in the summary
as 'skipped_duplicate_key=N' and would have produced identical counts.
EOF
}

# Detect grep tool.
detect_grep() {
    if [ -n "${GREPTOOL:-}" ]; then
        echo "$GREPTOOL"
    elif command -v rg >/dev/null 2>&1; then
        echo "rg"
    else
        echo "grep"
    fi
}

# Fast path: count ALL symbols against a file list in ONE pass.
# Inputs:
#   $1: TSV file with columns (name, defining_file)  — patterns to search
#   $2: file with one path per line (search corpus)
#   $3: tool (rg|grep)
# Output (stdout): "name\tcount" one per name, with the defining file
#   excluded from the count (so the count reflects external uses).
count_all_inverted() {
    local pat_tsv="$1"
    local files_list="$2"
    local tool="$3"

    # Build unique patterns file (just names, one per line, deduped).
    local patterns
    patterns=$(mktemp)
    awk -F'\t' '{print $1}' "$pat_tsv" | LC_ALL=C sort -u > "$patterns"

    # Run grep with -f patterns. -w whole-word, -F fixed string, with filename.
    # Output: file:matched_word for each occurrence. Then aggregate.
    local raw
    raw=$(mktemp)

    if [ "$tool" = "rg" ]; then
        # rg with -f patterns -wFo to print only matching tokens with filename
        # (--with-filename and --no-line-number make output: file:match).
        xargs -n 500 rg -wFo -f "$patterns" --no-line-number --with-filename --no-heading \
            < "$files_list" 2>/dev/null > "$raw"
    else
        # grep -wFo only prints matched tokens (one per line) with file: prefix.
        xargs -n 500 grep -wFo -f "$patterns" -H \
            < "$files_list" 2>/dev/null > "$raw"
    fi

    # Aggregate: for each (name, file) we know one occurrence; we need total
    # count per name MINUS occurrences in the defining file.
    # Format from grep -Ho is: file:match
    # Build a dict: count_per_file[name][file] += 1
    # Then for each (name, defining_file) in pat_tsv: total = sum_all_files - count_in_defining_file
    awk -F'\t' -v DEFTSV="$pat_tsv" -v RAW="$raw" '
        # Pass 1: read pat_tsv to learn each name -> defining_file
        FNR==NR && FILENAME==DEFTSV { def[$1]=$2; next }
        # Pass 2: read raw lines (file:match)
        FILENAME==RAW {
            line=$0
            i=index(line, ":")
            if (i==0) next
            file=substr(line, 1, i-1)
            tok=substr(line, i+1)
            total[tok]++
            if (file == def[tok]) self[tok]++
        }
        END {
            for (n in def) {
                t = (n in total) ? total[n] : 0
                s = (n in self)  ? self[n]  : 0
                print n "\t" (t - s)
            }
        }
    ' "$pat_tsv" "$raw"

    rm -f "$patterns" "$raw"
}

# Whole-word count of $1 across files in $2 (newline-separated path file),
# EXCLUDING $3 (the defining header). Returns integer count.
# Used by per-symbol slow path (legacy / compat / single-symbol queries).
count_word_in_files() {
    local word="$1"
    local files_list="$2"
    local exclude="$3"
    local tool="$4"
    local total=0

    # Build a temp file list excluding the defining header.
    local tmp_files
    tmp_files=$(mktemp)
    awk -v ex="$exclude" '$0 != ex' "$files_list" > "$tmp_files"

    if [ "$tool" = "rg" ]; then
        # Portable: feed file list via stdin, not -a (BSD xargs lacks -a).
        # rg -wFc per-file count.
        total=$(xargs -n 200 rg -wFc -- "$word" < "$tmp_files" 2>/dev/null \
                | awk -F: '{s+=$NF} END{print s+0}')
    else
        # GNU/BSD grep both: -w whole word, -F fixed string, -c count per file.
        total=$(xargs -n 200 grep -wFc -- "$word" < "$tmp_files" 2>/dev/null \
                | awk -F: '{s+=$NF} END{print s+0}')
    fi

    rm -f "$tmp_files"
    echo "${total:-0}"
}

# CSV-quote a field if it contains comma, quote, or newline.
csv_quote() {
    local s="$1"
    if printf '%s' "$s" | grep -q '[,"]'; then
        printf '"%s"' "$(printf '%s' "$s" | sed 's/"/""/g')"
    else
        printf '%s' "$s"
    fi
}

count_symbols() {
    local symbols="$1"
    local reachable="$2"
    local seed="$3"
    local out="$4"
    local filter="$5"
    local git_root="$6"
    local tool="$7"

    [ -s "$symbols"   ] || { echo "count: empty/missing symbols file"   >&2; return 1; }
    [ -s "$reachable" ] || { echo "count: empty/missing reachable file" >&2; return 1; }
    [ -s "$seed"      ] || { echo "count: empty/missing seed file"      >&2; return 1; }

    # 1. Apply filter to get the work list.
    local work
    work=$(mktemp)
    awk -F'\t' -v EXPR="$filter" '
        BEGIN {
            # Compile a 1-line awk program from the filter expr by sourcing it.
            # We invoke a sub-awk to evaluate. Simpler: just embed.
        }
    ' "$symbols" >/dev/null 2>&1
    # Direct embedding approach: run awk with the filter expression as the
    # action's condition. Done via -v injection is hard; use envsub.
    awk -F'\t' "
        function keep(name, kind, parent, file, sig, line) {
            return ($filter)
        }
        keep(\$1,\$2,\$3,\$4,\$5,\$6) { print }
    " "$symbols" > "$work"

    local n_work
    n_work=$(wc -l < "$work" | awk '{print $1}')
    echo "count: $n_work symbols pass filter (of $(wc -l < "$symbols" | awk '{print $1}') total)" >&2

    # 2. Resume: read already-done keys from existing --out
    local done_keys
    done_keys=$(mktemp)
    if [ -s "$out" ]; then
        # CSV header line is row 1; data rows are 2+
        awk -F, 'NR>1{ print $1 "|" $4 }' "$out" | LC_ALL=C sort -u > "$done_keys"
        local n_done
        n_done=$(wc -l < "$done_keys" | awk '{print $1}')
        echo "count: $n_done rows already in $out (will skip on resume + dedup)" >&2
    else
        echo "symbol,kind,parent_class,header,signature,line,prod_usage_count,prod_reachable,churn_12m,workflows_direct" > "$out"
        : > "$done_keys"
    fi

    # 3. Reachable-set membership lookup.
    local reach_sorted
    reach_sorted=$(mktemp)
    LC_ALL=C sort -u "$reachable" > "$reach_sorted"

    # 3b. FAST PATH: pre-compute prod_usage_count and workflows_direct
    # for ALL filtered symbols in two big inverted-loop passes.
    # Build (name, defining_file) pat_tsv from the work list.
    local pat_tsv
    pat_tsv=$(mktemp)
    awk -F'\t' '{print $1 "\t" $4}' "$work" | LC_ALL=C sort -u > "$pat_tsv"

    echo "count: pre-computing prod_usage_count for $(wc -l < "$pat_tsv" | awk '{print $1}') unique (name, file) keys via inverted-loop ($tool)..." >&2
    local t_inv
    t_inv=$(date +%s)
    local prod_counts
    prod_counts=$(mktemp)
    count_all_inverted "$pat_tsv" "$reachable" "$tool" \
        | LC_ALL=C sort -k1,1 > "$prod_counts"
    echo "count: prod_usage_count done in $(( $(date +%s) - t_inv ))s, $(wc -l < "$prod_counts" | awk '{print $1}') rows" >&2

    echo "count: pre-computing workflows_direct..." >&2
    t_inv=$(date +%s)
    local direct_counts
    direct_counts=$(mktemp)
    count_all_inverted "$pat_tsv" "$seed" "$tool" \
        | LC_ALL=C sort -k1,1 > "$direct_counts"
    echo "count: workflows_direct done in $(( $(date +%s) - t_inv ))s" >&2

    # 4. Iterate.
    local t0
    t0=$(date +%s)
    local processed=0
    local skipped=0
    while IFS= read -r raw_line; do
        # Manually split on TAB to preserve empty fields (bash `read` with
        # IFS=$'\t' collapses consecutive tabs).
        local IFS_BAK="$IFS"
        local fields_str="$raw_line"
        # Use awk to split with explicit field separator, output 6 NUL-delimited
        # fields. This preserves empty fields between consecutive tabs.
        local name kind parent file sig line
        name=$(printf  '%s' "$fields_str" | awk -F'\t' '{print $1}')
        kind=$(printf  '%s' "$fields_str" | awk -F'\t' '{print $2}')
        parent=$(printf '%s' "$fields_str" | awk -F'\t' '{print $3}')
        file=$(printf  '%s' "$fields_str" | awk -F'\t' '{print $4}')
        sig=$(printf   '%s' "$fields_str" | awk -F'\t' '{print $5}')
        line=$(printf  '%s' "$fields_str" | awk -F'\t' '{print $6}')
        IFS="$IFS_BAK"

        local key="$name|$file"
        if LC_ALL=C grep -Fxq "$key" "$done_keys"; then
            skipped=$((skipped+1))
            continue
        fi

        # prod_usage_count: lookup from pre-computed table
        local cnt
        cnt=$(LC_ALL=C awk -F'\t' -v n="$name" '$1==n {print $2; exit}' "$prod_counts")
        cnt="${cnt:-0}"

        # prod_reachable
        local reachable_flag="false"
        LC_ALL=C grep -Fxq "$file" "$reach_sorted" && reachable_flag="true"

        # workflows_direct: lookup from pre-computed table
        local direct
        direct=$(LC_ALL=C awk -F'\t' -v n="$name" '$1==n {print $2; exit}' "$direct_counts")
        direct="${direct:-0}"

        # churn_12m
        local churn=0
        if [ -f "$file" ] && [ -d "$git_root/.git" ]; then
            churn=$( ( cd "$git_root" && git log --since='12 months ago' --oneline -- "$file" 2>/dev/null | wc -l ) | awk '{print $1}' )
        fi

        # Emit CSV row.
        local sig_esc
        sig_esc=$(csv_quote "$sig")
        local parent_esc
        parent_esc=$(csv_quote "$parent")
        local name_esc
        name_esc=$(csv_quote "$name")
        printf '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n' \
            "$name_esc" "$kind" "$parent_esc" "$file" "$sig_esc" "$line" \
            "$cnt" "$reachable_flag" "$churn" "$direct" \
            >> "$out"
        printf '%s\n' "$key" >> "$done_keys"

        processed=$((processed+1))
        if [ $((processed % 100)) -eq 0 ]; then
            local t1; t1=$(date +%s); local dt=$((t1-t0))
            local rate
            rate=$(awk -v p="$processed" -v dt="$dt" 'BEGIN{ if (dt>0) print p/dt; else print 0 }')
            local eta
            eta=$(awk -v left=$((n_work - skipped - processed)) -v r="$rate" \
                'BEGIN{ if (r>0) printf "%d", left/r; else print "?" }')
            echo "count: $processed/$n_work processed (${rate} sym/s, ETA ${eta}s)" >&2
        fi
    done < "$work"

    local t1; t1=$(date +%s); local dt=$((t1-t0))
    echo "" >&2
    echo "=== count summary ===" >&2
    echo "filter_passed=$n_work" >&2
    echo "skipped_duplicate_key=$skipped" >&2
    echo "newly_processed=$processed" >&2
    echo "elapsed_sec=$dt" >&2
    echo "out=$out" >&2

    rm -f "$work" "$done_keys" "$reach_sorted" "$pat_tsv" "$prod_counts" "$direct_counts"
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    # Synthetic mini-tree
    mkdir -p "$tmp/repo/Common/MathUtils" "$tmp/repo/Detectors/TPC"

    cat > "$tmp/repo/Common/MathUtils/Tsallis.h" <<'EOF'
#pragma once
namespace o2 { namespace math_utils {
class Tsallis {
 public:
  double pdf(double x) const;
};
double tsallisPDF(double x);
}}
EOF

    cat > "$tmp/repo/Common/MathUtils/Util.h" <<'EOF'
#pragma once
namespace o2 { namespace math_utils {
double helperFunc(double x);
}}
EOF

    cat > "$tmp/repo/Detectors/TPC/use1.cxx" <<'EOF'
#include "MathUtils/Tsallis.h"
#include "MathUtils/Util.h"
double f() {
    Tsallis t;
    return t.pdf(1.0) + tsallisPDF(2.0) + helperFunc(3.0);
}
EOF

    cat > "$tmp/repo/Detectors/TPC/use2.cxx" <<'EOF'
#include "MathUtils/Tsallis.h"
double g() {
    return tsallisPDF(99.0);
}
EOF

    # Build inputs.
    cat > "$tmp/symbols.tsv" <<EOF
Tsallis	c	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h		3
pdf	p	o2::math_utils::Tsallis	$tmp/repo/Common/MathUtils/Tsallis.h	(double x) const	5
tsallisPDF	p	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h	(double x)	7
helperFunc	p	o2::math_utils	$tmp/repo/Common/MathUtils/Util.h	(double x)	3
EOF

    # Reachable: both .cxx + both .h
    {
        echo "$tmp/repo/Detectors/TPC/use1.cxx"
        echo "$tmp/repo/Detectors/TPC/use2.cxx"
        echo "$tmp/repo/Common/MathUtils/Tsallis.h"
        echo "$tmp/repo/Common/MathUtils/Util.h"
    } > "$tmp/reachable.txt"

    # Seed: only use1.cxx is an entry point
    echo "$tmp/repo/Detectors/TPC/use1.cxx" > "$tmp/seed.txt"

    # Run with default-ish filter (Common matches our path, kind c|s|f|p)
    local filter='kind ~ /^[csfp]$/ && file ~ /\/Common\// && name !~ /^__anon/'

    local tool
    tool=$(detect_grep)
    echo "TEST: using grep tool = $tool" >&2

    count_symbols "$tmp/symbols.tsv" "$tmp/reachable.txt" "$tmp/seed.txt" \
                  "$tmp/usage.csv" "$filter" "$tmp" "$tool" 2> "$tmp/stderr"

    echo "=== TEST CSV ==="
    cat "$tmp/usage.csv"
    echo "=== TEST STDERR (last 8 lines) ==="
    tail -8 "$tmp/stderr"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() {
        if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi
    }

    # 4 symbols pass filter -> 4 data rows + 1 header
    local n
    n=$(wc -l < "$tmp/usage.csv" | awk '{print $1}')
    check "5 lines (header + 4 data rows)" '[ "$n" = "5" ]'

    # Tsallis: matches in use1.cxx (#include line + 'Tsallis t;' = 2),
    # and use2.cxx (#include line = 1). Total 3. Includes count as references —
    # known noise source in Spec v2; documented limitation, not a bug.
    check "Tsallis prod_usage_count=3 (incl + decl + 2nd incl)" \
        'awk -F, "\$1==\"Tsallis\"{print \$7}" "$tmp/usage.csv" | grep -qx "3"'

    # pdf: appears in use1.cxx (t.pdf(...)) once
    check "pdf prod_usage_count=1" \
        'awk -F, "\$1==\"pdf\"{print \$7}" "$tmp/usage.csv" | grep -qx "1"'

    # tsallisPDF: appears in use1.cxx and use2.cxx -> count=2
    check "tsallisPDF prod_usage_count=2" \
        'awk -F, "\$1==\"tsallisPDF\"{print \$7}" "$tmp/usage.csv" | grep -qx "2"'

    # helperFunc: appears in use1.cxx -> count=1
    check "helperFunc prod_usage_count=1" \
        'awk -F, "\$1==\"helperFunc\"{print \$7}" "$tmp/usage.csv" | grep -qx "1"'

    # workflows_direct (only use1.cxx is seed):
    #   tsallisPDF appears 1x in use1.cxx -> direct=1
    check "tsallisPDF workflows_direct=1" \
        'awk -F, "\$1==\"tsallisPDF\"{print \$10}" "$tmp/usage.csv" | grep -qx "1"'

    # prod_reachable should be true for all (defining headers are in reachable)
    check "all prod_reachable=true" \
        '[ "$(awk -F, "NR>1{print \$8}" "$tmp/usage.csv" | sort -u)" = "true" ]'

    # ---- Resume test: rerun, expect 0 newly_processed ----
    count_symbols "$tmp/symbols.tsv" "$tmp/reachable.txt" "$tmp/seed.txt" \
                  "$tmp/usage.csv" "$filter" "$tmp" "$tool" 2> "$tmp/stderr2"
    check "resume: 0 newly processed second run" \
        'grep -q "newly_processed=0" "$tmp/stderr2"'
    check "resume: csv unchanged" '[ "$(wc -l < "$tmp/usage.csv" | awk "{print \$1}")" = "5" ]'

    echo
    if [ "$fail" = "0" ]; then
        echo "ALL TESTS PASSED"; return 0
    else
        echo "TESTS FAILED"; return 1
    fi
}

# ---------- CLI ----------
SYM=""; REACH=""; SEED=""; OUT=""; FILTER=""; GIT_ROOT="${ALICEO2_ROOT:-}"; GREP_TOOL=""
DEFAULT_FILTER='kind ~ /^[csfp]$/ && file ~ /\/Common\/|\/DataFormats\/Detectors\/Common\// && name !~ /^__anon/'

if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
            --symbols)   SYM="$2";       shift 2 ;;
            --reachable) REACH="$2";     shift 2 ;;
            --seed)      SEED="$2";      shift 2 ;;
            --out)       OUT="$2";       shift 2 ;;
            --filter)    FILTER="$2";    shift 2 ;;
            --git-root)  GIT_ROOT="$2";  shift 2 ;;
            --grep)      GREP_TOOL="$2"; shift 2 ;;
            --test)      run_test; exit $? ;;
            -h|--help)   usage; exit 0 ;;
            *)           echo "unknown: $1" >&2; usage; exit 1 ;;
        esac
    done
    if [ -z "$SYM" ] || [ -z "$REACH" ] || [ -z "$SEED" ] || [ -z "$OUT" ]; then
        usage; exit 1
    fi
    [ -z "$FILTER" ] && FILTER="$DEFAULT_FILTER"
    [ -z "$GREP_TOOL" ] && GREP_TOOL=$(detect_grep)
    count_symbols "$SYM" "$REACH" "$SEED" "$OUT" "$FILTER" "$GIT_ROOT" "$GREP_TOOL"
fi
