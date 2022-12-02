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
	case $2 in
		X) total_correct=$((total + 1)) ;;
		Y) total=$((total + 2)) ;;
		Z) total=$((total + 3)) ;;
	esac
}

while read -r line; do
	follow-guide $line
	follow-guide-correct $line
done < "./in/day_02.txt"

echo $total
echo $total_correct
