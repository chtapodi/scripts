#!/bin/bash

# Default search string if none provided
search_string=${1:-""}

# Initialize variables
in_category=false
reading_command=false
print_next=false
category=""

echo -e "\n"
while IFS= read -r line; do
    # Check if the line is a category header
    if [[ $line == "## "* ]] && [[ $line == *"$search_string"* ]]; then
        in_category=true
        echo "$line"
        # category="${line#?? }" # Remove '## ' prefix to get the category name
        # reading_command=false # Reset reading state for new category
    elif [[ $line == "#"* ]]; then
        # Check if the search string is in the description or the command
        if [[ $line == *"$search_string"* || $(tail -n +2 <<<"$line") == *"$search_string"* ]]; then
            echo "$line"
            print_next=true
        else
            if $in_category; then
                echo "$line"
            fi
            continue # Skip printing the description if the search string is not found
        fi
    else 
        # set echo color to orange
        echo -en "\e[33m"

        if $print_next; then
            echo "$line"
            print_next=false
            echo -e "\n"
        elif $in_category; then
            echo "$line"
        fi
        # reset echo color
        echo -en "\e[0m"
    fi



    # Check if we're inside a category and the line contains the search string
    if $in_category && [[ $line == *"$search_string"* ]]; then
        if [[ $line == "## /"* ]]; then
            # echo "$line"
            in_category=false
        fi
        continue
    fi

    # Check if we found the category and the line contains the search string
    if [[ $category == "$search_string" ]] && [[ $line != "## "* ]]; then
        echo "ss $line"
    fi

    # If we're reading a command and the search string is found, print the command too
    if $reading_command && [[ $line == *"$search_string"* ]]; then
        echo "rc $line"
    fi

done < "commands.txt"
