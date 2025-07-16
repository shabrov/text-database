#!/bin/bash

set -x

createDB() {
    if [[ -z $1 ]]; then
        echo "Database name has not been set"
    else    
        dbName="$1.txt"

        if [[ -e $dbName ]]; then 
            echo "Database $dbName already exists"
        else 
            echo -e "$1\n***************************************" > $dbName
            echo "Database $dbName created"
        fi
    fi
}

createDB "$@"