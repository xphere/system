#!/bin/bash

if [[ -t 1 && "$(tput colors)" -ge 8 ]]; then
    hook_title() { echo -en "\e[0;36m$@\e[0m — "; }
    hook_ok() { [ $# -ne 0 ] && echo -e "\e[0;32mOK \e[0;1;90m($@)\e[0m" || echo -e "\e[0;32mOK\e[0m"; }
    hook_ko() { [ $# -ne 0 ] && echo -e "\e[0;1;31mKO\e[0m \e[0;31m($@)\e[0m" || echo "\e[0;1;31mKO\e[0m"; }
    hook_skip() { [ $# -ne 0 ] && echo -e "\e[0mskip \e[0;1;90m($@)\e[0m" || echo "\e[0;90mskip\e[0m"; }
    hook_details() { while read -r line; do echo -e "\e[0m    - ${line}"; done <<< "$@"; }
    hook_info() { echo -e "\e[0;1;44m[*]\e[0;34m $@\e[0m"; }
    hook_warn() { echo -e "\e[0;1;30;43m[*]\e[0;33m $@\e[0m"; }
    hook_error() { echo -e "\e[0;1;41m[*]\e[0;31m $@\e[0m"; }
else
    hook_title() { echo -n "* $@ — "; }
    hook_ok() { [ $# -ne 0 ] && echo "OK ($@)" || echo OK; }
    hook_ko() { [ $# -ne 0 ] && echo "KO! ($@)" || echo KO!; }
    hook_skip() { [ $# -ne 0 ] && echo "skip ($@)" || echo skip; }
    hook_details() { while read -r line; do echo "    - ${line}"; done <<< "$@"; }
    hook_info() { echo "[INFO] $@"; }
    hook_warn() { echo "[WARNING] $@"; }
    hook_error() { echo "[ERROR] $@"; }
fi

export -f hook_title hook_ok hook_ko hook_skip hook_details hook_info hook_warn hook_error

function hooks_run {
    local DIR=$(dirname "$0")
    local SCRIPT=$(basename "$0")

    for FILE in ${DIR}/${SCRIPT}.d/*; do
        ${FILE} $@ || return $?
    done
}

function git_against {
    git rev-parse --verify ${1:-HEAD} || echo 4b825dc642cb6eb9a060e54bf8d69288fbee4904
}

function git_diff {
    git diff --cached --name-only --diff-filter=ACMR --exit-code $@
}

function git_changed_files {
    local files=()
    while read -r -d $'\0'; do
        files+=("$REPLY")
    done < <(git_diff -z -- $@)

    echo "${files[@]}"
}

function git_need_stash {
    git diff-files --quiet --
}

function git_stash {
    git stash save --keep-index --include-untracked --quiet -- ${1:-git-temp-hook-stash}
}

function git_unstash {
    git cat-file -p 'stash@{0}'|grep -q ${1:-git-temp-hook-stash} && git reset -q --hard && git stash pop -q --index
}

export -f git_diff git_changed_files
