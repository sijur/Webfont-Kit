#!/usr/bin/env bash

set -e

ALLCOMMANDS=($@)
# check if the command exists, if not, install it.
# iterate the ALLCOMMANDS list to check for each required command
# skip as soon as a command is not found

for CMD in "${ALLCOMMANDS[@]}"
do
    if ! command -v "$CMD" &> /dev/null; then
        package_name=$CMD
        # if the command is not found, look for the package.
        # if the package is found, install it.
        if -n "$package_name"; then
            echo "Installing $package_name"
            brew install "$package_name"
        else
            echo "Cannot locate $package_name. Please install it manually."
        fi
    fi
   if [[ ! -f $(command -v "$CMD") ]]; then
        echo "Cannot convert ($CMD). The following packages are required: eot-utils woff-tools woff2"
        exit 1
    fi
done