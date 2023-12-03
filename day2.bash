join() (
    tr $'\n' "$1" | sed -e "s/[$1]\$//g"
    echo
)

echo part 1
toomuch_red="($(seq 13 100 | join '|' )) red"
toomuch_green="($(seq 14 100 | join '|')) green"
toomuch_blue="($(seq 15 100 | join '|')) blue"
toomuch_all="($toomuch_red|$toomuch_green|$toomuch_blue)"

cat day2.txt \
    | grep -vE "$toomuch_all" \
    | sed -e 's/^Game \([0-9]*\).*/\1/g' \
    | join + \
    | bc

echo part 2

largest_color() (
    color="$1"
    grep "$color" | sed -e "s/ $color//g" -e 's/ //g' | sort -h | tail -1
)

cat day2.txt \
    | sed -e 's/Game [0-9]*: //g' \
    | while read line; do
          cubes="$(echo "$line" | tr , $'\n' | tr \; $'\n')"
          (
              echo "$cubes" | largest_color red
              echo "$cubes" | largest_color green
              echo "$cubes" | largest_color blue
          ) | join '*' | bc
      done \
    | join + \
    | bc
