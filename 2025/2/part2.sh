#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function check_number {
    local NUM="$1"
    local LEN="${#NUM}"
    local MID="$((LEN / 2))"
    local i
    local newstring
    for ((i = 1; i <= MID; i++)); do
        local substring="${NUM:0:i}"
        if ((LEN % i == 0)); then
            local amount=$((LEN / i))
            local j
            local newstring=''
            for ((j = 0; j < amount; j++)); do
                newstring+="$substring"
            done
            if ((newstring == NUM)); then
                return 1
            fi
        fi
    done
    return 0
}

function main {
    local -r INPUT_FILE=input.txt
    local -a ID_RANGES
    IFS=',' read -r -a ID_RANGES < "$INPUT_FILE"
    local START END
    local -i i part_two=0
    for x in "${ID_RANGES[@]}"; do
        IFS='-' read -r START END <<<"$x"
        echo "Range: $START → $END"
        for ((i = START; i <= END; i++)); do
            if ! check_number "$i"; then
                echo "Invalid ID: $i"
                (( part_two+=i ))
            fi
        done
    done
    # Part 2 correct answer is: 37432260594
    echo "Part 2: $part_two"
}

main "$@"

exit 0
