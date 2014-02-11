#!/bin/bash
hook_title PHP Lint

files=( $(git_changed_files -- '*.php') )
if [ ${#files[@]} -eq 0 ]; then
    hook_skip no PHP files found
    exit 0
fi

for file in "${files[@]}"; do
    error=$(php --syntax-check "${file}" -ddisplay_errors=1 -derror_reporting=E_ALL -dlog_errrors=0 2>&1 >/dev/null)
    if [ "$error" ]; then
        errors+=("$error");
    fi
done

if [ ${#errors[@]} -ne 0 ]; then
    hook_ko ${#errors[@]} errors found
    hook_details "${errors[@]}"
    exit 1
fi

hook_ok "${#files[@]}" files tested
