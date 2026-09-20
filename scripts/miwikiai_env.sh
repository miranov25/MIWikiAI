#!/usr/bin/env bash

# MIWikiAI environment.
#
# This script is expected to live in:
#   <MIWikiAI-root>/scripts/miwikiai_env.sh
#
# Therefore MIWIKIAI can be derived without using $HOME.

_MIWIKIAI_SCRIPT_DIR="$(
    cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd
)" || return 1

MIWIKIAI="$(
    cd "$_MIWIKIAI_SCRIPT_DIR/.." >/dev/null 2>&1 && pwd
)" || return 1

export MIWIKIAI
export MIWIKIAI_SCRIPTS="$MIWIKIAI/scripts"
export MIWIKIAI_O2="$MIWIKIAI/Alice/code/O2"
export MIWIKIAI_O2_REVIEWS="$MIWIKIAI/Alice/code/O2/reviews"

if [ ! -d "$MIWIKIAI/.git" ]; then
    echo "miwikiai_env.sh: not inside a MIWikiAI Git checkout:" >&2
    echo "  $MIWIKIAI" >&2
    return 1 2>/dev/null || exit 1
fi

# Downloads is intentionally NOT derived from HOME.
# It is machine/user specific and must be supplied externally.
if [ -z "${Downloads:-}" ]; then
    echo "miwikiai_env.sh: Downloads is not set." >&2
    echo "Set it explicitly, for example:" >&2
    echo '  export Downloads=/Users/miranov25/Downloads' >&2
    return 1 2>/dev/null || exit 1
fi

if [ ! -d "$Downloads" ]; then
    echo "miwikiai_env.sh: Downloads directory does not exist:" >&2
    echo "  $Downloads" >&2
    return 1 2>/dev/null || exit 1
fi

echo "MIWIKIAI=$MIWIKIAI"
echo "Downloads=$Downloads"

unset _MIWIKIAI_SCRIPT_DIR