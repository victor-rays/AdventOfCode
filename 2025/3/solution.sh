#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function part_one {
    local nr="$1"
    local length="${#nr}"
    local -i i j digit highest_nr one two
    for ((i = 0; i < (length - 1); i++ )); do
        one="${nr:i:1}"
        for ((j = (i + 1); j < length; j++)); do
            two="${nr:j:1}"
            digit="$one$two"
            ((digit > highest_nr)) && {
                highest_nr="$digit"
            }
        done
    done
    echo "$highest_nr"
}

function main {
    local -r INPUT_FILE=input.txt
    local -i total=0 number
    while read -r line; do
        number="$(part_one "$line")"
        let total+=number
    done < "$INPUT_FILE"
    # Part one's correct answer is: 17107
    echo "Part 1: $total"

    local K=12
    local expression
    awk -v k="$K" '
    {
        line = $0
        n = length(line)
        if (n <= k) {
            print line
            next
        }
        
        # stack in st[1..st_len]
        delete st
        st_len = 0
        to_remove = n - k
        
        for (i = 1; i <= n; ++i) {
            c = substr(line, i, 1)
            while (st_len > 0 && to_remove > 0 && st[st_len] < c) {
            st_len--
            to_remove--
            }
            st_len++
            st[st_len] = c
        }
        
        if (to_remove > 0) st_len -= to_remove
        
        res = ""
        # take first k digits from stack
        for (i = 1; i <= k; ++i) {
            res = res st[i]
        }
        print res
    }' "$INPUT_FILE" \
    | {
        # sum the produced k-digit numbers using bc (handles big integers)
        first=""
        if ! IFS= read -r first; then
            echo 0
            exit 0
        fi
        expression="$first"
        while IFS= read -r l; do
            expression="$expression+$l"
        done
        # evaluate expression
        # Part two's correct answer is: 169349762274117
        echo "Part 2: $(echo "$expression" | bc)"
    }
}

main "$@"

exit 0


