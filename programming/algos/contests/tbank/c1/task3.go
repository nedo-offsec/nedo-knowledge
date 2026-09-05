package main

import (
	"bufio"
	"os"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)

	n := readInt(reader)
	t := readInt(reader)

	row := make([]int, n)
	col := make([]int, n)
	var diag1, diag2 int

	ans := -1
	for i := 1; i <= t; i++ {
		a := readInt(reader)
		x := (a - 1) / n
		y := (a - 1) % n

		row[x]++
		col[y]++
		if x == y {
			diag1++
		}
		if x+y == n-1 {
			diag2++
		}

		if ans == -1 && (row[x] == n || col[y] == n || diag1 == n || diag2 == n) {
			ans = i
		}
	}

	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()
	if ans == -1 {
		writer.WriteString("-1\n")
	} else {
		writer.WriteString(itoa(ans) + "\n")
	}
}

func itoa(x int) string {
	if x == 0 {
		return "0"
	}
	var buf [12]byte
	pos := len(buf)
	for x > 0 {
		pos--
		buf[pos] = byte('0' + x%10)
		x /= 10
	}
	return string(buf[pos:])
}

func readInt(r *bufio.Reader) int {
	n := 0
	c, _ := r.ReadByte()
	for c == ' ' || c == '\n' || c == '\r' || c == '\t' {
		c, _ = r.ReadByte()
	}
	for c >= '0' && c <= '9' {
		n = n*10 + int(c-'0')
		c, _ = r.ReadByte()
	}
	return n
}
