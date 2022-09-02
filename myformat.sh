#!/bin/sh
set -u

/idea/bin/idea.sh format "$@"

rm -rf '?' # Workaround: Remove unnecessary config folder created by IntelliJ

FAIL_IF_NONCOMPLIANT="${FAIL_IF_NONCOMPLIANT:-false}"
if [ "$FAIL_IF_NONCOMPLIANT" = false ]; then
    exit 0
fi

exit "$(git diff-files --quiet; echo $?)"