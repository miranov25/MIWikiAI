#!/usr/bin/env bash
# =============================================================================
# miwikiai_shell.sh — verified-install helpers for MIWikiAI deliveries
# =============================================================================
#
# Source this from your shell profile:
#
#     source ~/github/MIWikiAI/scripts/miwikiai_shell.sh
#
# WHY THIS EXISTS
# ---------------
# Delivered files reach the working tree through a download directory. A copy
# can fail or copy the WRONG BYTES while looking entirely successful:
#
#   * `$Downloads` unset or misspelled -> cp fails, the OLD file stays, and the
#     next command runs against the previous version. This happened on
#     2026-05-05: `cp $Downloads/Common_utilities_API.md ...` silently failed,
#     the prefilter was run on the superseded artifact, and the resulting FAIL
#     was investigated as an artifact defect for a full turn. It was not.
#   * A stale file of the SAME NAME sits in the download directory from an
#     earlier revision. cp succeeds. Everything downstream is wrong, and the
#     filename gives no hint.
#   * Truncated or interrupted copy -> partial file, no error.
#
# The fix is not `&&`. The fix is to refuse to copy bytes that do not match a
# hash quoted in the delivery.
#
# RELATION TO THE RUN FINGERPRINT
# -------------------------------
# scripts/review_common.py records `artifact_sha256` at RUN time. That number
# is only meaningful if the installed bytes are the delivered bytes. These
# helpers verify at INSTALL time, closing the loop:
#
#     delivered bytes  ==  installed bytes  ==  bytes the tooling ran against
#
# On success an INSTALL RECORD line is printed. Paste it into review evidence;
# it is the proof that two parties hold the same file.
#
# ORIGIN
# ------
# `install_by_md5` is the Architect's function from a sibling project, adopted
# here with its semantics unchanged. Additions: portable hashing across
# GNU/BSD, SHA-256 support alongside MD5, and batch manifest install.
# =============================================================================

# --- repository root --------------------------------------------------------
# One manifest must work on the Mac and in the Linux container, so destination
# paths are repo-relative and resolved against MIWIKIAI_ROOT.
#
#   export MIWIKIAI_ROOT=/Users/miranov25/github/MIWikiAI     # Mac
#   export MIWIKIAI_ROOT=/home/miranov25/github/MIWikiAI      # container
#
# If unset, it is derived from this file's own location, so sourcing it from
# inside the checkout is enough.

if [ -z "$MIWIKIAI_ROOT" ]; then
    _mw_self="${BASH_SOURCE[0]:-$0}"
    MIWIKIAI_ROOT="$(cd "$(dirname "$_mw_self")/.." 2>/dev/null && pwd)"
    unset _mw_self
fi
export MIWIKIAI_ROOT

