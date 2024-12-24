#!/usr/bin/env bash

set -e

error_exit() {
    echo "$1" 1>&2
    
    if [[ -n "$2" ]]; then
        exit $2
    else
        exit 1
    fi
}