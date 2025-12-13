#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function main {
    local SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    [[ ! -f "$SCRIPT_DIR/.session" ]] && {
        echo "Missing .session file with session cookie."
        exit 1
    }
    local -r SESSION_COOKIE="$(cat "$SCRIPT_DIR/.session")"
    local YEAR="$(date +%Y)"
    local DAY="$1"
    local URL="https://adventofcode.com/$YEAR/day/${DAY}#part2"
    curl -sL -b "$SESSION_COOKIE"  "$URL" \
    | sed -n '/id="part2"/,/<.article/p' \
    | sed 's/<.h2>/\n/g; s/<.p>/\n/g; s/<[^>]*>//g' \
    > "$SCRIPT_DIR/$YEAR/$DAY/part2.txt"
    
}

main "$@"

exit 0
