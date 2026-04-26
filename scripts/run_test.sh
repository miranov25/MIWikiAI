#!/bin/bash
# run_test.sh — MIWikiAI link + cross-reference validation
# Checks: internal file links, in-file anchors, version-duplication,
#         [VERIFY] flag sync, [computed] derivations, required front-matter,
#         optional external URL reachability.
# Usage: ./run_test.sh [--external] [--verbose] [path]
#   --external  also check external URLs (slow, requires curl)
#   --verbose   show all passed checks too
#   path        default: Alice/
# Exit codes: 0 pass/warnings, 1 errors, 2 preflight failure

set -u

# ─── config ───────────────────────────────────────────────────────────
ROOT="Alice"
CHECK_EXTERNAL=false
VERBOSE=false

for arg in "$@"; do
    case "$arg" in
        --external) CHECK_EXTERNAL=true ;;
        --verbose)  VERBOSE=true ;;
        --help|-h)
            grep '^#' "$0" | head -12
            exit 0
            ;;
        -*)
            echo "unknown option: $arg" >&2
            exit 2
            ;;
        *) ROOT="$arg" ;;
    esac
done

# ─── subshell-safe counter files ──────────────────────────────────────
# bash `while read` loops execute in subshells; counters incremented
# there don't propagate back to the parent. Use tempfiles instead.
TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'runtest')
ERR_F="$TMPDIR/err"
WARN_F="$TMPDIR/warn"
CHK_F="$TMPDIR/chk"
echo 0 > "$ERR_F"; echo 0 > "$WARN_F"; echo 0 > "$CHK_F"
trap 'rm -rf "$TMPDIR"' EXIT

bump() {
    local f=$1
    local n
    n=$(cat "$f")
    echo $((n+1)) > "$f"
}

# ─── color output (disabled if not a tty) ─────────────────────────────
if [ -t 1 ]; then
    RED=$'\033[0;31m'
    YELLOW=$'\033[0;33m'
    GREEN=$'\033[0;32m'
    BLUE=$'\033[0;34m'
    NC=$'\033[0m'
else
    RED=""; YELLOW=""; GREEN=""; BLUE=""; NC=""
fi

err()  { echo "${RED}ERROR${NC}   $1"; bump "$ERR_F"; }
warn() { echo "${YELLOW}WARN${NC}    $1"; bump "$WARN_F"; }
ok()   { bump "$CHK_F"; [ "$VERBOSE" = true ] && echo "${GREEN}OK${NC}      $1"; return 0; }
info() { echo "${BLUE}INFO${NC}    $1"; }

# ─── preflight ────────────────────────────────────────────────────────
if [ ! -d "$ROOT" ]; then
    echo "${RED}ERROR${NC}   $ROOT directory not found — run from repo root or pass path"
    echo "        usage: $0 [--external] [--verbose] [path]"
    exit 2
fi

echo "=================================================================="
echo " MIWikiAI link validation"
echo " root:     $ROOT"
echo " external: $CHECK_EXTERNAL"
echo " verbose:  $VERBOSE"
echo "=================================================================="
echo

# ─── gather files ─────────────────────────────────────────────────────
MD_FILES=$(find "$ROOT" -name '*.md' -type f 2>/dev/null | sort)
if [ -z "$MD_FILES" ]; then
    warn "no markdown files found under $ROOT"
    exit 0
fi
MD_COUNT=$(echo "$MD_FILES" | grep -c . | tr -d ' ')
info "found $MD_COUNT markdown files"
echo

# ─── test 1: version duplication ──────────────────────────────────────
echo "─── TEST 1: version duplication ─────────────────────────────────"
echo "$MD_FILES" | while read -r f; do
    base=$(basename "$f" .md)
    stem=$(echo "$base" | sed -E 's/_v[0-9]+[._][0-9]+(_turn[0-9]+)?$//; s/_v[0-9]+$//')
    # normalize for case-insensitive grouping (ITS_source_of_truth vs ITS_SourceOfTruth)
    norm=$(echo "$stem" | tr '[:upper:]' '[:lower:]' | tr -d '_')
    echo "$norm|$stem|$f"
