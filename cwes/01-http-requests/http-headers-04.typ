// ============================================================
// Конспект: Web Requests – HTTP Headers
// Модуль HTB Academy, Section 4/8
// ============================================================

#set page(
  margin: (x: 1.8cm, y: 2.2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "4.1.")

#align(center)[
  #text(size: 20pt, weight: "bold")[Web Requests]
  #text(size: 14pt)[HTTP Headers]
]

#v(1.2em)

== Введение

*HTTP-заголовки* передают дополнительную информацию между клиентом и сервером. Они имеют формат `Ключ: значение` (одно или несколько значений, разделённых запятыми). Заголовки делятся на категории:

- *Общие* (General) – для запросов и ответов;
- *Сущности* (Entity) – описывают содержимое;
- *Запросов* (Request) – только в запросах;
- *Ответов* (Response) – только в ответах;
- *Безопасности* (Security) – политики безопасности.

== Общие заголовки (General Headers)

Используются в обоих направлениях, описывают сообщение в целом.

#table(
  columns: (auto, auto, 1fr),
  [*Заголовок*], [*Пример*], [*Описание*],
  [Date], [Date: Wed, 16 Feb 2022 10:38:44 GMT], "Дата и время создания сообщения (в UTC)",
  [Connection], [Connection: close], "Управление соединением: `close` – закрыть после ответа, `keep-alive` – оставить открытым",
)

== Заголовки сущности (Entity Headers)

Описывают содержимое (тело) сообщения. Часто в ответах и в запросах POST/PUT.

#table(
  columns: (auto, auto, 1fr),
  [*Заголовок*], [*Пример*], [*Описание*],
  [Content-Type], [Content-Type: text/html; charset=UTF-8], "Тип ресурса (MIME) и кодировка",
  [Media-Type], [Media-Type: application/pdf], "Аналогичен Content-Type, может влиять на интерпретацию сервером",
  [Boundary], [boundary="b4e4fbd93540"], "Разделитель для многокомпонентных данных (например, в form-data)",
  [Content-Length], [Content-Length: 385], "Размер тела в байтах (автоматически вычисляется)",
  [Content-Encoding], [Content-Encoding: gzip], "Метод сжатия (gzip, deflate, br)",
)

== Заголовки запроса (Request Headers)

Отправляются клиентом, не относятся к содержимому.

#table(
  columns: (auto, auto, 1fr),
  [*Заголовок*], [*Пример*], [*Описание*],
  [Host], [Host: www.inlanefreight.com], ["Доменное имя или IP запрашиваемого сервера (обязателен для HTTP/1.1)"],
  [User-Agent], [User-Agent: curl/7.77.0], ["Информация о клиенте (браузер, версия, ОС)"],
  [Referer], [Referer: http://www.inlanefreight.com/], ["URL, с которого был совершён переход (может быть подделан)"],
  [Accept], [Accept: `*/*`], ["Типы медиа, которые клиент готов принять (`*/*` – любые)"],
  [Cookie], [Cookie: PHPSESSID=b4e4fbd93540], ["Пары `имя=значение` для сессионной идентификации"],
  [Authorization], [Authorization: BASIC cGFzc3dvcmQK], ["Токен для аутентификации (Basic, Bearer и др.)"],
)

#block(
  inset: 0.5em,
  stroke: gray + 0.5pt,
  fill: rgb(240, 245, 255),
)[
  *Важно:* заголовок `Host` критичен для виртуального хостинга – по нему сервер определяет, какой сайт обслуживать.
]

== Заголовки ответа (Response Headers)

Отправляются сервером, не относятся к содержимому.

#table(
  columns: (auto, auto, 1fr),
  [*Заголовок*], [*Пример*], [*Описание*],
  [Server], [Server: Apache/2.2.14 (Win32)], ["Информация о веб-сервере (версия, ОС) – часто скрывается"],
  [Set-Cookie], [Set-Cookie: PHPSESSID=b4e4fbd93540], ["Устанавливает куки на клиенте для будущих запросов"],
  [WWW-Authenticate], [WWW-Authenticate: BASIC realm="localhost"], ["Указывает требуемый метод аутентификации"],
)

== Заголовки безопасности (Security Headers)

Заголовки ответа, которые предписывают браузеру определённые политики безопасности.

#table(
  columns: (auto, auto, 1fr),
  [*Заголовок*], [*Пример*], [*Описание*],
  [Content-Security-Policy], [Content-Security-Policy: script-src 'self'], ["Разрешает загрузку ресурсов только с доверенных доменов (защита от XSS)"],
  [Strict-Transport-Security], [Strict-Transport-Security: max-age=31536000], ["Принудительно использует HTTPS (HSTS) на указанный срок"],
  [Referrer-Policy], [Referrer-Policy: origin], ["Управляет передачей Referer (например, только домен, без пути)"],
)

== Работа с заголовками в cURL

=== Просмотр только ответных заголовков (флаг `-I`)

Отправляет *HEAD*-запрос и показывает только заголовки ответа:

```bash
$ curl -I https://www.inlanefreight.com
HTTP/1.1 200 OK
Date: Sun, 06 Aug 2020 08:49:37 GMT
Server: Apache/2.2.14 (Win32)
Content-Type: text/html; charset=ISO-8859-4
...
```

=== Просмотр заголовков и тела (флаг -i)

Отправляет обычный запрос (GET по умолчанию) и выводит и заголовки, и тело:

```bash
$ curl -i https://www.inlanefreight.com
HTTP/1.1 200 OK
...
<html>...</html>
```

=== Установка пользовательского заголовка (флаг -H)

```bash
$ curl -H "User-Agent: MyCustomAgent" -H "X-Custom: test" https://www.inlanefreight.com
```

=== Установка User-Agent через -A

Специальный флаг для подмены User-Agent:

```bash
$ curl https://www.inlanefreight.com -A 'Mozilla/5.0'
```

Чтобы проверить, что заголовок изменился, добавьте -v или -I.

== Просмотр заголовков в браузерных DevTools

Откройте DevTools (F12 или Ctrl+Shift+I).

Перейдите на вкладку Network.

Обновите страницу – увидите список всех запросов.

Кликните на любой запрос – откроется панель с деталями:

Вкладка Headers показывает заголовки запроса и ответа (можно переключиться в Raw).

Вкладка Cookies – куки, переданные в запросе.

Вкладка Response – тело ответа.

#block(
inset: 0.5em,
stroke: green + 0.5pt,
fill: rgb(240, 255, 240),
)[
Упражнение: используйте -I и -v с cURL для просмотра заголовков; в DevTools изучите заголовки любого запроса и найдите знакомые поля.
]

// ============================================================
// Конец раздела 4
// ============================================================
