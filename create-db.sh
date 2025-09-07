#!/bin/bash

createDB() {
    [[ -z $1 ]] && return 1    
    
    dbName="$1.txt"

    [[ -e "$dbName" ]] && return 2

    echo -e "$1\n" > "$dbName"
    echo -e "**********************************************" >> "$dbName"
    echo "Database "$dbName" created"
    return 0
}

createDB "$@"
status=$?

[[ $status -eq 0 ]] && echo "Success"
[[ $status -eq 1 ]] && echo "Error: No database name provided"
[[ $status -eq 2 ]] && echo "Error: Database already exists"

exit $status