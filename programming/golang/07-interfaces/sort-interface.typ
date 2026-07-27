=== Суть
В Go сортировка работает через интерфейс `sort.Interface`.

```go
package sort

type Interface interface {
    Len() int            // длина последовательности
    Less(i, j int) bool  // сравнение элементов i и j
    Swap(i, j int)       // обмен элементов i и j
}
```

=== Как это работает

Любой тип, у которого есть эти 3 метода, можно отсортировать функцией sort.Sort.

=== Пример: срез строк

```go
type StringSlice []string

func (p StringSlice) Len() int           { return len(p) }
func (p StringSlice) Less(i, j int) bool { return p[i] < p[j] }
func (p StringSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

// Использование
names := []string{"Moby", "Delilah", "Alicia"}
sort.Sort(StringSlice(names))
```

Для строк уже есть готовый sort.Strings(names).

=== Сортировка структуры

Структура Track:

```go
type Track struct {
    Title  string
    Artist string
    Album  string
    Year   int
    Length time.Duration
}
```

Чтобы отсортировать срез треков по исполнителю:

```go
type byArtist []*Track

func (x byArtist) Len() int           { return len(x) }
func (x byArtist) Less(i, j int) bool { return x[i].Artist < x[j].Artist }
func (x byArtist) Swap(i, j int)      { x[i], x[j] = x[j], x[i] }

// Сортировка
sort.Sort(byArtist(tracks))
```

=== Обратная сортировка

```go
sort.Sort(sort.Reverse(byArtist(tracks)))
```

`sort.Reverse` оборачивает любой `sort.Interface` и меняет логику `Less` 
на противоположную.


=== Многоуровневая сортировка

```go
type customSort struct {
    t    []*Track
    less func(x, y *Track) bool
}

func (x customSort) Len() int           { return len(x.t) }
func (x customSort) Less(i, j int) bool { return x.less(x.t[i], x.t[j]) }
func (x customSort) Swap(i, j int)      { x.t[i], x.t[j] = x.t[j], x.t[i] }
```

Сортировка по нескольким полям:

```go
sort.Sort(customSort{tracks, func(x, y *Track) bool {
    if x.Title != y.Title {
        return x.Title < y.Title
    }
    if x.Year != y.Year {
        return x.Year < y.Year
    }
    return x.Length < y.Length
}})
```

=== Готовые функции

Пакет sort уже умеет сортировать:

```go
sort.Ints([]int{3, 1, 4})              // []int
sort.Strings([]string{"b", "a"})       // []string
sort.Float64s([]float64{3.14, 1.0})    // []float64
```

=== Ключевая мысль

`sort.Interface` -- это абстракция. Она работает с любой последовательностью:
срез, массив, структура.

Главное -- реализовать 3 метода: `Len`, `Less`, `Swap`.

