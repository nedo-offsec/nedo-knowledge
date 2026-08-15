package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		file = os.Stdin
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)

	counter := make(map[string]int)

	firstWord := true

	for scanner.Scan() {
		word := scanner.Text()

		if !firstWord {
			fmt.Print(" ")
		}
		firstWord = false

		fmt.Print(counter[word])
		counter[word]++
	}

	fmt.Println()
}
