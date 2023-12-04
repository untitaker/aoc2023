#!/bin/bash

join() (
    tr $'\n' "$1" | sed -e "s/[$1]\$//g"
    echo
)

fname=day3.txt

echo part 1

colcount=$(( $(cat $fname | head -1 | wc -c) ))
number_lenghts="3 2 1"

symbol='[^a-zA-Z0-9.]'
newline=A

cat $fname | tr $'\n' $newline | rg --pcre2 -f <(
    for number_len in $number_lenghts; do
        number_fixedlen="([0-9]{$number_len})"

        for i in $colcount $(seq 0 $(( $number_len + 1 ))); do
            number_padding=".{$(( $colcount - $i ))}"
            echo "(?<=$symbol$number_padding)$number_fixedlen"
            echo "$number_fixedlen(?=$number_padding$symbol)"
        done
    done
) -o | join + | bc

echo part 2

pre_padding() {
    if [ $1 -gt 0 ]; then
        echo ".{$(( $1 - 1 ))}[^0-9]"
    fi
}

post_padding() {
    if [ $1 -gt 0 ]; then
        echo "[^0-9].{$(( $1 - 1 ))}"
    fi
}

part2() (
    fname="$1"
    colcount=$(( $(cat $fname | head -1 | wc -c) ))

    pattern="$(
        for number_len_i in $number_lenghts; do
            number_i="([0-9]{$number_len_i})"
            for number_len_j in $number_lenghts; do
                number_j="([0-9]{$number_len_j})"
                for i in $colcount 0 $(seq $(( $number_len_i + 1 ))); do
                    number_padding_i="$(( $colcount - $i ))"
                    for j in $colcount 0 $(seq $(( $number_len_j + 1 ))); do
                        number_padding_j="$(( $colcount - $j ))"
                        echo "(?<=$number_i$(post_padding $number_padding_i))[*](?=$(pre_padding $number_padding_j)$number_j)"

                        number_padding_j2="$(( $number_padding_j - $number_padding_i - $number_len_i ))"
                        if [ $number_padding_j2 -gt 0 ]; then
                            echo "(?<=$number_j$(post_padding $number_padding_j2)$number_i$(post_padding $number_padding_i))[*]"
                            echo "[*](?=$(pre_padding $number_padding_i)$number_i$(pre_padding $number_padding_j2)$number_j)"
                        fi
                    done
                done
            done
        done
    )"

    pattern_count=$(echo "$pattern" | wc -l)
    replacement="$(seq $(( 2 * $pattern_count )) | sed -e 's/^/\$/g' | join ' ')"

    cat $fname | tr $'\n' $newline \
        | rg --pcre2 -f <(echo "$pattern") -or "$replacement" \
        | rg '^.*?([0-9]+).+?([0-9]+).*$' -r '( $1 * $2 )'
)

part2 $fname | join + | bc
