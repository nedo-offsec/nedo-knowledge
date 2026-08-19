`sync.Pool` -- это временное хранилище объектов,
чтобы не создавать новые и снизить нагрузку на GC.

```go
type Pool struct {
  // публичное поле -- фабрика  
  New func() interface{}

  // приватные поля
  // локальный пул -- указатель на массив poolLocal
  // каждый P (процессор) имеет собственный пул
  local       unsafe.Pointer  // указатель на []poolLocal
  localSize   uintptr         // размер локального массива

  // victim -- жертвенный пул для смягчения GC
  // объекты, которые пережили один цикл GC
  victim      unsafe.Pointer
  victimSize  uintptr
  
  // для защиты в редких случаях
  mu sync.Mutex
}
```

Что такое `poolLocal`?

Каждый процессор (P) в Go runtime имеет свой локальный пул
объектов:

```go
type poolLocal struct {
    poolLocalInternal
    // выравнивание для предотвращения 
    // ложного совместного доступа (false sharing)
    pad [128 - unsafe.Sizeof(poolLocalInternal{})%128]byte
}

type poolLocalInternal struct {
    // быстрый доступ к одному объекту (без блокировок)
    private interface{} 
    // очередь объектов для этого P (с блокировками)
    shared  poolChain
}

type poolChain struct {
    head *poolChainElt   // начало очереди (только push/pop с одной стороны)
    tail *poolChainElt   // конец очереди (для кражи)
}

type poolChainElt struct {
    poolDequeue          // кольцевой буфер фиксированного размера
    next, prev *poolChainElt
}
```

Пример для ознакомления:

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	pool := &sync.Pool{
		New: func() interface{} {
			fmt.Println("Создаём новый объект")
			return make([]byte, 1024)
		},
	}

	// Получаем объект из пула
	buf := pool.Get().([]byte)
	fmt.Println("Получили:", len(buf))

	// Используем
	buf = append(buf, 42)

	// Возвращаем в пул
	pool.Put(buf)

	// Берём снова — получаем тот же объект
	buf2 := pool.Get().([]byte)
	fmt.Println("Снова получили:", len(buf2))
}
```

Вывод:

```go
Создаём новый объект
Получили: 1024
Снова получили: 1025
```

== Структура и методы на практике
Вернемся к насущному

```go
type Pool struct {
    New func() interface{}   // фабрика (не метод, но ключевая часть)
}

