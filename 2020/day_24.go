package main

import (
	"bufio"
	"fmt"
	"os"
)

type Position struct {
	X, Y int
}

func follow_path(line string) Position {
	x, y := 0, 0
	for i := 0; i < len(line); i += 1 {
		// ne = +x
		// sw = -x
		// nw = +y
		// se = -y
		// e  = 1x - 1y
		// w  = 1y - 1x
		switch line[i] {
		case 'n':
			i += 1
			if line[i] == 'e' {
				x += 1
			} else {
				y += 1
			}
		case 's':
			i += 1
			if line[i] == 'e' {
				y -= 1
			} else {
				x -= 1
			}
		case 'e':
			x += 1
			y -= 1
		case 'w':
			x -= 1
			y += 1
		}
	}
	return Position { x, y }
}

func main() {
	file, _ := os.Open("in/day_24.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)
	tiles := make(map[Position]bool)
	for scanner.Scan() {
		line := scanner.Text()
		pos := follow_path(line)
		if _, seen := tiles[pos]; seen {
			delete(tiles, pos)
		} else {
			tiles[pos] = true
		}
	}
	fmt.Printf("%d\n", len(tiles))
}
