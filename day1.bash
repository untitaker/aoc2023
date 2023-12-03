#!/bin/bash

run() (
    sed \
        -e 's/^\([a-z]*\([0-9]\).*\)$/\2\1/g' \
        -e 's/^\(\(.\).*\([0-9]\)[a-z]*\)$/\2\3/g' \
        | paste -sd+ - \
        | bc
)

echo part 1
cat day1.txt | run


echo part 2
cat day1.txt \
    | sed \
    $(
        i=0
        for f in one two three four five six seven eight nine; do
            (( i += 1 ))
            echo "-e s/$f/$f$i$f/g"
        done
    ) \
    | run
