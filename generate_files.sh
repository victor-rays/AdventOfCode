#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function main {
    local SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    [[ ! -f "$SCRIPT_DIR/.session" ]] && {
        echo "Missing .session file with session cookie."
        exit 1
    }
    local YEAR
    local DAYS
    local CREATE_SOLUTION_FILE
    [[ "$#" -ne 0 ]] && {
        YEAR="$1"
        DAYS="$2"
        CREATE_SOLUTION_FILE="$3"
    } || {
        YEAR="$(date +%Y)"
        DAYS="$(date +%d)"
        CREATE_SOLUTION_FILE=0
    }
    local MONTH="$(date +%m)"
    # In 2025 it was only 12 days of puzzles.
    [[ "$YEAR" -eq 2025 && "$DAYS" -gt 12 ]] && {
        DAY=12
    }
    local URL="https://adventofcode.com/$YEAR/day"
    local FILETYPE='sh'
    local SOLUTION_FILE_TEMPLATE
    read -r -d '' SOLUTION_FILE_TEMPLATE <<'EOF'
#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function main {
    local -r input_file=input.txt
    
}

main "$@"

exit 0

EOF
    local -r SESSION_COOKIE="$(cat "$SCRIPT_DIR/.session")"
    local PUZZLE INPUT TITLE
    mkdir -p "$SCRIPT_DIR/$YEAR"
    [[ ("$MONTH" = 12) ]] && {
        for day in $(seq 1 "$DAYS")
        do
            mkdir -vp "$SCRIPT_DIR/$YEAR/$day"
            echo "Day $day."
            [[ ! -f "$SCRIPT_DIR/$YEAR/$day/puzzle.txt" ]] && {
                echo "Fetching puzzle."
                curl -sL -b "$SESSION_COOKIE"  "$URL/$day" \
                | sed -n '/<article/,/<.article/p' \
                | sed 's/<.p>/\n/; s/<[^>]*>//g' > "$SCRIPT_DIR/$YEAR/$day/puzzle.txt"
            }
            [[ ! -f "$SCRIPT_DIR/$YEAR/$day/input.txt" ]] && {
                echo "Fetching puzzle input."
                curl -sL -b "$SESSION_COOKIE" "$URL/$day"/input > "$SCRIPT_DIR/$YEAR/$day/input.txt"
            }
            [[ ! -f "$SCRIPT_DIR/$YEAR/$day/solution.$FILETYPE" ]] && \
            (("$CREATE_SOLUTION_FILE" = 1)) && {
                echo "Creating solution file."
                printf '%s\n' "$SOLUTION_FILE_TEMPLATE" > "$SCRIPT_DIR/$YEAR/$day/solution.$FILETYPE"
            }
            # Sleep so I don't spam their website.
            # I only want to fetch the puzzle and input once.
            sleep 5
        done
    }
}


main "$@"

exit 0
