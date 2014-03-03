#!/bin/bash
hook_title SF2 Doctrine Schema Validator

files=( $(git_changed_files -- '*/Entity/*.php') )
if [ ${#files[@]} -eq 0 ]; then
    hook_skip no new or modified entities
    exit 0
fi

errors=$(app/console doctrine:schema:validate|grep -A1 Mapping.*FAIL)
if [ $? -eq 0 ]; then
    hook_ko
    hook_details "$errors"
    exit 1
fi

hook_ok
