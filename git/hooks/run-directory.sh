#!/bin/bash -x

DIR=$(dirname "$0")
SCRIPT=$(basename "$0")
FILES=${DIR}/${SCRIPT}.d/*
for FILE in "${FILES}"; do
  ${FILE} $@ || exit $?
done

exit 1
