package main

import (
	"fmt"
)

func abs(x int) int {
	return (x ^ (x >> 63)) - (x >> 63)
}

func main() {
	var n int
	fmt.Scanf("%d", &n)
	
	arr := make([]int, n, n)

	for i := 0; i < n; i++ {
		fmt.Scanf("%d", &arr[i])
	}

	var x int
	fmt.Scanf("%d", &x)
	
	min_distance := abs(x-arr[0])
	number := arr[0]

	for i := 0; i < n; i++ {
		if abs(x-arr[i]) <= min_distance {
			min_distance = abs(x-arr[i])
			number = arr[i]
		}
	}

	fmt.Printf("%d\n", number)
}

