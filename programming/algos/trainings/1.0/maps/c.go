package main

import (
	"fmt"
	"os"
	"bufio"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		file = os.Stdin
	}

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)

	words := make(map[string]int)
	for scanner.Scan() {
		word := scanner.Text()
		words[word]++
	}

	max_count := 0
	str := ""
	for key, value := range words {
		if value == max_count && key < str {
			str = key
		}
		if value > max_count {
			str = key
			max_count = value
		}
	}

	fmt.Println(str)
}
