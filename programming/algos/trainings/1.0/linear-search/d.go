package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')

	parts := strings.Fields(line)
	arr := []int{}

	for _, p := range parts {
		num, _ := strconv.Atoi(p)
		arr = append(arr, num)
	}
	
	count := 0
	
	if len(arr) > 1 {
		for i := 1; i < len(arr)-1; i++ {
			if arr[i-1] < arr[i] && arr[i] > arr[i+1] {count++}
		}
	}
	fmt.Printf("%d\n", count)
}
