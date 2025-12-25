#!/usr/bin/env bash
# _______________________________________________
# Author § Victor-ray, S. <git@zendai.net.eu.org>

function read_grid {
    local -r INPUT_FILE=$1
    local -a input
    declare -gA grid
    local -i c=0
    mapfile -t input < "$INPUT_FILE"
    declare -gr x_len="${#input[@]}"
    declare -gr y_len="${#input[0]}"
    for ((x = 0; x < "$x_len"; x++)); do
        for ((z = 0; z < "$y_len"; z++)); do
            grid+=( ["($x,$z)"]="${input[$x]:$z:1}" )
        done
    done
}

function get_positions {
    local -ga can_remove=()
    local -i x y count
    local pos current new_x new_y new_pos new_loc
    for ((x = 0; x < "$x_len"; x++)); do
        for ((y = 0; y < "$y_len"; y++)); do
            pos="($x,$y)"
            current="${grid[$pos]}"
            [[ "$current" == "@" ]] && {
                count=0
                [[ "$x" -eq 0 ]] && {
                    [[ "$y" -eq 0 ]] && {
                        new_y=$((y+1))
                        new_pos="($x,$new_y)"
                        new_loc="${grid[$new_pos]}"
                        [[ "$new_loc" == "@" ]] && {
                            ((count+=1))
                        }
                        new_x=$((x+1))
                        [[ "$new_x" -lt "$x_len" ]] && {
                            new_pos="($new_x,$y)"
                            new_loc="${grid[$new_pos]}"
                            [[ "$new_loc" == "@" ]] && {
                                ((count+=1))
                            }
                        }
                    }
                    
                    [[ "$y" -gt 0 ]] && {
                        for v in -1 1; do
                            new_y=$((y+v))
                            new_pos="($x,$new_y)"
                            new_loc="${grid[$new_pos]}"
                            [[ "$new_loc" == "@" ]] && {
                                ((count+=1))
                            }
                        done
                        new_x=$((x+1))
                        [[ "$new_x" -lt "$x_len" ]] && {
                            for v in -1 0 1; do
                                new_y=$((y+v))
                                new_pos="($new_x,$new_y)"
                                new_loc="${grid[$new_pos]}"
                                [[ "$new_loc" == "@" ]] && {
                                    ((count+=1))
                                }
                            done
                        }
                    }
                }
                
                [[ "$x" -gt 0 ]] && {
                    [[ "$y" -eq 0 ]] && {
                        new_y=$((y+1))
                        for v in -1 0 1; do
                            new_x=$((x+v))
                            [[ "$new_x" -lt "$x_len" ]] && {
                                [[ "$v" -eq 0 ]] && {
                                    new_pos="($new_x,$new_y)"
                                    new_loc="${grid[$new_pos]}"
                                    [[ "$new_loc" == "@" ]] && {
                                        ((count+=1))
                                    }
                                }
                                [[ "$v" -ne 0 ]] && {
                                    new_pos="($new_x,$y)"
                                    new_loc="${grid[$new_pos]}"
                                    [[ "$new_loc" == "@" ]] && {
                                        ((count+=1))
                                    }
                                    new_pos="($new_x,$new_y)"
                                    new_loc="${grid[$new_pos]}"
                                    [[ "$new_loc" == "@" ]] && {
                                        ((count+=1))
                                    }
                                }
                            }
                        done
                    }
                    
                    [[ "$y" -gt 0 ]] && {
                        for h in -1 0 1; do
                            new_x=$((x+h))
                            [[ "$new_x" -lt "$x_len" ]] && {
                                [[ "$h" -eq 0 ]] && {
                                    for ny in -1 1; do
                                        new_y=$((y+ny))
                                        new_pos="($new_x,$new_y)"
                                        new_loc="${grid[$new_pos]}"
                                        [[ "$new_loc" == "@" ]] && {
                                            ((count+=1))
                                        }
                                    done
                                }
                                [[ "$h" -ne 0 ]] && {
                                    for ny in -1 0 1; do
                                        new_y=$((y+ny))
                                        new_pos="($new_x,$new_y)"
                                        new_loc="${grid[$new_pos]}"
                                        [[ "$new_loc" == "@" ]] && {
                                            ((count+=1))
                                        }
                                    done
                                }
                            }
                        done
                    }
                }
                [[ "$count" -lt 4 ]] && {
                    can_remove+=( "$pos" )
                }
            }
        done
    done
    [[ "${#can_remove[@]}" -ne 0 ]] && {
        #echo "Can be removed: ${can_remove[@]}"
        echo "Removing: ${#can_remove[@]}"
    }
}

function remove_paper_rolls {
    [[ "${#can_remove[@]}" -gt 0 ]] && {
        ((total_removed+="${#can_remove[@]}"))
        for r in "${can_remove[@]}"; do
            grid["$r"]="."
        done
        #for ((x = 0; x < "$x_len"; x++)); do
        #    for ((y = 0; y < "$y_len"; y++)); do
        #        echo -n "${grid[($x,$y)]}"
        #    done
        #    echo ""
        #done
    }
}

