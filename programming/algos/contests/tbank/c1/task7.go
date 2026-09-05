package main

import (
	"bufio"
	"os"
	"strconv"
)

var (
	ch    [][2]int32
	par   []int32
	rv    []bool
	val   []int64
	mx    []int64
	mxPos []int32
	eu    []int32
	ev    []int32
	stk   []int32
)

func isRoot(x int32) bool {
	p := par[x]
	return p == 0 || (ch[p][0] != x && ch[p][1] != x)
}

func pushUp(x int32) {
	mx[x] = val[x]
	mxPos[x] = x
	if l := ch[x][0]; l != 0 && mx[l] > mx[x] {
		mx[x] = mx[l]
		mxPos[x] = mxPos[l]
	}
	if r := ch[x][1]; r != 0 && mx[r] > mx[x] {
		mx[x] = mx[r]
		mxPos[x] = mxPos[r]
	}
}

func pushDown(x int32) {
	if rv[x] {
		l, r := ch[x][0], ch[x][1]
		ch[x][0], ch[x][1] = r, l
		if l != 0 {
			rv[l] = !rv[l]
		}
		if r != 0 {
			rv[r] = !rv[r]
		}
		rv[x] = false
	}
}

func rotate(x int32) {
	y := par[x]
	z := par[y]
	var k int32
	if ch[y][1] == x {
		k = 1
	}
	if !isRoot(y) {
		if ch[z][0] == y {
			ch[z][0] = x
		} else {
			ch[z][1] = x
		}
	}
	par[x] = z
	ch[y][k] = ch[x][1-k]
	if ch[x][1-k] != 0 {
		par[ch[x][1-k]] = y
	}
	ch[x][1-k] = y
	par[y] = x
	pushUp(y)
	pushUp(x)
}

func splay(x int32) {
	stk = stk[:0]
	y := x
	stk = append(stk, y)
	for !isRoot(y) {
		y = par[y]
		stk = append(stk, y)
	}
	for i := len(stk) - 1; i >= 0; i-- {
		pushDown(stk[i])
	}
	for !isRoot(x) {
		y := par[x]
		z := par[y]
		if !isRoot(y) {
			if (ch[z][0] == y) == (ch[y][0] == x) {
				rotate(y)
			} else {
				rotate(x)
			}
		}
		rotate(x)
	}
}

func access(x int32) {
	var last int32 = 0
	for y := x; y != 0; y = par[y] {
		splay(y)
		ch[y][1] = last
		pushUp(y)
		last = y
	}
	splay(x)
}

func makeRoot(x int32) {
	access(x)
	rv[x] = !rv[x]
}

func link(x, y int32) {
	makeRoot(x)
	par[x] = y
}

func cut(x, y int32) {
	makeRoot(x)
	access(y)
	if ch[y][0] == x && ch[x][1] == 0 {
		ch[y][0] = 0
		par[x] = 0
		pushUp(y)
	}
}

func main() {
	reader := bufio.NewReaderSize(os.Stdin, 1<<20)
	n := readInt(reader)
	q := readInt(reader)

	maxNodes := n + (n - 1) + q + 5
	ch = make([][2]int32, maxNodes)
	par = make([]int32, maxNodes)
	rv = make([]bool, maxNodes)
	val = make([]int64, maxNodes)
	mx = make([]int64, maxNodes)
	mxPos = make([]int32, maxNodes)
	eu = make([]int32, maxNodes)
	ev = make([]int32, maxNodes)
	stk = make([]int32, 0, maxNodes)

	for i := int32(1); i <= int32(n); i++ {
		val[i] = -1
		mx[i] = -1
		mxPos[i] = i
	}

	cnt := int32(n)
	var total int64 = 0

	for i := 0; i < n-1; i++ {
		a := int32(readInt(reader))
		b := int32(readInt(reader))
		c := int64(readInt(reader))
		cnt++
		e := cnt
		val[e], mx[e], mxPos[e] = c, c, e
		eu[e], ev[e] = a, b
		link(e, a)
		link(b, e)
		total += c
	}

	writer := bufio.NewWriterSize(os.Stdout, 1<<22)
	defer writer.Flush()

	for i := 0; i < q; i++ {
		u := int32(readInt(reader))
		v := int32(readInt(reader))
		w := int64(readInt(reader))

		makeRoot(u)
		access(v)
		maxW := mx[v]
		maxNode := mxPos[v]

		if w < maxW {
			total += w - maxW
			a2, b2 := eu[maxNode], ev[maxNode]
			cut(a2, maxNode)
			cut(maxNode, b2)

			cnt++
			e := cnt
			val[e], mx[e], mxPos[e] = w, w, e
			eu[e], ev[e] = u, v
			link(e, u)
			link(v, e)
		}

		writer.WriteString(strconv.FormatInt(total, 10))
		writer.WriteByte('\n')
	}
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
