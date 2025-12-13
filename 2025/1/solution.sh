#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function main {
    local -r INPUT_FILE=input.txt
    local -i DIAL=50 PART_ONE=0 PART_TWO=0 PREV_POS DIAL_TWO=0 COUNT
    local ROTATION DIRECTION
    while IFS= read -r line
    do
        ROTATION="${line:1}"
        DIRECTION="${line:0:1}"
        COUNT=0
        [[ ("$DIRECTION" = "L") ]] && {
            PREV_POS="$DIAL"
            DIAL=$(( (DIAL - ROTATION) % 100 ))
            [[ "$DIAL" -lt 0 ]] && {
                DIAL+=100
            }
            [[ "$ROTATION" -ge 100 ]] && {
                COUNT=$(( ROTATION / 100 ))
                [[ "$PREV_POS" -lt "$DIAL" && "$PREV_POS" -ne 0 ]] && {
                    (( COUNT+=1 ))
                }
            } || {
                [[ "$PREV_POS" -lt "$DIAL" && "$PREV_POS" -ne 0 ]] && {
                    (( COUNT+=1 ))
                }
            }
        }
        [[ ("$DIRECTION" = "R") ]] && {
            PREV_POS="$DIAL"
            DIAL=$(( (DIAL + ROTATION) % 100 ))
            [[ "$ROTATION" -ge 100 ]] && {
                COUNT=$(( ROTATION / 100 ))
                [[ "$PREV_POS" -gt "$DIAL" && "$DIAL" -ne 0 ]] && {
                    (( COUNT+=1 ))
                }
            } || {
                [[ "$PREV_POS" -gt "$DIAL" && "$DIAL" -ne 0 ]] && {
                    (( COUNT+=1 ))
                }
            }
        }
        [[ ("$DIAL" = 0) ]] && {
            (( PART_ONE+=1 ))
            (( COUNT+=1 ))
        }
        (( PART_TWO+=COUNT ))
    done < "$INPUT_FILE"
    # Part one correct answer is: 1097
    # Part two correct answer is: 7101
    echo "Answers."
    echo "Part 1: $PART_ONE"
    echo "Part 2: $PART_TWO"
}

main "$@"

exit 0
