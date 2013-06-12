#!/usr/bin/env bash

PREVIOUS_HEAD=$1
NEW_HEAD=$2
BRANCH_SWITCH=$3

if [ $BRANCH_SWITCH == "1" ]; then
  DESCRIPTION=$(git config --get branch.$(git rev-parse --abbrev-ref HEAD).description 2> /dev/null)
  if [ "$DESCRIPTION" ]; then
    echo "Description: $DESCRIPTION"
  fi
fi
