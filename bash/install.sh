#!/usr/bin/env bash

BASEDIR=$1
DESTINATION=$2
SOURCE=$(dirname "$BASH_SOURCE")/
INSTALLER=$(basename "$BASH_SOURCE")

# Copy all files from this directory to destination, except this script
rsync --exclude "$INSTALLER" -a --no-perms "$SOURCE" "$DESTINATION"
