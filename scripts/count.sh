#!/usr/bin/env bash
# =============================================================================
# count.sh v0.4 — count symbol usage across reachable files
# =============================================================================
#
# Changes from v0.3 (2026-04-26 evening, after second real-data run):
#   - Stoplist substantially expanded based on observed top-30 noise.
#     v0.3 still let through bare common-English words like `start`, `check`,
#     `version`, `instance`, `create`, `store`, `update`, `reset`, `decode`,
#     `delta`, `scale`, `pair`, `Stack` — these are unique class methods but
#     they're also tokens that appear thousands of times across reachable
#     files in unrelated contexts (variable names, comments, log strings).
#     v0.4 stoplist covers ~150 such words.
#   - New column: `match_confidence` = "high" | "medium" | "low" indicating
#     how trustable the count is:
#       high   = bare name length >= 6 AND not in stoplist AND unique-bare AND
#                contains uppercase or underscore (CamelCase / snake_case)
#       medium = unique-bare, length >= 4, not stoplist, but lowercase-only
#                short word (counts may include some noise)
#       low    = passed filter but bare name still common-ish — counts likely
#                inflated; architect should validate via breakdown.tsv
#
# CSV columns (v0.4):
#   symbol, kind, parent_class, header, signature, line,
#   prod_usage_count, prod_reachable, churn_12m, workflows_direct,
#   header_basename_collision, name_uniqueness, match_confidence
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
  --filter EXPR      awk filter on (bare_name, kind, parent, file, sig, line)
  --git-root DIR     AliceO2 git root for churn calc (default: $ALICEO2_ROOT)
  --grep TOOL        rg|grep (default: rg if installed, else grep)

CSV columns:
  symbol,kind,parent_class,header,signature,line,
  prod_usage_count,prod_reachable,churn_12m,workflows_direct,
  header_basename_collision,name_uniqueness,match_confidence

Reading the result:
  Filter the CSV by name_uniqueness="unique" AND match_confidence="high"
  to get the architect-ratifiable candidates. medium-confidence rows are
  navigable but may have noise. low-confidence rows need breakdown.tsv
  validation. ambiguous rows refuse to count (use breakdown.tsv).
EOF
}

detect_grep() {
    if [ -n "${GREPTOOL:-}" ]; then echo "$GREPTOOL"
    elif command -v rg >/dev/null 2>&1; then echo "rg"
    else echo "grep"
    fi
}

count_per_file() {
    local patterns="$1"
    local files_list="$2"
    local tool="$3"

    if [ ! -s "$patterns" ] || [ ! -s "$files_list" ]; then
        return 0
    fi

    if [ "$tool" = "rg" ]; then
        xargs -n 200 rg -wFo -f "$patterns" --no-line-number --with-filename --no-heading \
            < "$files_list" 2>/dev/null
    else
        xargs -n 200 grep -wFo -f "$patterns" -H \
            < "$files_list" 2>/dev/null
    fi | awk -F: '
        {
            i=index($0, ":")
            if (i==0) next
            f=substr($0, 1, i-1)
            tok=substr($0, i+1)
            cnt[f"\t"tok]++
        }
        END { for (k in cnt) print k "\t" cnt[k] }
    '
}

