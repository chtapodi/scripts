#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $(basename "$0") [-h] <path>"
    echo "Opens the passed in path"
    echo "  -h, --help  Display this help message."
    exit 0
}

# Function to check the type of file and perform actions
click_path() {
    local path="$1"

    if [ -d "${path}" ]; then
            nautilus "${path}"

    elif [ -f "${path}" ]; then

        if [ -x "${path}" ]; then

            ./"${path}"
        else

            xdg-open "${path}"
        fi
    else
        echo "${path} is of an unexpected format."
    fi
}

# Argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            ;;
        *)
            path="$1"
            click_path "${path}"
            ;;
    esac
    shift
done
