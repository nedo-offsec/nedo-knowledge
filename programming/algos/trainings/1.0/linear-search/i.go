package main

import (
	"fmt"
	"bufio"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	var n, m, amount int
	fmt.Fscan(reader, &n, &m, &amount)

	
	matrix := make([][]int, n)
	for i := 0; i < n; i++ {
		matrix[i] = make([]int, m)
	}

	var x, y int
	for k := 0; k < amount; k++ {
		fmt.Fscan(reader, &y, &x)
		matrix[y-1][x-1] = 1
	}

	for i := 0; i < n; i++ {
		for j := 0; j < m; j++ {
			if matrix[i][j] == 1 {
				fmt.Printf("*")
			} else {
				fmt.Printf("%d", count(i, j, matrix, n, m))
			}

			if j != m-1 {
				fmt.Printf(" ")
			}
		}
		fmt.Println()
	}
}

func count(i int, j int, matrix [][]int, rows int, cols int) int {
	res := 0
	if j != 0 {
		res += matrix[i][j-1]
	}
	if j != cols-1 {
		res += matrix[i][j+1]
	}
	if i != 0 {
		res += matrix[i-1][j]
	}
	if i != rows-1 {
		res += matrix[i+1][j]
	}

	if i != 0 && j != 0 {
		res += matrix[i-1][j-1]
	}
	if i != rows-1 && j != 0 {
		res += matrix[i+1][j-1]
	}
	if i != rows-1 && j != cols-1 {
		res += matrix[i+1][j+1]
	}
	if i != 0 && j != cols-1 {
		res += matrix[i-1][j+1]
	}
	return res
}
