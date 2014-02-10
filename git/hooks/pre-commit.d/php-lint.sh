#!/bin/bash
echo -n "PHP Lint — "

opts='--cached --name-only --diff-filter=ACMR -- *.php'
if [ $(git diff $opts | wc -l) -eq 0 ]; then
    echo Skipping early… no PHP files found in the commit
    exit 0
fi

git stash save -u -k -- "PHP-Lint" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo Error! Can\'t stash pending changes
    exit 1
fi

files=()
errors=()
while read -r -d $'\0'; do
    files+=("$REPLY")
    error=$(php -l "$REPLY" -ddisplay_errors=1 -derror_reporting=E_ALL -dlog_errrors=0 2>&1 >/dev/null)
    if [ -n "$error" ]; then
        errors+=($error);
    fi
done < <(git diff -z $opts)

if [ ${#errors[@]} -ne 0 ]; then
    echo KO!\n${errors[*]}
    exit 1
fi

echo OK \(${#files[@]} files tested\)

git cat-file -p stash@{0} | grep PHP-Lint >/dev/null 2>&1
if [ $? -eq 0 ]; then
    git stash pop >/dev/null 2>&1
fi

exit 0
