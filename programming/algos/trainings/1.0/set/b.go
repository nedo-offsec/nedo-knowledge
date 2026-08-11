package main

import (
	"fmt"
	"bufio"
	"os"
	"strings"
	"strconv"
	"slices"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	line1, _ := reader.ReadString('\n')
	line1 = strings.TrimSpace(line1)
	parts1 := strings.Fields(line1)
	
	line2, _ := reader.ReadString('\n')
	line2 = strings.TrimSpace(line2)
	parts2 := strings.Fields(line2)

	set := make(map[int]int)
	intersection := []int{}	

	for _, v := range parts1 {
		key, _ := strconv.Atoi(v)
		set[key]++
	}

	for _, v := range parts2 {
		key, _ := strconv.Atoi(v)
		set[key]++
	}

	for key, _ := range set {
		if set[key] > 1 {
			intersection = append(intersection, key)
		}
	}

	slices.Sort(intersection)
	for ind, v := range intersection {
		fmt.Print(v)
		if ind != len(intersection)-1 {
			fmt.Print(" ")
		} else {
			fmt.Println()
		}
	}
}
