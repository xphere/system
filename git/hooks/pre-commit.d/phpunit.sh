#!/bin/bash
hook_title PHPUnit

config=$(find -iname 'phpunit.xml*' | sort | head -1)
if [ -z "$config" ]; then
    hook_skip no PHPUnit configuration file found
    exit 0
fi

RESULT=$(phpunit -c $(dirname "${config}") --stop-on-error --stop-on-failure)
if [ $? -ne 0 ]; then
    hook_ko $(echo "${RESULT}"|grep -oP '(?<=^There was )[1-9][0-9]*+(?= failure)') failing tests
    echo "${RESULT}"
    exit 1
fi

hook_ok All tests passed