func (p *Pool) Get() interface{}   // взять объект
func (p *Pool) Put(x interface{})  // вернуть объект
```

=== Поле `New` -- фабрика объектов
```go
var pool = sync.Pool{
    New: func() interface{} {
        return &MyStruct{}
    },
}
```

Что и зачем:

- Функция -- фабрика нового объекта
- Вызывается автоматически в `Get()`, если пул пуст
- Не обязательна, но очень рекомендуется

Правила:

- Если `New == nil`, то `Get()` вернёт `nil`, когда пул пуст.
- Должна возвращать новый объект (не из пула).
- Должна быть потокобезопасной (обычно это просто конструктор).

=== Метод `Get()` -- взять объект

```go
func (p *Pool) Get() interface{}
```

Что делает:

- Возвращает объект из пула (если есть).
- Если пул пуст -- создаёт новый через `New()`.
- Если `New == nil` и пул пуст -- возвращает `nil`.

Рекомендации:
+ Type assertion
  ```go
  // Неправильно: работаем с interface{}
  obj := pool.Get()
  obj.WriteString("hello") // ОШИБКА! interface{} не имеет метода WriteString

  // Правильно: приводим к нужному типу
  buf := pool.Get().(*bytes.Buffer)
  buf.WriteString("hello")
  ```
+ Объект нужно сбросить.
  ```go
  // Неправильно: предполагаем, что объект чистый
  buf := pool.Get().(*bytes.Buffer)
  buf.WriteString("data") // может дописать к старым данным!

  // Правильно: сбрасываем состояние перед использованием
  buf := pool.Get().(*bytes.Buffer)
  buf.Reset() // критически важно!
  buf.WriteString("data")
  ```
  Но сначала убедись что Reset() существует, например, 
  если работаем со своими структурами или типами без такого 
  метода.
+ Не хранить ссылку на объект после использования
+ Get() может вернуть объект, созданный другим потоком.
  Это нормально. Все равно надо сбросить его сотояние

=== Метод Put() -- вернуть объект

```go
func (p *Pool) Put(x interface{})
```

Он кладет объект обратно в пул для будущего переиспользования

Правила+Рекомендации+Возможности:
+ Кладем то, что взяли
  ```go
  // Неправильно: кладём чужой объект
  buf := &bytes.Buffer{} // создали сами
  pool.Put(buf) // можно, но НЕ РЕКОМЕНДУЕТСЯ

  // Правильно: кладём только взятое из пула
  buf := pool.Get().(*bytes.Buffer)
  // ... работа
  pool.Put(buf) // возвращаем то же, что взяли
  ```
+ Объект должен быть "чистым":
  ```go
  // Неправильно: кладём "грязный" объект
  buf := pool.Get().(*bytes.Buffer)
  buf.WriteString("data")
  pool.Put(buf) // следующий получит буфер с "data"

  // Правильно: сбрасываем перед возвратом (опционально)
  buf := pool.Get().(*bytes.Buffer)
  buf.WriteString("data")
  buf.Reset() // чистим!
  pool.Put(buf)
  ```
+ Можно не возвращать объект, но тогда он уйдет в GC
+ Можно передать nil, но это бессмысленно
  (он попросту не будет храниться)

Пример хорошей практики:
```go
package main

import (
    "sync"
    "bytes"
)

var pool = sync.Pool{
    New: func() interface{} {
        return &bytes.Buffer{}
    },
}

func processData(data string) {
    // 1. Забираем объект
    buf := pool.Get().(*bytes.Buffer)
    
    // 2. Сбрасываем состояние (КРИТИЧНО!)
    buf.Reset()
    
    // 3. Используем
    buf.WriteString(data)
    result := buf.String()
    
    // 4. Возвращаем в пул (через defer для безопасности)
    defer pool.Put(buf)
    
    // Используем result
    _ = result
}
```

Идиомы и лучшие практики
1. Всегда объявляйте New
  ```go
  var pool = sync.Pool{
      New: func() interface{} {
          return make([]byte, 0, 1024)
      },
  }
  ```
2. Используйте defer для Put()
  ```go
  buf := pool.Get().(*bytes.Buffer)
  defer pool.Put(buf)
  ```
3. Сбрасывайте объект сразу после Get()
  ```go
  buf := pool.Get().(*MyStruct)
  buf.Reset() // или очистка полей
  ```
4. Не храните ссылки на объекты после Put()
  ```go
  buf := pool.Get().(*bytes.Buffer)
  defer pool.Put(buf)
  // ... работа
  // после Put не используйте buf!
  ```
5. Проверяйте тип при Get()
  ```go
  // Небезопасно
  obj := pool.Get()
  buf := obj.(*bytes.Buffer) // может упасть!

  // Безопасно
  obj := pool.Get()
  buf, ok := obj.(*bytes.Buffer)
  if !ok {
      // обработайте ошибку
  }
  ```

== Особый случай

С sync.Pool можно работать без New:
```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var pool sync.Pool
    
    // 1. Кладём объект
    pool.Put("first message")
    
    // 2. Забираем его
    msg1 := pool.Get()
    fmt.Println(msg1) // "first message"
    
    // 3. Пул снова пуст -> Get() вернёт nil
    msg2 := pool.Get()
    fmt.Println(msg2) // nil (так как New == nil)
}
``` 

Но это не значит что так надо делать