function part_one {
    local -r INPUT_FILE=$1
    local -a data
    local len current to_check x_pos y_pos new_x new_y
    local -i i c count part_one=0
    mapfile -t data < "$INPUT_FILE"
    len="${#data[@]}"
    for ((i = 0; i < "$len"; i++)); do
        for ((c = 0; c < "${#data[$i]}"; c++)); do
            x_pos="$i"
            y_pos="$c"
            current="${data[$i]:$c:1}"
            [[ "$current" == "@" ]] && {
                echo "Paper roll at: ($x_pos,$y_pos)"
                count=0
                [[ "$x_pos" -eq 0 ]] && {
                    [[ "$y_pos" -eq 0 ]] && {
                        new_y=$((y_pos + 1))
                        to_check="${data[$x_pos]:$new_y:1}"
                        if [[ "$to_check" == "@" ]]; then
                            echo "($x_pos,$new_y) $to_check Paper roll"
                            ((count+=1))
                        else
                            echo "($x_pos,$new_y) $to_check"
                        fi
                        new_x=$((x_pos+1))
                        [[ "$new_x" -lt "$len" ]] && {
                            to_check="${data[$new_x]:$y_pos:1}"
                            if [[ "$to_check" == "@" ]]; then
                                echo "($new_x,$y_pos) $to_check Paper roll"
                                ((count+=1))
                            else
                                echo "($new_x,$y_pos) $to_check"
                            fi
                        }
                    }
                    
                    [[ "$y_pos" -gt 0 ]] && {
                        for h in -1 1; do
                            new_y=$((y_pos + h))
                            to_check="${data[$x_pos]:$new_y:1}"
                            if [[ "$to_check" == "@" ]]; then
                                echo "($x_pos,$new_y) $to_check Paper roll"
                                ((count+=1))
                            else
                                echo "($x_pos,$new_y) $to_check"
                            fi
                        done
                        
                        new_x=$((x_pos+1))
                        [[ "$new_x" -lt "$len" ]] && {
                            for v in -1 0 1; do
                                new_y=$((y_pos+v))
                                to_check="${data[$new_x]:$new_y:1}"
                                if [[ "$to_check" == "@" ]]; then
                                    echo "($new_x,$new_y) $to_check Paper roll"
                                    ((count+=1))
                                else
                                    echo "($new_x,$new_y) $to_check"
                                fi
                            done
                        }
                    }
                }
                
                [[ "$x_pos" -gt 0 ]] && {
                    
                    [[ "$y_pos" -eq 0 ]] && {
                        new_y=$((y_pos+1))
                        for z in -1 0 1; do
                            new_x=$((x_pos+z))
                            [[ "$new_x" -lt "$len" ]] && {
                                [[ "$z" -eq 0 ]] && {
                                    to_check="${data[$new_x]:$new_y:1}"
                                    if [[ "$to_check" == "@" ]]; then
                                        echo "($new_x,$new_y) $to_check Paper roll"
                                        ((count+=1))
                                    else
                                        echo "($new_x,$new_y) $to_check"
                                    fi
                                }
                                
                                [[ "$z" -ne 0 ]] && {
                                    to_check="${data[$new_x]:$y_pos:1}"
                                    if [[ "$to_check" == "@" ]]; then
                                        echo "($new_x,$y_pos) $to_check Paper roll"
                                        ((count+=1))
                                    else
                                        echo "($new_x,$y_pos) $to_check"
                                    fi
                                    
                                    to_check="${data[$new_x]:$new_y:1}"
                                    if [[ "$to_check" == "@" ]]; then
                                        echo "($new_x,$new_y) $to_check Paper roll"
                                        ((count+=1))
                                    else
                                        echo "($new_x,$new_y) $to_check"
                                    fi
                                }
                            
                            }  
                        done
                    }
                    
                    [[ "$y_pos" -gt 0 ]] && {
                        for q in -1 0 1; do
                            new_x=$((x_pos+q))
                            [[ "$new_x" -lt "$len" ]] && {
                                [[ "$q" -eq 0 ]] && {
                                    for o in -1 1; do
                                        new_y=$((y_pos+o))
                                        to_check="${data[$new_x]:$new_y:1}"
                                        if [[ "$to_check" == "@" ]]; then
                                            echo "($new_x,$new_y) $to_check Paper roll"
                                            ((count+=1))
                                        else
                                            echo "($new_x,$new_y) $to_check"
                                        fi
                                    done
                                }
                                
                                [[ "$q" -ne 0 ]] && {
                                    for t in -1 0 1; do
                                        new_y=$((y_pos+t))
                                        to_check="${data[$new_x]:$new_y:1}"
                                        
                                        if [[ "$to_check" == "@" ]]; then
                                            echo "($new_x,$new_y) $to_check Paper roll"
                                            ((count+=1))
                                        else
                                            echo "($new_x,$new_y) $to_check"
                                        fi
                                        
                                    done
                                }
                            } # new_x le len
                        done
                    } # y_pos gt 0
                    
                } # x -gt 0
                echo "Adjacent rolls: $count"
                [[ "$count" -lt 4 ]] && {
                    ((part_one+=1))
                    echo "Position: ($x_pos,$y_pos)"
                }
            } # current = @
        done
    done
    # Part 1's correct answer is: 1363
    echo "Part 1: $part_one"
}

function main {
    local -r input_file=input.txt
    declare -gi total_removed=0
    #part_one "$input_file"
    read_grid "$input_file"
    get_positions
    remove_paper_rolls
    while [[ "${#can_remove[@]}" -ge 1 ]]; do
        get_positions
        remove_paper_rolls
    done
    echo "Total removed paper rolls: $total_removed"
}

main "$@"

exit 0
