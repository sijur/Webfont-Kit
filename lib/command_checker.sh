#!/usr/bin/env bash

set -e

CUR_DIR=$(pwd)
source "$CUR_DIR/lib/error_exit.sh"

main() {
    ALLCOMMANDS=($@)
    # check if the command exists, if not, install it.
    # iterate the ALLCOMMANDS list to check for each required command
    # skip as soon as a command is not found

    for CMD in "${ALLCOMMANDS[@]}"
    do
        echo "Checking $CMD"
        # check if there's anything in the $CMD variable
        if [[ -z "$CMD" ]]; then
            error_exit "Please provide a valid command."
        fi

        # check if the command is installed
        if [[ ! -n $(command -v "$CMD") ]]; then
            echo "$CMD is not installed."

            # check if the command is found in the package list
            package_name=$(brew search $CMD)

            error_exit $package_name 0

            # if command -v "$CMD" &> /dev/null; then
                
            #     # if the command is not found, look for the package.
            #     # if the package is found, install it.
            #     if -n "$package_name"; then
                    
            #         echo "Installing $package_name"
            #         brew install "$package_name"
            #     else
            #         error_exit "Cannot locate $package_name. Please install it manually."
            #     fi
            # fi
        fi
        
        if [[ ! -f $(command -v "$CMD") ]]; then
            error_exit "Cannot use $CMD. Please install it manually."
        else
            echo "$CMD is installed."
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi