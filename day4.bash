#!/bin/bash

join() (
    tr $'\n' "$1" | sed -e "s/[$1]\$//g"
    echo
)

fname=day4.txt

patterns="$(cat $fname | \
    rg '^Card[ ]+(\d+):(.*?)\|(.*?)$' -or '$2:$1' | \
    rg --pcre2 '\b(\d+)(?=\b.*?:(\d+))' \
        -or '^$1:$2$')"

cat $fname | \
    rg '^Card[ ]+(\d+):(.*?)\|(.*?)$' -or '$3:$1' | \
    rg --pcre2 '\b(\d+)(?=\b.*?:(\d+))' \
        -or '$1:$2' | \
    rg -f <(echo "$patterns") | \
    cut -d: -f2 | \
    uniq -c | \
    rg '^.*?(\d+)' -or '(2^($1-1))' | \
    join + | \
    bc
