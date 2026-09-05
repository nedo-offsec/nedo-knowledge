package main

import (
	"bufio"
	"os"
	"sort"
)

var b []int64

func countLE(x int64) int64 {
	n := len(b)
	var total int64 = 0
	for _, v := range b {
		var cnt int
		switch {
		case v > 0:
			idx := sort.Search(n, func(j int) bool { return v*b[j] > x })
			cnt = idx
		case v < 0:
			idx := sort.Search(n, func(j int) bool { return v*b[j] <= x })
			cnt = n - idx
		default:
			if x >= 0 {
				cnt = n
			} else {
				cnt = 0
			}
		}
		if v*v <= x {
			cnt--
		}
		total += int64(cnt)
	}
	return total / 2
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)

	n := readInt(reader)
	k := readInt64(reader)

	b = make([]int64, n)
	for i := 0; i < n; i++ {
		b[i] = readInt64(reader)
	}
	sort.Slice(b, func(i, j int) bool { return b[i] < b[j] })

	// границы бинпоиска по значению X: берём максимум по модулю
	var m int64 = 0
	if abs(b[0]) > m {
		m = abs(b[0])
	}
	if abs(b[n-1]) > m {
		m = abs(b[n-1])
	}
	lo, hi := -m*m, m*m

	for lo < hi {
		mid := lo + (hi-lo)/2
		if countLE(mid) >= k {
			hi = mid
		} else {
			lo = mid + 1
		}
	}

	os.Stdout.WriteString(itoa(lo) + "\n")
}

func abs(x int64) int64 {
	if x < 0 {
		return -x
	}
	return x
}

func itoa(x int64) string {
	if x == 0 {
		return "0"
	}
	neg := false
	if x < 0 {
		neg = true
		x = -x
	}
	var buf [24]byte
	pos := len(buf)
	for x > 0 {
		pos--
		buf[pos] = byte('0' + x%10)
		x /= 10
	}
	if neg {
		pos--
		buf[pos] = '-'
	}
	return string(buf[pos:])
}

func readInt(r *bufio.Reader) int {
	return int(readInt64(r))
}

func readInt64(r *bufio.Reader) int64 {
	var n int64 = 0
	neg := false
	c, _ := r.ReadByte()
	for c == ' ' || c == '\n' || c == '\r' || c == '\t' {
		c, _ = r.ReadByte()
	}
	if c == '-' {
		neg = true
		c, _ = r.ReadByte()
	}
	for c >= '0' && c <= '9' {
		n = n*10 + int64(c-'0')
		c, _ = r.ReadByte()
	}
	if neg {
		n = -n
	}
	return n
}
