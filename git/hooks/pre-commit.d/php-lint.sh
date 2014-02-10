#!/bin/bash
echo -n "PHP Lint — "

opts='--cached --name-only --diff-filter=ACMR -- *.php'
if [ $(git diff $opts | wc -l) -eq 0 ]; then
    echo Skipping early… no PHP files found in the commit
    exit 0
fi

errors=()
files=()
while read -r -d $'\0'; do
    files+=("$REPLY")
    error=$(php -l "$REPLY" -ddisplay_errors=1 -derror_reporting=E_ALL -dlog_errrors=0 2>&1 >/dev/null)
    if [ -n "$error" ]; then
        errors+=($error);
    fi
done < <(git diff -z $opts)

if [ ${#errors[@]} -ne 0 ]; then
    echo KO!
    echo ${errors[*]}
    exit 1
fi

echo OK \(${#files[@]} files tested\)
exit 0
