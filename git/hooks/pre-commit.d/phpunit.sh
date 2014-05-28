#!/bin/bash
hook_title PHPUnit

config=$(find -maxdepth 2 -iname 'phpunit.xml*' | sort | head -1)
if [ -z "$config" ]; then
    hook_skip no PHPUnit configuration file found
    exit 0
fi

RESULT=$(phpunit -c $(dirname "${config}") --stop-on-error --stop-on-failure 2>&1)
if [ $? -ne 0 ]; then
    if echo "${RESULT}"|grep -q 'PHP Fatal error'; then
        INFO="Fatal error"
    else
        INFO="$(echo "${RESULT}"|grep -oP '(?<=^There was )[1-9][0-9]*+(?= failure)') failing tests"
    fi
    hook_ko "${INFO}"
    echo "${RESULT}"
    exit 1
fi

hook_ok All tests passed
