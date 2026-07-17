// ============================================================
// Шпаргалка: Инструменты модуля Web Requests
// HTB Academy – Web Requests (Sections 1–8)
// ============================================================

#set page(
  margin: (x: 1.8cm, y: 2.2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "A.1.")

#align(center)[
  #text(size: 22pt, weight: "bold")[Шпаргалка по инструментам]
  #text(size: 14pt)[Web Requests – cURL, DevTools, jq]
]

#v(1.2em)

== cURL – основные флаги

*curl* – командная утилита для отправки HTTP-запросов.

=== Базовые флаги

#table(
  columns: (auto, auto),
  [*Флаг*], [*Назначение / Пример*],
  [`-v`], ["Подробный вывод (показывает запрос, ответ и служебную информацию)."],
  [`-vvv`], ["Ещё более подробный вывод (включая тайминги, детали TLS)."],
  [`-i`], ["Включить в вывод заголовки ответа (вместе с телом)."],
  [`-I`], ["Отправить HEAD-запрос и показать только заголовки ответа."],
  [`-O`], ["Сохранить ответ в файл с именем удалённого ресурса."],
  [`-o <file>`], ["Сохранить ответ в файл с указанным именем."],
  [`-s`], ["Тихий режим (без прогресс-бара и ошибок)."],
  [`-k` / `--insecure`], ["Игнорировать ошибки SSL-сертификата (для тестирования)."],
  [`-L`], ["Следовать за перенаправлениями (редиректами)."],
)

=== Аутентификация и заголовки

#table(
  columns: (auto, auto),
  [*Флаг*], [*Назначение / Пример*],
  [`-u user:pass`], ["Basic-аутентификация через логин и пароль."],
  [`-A 'User-Agent'`], ["Установить User-Agent."],
  [`-H 'Header: value'`], ["Установить произвольный заголовок (можно несколько)."],
  [`-b 'cookie=value'`], ["Установить куку (или файл с куками)."],
  [`-d 'data'`], ["Отправить данные в теле запроса (POST/PUT/PATCH)."],
  [`-X METHOD`], ["Задать метод (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)."],
)

=== Примеры команд

```bash
# GET с выводом заголовков
curl -i https://example.com

# Только заголовки (HEAD)
curl -I https://example.com

# POST с данными формы
curl -X POST -d 'username=admin&password=admin' http://target.com/login

# POST с JSON
curl -X POST -d '{"search":"london"}' -H 'Content-Type: application/json' http://target.com/api.php

# PUT с JSON и кукой
curl -X PUT -d '{"city":"New"}' -H 'Content-Type: application/json' -b 'PHPSESSID=abc123' http://target.com/api.php/city/old

# DELETE
curl -X DELETE http://target.com/api.php/city/New

# Сохранить файл с удалённого сервера
curl -O http://example.com/file.zip

# Сохранить с другим именем
curl -o myfile.zip http://example.com/file.zip
```

== jq – форматирование JSON

jq – утилита для парсинга и красивого вывода JSON.

```bash
# Простое форматирование
curl -s http://target.com/api.php/city/ | jq

# Выбор конкретного поля
curl -s http://target.com/api.php/city/ | jq '.[].city_name'

# Фильтрация
curl -s http://target.com/api.php/city/ | jq '.[] | select(.country_name=="(UK)")'
```

== Браузерные DevTools

=== Network (Сеть)

F12 или Ctrl+Shift+I → вкладка Network.

Отображает все запросы (метод, URL, статус, размер, время).

Клик по запросу → детали:
Headers – заголовки запроса и ответа (можно переключить в Raw).
Request / Payload – тело запроса (для POST/PUT).
Response – тело ответа (можно переключить в Raw).
Cookies – куки, отправленные в запросе.

Фильтр по URL, методу, типу (XHR, JS, CSS и т.д.).
Copy as cURL – скопировать запрос в виде команды cURL.
Copy as Fetch – скопировать запрос в виде JavaScript-кода для консоли.

=== Storage / Application (Хранилище)

Вкладка Storage (Firefox) или Application (Chrome) → раздел Cookies.
Позволяет просматривать, добавлять, редактировать и удалять куки.
Используется для ручной установки сессионных кук (например, для обхода логина).

=== Console (Консоль)

Ctrl+Shift+K (Firefox) или Ctrl+Shift+J (Chrome) → вкладка Console.

Можно выполнять JavaScript-код, в том числе отправлять Fetch-запросы (скопированные через Copy as Fetch).

Пример выполнения Fetch:

```javascript
fetch('http://target.com/api.php/city/london', {
  method: 'GET',
  headers: { 'Authorization': 'Basic YWRtaW46YWRtaW4=' }
})
.then(response => response.json())
.then(data => console.log(data));
```

== Полезные комбинации

#table(
  columns: (auto, auto),
  [Действие], [Команда],
  [Получить страницу с кукой], [curl -b 'PHPSESSID=xxx' http://target.com]
  [Отправить JSON с авторизацией], [curl -X POST -d '{"key":"val"}' -H 'Content-Type: application/json' -u admin:pass http://target.com/api]
  [Проверить доступные методы], [curl -X OPTIONS http://target.com/api.php -v]
  [Отследить редиректы], [curl -L -v http://target.com/redirect]
  [Скачать и сохранить с прогрессом], [curl -O -# http://target.com/bigfile.zip]
)

#block(
inset: 0.5em,
stroke: gray + 0.5pt,
fill: rgb(240, 245, 255),
)[
  Совет: всегда используйте -v при отладке – он показывает точный запрос и ответ, что помогает выявить проблемы с заголовками, куками или форматом данных.
]

// ============================================================
// Конец шпаргалки
// ============================================================
