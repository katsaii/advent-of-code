package main

import (
	"strings"
	"strconv"
	"bufio"
	"os"
	"fmt"
	"math"
)

type RopeNode struct {
	next *RopeNode
	x float64
	y float64
}

func (self *RopeNode) Move(movex float64, movey float64) {
	self.x += movex
	self.y += movey
	if other := self.next; other != nil {
		var dx = self.x - other.x
		var dy = self.y - other.y
		var mx = math.Abs(dx)
		var my = math.Abs(dy)
		if mx <= 1 && my <= 1 {
			return
		} else if mx > my {
			other.Move(dx - math.Copysign(1, dx), dy)
		} else if mx < my {
			other.Move(dx, dy - math.Copysign(1, dy))
		} else {
			other.Move(dx - math.Copysign(1, dx), dy - math.Copysign(1, dy))
		}
	}
}

func main() {
	var file, _ = os.Open("in/day_09.txt")
	defer file.Close()
	var scanner = bufio.NewScanner(file)
	var rope = RopeNode { next : &RopeNode { } }
	var tail = rope.next
	var rope_long = RopeNode { }
	var tail_long = &rope_long
	for i := 1; i <= 9; i += 1 {
		tail_long.next = &RopeNode { }
		tail_long = tail_long.next
	}
	var rope_visits = make(map[string]bool)
	var rope_visits_long = make(map[string]bool)
	for scanner.Scan() {
		var inst = strings.Split(scanner.Text(), " ")
		var code = inst[0]
		var value, _ = strconv.Atoi(inst[1])
		for i := 0; i < value; i += 1 {
			switch code {
				case "L":
					rope.Move(-1, 0)
					rope_long.Move(-1, 0)
				case "R":
					rope.Move(1, 0)
					rope_long.Move(1, 0)
				case "U":
					rope.Move(0, -1)
					rope_long.Move(0, -1)
				case "D":
					rope.Move(0, 1)
					rope_long.Move(0, 1)
			}
			rope_visits[fmt.Sprint(tail.x, tail.y)] = true
			rope_visits_long[fmt.Sprint(tail_long.x, tail_long.y)] = true
		}
	}
	fmt.Println("number of unique tiles visited by the tail of the short rope")
	fmt.Println(len(rope_visits))
	fmt.Println("\nnumber of unique tiles visited by the tail of the long rope")
	fmt.Println(len(rope_visits_long))
}