done | sort > "$TMPDIR/stems"

awk -F'|' '
{
    files[$1] = files[$1] ? files[$1] "|" $3 : $3
    count[$1]++
    orig[$1] = $2
}
END {
    for (k in count) {
        if (count[k] > 1) {
            printf "DUP|%s|%s\n", orig[k], files[k]
        }
    }
}' "$TMPDIR/stems" | sort > "$TMPDIR/dups"

if [ -s "$TMPDIR/dups" ]; then
    while IFS='|' read -r _ stem rest; do
        warn "duplicate versions of '$stem':"
        echo "$rest" | tr '|' '\n' | sed 's/^/          /'
    done < "$TMPDIR/dups"
else
    ok "no duplicate versions detected"
fi
echo

# ─── test 2: internal file links resolve ──────────────────────────────
echo "─── TEST 2: internal file links resolve ─────────────────────────"
for f in $MD_FILES; do
    grep -oE '\]\([^)]*\.md[^)]*\)' "$f" 2>/dev/null | \
        sed -E 's/^\]\(//; s/\)$//' | while read -r link; do
        if echo "$link" | grep -qE '^https?:|^mailto:'; then
            continue
        fi
        target=$(echo "$link" | sed 's|#.*||')
        [ -z "$target" ] && continue
        dir=$(dirname "$f")
        if [ -f "$dir/$target" ]; then
            ok "$f → $link"
        elif (cd "$dir" 2>/dev/null && [ -f "$target" ]); then
            ok "$f → $link"
        else
            err "$f → broken link: $link"
        fi
    done
done
echo

