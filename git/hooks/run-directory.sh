#!/bin/bash
for file in $(dirname "$0")/$(basename "$0").d/*; do
  $file $@ || exit $?
done
