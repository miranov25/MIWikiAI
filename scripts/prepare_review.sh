#!/usr/bin/env bash
# =============================================================================
# prepare_review.sh — bash wrapper around prepare_review.py v1.4
# =============================================================================
#
# v1.0 replaced the v0.x regex-based bash heredoc approach with a Python
# module using the mistletoe markdown AST parser. This file is a thin wrapper
# that forwards arguments to prepare_review.py for backward-compat with
# existing `bash scripts/prepare_review.sh ...` invocations.
#
# Run modes:
#   prepare_review.sh --artifact FILE [options]
#   prepare_review.sh --test       — run unit tests via pytest
#   prepare_review.sh -h | --help  — show help
#
# Dependencies: see scripts/requirements.txt
#   python3 -m pip install -r scripts/requirements.txt
#
# =============================================================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON_SCRIPT="$SCRIPT_DIR/prepare_review.py"
PYTHON="${PYTHON:-python3}"

if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    echo "ERROR: $PYTHON_SCRIPT not found" >&2
    exit 2
fi

# -----------------------------------------------------------------------------
# Dependency preflight
#
# MUST run before the --test branch below. That branch ends in `exec`, which
# replaces the process, so anything placed after it is unreachable for --test.
# Before this was hoisted, a missing mistletoe surfaced as a raw
# ModuleNotFoundError from inside pytest collection — which does not tell the
# operator which interpreter needs the package.
#
# Naming sys.executable matters: pytest resolves the same interpreter this
# script uses, which is not necessarily the active venv. Installing into the
# venv while pytest runs an aliBuild python leaves --test failing identically.
# -----------------------------------------------------------------------------
_check_deps() {
    local missing=()

    # keep in sync with scripts/requirements.txt
    for mod in mistletoe; do
        "$PYTHON" -c "import ${mod}" 2>/dev/null || missing+=("${mod}")
    done

    # pytest is only needed for --test
    if [[ "$1" == "--test" ]]; then
        "$PYTHON" -c "import pytest" 2>/dev/null || missing+=("pytest")
    fi

    [ ${#missing[@]} -eq 0 ] && return 0

    local exe
    exe="$("$PYTHON" -c 'import sys; print(sys.executable)' 2>/dev/null || echo "$PYTHON")"

    echo "ERROR: missing Python module(s): ${missing[*]}" >&2
    echo "" >&2
    echo "       Interpreter in use: ${exe}" >&2
    echo "       Install into THAT interpreter, not merely the active venv:" >&2
    echo "" >&2
    echo "           ${exe} -m pip install -r ${SCRIPT_DIR}/requirements.txt" >&2
    echo "" >&2
    echo "       On a system Python that refuses, append --break-system-packages." >&2
    return 2
}

_check_deps "$1" || exit 2

# Report resolved versions — usable as runtime_evidence under the
# MIWikiAI Source Identity Convention v0.3 §7.2.
"$PYTHON" - <<'PY'
import sys, mistletoe
print(f"INFO    deps ok: python {sys.version.split()[0]}, mistletoe {mistletoe.__version__}")
PY

# -----------------------------------------------------------------------------
# Special handling: --test runs pytest, not the main module
# -----------------------------------------------------------------------------
if [[ "$1" == "--test" ]]; then
    if [[ ! -d "$SCRIPT_DIR/tests" ]]; then
        echo "ERROR: tests/ not found at $SCRIPT_DIR/tests" >&2
        exit 2
    fi
    cd "$SCRIPT_DIR/.."
    exec "$PYTHON" -m pytest "scripts/tests/" -v
fi

# Forward all arguments to the Python module
exec "$PYTHON" "$PYTHON_SCRIPT" "$@"
