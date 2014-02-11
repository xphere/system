#!/bin/bash
. $(dirname $0)/utils.sh

git_need_stash
STASHED=$?
if [ ${STASHED} -ne 0 ]; then
    hook_warn You have unstaged changes, stashing
    git_stash
fi

hooks_run "$@"
RETVAL=$?

if [ ${STASHED} -ne 0 ]; then
    hook_info Unstashing previously saved changes
    git_unstash
fi

if [ ${RETVAL} -ne 0 ]; then
    hook_error Aborting commit due to errors on verification
    exit "${RETVAL}"
fi
