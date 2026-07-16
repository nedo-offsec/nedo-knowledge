// ============================================================
// Конспект: Web Requests – CRUD API
// Модуль HTB Academy, Section 8/8
// ============================================================

#set page(
  margin: (x: 1.8cm, y: 2.2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "8.1.")

#align(center)[
  #text(size: 20pt, weight: "bold")[Web Requests]
  #text(size: 14pt)[CRUD API]
]

#v(1.2em)

== Введение

*API* (Application Programming Interface) позволяют взаимодействовать с базой данных через HTTP-запросы. Обычно в URL указываются таблица и запись, а метод HTTP определяет операцию.

Пример: `api.php/city/london` – обращение к таблице `city` и записи с именем `london`.

== CRUD-операции

*CRUD* – аббревиатура четырёх основных операций:

#table(
  columns: (auto, auto, auto),
  [*Операция*], [*Метод*], [*Описание*],
  [Create], [POST], ["Создание новой записи в таблице"],
  [Read], [GET], ["Чтение записи (или всех записей)"],
  [Update], [PUT / PATCH], ["Обновление существующей записи (PUT – целиком, PATCH – частично)"],
  [Delete], [DELETE], ["Удаление записи"],
)

== Чтение (Read)

=== Чтение конкретной записи

```bash
$ curl http://<SERVER_IP>:<PORT>/api.php/city/london
[{"city_name":"London","country_name":"(UK)"}]
```

=== Форматирование вывода с jq

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/london | jq
[
  {
    "city_name": "London",
    "country_name": "(UK)"
  }
]
```

=== Поиск по части названия

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/le | jq
[
  { "city_name": "Leeds", "country_name": "(UK)" },
  { "city_name": "Leicester", "country_name": "(UK)" },
  ...
]
```

=== Получение всех записей (пустой параметр)

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/ | jq
```

#block(
inset: 0.5em,
stroke: gray + 0.5pt,
fill: rgb(240, 245, 255),
)[
Примечание: можно открыть любой из этих URL в браузере – результат будет отображён в виде JSON.
]

== Создание (Create)

Для добавления новой записи используется POST. Данные передаются в теле в формате JSON с заголовком Content-Type: application/json.

```bash
$ curl -X POST http://<SERVER_IP>:<PORT>/api.php/city/ -d '{"city_name":"HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'
```

Проверка, что запись создана:

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/HTB_City | jq
[
  {
    "city_name": "HTB_City",
    "country_name": "HTB"
  }
]
```

#block(
inset: 0.5em,
stroke: green + 0.5pt,
fill: rgb(240, 255, 240),
)[
Упражнение: попробуйте добавить новый город через Fetch в браузере, как делали в разделе POST.
]

== Обновление (Update)

Для обновления используется метод PUT (или PATCH). Нужно указать имя изменяемой записи в URL и передать новые данные.

```bash
$ curl -X PUT http://<SERVER_IP>:<PORT>/api.php/city/london -d '{"city_name":"New_HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'
```

После этого запись london заменяется на New_HTB_City. Проверка:

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/New_HTB_City | jq
[
  {
    "city_name": "New_HTB_City",
    "country_name": "HTB"
  }
]
```

#block(
inset: 0.5em,
stroke: orange + 0.5pt,
fill: rgb(255, 248, 230),
)[
Важно: некоторые API могут создавать запись, если она не существует (upsert). В нашем примере это не так – попробуйте обновить несуществующий город и посмотрите на ответ.
]

== Удаление (Delete)

Удаление выполняется методом DELETE. Достаточно указать имя записи в URL.

```bash
$ curl -X DELETE http://<SERVER_IP>:<PORT>/api.php/city/New_HTB_City
```

После удаления попытка чтения вернёт пустой массив:

```bash
$ curl -s http://<SERVER_IP>:<PORT>/api.php/city/New_HTB_City | jq

[]
```

#block(
inset: 0.5em,
stroke: red + 0.5pt,
fill: rgb(255, 240, 240),
)[
Важно: в реальных приложениях доступ к операциям CRUD ограничен правами пользователя. Неавторизованный доступ к PUT/DELETE – уязвимость. Для аутентификации обычно используют куки или токены (JWT).
]

== Практическое применение

Взаимодействие с API напрямую через cURL значительно ускоряет тестирование.

Все операции CRUD можно выполнять как из командной строки, так и через браузерные DevTools (копируя Fetch-запросы).

Знание этих методов необходимо для обнаружения уязвимостей, таких как IDOR, недостаточный контроль доступа и т.п.

// ============================================================
// Конец раздела 8
// ============================================================
