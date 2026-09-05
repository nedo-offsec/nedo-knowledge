package main

import (
	"bufio"
	"os"
	"strconv"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)

	n := readInt(reader)
	total := 1 << n

	c := make([][]int64, total)
	for i := 0; i < total; i++ {
		c[i] = make([]int64, n)
		for j := 0; j < n; j++ {
			c[i][j] = readInt64(reader)
		}
	}

	dp := make([]int64, total)

	for k := 1; k <= n; k++ {
		blockSize := 1 << k
		half := blockSize / 2
		rewardIdx := k - 2 

		for s := 0; s < total; s += blockSize {
			var bestLeft, bestRight int64 = -1 << 62, -1 << 62
			for i := s; i < s+half; i++ {
				v := dp[i]
				if rewardIdx >= 0 {
					v += c[i][rewardIdx]
				}
				if v > bestLeft {
					bestLeft = v
				}
			}
			for j := s + half; j < s+blockSize; j++ {
				v := dp[j]
				if rewardIdx >= 0 {
					v += c[j][rewardIdx]
				}
				if v > bestRight {
					bestRight = v
				}
			}
			for i := s; i < s+half; i++ {
				dp[i] += bestRight
			}
			for j := s + half; j < s+blockSize; j++ {
				dp[j] += bestLeft
			}
		}
	}

	var ans int64 = -1 << 62
	for i := 0; i < total; i++ {
		v := dp[i] + c[i][n-1] 
		if v > ans {
			ans = v
		}
	}

	writer := bufio.NewWriter(os.Stdout)
	defer writer.Flush()
	writer.WriteString(strconv.FormatInt(ans, 10))
	writer.WriteString("\n")
}

func readInt(r *bufio.Reader) int {
	return int(readInt64(r))
}

func readInt64(r *bufio.Reader) int64 {
	var n int64 = 0
	c, _ := r.ReadByte()
	for c == ' ' || c == '\n' || c == '\r' || c == '\t' {
		c, _ = r.ReadByte()
	}
	for c >= '0' && c <= '9' {
		n = n*10 + int64(c-'0')
		c, _ = r.ReadByte()
	}
	return n
}