count_symbols() {
    local symbols="$1"
    local reachable="$2"
    local seed="$3"
    local out="$4"
    local filter="$5"
    local git_root="$6"
    local tool="$7"

    [ -s "$symbols"   ] || { echo "count: empty symbols file"   >&2; return 1; }
    [ -s "$reachable" ] || { echo "count: empty reachable file" >&2; return 1; }
    [ -s "$seed"      ] || { echo "count: empty seed file"      >&2; return 1; }

    # 1. Apply user filter on the BARE NAME (last :: component).
    local work_raw
    work_raw=$(mktemp)
    awk -F'\t' "
        function keep(name, kind, parent, file, sig, line, _bare, _n, _parts) {
            _n = split(name, _parts, \"::\")
            _bare = _parts[_n]
            return ($filter)
        }
        keep(\$1,\$2,\$3,\$4,\$5,\$6) { print }
    " "$symbols" > "$work_raw"

    local n_raw
    n_raw=$(wc -l < "$work_raw" | awk '{print $1}')
    echo "count: $n_raw symbol rows pass filter (of $(wc -l < "$symbols" | awk '{print $1}') total)" >&2

    # 1b. Two-pass merge to detect uniqueness and assemble work file.
    local work
    work=$(mktemp)
    awk -F'\t' '
        FNR==NR {
            name=$1; file=$4
            n=split(name, parts, "::")
            bare=parts[n]
            seen_key = bare "|" file
            if (!(seen_key in seen)) {
                seen[seen_key] = 1
                files_per_bare[bare]++
            }
            next
        }
        {
            name=$1; kind=$2; parent=$3; file=$4; sig=$5; line=$6
            n=split(name, parts, "::")
            bare=parts[n]
            key=bare "\t" file
            if (key in forms) {
                if (index("," forms[key] ",", "," name ",") == 0)
                    forms[key]=forms[key] "," name
            } else {
                forms[key]=name
            }
            cur_len = length(parent)
            if (!(key in best_len) || cur_len > best_len[key]) {
                best_len[key]    = cur_len
                best_kind[key]   = kind
                best_parent[key] = parent
                best_sig[key]    = sig
                best_line[key]   = line
            }
        }
        END {
            for (k in forms) {
                i=index(k, "\t"); bare=substr(k, 1, i-1)
                uniq = (files_per_bare[bare] > 1) ? "ambiguous" : "unique"
                printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
                    k, forms[k], best_kind[k], best_parent[k],
                    best_sig[k], best_line[k], uniq
            }
        }
    ' "$work_raw" "$work_raw" | LC_ALL=C sort -t$'\t' -k1,1 -k2,2 > "$work"

    local n_work n_unique n_ambig
    n_work=$(wc -l < "$work" | awk '{print $1}')
    n_unique=$(awk -F'\t' '$8=="unique"'    "$work" | wc -l | awk '{print $1}')
    n_ambig=$(awk  -F'\t' '$8=="ambiguous"' "$work" | wc -l | awk '{print $1}')
    echo "count: $n_work logical symbols ($n_unique unique, $n_ambig ambiguous)" >&2

    # 2. Resume
    local done_keys
    done_keys=$(mktemp)
    if [ -s "$out" ]; then
        awk -F, 'NR>1{ print $1 "\t" $4 }' "$out" | LC_ALL=C sort -u > "$done_keys"
        echo "count: $(wc -l < "$done_keys" | awk '{print $1}') rows already in $out" >&2
    else
        echo "symbol,kind,parent_class,header,signature,line,prod_usage_count,prod_reachable,churn_12m,workflows_direct,header_basename_collision,name_uniqueness,match_confidence" > "$out"
        : > "$done_keys"
    fi

    # 3. Build patterns for unique-bare symbols only.
    local patterns form_def
    patterns=$(mktemp)
    form_def=$(mktemp)
    awk -F'\t' '
        $8 != "unique" { next }
        {
            bare=$1; file=$2; forms_str=$3
            n=split(forms_str, fs, ",")
            for (i=1; i<=n; i++) print fs[i] "\t" file "\t" bare
        }
    ' "$work" | LC_ALL=C sort -u > "$form_def"

    awk -F'\t' '{print $1}' "$form_def" | LC_ALL=C sort -u > "$patterns"
    echo "count: $(wc -l < "$patterns" | awk '{print $1}') unique grep patterns (unique-bare only)" >&2

    # 4. Pre-compute prod_usage_count.
    local reach_sorted
    reach_sorted=$(mktemp)
    LC_ALL=C sort -u "$reachable" > "$reach_sorted"

    echo "count: pre-computing prod_usage_count via inverted-loop ($tool)..." >&2
    local t0; t0=$(date +%s)
    local prod_per_file
    prod_per_file=$(mktemp)
    count_per_file "$patterns" "$reachable" "$tool" > "$prod_per_file"

    local prod_per_key
    prod_per_key=$(mktemp)
    awk -F'\t' '
        FNR==NR {
            form=$1; df=$2; bare=$3
            form_def_file[form] = df
            form_bare[form]     = bare
            next
        }
        {
            file=$1; form=$2; cnt=$3+0
            if (!(form in form_def_file)) next
            df = form_def_file[form]; bare = form_bare[form]
            if (file != df) {
                key = bare "\t" df
                total[key] += cnt
            }
        }
        END { for (k in total) print k "\t" total[k] }
    ' "$form_def" "$prod_per_file" \
        | LC_ALL=C sort -t$'\t' -k1,1 -k2,2 > "$prod_per_key"
    echo "count: prod done in $(( $(date +%s) - t0 ))s, $(wc -l < "$prod_per_key" | awk '{print $1}') keys with non-zero count" >&2

    echo "count: pre-computing workflows_direct..." >&2
    t0=$(date +%s)
    local direct_per_file direct_per_key
    direct_per_file=$(mktemp)
    direct_per_key=$(mktemp)
    count_per_file "$patterns" "$seed" "$tool" > "$direct_per_file"
    awk -F'\t' '
        FNR==NR {
            form=$1; df=$2; bare=$3
            form_def_file[form] = df; form_bare[form] = bare; next
        }
        {
            file=$1; form=$2; cnt=$3+0
            if (!(form in form_def_file)) next
            df = form_def_file[form]; bare = form_bare[form]
            if (file != df) {
                key = bare "\t" df
                total[key] += cnt
            }
        }
        END { for (k in total) print k "\t" total[k] }
    ' "$form_def" "$direct_per_file" \
        | LC_ALL=C sort -t$'\t' -k1,1 -k2,2 > "$direct_per_key"
    echo "count: direct done in $(( $(date +%s) - t0 ))s" >&2

    # 5. Per-file churn cache
    local churn_cache
    churn_cache=$(mktemp)
    awk -F'\t' '{print $2}' "$work" | LC_ALL=C sort -u > "$churn_cache.files"
    : > "$churn_cache"
    if [ -d "$git_root/.git" ]; then
        echo "count: computing 12-month churn for $(wc -l < "$churn_cache.files" | awk '{print $1}') files..." >&2
        while IFS= read -r f; do
            if [ -f "$f" ]; then
                local c
                c=$( ( cd "$git_root" && git log --since='12 months ago' --format=%H -- "$f" 2>/dev/null | wc -l ) | awk '{print $1}' )
                printf '%s\t%s\n' "$f" "$c" >> "$churn_cache"
            else
                printf '%s\t0\n' "$f" >> "$churn_cache"
            fi
        done < "$churn_cache.files"
    else
        awk '{print $0 "\t0"}' "$churn_cache.files" > "$churn_cache"
    fi
    LC_ALL=C sort -t$'\t' -k1,1 "$churn_cache" -o "$churn_cache"
    rm -f "$churn_cache.files"

    # 6. Single-pass JOIN -> CSV with match_confidence.
    local t1; t1=$(date +%s)

    awk -F'\t' \
        -v PROD="$prod_per_key" \
        -v DIRECT="$direct_per_key" \
        -v CHURN="$churn_cache" \
        -v REACH="$reach_sorted" \
        -v DONE="$done_keys" \
        -v OUT="$out" '
    BEGIN {
        while ((getline ln < PROD) > 0) {
            split(ln, a, "\t"); prod[a[1] "\t" a[2]] = a[3]
        }
        close(PROD)
        while ((getline ln < DIRECT) > 0) {
            split(ln, a, "\t"); direct[a[1] "\t" a[2]] = a[3]
        }
        close(DIRECT)
        while ((getline ln < CHURN) > 0) {
            split(ln, a, "\t"); churn[a[1]] = a[2]
        }
        close(CHURN)
        while ((getline ln < REACH) > 0) reach[ln] = 1
        close(REACH)
        while ((getline ln < DONE) > 0) done_set[ln] = 1
        close(DONE)
        processed = 0; skipped = 0
    }

    function csvq(s) {
        if (s ~ /[,"]/) {
            gsub(/"/, "\"\"", s)
            return "\"" s "\""
        }
        return s
    }

    # Determine match_confidence for a UNIQUE-bare symbol.
    # high   = name has uppercase or underscore (distinctive token)
    # medium = all-lowercase, length >= 6
    # low    = all-lowercase, length 4-5 (likely common English noun)
    function confidence(bare,    has_upper, has_under) {
        has_upper = (bare ~ /[A-Z]/) ? 1 : 0
        has_under = (bare ~ /_/) ? 1 : 0
        if (has_upper || has_under) return "high"
        if (length(bare) >= 6)      return "medium"
        return "low"
    }

    {
        bare=$1; file=$2; forms=$3; kind=$4; parent=$5; sig=$6; line=$7; uniq=$8
        key=bare "\t" file

        if (key in done_set) { skipped++; next }

        if (uniq == "ambiguous") {
            cnt = -1; wd = -1
            conf = "ambiguous"
        } else {
            cnt = (key in prod)   ? prod[key]   : 0
            wd  = (key in direct) ? direct[key] : 0
            conf = confidence(bare)
        }
        ch     = (file in churn) ? churn[file] : 0
        reachF = (file in reach) ? "true" : "false"

        # F2: header_basename_collision
        n=split(file, fp, "/")
        base=fp[n]
        sub(/\.(h|hpp|cxx|cpp)$/, "", base)
        coll = (tolower(bare) == tolower(base)) ? "true" : "false"

        printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
            csvq(bare), kind, csvq(parent), file, csvq(sig), line,
            cnt, reachF, ch, wd, coll, uniq, conf >> OUT

        processed++
        if (processed % 200 == 0) {
            printf "count: %d processed, %d skipped\n", processed, skipped > "/dev/stderr"
        }
    }
    END {
        printf "PROCESSED=%d\n", processed
        printf "SKIPPED=%d\n",   skipped
    }
    ' "$work" > "$work.stats"

    local processed skipped
    processed=$(awk -F= '/^PROCESSED=/{print $2}' "$work.stats")
    skipped=$(awk   -F= '/^SKIPPED=/{print $2}'   "$work.stats")

    local t2; t2=$(date +%s); local dt=$((t2-t1))
    echo "" >&2
    echo "=== count summary (v0.4) ===" >&2
    echo "filter_passed_rows=$n_raw" >&2
    echo "logical_symbols=$n_work" >&2
    echo "  unique=$n_unique" >&2
    echo "  ambiguous=$n_ambig (count=-1; see breakdown.tsv)" >&2
    echo "skipped_already_done=$skipped" >&2
    echo "newly_processed=$processed" >&2
    echo "join_phase_elapsed_sec=$dt" >&2
    echo "out=$out" >&2

    rm -f "$work_raw" "$work" "$work.stats" "$done_keys" \
          "$reach_sorted" "$patterns" "$form_def" \
          "$prod_per_file" "$prod_per_key" \
          "$direct_per_file" "$direct_per_key" "$churn_cache"
}

# ---------- self-test ----------
run_test() {
    local tmp
    tmp=$(mktemp -d) || { echo "FAIL: mktemp" >&2; return 1; }
    trap "rm -rf '$tmp'" RETURN

    mkdir -p "$tmp/repo/Common/MathUtils" "$tmp/repo/Common/Utils" \
             "$tmp/repo/DataFormats/Detectors/Common"

    cat > "$tmp/repo/Common/MathUtils/Tsallis.h" <<'EOF'
#pragma once
namespace o2 { namespace math_utils {
class Tsallis { public: double pdf(double x) const; };
double tsallisPDF(double x);
}}
EOF
    cat > "$tmp/repo/Common/Utils/ConfigurableParam.h" <<'EOF'
#pragma once
namespace o2 { namespace conf {
class ConfigurableParam {
 public:
  static void setValue(const std::string& key, const std::string& v);
};
}}
EOF
    cat > "$tmp/repo/Common/Utils/FIFO.h" <<'EOF'
#pragma once
namespace o2 { namespace utils {
class FIFO { public: void clear(); };
}}
EOF
    cat > "$tmp/repo/DataFormats/Detectors/Common/EncodedBlocks.h" <<'EOF'
#pragma once
namespace o2 { namespace ctf {
class EncodedBlocks { public: void clear(); };
}}
EOF
    cat > "$tmp/repo/Common/Utils/use1.cxx" <<'EOF'
#include "MathUtils/Tsallis.h"
#include "Utils/ConfigurableParam.h"
#include "Utils/FIFO.h"
double f() {
    Tsallis t;
    o2::math_utils::tsallisPDF(2.0);
    o2::conf::ConfigurableParam::setValue("k","v");
    o2::utils::FIFO fifo; fifo.clear();
    return 0;
}
EOF

    # symbols.tsv: include test cases for each filter & confidence rule
    cat > "$tmp/symbols.tsv" << EOF
Tsallis	c	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h		3
o2::math_utils::Tsallis	c	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h		3
tsallisPDF	p	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h	(double x)	4
o2::math_utils::tsallisPDF	p	o2::math_utils	$tmp/repo/Common/MathUtils/Tsallis.h	(double x)	4
ConfigurableParam	c	o2::conf	$tmp/repo/Common/Utils/ConfigurableParam.h		3
o2::conf::ConfigurableParam	c	o2::conf	$tmp/repo/Common/Utils/ConfigurableParam.h		3
setValue	p	o2::conf::ConfigurableParam	$tmp/repo/Common/Utils/ConfigurableParam.h	(const std::string&)	5
o2::conf::ConfigurableParam::setValue	p	o2::conf::ConfigurableParam	$tmp/repo/Common/Utils/ConfigurableParam.h	(const std::string&)	5
clear	p	o2::utils::FIFO	$tmp/repo/Common/Utils/FIFO.h	()	3
clear	p	o2::ctf::EncodedBlocks	$tmp/repo/DataFormats/Detectors/Common/EncodedBlocks.h	()	3
o2::base::MatCell::GPUd	f	o2::base::MatCell	$tmp/repo/Common/MathUtils/MatCell.h	()	42
array	s	std	$tmp/repo/Common/MathUtils/Tsallis.h		20
start	p	o2::utils::FileFetcher	$tmp/repo/Common/Utils/Fake.h	()	5
helperFunction	p	o2::utils	$tmp/repo/Common/Utils/Fake.h	()	7
my_helper	p	o2::utils	$tmp/repo/Common/Utils/Fake.h	()	8
EOF

    cat > "$tmp/reachable.txt" <<EOF
$tmp/repo/Common/Utils/use1.cxx
$tmp/repo/Common/MathUtils/Tsallis.h
$tmp/repo/Common/Utils/ConfigurableParam.h
$tmp/repo/Common/Utils/FIFO.h
$tmp/repo/DataFormats/Detectors/Common/EncodedBlocks.h
EOF
    echo "$tmp/repo/Common/Utils/use1.cxx" > "$tmp/seed.txt"

    # The default-style filter — same as production
    local filter='kind ~ /^[csfp]$/ && file ~ /\/Common\/|\/DataFormats\/Detectors\/Common\// && _bare !~ /^__anon/ && length(_bare) >= 4 && _bare !~ /^GPU[a-z]*$/ && parent !~ /^std$/ && parent !~ /^std::/'

    local tool; tool=$(detect_grep)
    echo "TEST: tool=$tool" >&2
    count_symbols "$tmp/symbols.tsv" "$tmp/reachable.txt" "$tmp/seed.txt" \
                  "$tmp/usage.csv" "$filter" "$tmp" "$tool" 2> "$tmp/stderr"

    echo "=== TEST CSV ==="
    cat "$tmp/usage.csv"
    echo "=== TEST CHECKS ==="

    local fail=0
    check() { if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi }

    # Bug A
    check "Bug A: GPUd not in CSV" \
        '! grep -q "^GPUd," "$tmp/usage.csv"'
    # Bug C
    check "Bug C: array (std::array) excluded" \
        '! grep -q "^array," "$tmp/usage.csv"'
    # Bug B
    check "Bug B: clear marked ambiguous (count=-1)" \
        '[ "$(awk -F, "\$1==\"clear\"{print \$7}" "$tmp/usage.csv" | sort -u)" = "-1" ]'
    check "Bug B: clear has 2 rows" \
        '[ "$(grep -c "^clear," "$tmp/usage.csv")" = "2" ]'
    # match_confidence
    check "confidence: Tsallis = high (CamelCase)" \
        '[ "$(awk -F, "\$1==\"Tsallis\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: tsallisPDF = high (mixed case)" \
        '[ "$(awk -F, "\$1==\"tsallisPDF\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: ConfigurableParam = high (CamelCase)" \
        '[ "$(awk -F, "\$1==\"ConfigurableParam\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: setValue = high (CamelCase)" \
        '[ "$(awk -F, "\$1==\"setValue\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: start = low (5 chars, all lowercase)" \
        '[ "$(awk -F, "\$1==\"start\"{print \$13}" "$tmp/usage.csv")" = "low" ]'
    check "confidence: helperFunction = high (CamelCase)" \
        '[ "$(awk -F, "\$1==\"helperFunction\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: my_helper = high (snake_case underscore)" \
        '[ "$(awk -F, "\$1==\"my_helper\"{print \$13}" "$tmp/usage.csv")" = "high" ]'
    check "confidence: clear = ambiguous" \
        '[ "$(awk -F, "\$1==\"clear\"{print \$13}" "$tmp/usage.csv" | sort -u)" = "ambiguous" ]'

    # CSV columns
    check "CSV header has 13 columns" \
        '[ "$(head -1 "$tmp/usage.csv" | awk -F, "{print NF}")" = "13" ]'

    # Resume
    count_symbols "$tmp/symbols.tsv" "$tmp/reachable.txt" "$tmp/seed.txt" \
                  "$tmp/usage.csv" "$filter" "$tmp" "$tool" 2> "$tmp/stderr2"
    check "resume: 0 newly processed second run" \
        'grep -q "newly_processed=0" "$tmp/stderr2"'

    echo
    if [ "$fail" = "0" ]; then echo "ALL TESTS PASSED"; return 0
    else echo "TESTS FAILED"; return 1; fi
}

# ---------- CLI ----------
SYM=""; REACH=""; SEED=""; OUT=""; FILTER=""; GIT_ROOT="${ALICEO2_ROOT:-}"; GREP_TOOL=""

# v0.4 default filter — minimal, since match_confidence column now does the
# heavy lifting. Just exclude the clearly-not-real-symbols (GPU macros,
# std namespace, single-letter, anonymous lambdas). Common English words
# remain in CSV but with match_confidence=low for architect-side filtering.
DEFAULT_FILTER='kind ~ /^[csfp]$/ \
&& file ~ /\/Common\/|\/DataFormats\/Detectors\/Common\// \
&& _bare !~ /^__anon/ \
&& length(_bare) >= 4 \
&& _bare !~ /^GPU[a-z]*$/ \
&& parent !~ /^std$/ \
&& parent !~ /^std::/'

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
