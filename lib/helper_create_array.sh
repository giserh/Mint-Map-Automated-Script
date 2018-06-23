#!/usr/bin/env bash

# helper_create_array "ARRAY_NAME" "STRING_NAME" "TOKEN"
helper_create_array() {

 	ARRAY_NAME=$1
 	STRING_NAME=$2
 	eval STRING=\$$STRING_NAME
 	TOKEN="$3"
 	if [[ -z "$3" ]]; then
 		TOKEN='\n'
 	fi
	if [[ "$TOKEN" != '\n' ]]; then
		STRING=$(echo $STRING | tr "$TOKEN" '\n')
	fi	

	# declare -a "$ARRAY_NAME"
	# eval "$ARRAY_NAME=()"

    let _counter=0
    printf "%s\n" "$STRING" | while IFS=$'\n' read -r line_data; do
        	# echo $line_data
            eval "$ARRAY_NAME+=(\"$line_data\")"
            echo "$ARRAY_NAME+=(\"$line_data\")"
            ((++_counter))
    done
    
}