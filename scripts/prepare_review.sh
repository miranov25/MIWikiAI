#!/usr/bin/env bash
# =============================================================================
# prepare_review.sh — bash wrapper around prepare_review.py v1.0
# =============================================================================
#
# v1.0 replaces the v0.x regex-based bash heredoc approach with a Python
# module using mistletoe markdown AST parser. This file is a thin wrapper
# that forwards arguments to prepare_review.py for backward-compat with
# existing `bash scripts/prepare_review.sh ...` invocations.
#
# Run modes:
#   prepare_review.sh --artifact FILE [options]
#   prepare_review.sh --test       — run unit tests via pytest
#   prepare_review.sh -h | --help  — show help
#
# Requires: python3 with mistletoe and pytest installed.
#   pip install mistletoe pytest
#
# =============================================================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON_SCRIPT="$SCRIPT_DIR/prepare_review.py"

if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    echo "ERROR: $PYTHON_SCRIPT not found" >&2
    exit 2
fi

# Special handling: --test runs pytest, not the main module
if [[ "$1" == "--test" ]]; then
    if [[ ! -d "$SCRIPT_DIR/tests" ]]; then
        echo "ERROR: tests/ not found at $SCRIPT_DIR/tests" >&2
        exit 2
    fi
    cd "$SCRIPT_DIR/.."
    exec python3 -m pytest "scripts/tests/" -v
fi

# Verify mistletoe is installed
if ! python3 -c "import mistletoe" 2>/dev/null; then
    echo "ERROR: mistletoe not installed. Run: pip install mistletoe pytest" >&2
    echo "    (or: pip install --break-system-packages mistletoe pytest on system Python)" >&2
    exit 2
fi

# Forward all arguments to the Python module
exec python3 "$PYTHON_SCRIPT" "$@"
