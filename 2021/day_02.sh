#!/bin/bash
x=0
y=0
aim=0

function parse-instruction {
	case $1 in
	forward)
		x=$((x + $2))
		y=$((y + $2 * aim))
		;;
	down)
		aim=$((aim + $2))
		;;
	up)
		aim=$((aim - $2))
		;;
	esac
}

while read -r line; do
	parse-instruction $line
done < "./in/day_02.txt"

echo "product of final horizontal position ($x) and depth ($aim)"
echo "$((x * aim))"
echo
echo "product of final horizontal position ($x) and corrected depth ($y)"
echo "$((x * y))"
