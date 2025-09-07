#!/bin/bash

format_row() {
    row="**"
    for field in "$@"; do
        row=$row$(printf " %-7s" "$field")*
    done
    echo -e "$row*"
}

insertData() {
    checkArguments "$@" || return $?
    db="$1.txt"
    header=$(format_row "${@:2}")
    echo "$header" >> "$db"
    echo "Record created with values: ${@:2}"
}

checkArguments() {
    [[ -z $1 ]] && echo "Error: No database name provided" && return 1
    [[ ! -e "$1.txt" ]] && echo "Error: Database does not exist" && return 2
    [[ -z $2 ]] && echo "Error: values are not set" && return 3
    return 0
}

insertData "$@"
exit $?