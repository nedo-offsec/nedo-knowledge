package main

import (
	"bufio"
	"os"
	"strconv"
)

var bit []int
var logN int

func update(pos, val, n int) {
	for ; pos <= n; pos += pos & (-pos) {
		bit[pos] += val
	}
}

func findKth(k, n int) int {
	pos := 0
	sum := 0
	for l := logN; l >= 0; l-- {
		next := pos + (1 << l)
		if next <= n && sum+bit[next] < k {
			pos = next
			sum += bit[next]
		}
	}
	return pos + 1
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer writer.Flush()

	n := readInt(reader)
	k := readInt64(reader)

	bit = make([]int, n+1)
	for logN = 0; (1 << (logN + 1)) <= n; logN++ {
	}

	for i := 1; i <= n; i++ {
		update(i, 1, n)
	}

	buf := make([]byte, 0, n*7)
	for i := 1; i <= n; i++ {
		remaining := int64(n - i + 1)
		maxHere := remaining - 1
		c := k
		if c > maxHere {
			c = maxHere
		}
		k -= c

		val := findKth(int(c)+1, n)
		update(val, -1, n)

		if i > 1 {
			buf = append(buf, ' ')
		}
		buf = strconv.AppendInt(buf, int64(val), 10)
	}
	buf = append(buf, '\n')
	writer.Write(buf)
}

func readInt(r *bufio.Reader) int {
	n := 0
	c, _ := r.ReadByte()
	for c == ' ' || c == '\n' || c == '\r' {
		c, _ = r.ReadByte()
	}
	for c >= '0' && c <= '9' {
		n = n*10 + int(c-'0')
		c, _ = r.ReadByte()
	}
	return n
}

func readInt64(r *bufio.Reader) int64 {
	var n int64 = 0
	c, _ := r.ReadByte()
	for c == ' ' || c == '\n' || c == '\r' {
		c, _ = r.ReadByte()
	}
	for c >= '0' && c <= '9' {
		n = n*10 + int64(c-'0')
		c, _ = r.ReadByte()
	}
	return n
}
