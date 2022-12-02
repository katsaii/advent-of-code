#!/bin/bash

total=0
total_correct=0

function follow-guide {
	case $2 in
		X) total=$((total + 1)) ;;
		Y) total=$((total + 2)) ;;
		Z) total=$((total + 3)) ;;
	esac
	case $1$2 in
		AX|BY|CZ) total=$((total + 3)) ;;
		AY|BZ|CX) total=$((total + 6)) ;;
	esac
}

function follow-guide-correct {
	case $1$2 in
		AY|BX|CZ) total_correct=$((total_correct + 1)) ;;
		AZ|BY|CX) total_correct=$((total_correct + 2)) ;;
		AX|BZ|CY) total_correct=$((total_correct + 3)) ;;
	esac
	case $2 in
		Y) total_correct=$((total_correct + 3)) ;;
		Z) total_correct=$((total_correct + 6)) ;;
	esac
}

while read -r line; do
	follow-guide $line
	follow-guide-correct $line
done < "./in/day_02.txt"

echo "total score when following the assumed strategy guide"
echo $total
echo
echo "total score when following the strategy guide correctly"
echo $total_correct
