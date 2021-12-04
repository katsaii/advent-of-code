package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	var file, _ = os.Open("in/day_04.txt")
	defer file.Close()
	var scanner = bufio.NewScanner(file)
	for scanner.Scan() {
		var line = scanner.Text()
		fmt.Println(line)
	}
}