# Resolve a repo-relative path; absolute paths pass through untouched.
_mw_abs() {
    case "$1" in
        /*) printf '%s\n' "$1" ;;
        *)  printf '%s\n' "${MIWIKIAI_ROOT%/}/$1" ;;
    esac
}

miwikiai_root() { echo "$MIWIKIAI_ROOT"; }

# --- portable hashing -------------------------------------------------------
# GNU coreutils, BSD/macOS, and busybox all spell these differently.

_ibm5_md5() {
    local f="$1"
    if   command -v md5sum >/dev/null 2>&1; then md5sum   "$f" | awk '{print $1}'
    elif command -v md5    >/dev/null 2>&1; then md5 -q   "$f"
    elif command -v openssl>/dev/null 2>&1; then openssl md5 -r "$f" | awk '{print $1}'
    else echo "install_by_md5: no md5 tool found (md5sum/md5/openssl)" >&2; return 1
    fi
}

_ibm5_sha256() {
    local f="$1"
    if   command -v sha256sum >/dev/null 2>&1; then sha256sum "$f" | awk '{print $1}'
    elif command -v shasum    >/dev/null 2>&1; then shasum -a 256 "$f" | awk '{print $1}'
    elif command -v openssl   >/dev/null 2>&1; then openssl sha256 -r "$f" | awk '{print $1}'
    else echo "install_by_md5: no sha256 tool found (sha256sum/shasum/openssl)" >&2; return 1
    fi
}

# Dispatch on digest length so callers need not say which algorithm they used.
#   32 hex chars -> MD5      64 hex chars -> SHA-256
_ibm5_hash_for() {
    local f="$1" expected="$2"
    case "${#expected}" in
        32) _ibm5_md5    "$f" ;;
        64) _ibm5_sha256 "$f" ;;
        *)  echo "install_by_md5: expected digest must be 32 (md5) or 64 (sha256) hex chars; got ${#expected}" >&2
            return 1 ;;
    esac
}

_ibm5_algo_name() {
    case "${#1}" in 32) echo md5 ;; 64) echo sha256 ;; *) echo unknown ;; esac
}


# --- install_by_md5 ---------------------------------------------------------

install_by_md5() {
    local src dst expected actual backup algo

    if [ "$#" -ne 3 ]; then
        cat >&2 <<'USAGE'
usage: install_by_md5 <src> <dst> <expected_digest>
  <src>              file to install, e.g. "$Downloads/review_common.py"
  <dst>              path in the working tree, e.g. scripts/review_common.py
  <expected_digest>  the MD5 (32 hex) or SHA-256 (64 hex) quoted in the delivery
Nothing is copied unless <src> matches <expected_digest> exactly.
USAGE
        return 2
    fi

    src="$1"; dst="$2"; expected="$3"
    algo="$(_ibm5_algo_name "$expected")"

    if [ "$algo" = "unknown" ]; then
        echo "install_by_md5: expected digest must be 32 (md5) or 64 (sha256) hex chars" >&2
        echo "  got ${#expected} chars: $expected" >&2
        return 2
    fi

    if [ ! -f "$src" ]; then
        echo "install_by_md5: SOURCE NOT FOUND: $src" >&2
        echo "  If you used \$Downloads, check it is set:  echo \"\$Downloads\"" >&2
        echo "  An unset variable expands to empty and the path silently becomes" >&2
        echo "  /<filename>, which does not exist. Nothing was installed." >&2
        return 1
    fi

    actual="$(_ibm5_hash_for "$src" "$expected")" || return 1

    if [ "$actual" != "$expected" ]; then
        echo "install_by_md5: ${algo^^} MISMATCH -- nothing was installed" >&2
        echo "  source   : $src" >&2
        echo "  expected : $expected" >&2
        echo "  actual   : $actual" >&2
        echo "  Most likely a STALE file of the same name is in the download" >&2
        echo "  directory. Delete it and download the delivered file again." >&2
        return 1
    fi

    mkdir -p "$(dirname "$dst")" || return 1

    if [ -e "$dst" ]; then
        local prev
        prev="$(_ibm5_hash_for "$dst" "$expected" 2>/dev/null)"
        if [ "$prev" = "$expected" ]; then
            echo "install_by_md5: ALREADY CURRENT  $dst  $actual"
            echo "INSTALL RECORD  $dst  $algo=$actual  (unchanged)"
            return 0
        fi
        backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
        cp -p "$dst" "$backup" || return 1
        echo "install_by_md5: previous version saved to $backup"
    fi

    cp -p "$src" "$dst" || return 1

    actual="$(_ibm5_hash_for "$dst" "$expected")" || return 1
    if [ "$actual" != "$expected" ]; then
        echo "install_by_md5: POST-COPY VERIFY FAILED for $dst" >&2
        echo "  expected : $expected" >&2
        echo "  actual   : $actual" >&2
        echo "  The copy completed but the bytes differ. Disk full, or the" >&2
        echo "  destination is being written by something else." >&2
        return 1
    fi

    echo "install_by_md5: OK  $dst  $actual"
    echo "INSTALL RECORD  $dst  $algo=$actual"
    return 0
}


# --- install_newest_by_md5 --------------------------------------------------
# macOS re-downloads the same name as "file (1).ext", "file (2).ext", ... A
# fixed-basename lookup then either misses the new copy or silently installs
# the OLDEST one. This globs, takes the newest by mtime, verifies, installs,
# and then removes EVERY match so the next download cannot be stale.
#
#     install_newest_by_md5 'check_links*.py' scripts/check_links.py <digest>
#
# Adopted from the Architect's AO2DAI function. Additions: MIWIKIAI_ROOT
# resolution for <dst>, sha256 support, cleanup only after a verified install,
# and the other candidates are listed so an unexpected match is visible.

install_newest_by_md5() {
    local pattern dst want src n from

    if [ "$#" -ne 3 ]; then
        echo "usage: install_newest_by_md5 <glob> <dst> <expected_digest>" >&2
        echo "  <glob>  pattern under \$Downloads, e.g. 'check_links*.py'" >&2
        echo "  <dst>   repo-relative or absolute destination" >&2
        return 2
    fi
    pattern="$1"; dst="$2"; want="$3"

    from="${Downloads:-$HOME/Downloads}"
    from="${from%/}"
    if [ ! -d "$from" ]; then
        echo "install_newest_by_md5: download directory not found: $from" >&2
        echo "  set \$Downloads, e.g.  export Downloads=\"\$HOME/Downloads\"" >&2
        return 2
    fi

    src="$(ls -t $from/$pattern 2>/dev/null | head -1)"
    if [ -z "$src" ]; then
        echo "install_newest_by_md5: nothing matches $from/$pattern" >&2
        return 1
    fi

    n="$(ls -t $from/$pattern 2>/dev/null | wc -l | tr -d ' ')"
    echo "  using $src  ($n copy/copies present)"
    if [ "$n" -gt 1 ]; then
        ls -t $from/$pattern 2>/dev/null | tail -n +2 | sed 's/^/    also: /'
    fi

    install_by_md5 "$src" "$(_mw_abs "$dst")" "$want" || return 1

    # Only after a verified install: clear every copy, so the next download
    # of this name starts from an empty slot.
    rm -f $from/$pattern
    echo "  cleaned $n copy/copies from $from"
    return 0
}


# --- verify_by_md5 ----------------------------------------------------------
# Check without installing. Use before running the tooling, to confirm the
# tree holds what the delivery said it should.

verify_by_md5() {
    local f expected actual algo
    if [ "$#" -ne 2 ]; then
        echo "usage: verify_by_md5 <file> <expected_digest>" >&2
        return 2
    fi
    f="$1"; expected="$2"; algo="$(_ibm5_algo_name "$expected")"
    [ -f "$f" ] || { echo "verify_by_md5: NOT FOUND: $f" >&2; return 1; }
    actual="$(_ibm5_hash_for "$f" "$expected")" || return 1
    if [ "$actual" != "$expected" ]; then
        echo "verify_by_md5: MISMATCH  $f" >&2
        echo "  expected : $expected" >&2
        echo "  actual   : $actual" >&2
        return 1
    fi
    echo "verify_by_md5: OK  $f  $algo=$actual"
    return 0
}


# --- install_manifest -------------------------------------------------------
# Batch install from a delivery manifest. One command per delivery instead of
# one per file, and NOTHING is copied unless EVERY file verifies first.
#
# Manifest format — one record per line, '#' comments and blanks ignored:
#
#     <digest>  <src_basename>  <dst_path_in_repo>
#
# Example (scripts/DELIVERY_20260825.manifest):
#
#     eeb63cd3...8370  Common_utilities_v0_3_1.md  Alice/code/O2/Common_utilities_v0_3_1.md
#     c8d1be7c...01a5  check_links.py              scripts/check_links.py
#
# Source files are looked up in --from (default "$Downloads").

install_manifest() {
    local manifest from="${Downloads:-$HOME/Downloads}" dry=0
    from="${from%/}"
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --from) from="$2"; shift 2 ;;
            --dry-run) dry=1; shift ;;
            -h|--help)
                cat <<'USAGE'
usage: install_manifest <manifest> [--from DIR] [--dry-run]
Two-phase: every file is verified before any file is copied.
A single mismatch aborts the whole delivery, leaving the tree untouched.
USAGE
                return 0 ;;
            *) manifest="$1"; shift ;;
        esac
    done
    [ -n "$manifest" ] || { echo "install_manifest: no manifest given" >&2; return 2; }
    manifest="$(_mw_abs "$manifest")"
    [ -f "$manifest" ] || { echo "install_manifest: manifest not found: $manifest" >&2; return 1; }

    local digest base dst n=0 bad=0
    local -a D B T S

    # ---- phase 1: verify everything, install nothing ----
    echo "install_manifest: verifying against $from"
    echo "install_manifest: installing into  $MIWIKIAI_ROOT"
    while read -r digest base dst _; do
        case "$digest" in ''|'#'*) continue ;; esac
        [ -n "$dst" ] || { echo "  MALFORMED LINE: $digest $base" >&2; bad=$((bad+1)); continue; }
        n=$((n+1))
        # The src column is a GLOB. macOS gives "name (1).ext" on re-download,
        # so a literal basename would miss the new copy or take the oldest.
        local cand cnt
        cand="$(ls -t $from/$base 2>/dev/null | head -1)"
        if [ -z "$cand" ]; then
            echo "  MISSING   $base   (no match in $from)" >&2; bad=$((bad+1)); continue
        fi
        cnt="$(ls -t $from/$base 2>/dev/null | wc -l | tr -d ' ')"
        local a; a="$(_ibm5_hash_for "$cand" "$digest")" || { bad=$((bad+1)); continue; }
        if [ "$a" != "$digest" ]; then
            echo "  MISMATCH  $(basename "$cand")" >&2
            echo "              expected $digest" >&2
            echo "              actual   $a" >&2
            [ "$cnt" -gt 1 ] && echo "              ($cnt copies match '$base'; newest was used)" >&2
            bad=$((bad+1)); continue
        fi
        if [ "$cnt" -gt 1 ]; then
            echo "  ok        $(basename "$cand")   ($cnt copies, newest used)"
        else
            echo "  ok        $(basename "$cand")"
        fi
        D+=("$digest"); B+=("$base"); T+=("$dst"); S+=("$cand")
    done < "$manifest"

    if [ "$bad" -gt 0 ]; then
        echo "install_manifest: $bad of $n file(s) failed verification -- NOTHING INSTALLED" >&2
        echo "  A stale copy of the same name in $from is the usual cause." >&2
        return 1
    fi
    echo "install_manifest: all $n file(s) verified"

    if [ "$dry" -eq 1 ]; then
        echo "install_manifest: --dry-run, stopping before install"
        return 0
    fi

    # ---- phase 2: install ----
    local i
    for i in "${!D[@]}"; do
        install_by_md5 "${S[$i]}" "$(_mw_abs "${T[$i]}")" "${D[$i]}" || {
            echo "install_manifest: FAILED at ${T[$i]} -- tree is now PARTIALLY installed" >&2
            return 1
        }
    done
    echo "install_manifest: $n file(s) installed and post-copy verified"
    return 0
}
