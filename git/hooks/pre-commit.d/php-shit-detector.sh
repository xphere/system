#!/bin/bash
hook_title PHP Shit Detector

files=( $(git_changed_files -- '*.php') )
if [ ${#files[@]} -eq 0 ]; then
    hook_skip no PHP files found
    exit 0
fi

REGEX="die|var_dump"

errors=$(egrep -nw "$REGEX" -- "${files[@]}")
if [ -n "${errors}" ]; then
    hook_ko Found messy code at
    hook_details "${errors}"
    exit 1
fi

hook_ok "${#files[@]} files tested"
