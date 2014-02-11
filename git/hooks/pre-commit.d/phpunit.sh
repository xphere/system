#!/bin/bash
hook_title PHPUnit

RESULT=$(phpunit -c app --stop-on-error --stop-on-failure)
if [ $? -ne 0 ]; then
    hook_ko $(echo "${RESULT}"|grep -oP '(?<=^There was )[1-9][0-9]*+(?= failure)') failing tests
    echo "${RESULT}"
    exit 1
else
    hook_ok All tests passed
    exit 0
fi
