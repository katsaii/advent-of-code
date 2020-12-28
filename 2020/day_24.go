package main

import (
	"bufio"
	"fmt"
	"os"
)

type Position struct {
	X, Y int
}

func (pos Position) neighbours() [6]Position {
	x := pos.X
	y := pos.Y
	return [6]Position {
			Position { x + 1, y }, Position { x - 1, y },
			Position { x, y + 1 }, Position { x, y - 1 },
			Position { x + 1, y - 1 }, Position { x - 1, y + 1 } }
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

func mutate_tiles(tiles *map[Position]bool) {
	neighbour_counts := make(map[Position]int)
	for pos := range *tiles {
		for _, neighbour := range pos.neighbours() {
			if n, seen := neighbour_counts[neighbour]; seen {
				neighbour_counts[neighbour] = n + 1
			} else {
				neighbour_counts[neighbour] = 1
			}
		}
	}
	new_tiles := make(map[Position]bool)
	for neighbour, n := range neighbour_counts {
		if _, seen := (*tiles)[neighbour]; seen {
			if n == 0 || n > 2 {
				continue
			}
		} else if n != 2 {
			continue
		}
		new_tiles[neighbour] = true
	}
	*tiles = new_tiles
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
	for i := 0; i < 100; i += 1 {
		mutate_tiles(&tiles)
		fmt.Printf("%d\n", len(tiles))
	}
}
