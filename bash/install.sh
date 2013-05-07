#!/usr/bin/env bash

BASEDIR=$1
DESTINATION=$2
SOURCE=$(dirname "$BASH_SOURCE")/
INSTALLER=$(basename "$BASH_SOURCE")

# Copy all files from this directory to destination, except this script
copy_files "$SOURCE" "$DESTINATION" "$INSTALLER"

