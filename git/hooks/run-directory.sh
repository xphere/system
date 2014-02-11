#!/bin/bash

DIR=$(dirname "$0")
SCRIPT=$(basename "$0")
for FILE in ${DIR}/${SCRIPT}.d/*; do
  ${FILE} $@ || exit $?
done

exit 1
