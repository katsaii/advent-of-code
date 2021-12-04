package main

import (
	"strings"
	"strconv"
	"bufio"
	"fmt"
	"os"
)

func intoInt(s string) int {
	if n, err := strconv.Atoi(s); err == nil {
		return n
	} else {
		return 0
	}
}

type Cell struct {
	Col, Row int
	Marked bool
	Label string
}

type BingoCard struct {
	ColN, RowN [5]int
	Cells map[string]*Cell
	WinningCell *Cell
}

func (card *BingoCard) DrawCell(key string) {
	if cell, exists := card.Cells[key]; exists {
		cell.Marked = true
		card.ColN[cell.Col] += 1
		card.RowN[cell.Row] += 1
		if card.ColN[cell.Col] >= 5 || card.RowN[cell.Row] >= 5 {
			card.WinningCell = cell
		}
	}
}

func (card *BingoCard) GetScore() int {
	var count int = 0
	for key, cell := range card.Cells {
		if cell.Marked {
			continue
		}
		count += intoInt(key)
	}
	return count * intoInt(card.WinningCell.Label)
}

func main() {
	var file, _ = os.Open("in/day_04.txt")
	defer file.Close()
	var scanner = bufio.NewScanner(file)
	scanner.Scan()
	var drawOrder = strings.Split(scanner.Text(), ",")
	var bingoCards []*BingoCard
	for scanner.Scan() {
		var bingoCard = &BingoCard {
			ColN : [5]int { 0, 0, 0, 0, 0 },
			RowN : [5]int { 0, 0, 0, 0, 0 },
			Cells : make(map[string]*Cell),
			WinningCell : nil,
		}
		for row := 0; row < 5; row += 1 {
			scanner.Scan()
			var line = strings.Fields(scanner.Text())
			for col, key := range line {
				bingoCard.Cells[key] = &Cell {
					Col : col,
					Row : row,
					Marked : false,
					Label : key,
				}
			}
		}
		bingoCards = append(bingoCards, bingoCard)
	}
	var winningCard *BingoCard
	var losingCard *BingoCard
	for _, draw := range drawOrder {
		for _, card := range bingoCards {
			if card.WinningCell != nil {
				continue
			}
			card.DrawCell(draw)
			if winningCard == nil && card.WinningCell != nil {
				winningCard = card;
			}
			losingCard = card;
		}
	}
	fmt.Println("winning card score")
	fmt.Println(winningCard.GetScore())
	fmt.Println()
	fmt.Println("losing card score")
	fmt.Println(losingCard.GetScore())
}
