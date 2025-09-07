#!/bin/bash

getColumns() {
    sed -n '4p' "$1" | sed 's/*//g' | awk '{$1=$1; print}'
}

getColumnIndex() {
    db="$1"
    colName="$2"
    cols=($(getColumns "$db"))
    for i in "${!cols[@]}"; do
        if [[ "${cols[$i]}" == "$colName" ]]; then
            echo $i
            return 0
        fi
    done
    return 1
}

selectRecord() {
    checkArguments "$@" || return $?
    db="$1.txt"
    shift

    if [[ "$1" != "--where" ]]; then
        echo "Error: Usage: $0 <db> --where col=val [col=val ...]"
        return 3
    fi
    shift
    conditions=("$@")

    cols=($(getColumns "$db"))
    echo "Columns: ${cols[*]}"
    echo "Searching for conditions: ${conditions[*]}"

    tail -n +4 "$db" | while read -r line; do
        fields=($(echo "$line" | sed 's/*//g' | awk '{$1=$1; print}'))

        match=true
        for cond in "${conditions[@]}"; do
            col="${cond%%=*}"
            val="${cond#*=}"
            colIndex=$(getColumnIndex "$db" "$col") || {
                echo "Error: Column '$col' not found. Available: ${cols[*]}"
                exit 4
            }
            if [[ "${fields[$colIndex]}" != "$val" ]]; then
                match=false
                break
            fi
        done

        if $match; then
            echo "$line"
        fi
    done
}

checkArguments() {
    [[ -z $1 ]] && echo "Error: No database name provided" && return 1
    [[ ! -e "$1.txt" ]] && echo "Error: Database does not exist" && return 2
    return 0
}

selectRecord "$@"
exit $?
