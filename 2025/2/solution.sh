#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function main {
    local -r INPUT_FILE=input.txt
    local -a ID_RANGES
    IFS=',' read -r -a ID_RANGES < "$INPUT_FILE"
    local START END
    for x in "${ID_RANGES[@]}"; do
        START="$(cut -d '-' -f 1 <<<"$x")"
        END="$(cut -d '-' -f 2 <<<"$x")"
        echo "$START"
        echo "$END"
    done
}

main "$@"

exit 0