# ─── test 3: §N.M anchor references ────────────────────────────────────
echo "─── TEST 3: §N.M anchor references resolve within file ──────────"
for f in $MD_FILES; do
    body=$(awk 'BEGIN{fm=0} /^---$/{fm++; next} fm>=2 || fm==0{print}' "$f")
    refs=$(echo "$body" | grep -oE '§[0-9]+(\.[0-9]+)*' 2>/dev/null | sort -u)
    [ -z "$refs" ] && continue
    # headings can be "## 1 Title" or "## 1. Title" or "### 3.1.2 Title" — normalize
    headings=$(grep -oE '^#+ +[0-9]+(\.[0-9]+)*\.? ' "$f" 2>/dev/null | \
               sed -E 's/^#+ +//; s/\.? +$//' | sort -u)
    echo "$refs" | while read -r ref; do
        [ -z "$ref" ] && continue
        num=${ref#§}
        if echo "$headings" | grep -qx "$num"; then
            ok "$f — $ref resolves"
        else
            parent=$(echo "$num" | cut -d. -f1)
            if echo "$headings" | grep -qx "$parent"; then
                ok "$f — $ref (sub-ref of §$parent)"
            else
                warn "$f — $ref referenced but no matching heading"
            fi
        fi
    done
done
echo

# ─── test 4: [VERIFY] flags ───────────────────────────────────────────
echo "─── TEST 4: [VERIFY] body tags vs front-matter known_verify_flags ──"
for f in $MD_FILES; do
    body_count=$(grep -c '\[VERIFY' "$f" 2>/dev/null | head -1)
    body_count=${body_count:-0}
    if [ "$body_count" -gt 0 ]; then
        if grep -q '^known_verify_flags:' "$f" 2>/dev/null; then
            ok "$f — [VERIFY] body=$body_count, fm field present"
        else
            warn "$f — $body_count [VERIFY] in body, no known_verify_flags field"
        fi
    fi
done
echo

# ─── test 5: [computed] derivations ───────────────────────────────────
echo "─── TEST 5: [computed] tags have derivation within 3 lines ──────"
for f in $MD_FILES; do
    # find [computed] line numbers, but skip `[computed]` in backticks
    # (those are meta-references to the convention, not actual tag uses)
    grep -n '\[computed\]' "$f" 2>/dev/null | while IFS=: read -r lineno rest; do
        # skip if the match is inside backticks: `[computed]` or ` `[computed]` `
        if echo "$rest" | grep -qE '`\[computed\]`'; then
            ok "$f:$lineno — [computed] in backticks (meta-reference, skipped)"
            continue
        fi
        start=$((lineno > 3 ? lineno - 3 : 1))
        end=$((lineno + 7))  # widened from 3 to 7 to catch derivation in following prose paragraph
        snippet=$(sed -n "${start},${end}p" "$f" 2>/dev/null)
        # accept: HTML comment with digits + operator, OR inline eq like N op M = P
        if echo "$snippet" | grep -qE '<!--' && echo "$snippet" | grep -qE '<!--.*[0-9]+.*[-+*/×].*[0-9]'; then
            ok "$f:$lineno — [computed] has HTML-comment derivation"
        elif echo "$snippet" | grep -qE '[0-9]+ *[-+*/×] *[0-9]+ *='; then
            ok "$f:$lineno — [computed] has inline equation"
        elif echo "$snippet" | grep -qE '= *[0-9]'; then
            ok "$f:$lineno — [computed] has result assignment"
        else
            warn "$f:$lineno — [computed] no derivation within ±3 / +7 lines"
        fi
    done
done
echo

# ─── test 6: required front-matter fields ─────────────────────────────
echo "─── TEST 6: required front-matter fields ────────────────────────"
REQUIRED_FIELDS="wiki_id review_status"
for f in $MD_FILES; do
    if ! head -1 "$f" 2>/dev/null | grep -q '^---$'; then
        warn "$f — no YAML front-matter"
        continue
    fi
    fm=$(awk 'BEGIN{n=0} /^---$/{n++; if(n==2) exit; next} n==1{print}' "$f")
    for field in $REQUIRED_FIELDS; do
        if echo "$fm" | grep -q "^${field}:"; then
            ok "$f — has $field"
        else
            warn "$f — missing front-matter field: $field"
        fi
    done
done
echo

# ─── test 7: external URL reachability (opt-in) ───────────────────────
if [ "$CHECK_EXTERNAL" = true ]; then
    echo "─── TEST 7: external URL reachability ───────────────────────"
    if ! command -v curl >/dev/null 2>&1; then
        warn "curl not available — skipping external URL check"
    else
        URLS=$(grep -rhoE 'https?://[^ )"<>]+' "$ROOT" --include='*.md' 2>/dev/null | \
               sed 's/[.,;:]*$//' | sort -u)
        URL_COUNT=$(echo "$URLS" | grep -c . 2>/dev/null || echo 0)
        info "checking $URL_COUNT unique external URLs (10s timeout each)"
        echo "$URLS" | while read -r url; do
            [ -z "$url" ] && continue
            if echo "$url" | grep -qE 'docs\.google\.com|indico\.cern\.ch'; then
                ok "$url (skipped — auth-gated)"
                continue
            fi
            code=$(curl -sS -o /dev/null -w '%{http_code}' \
                        --max-time 10 -L -I "$url" 2>/dev/null || echo "000")
            case "$code" in
                2*|401|403) ok "$url ($code)" ;;
                000)        warn "$url — timeout/unreachable" ;;
                *)          err "$url — HTTP $code" ;;
            esac
        done
    fi
    echo
fi

# ─── summary ──────────────────────────────────────────────────────────
FINAL_ERR=$(cat "$ERR_F")
FINAL_WARN=$(cat "$WARN_F")
FINAL_CHK=$(cat "$CHK_F")

echo "=================================================================="
echo " summary"
echo "=================================================================="
printf " checks passed:   %d\n" "$FINAL_CHK"
printf " warnings:        %d\n" "$FINAL_WARN"
printf " errors:          %d\n" "$FINAL_ERR"
echo

if [ "$FINAL_ERR" -gt 0 ]; then
    echo "${RED}FAIL${NC} — $FINAL_ERR errors found"
    exit 1
elif [ "$FINAL_WARN" -gt 0 ]; then
    echo "${YELLOW}PASS WITH WARNINGS${NC} — $FINAL_WARN warnings"
    exit 0
else
    echo "${GREEN}PASS${NC} — all checks passed"
    exit 0
fi
