#!/bin/sh

/idea/bin/idea.sh format "$@"

# Workaround: Remove unnecessary config folder created by IntelliJ
rm -rf '?'
