#!/bin/bash

run() (
    input="$(cat)"
    
    paste \
        <(echo -n "$input" | sed -e 's/^[a-z]*\([0-9]\).*$/\1/g') \
        <(echo -n "$input" | sed -e 's/^.*\([0-9]\)[a-z]*$/\1/g') \
        | tr -d $'\t' \
        | tr $'\n' '+' \
        | sed -e 's/+$//g' \
        | bc
)

echo day 1
cat day1.txt | run


echo day 2
cat day1.txt \
    | sed \
    $(
        i=0
        for f in one two three four five six seven eight nine; do
            (( i+=1 ))
            echo "-e s/$f/$f$i$f/g"
        done
    ) \
    | run
