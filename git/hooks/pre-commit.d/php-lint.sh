#!/bin/bash
FILES=$(git diff --cached --name-status | grep -v "^D" | cut -f2 | grep -e \.php$)
if [ "$FILES" ]; then
  echo $FILES | xargs -n1 php -l
  exit $?
fi
