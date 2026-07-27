Имена всего следуют правилу:
+ Имя начинается с буквы или подчеркивания
+ Имена чувствительны к регистру

_Go_ имеет 25 ключевых слов:

// Функция для отображения списка слов в виде чипсов
#let keyword-chips(..words) = {
  grid(
    columns: 5,               // Количество колонок (можно менять)
    gutter: 0.5em,            // Расстояние между чипсами
    ..words.map(word => {
      rect(
        fill: rgb("#1e1e1e"), // Тёмный фон как на скриншоте
        inset: (x: 0.8em, y: 0.4em),
        radius: 0.3em,
        stroke: 0.1em + rgb("#333333"), // Лёгкая обводка
      )[
        #set text(
          font: "JetBrains Mono", 
          fill: rgb("#66ccff"),   // Голубой цвет, как на скриншоте
          size: 0.9em,
          weight: "regular"
        )
        #word
      ]
    })
  )
}

=== Ключевые слова Go

Здесь перечислены основные ключевые слова языка:

#keyword-chips(
  "break", "case", "chan", "const", "continue",
  "default", "defer", "else", "fallthrough", "for",
  "func", "go", "goto", "if", "import",
  "interface", "map", "package", "range", "return",
  "select", "struct", "switch", "type", "var"
)

А также есть около 3 десятков предопределенных имен:

#table(
  columns: (auto, auto),
  [Константы:], [true, false, iota, nil],
  [Типы:], [
    int, int8, int16, int32, int64,
    uint, uint8, uint16, uint32, uint64,
    float32, float64, complex64, complex128,
    bool, byte, rune, string, error,
  ],
  [Функции:], [
    make, len, cap, new, append, copy, close, delete,
    complex, real, imag, panic, recover
  ],
)

Их можно использовать в объявлениях, но будьте аккуратны, тк переобъявление может
привести к путанице
