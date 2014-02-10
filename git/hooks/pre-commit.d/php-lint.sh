#!/bin/bash
echo -n "PHP Lint — "

skip=1
errors=()
files=()
while read -r -d $'\0'; do
    skip=0
    files+=("$REPLY")
    error=$(php -l "$REPLY" -ddisplay_errors=1 -derror_reporting=E_ALL -dlog_errrors=0 2>&1 >/dev/null)
    if [ -n "$error" ]; then
        errors+=($error);
    fi
done < <(git diff -z --cached --name-only --diff-filter=ACMR -- '*.php')

if [ $skip -eq 1 ]; then
    echo Skipping… no PHP files found in the commit
    exit 0
fi

if [ ${#errors[@]} -ne 0 ]; then
    echo KO!
    echo ${errors[*]}
    exit 1
fi

echo OK \(${#files[@]} files tested\)
exit 0
