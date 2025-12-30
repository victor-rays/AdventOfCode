#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function part_one {
    local -r input_file="$1"
    local -a range=() id=()
    local start end i valid
    local -i count=0
    while read -r line; do
        [[ "$line" == *"-"* ]] && {
            range+=("$line")
        }
        [[ "$line" != *"-"* && "$line" != "" ]] && {
            id+=("$line")
        }
    done < "$input_file"
    for int in "${id[@]}"; do
        valid=false
        for r in "${range[@]}"; do
            IFS='-' read -r start end <<<"$r"
            (( int >= start && int <= end )) && {
                valid=true
                echo "Valid ID: $int"
                break
            }
        done
        [[ "$valid" == "true" ]] && {
            ((count+=1))
        }
    done
    echo "$count"
}

function part_two {
    local -r input_file="$1"
    local -a ranges=()
    local line
    
    while read -r line; do
        if [[ "$line" == *"-"* ]]; then
            ranges+=("$line")
        elif [[ "$line" == "" ]]; then
           continue
        else
             [[ "$line" != *"-"* ]] && break
        fi
    done < "$input_file"

    local -a sorted_ranges
    mapfile -t sorted_ranges < <(printf '%s\n' "${ranges[@]}" | sort -t '-' -k1,1n)

    local -i total_count=0
    local -i current_start=-1
    local -i current_end=-1
    local -i start end

    for range in "${sorted_ranges[@]}"; do
        IFS='-' read -r start end <<<"$range"
        
        if (( current_start == -1 )); then
            current_start="$start"
            current_end="$end"
        else
            if (( start <= current_end )); then
                if (( end > current_end )); then
                    current_end="$end"
                fi
            else
                # Disjoint
                (( total_count += (current_end - current_start + 1) ))
                current_start="$start"
                current_end="$end"
            fi
        fi
    done
    if (( current_start != -1 )); then
        (( total_count += (current_end - current_start + 1) ))
    fi
    echo "Total fresh ingredients: $total_count"
}

function main {
    local input_file="input.txt"
    if [[ "$1" != "" ]]; then
        input_file="$1"
    fi
    part_one "$input_file"
    part_two "$input_file"
}

main "$@"

exit 0
