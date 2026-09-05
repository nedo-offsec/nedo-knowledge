package main

import (
	"bufio"
	"os"
	"sort"
	"strconv"
)

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	writer := bufio.NewWriterSize(os.Stdout, 1<<20)
	defer writer.Flush()

	n := readInt(reader)

	counts := make(map[string]int, n)
	for i := 0; i < n; i++ {
		s := readString(reader)
		counts[s]++
	}

	maxCount := 0
	for _, c := range counts {
		if c > maxCount {
			maxCount = c
		}
	}

	result := make([]string, 0)
	for s, c := range counts {
		if c == maxCount {
			result = append(result, s)
		}
	}

	sort.Strings(result)

	for _, s := range result {
		writer.WriteString(s)
		writer.WriteByte('\n')
	}
}

func readInt(r *bufio.Reader) int {
	s := readString(r)
	n, _ := strconv.Atoi(s)
	return n
}

func readString(r *bufio.Reader) string {
	var buf []byte
	// пропускаем пробельные символы
	for {
		b, err := r.ReadByte()
		if err != nil {
			break
		}
		if b != ' ' && b != '\n' && b != '\r' && b != '\t' {
			buf = append(buf, b)
			break
		}
	}
	for {
		b, err := r.ReadByte()
		if err != nil {
			break
		}
		if b == ' ' || b == '\n' || b == '\r' || b == '\t' {
			break
		}
		buf = append(buf, b)
	}
	return string(buf)
}
