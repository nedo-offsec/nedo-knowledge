// ============================================================
// Конспект: Web Requests – HTTP Requests and Responses
// Модуль HTB Academy, Section 3/8
// ============================================================

#set page(
  margin: (x: 1.8cm, y: 2.2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "3.1.")

#align(center)[
  #text(size: 20pt, weight: "bold")[Web Requests]
  #text(size: 14pt)[HTTP Requests and Responses]
]

#v(1.2em)

== Введение

*HTTP-коммуникация* состоит из *запроса* (request) и *ответа* (response). 
- Клиент (браузер, cURL) отправляет запрос, содержащий URL, параметры, заголовки и данные.
- Сервер обрабатывает запрос и возвращает ответ с *кодом состояния* и (опционально) телом ресурса.

== HTTP-запрос (Request)

=== Структура запроса

*Стартовая строка* (request line) содержит три поля, разделённых пробелами:

#table(
  columns: (auto, auto, auto),
  [*Поле*], [*Пример*], [*Описание*],
  [Метод], [GET], ["Тип действия (GET, POST, PUT, DELETE и др.)"],
  [Путь], [/users/login.html], ["Путь к ресурсу (может содержать строку запроса: `?username=user`)"],
  [Версия], [HTTP/1.1], ["Версия протокола HTTP"],
)

После стартовой строки идут *заголовки* (пары `ключ: значение`), например:
- `Host: inlanefreight.com`
- `User-Agent: Mozilla/5.0`
- `Cookie: PHPSESSID=c4ggt4jull9obt7aupa55o8vbf`

Заголовки завершаются пустой строкой (перевод строки). Затем может следовать *тело запроса* (например, для POST).

#block(
  inset: 0.5em,
  stroke: gray + 0.5pt,
  fill: rgb(240, 245, 255),
)[
  *Примечание:* HTTP/1.x передаёт данные в текстовом виде с разделением переводами строк. HTTP/2 использует бинарный формат и словари.
]

=== Пример HTTP-запроса

```http
GET /users/login.html HTTP/1.1
Host: inlanefreight.com
User-Agent: Mozilla/5.0
Cookie: PHPSESSID=c4ggt4jull9obt7aupa55o8vbf
```

== HTTP-ответ (Response)

=== Структура ответа

Строка статуса содержит:

Версию HTTP (например, HTTP/1.1)

Код состояния и текстовое описание (например, 200 OK)

Затем идут заголовки ответа (например, Date, Server, Set-Cookie, Content-Type). После пустой строки — тело ответа (HTML, JSON, изображение, PDF и т.д.).

=== Пример HTTP-ответа

```http
HTTP/1.1 200 OK
Date: Tue, 21 Jul 2020 05:20:15 GMT
Server: Apache/2.4.41 (Ubuntu)
Set-Cookie: PHPSESSID=m4u64rqlpfthrvvb12ai9voqgf
Content-Type: text/html; charset=UTF-8

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>...</head></html>
```

== Работа с запросами и ответами в cURL

=== Просмотр полного обмена (флаг -v)

По умолчанию cURL показывает только тело ответа. Чтобы увидеть и запрос, и ответ (включая заголовки), используйте флаг -v (verbose):

```bash
$ curl inlanefreight.com -v
*   Trying SERVER_IP:80...
* Connected to inlanefreight.com (SERVER_IP) port 80 (#0)
> GET / HTTP/1.1
> Host: inlanefreight.com
> User-Agent: curl/7.65.3
> Accept: */*
> 
< HTTP/1.1 401 Unauthorized
< Date: Tue, 21 Jul 2020 05:20:15 GMT
< Server: Apache/X.Y.ZZ (Ubuntu)
< WWW-Authenticate: Basic realm="Restricted Content"
< Content-Length: 464
< Content-Type: text/html; charset=iso-8859-1
< 
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>...SNIP...
```

В выводе:

Строки, начинающиеся с > — это запрос.

Строки с < — это ответ.

Строки без префикса — диагностика cURL.

=== Ещё более подробный вывод (-vvv)

Флаг -vvv даёт ещё больше деталей (например, время выполнения, информацию о TLS-рукопожатии и т.д.):

```bash
$ curl inlanefreight.com -vvv
```

== Инструменты разработчика в браузере (DevTools)

DevTools (открываются по F12 или Ctrl+Shift+I) — незаменимый инструмент для анализа веб-трафика.

=== Вкладка Network

Показывает все запросы, отправленные страницей.

Отображает метод, статус, путь, размер, время загрузки.

Позволяет фильтровать запросы по типу (XHR, JS, CSS, изображения и др.).

=== Просмотр деталей запроса

Кликните на любой запрос, чтобы увидеть:

Headers — заголовки запроса и ответа.

Response — тело ответа (можно переключиться в Raw для просмотра исходного кода без рендеринга).

Cookies — куки, переданные в запросе.

#block(
inset: 0.5em,
stroke: green + 0.5pt,
fill: rgb(240, 255, 240),
)[
Упражнение: откройте DevTools, перейдите на вкладку Network, обновите страницу и изучите любой запрос. Нажмите на запрос, затем перейдите на вкладку Response и нажмите Raw — вы увидите необработанный HTML-код ответа.
]

== Ключевые выводы

HTTP-запрос состоит из метода, пути, версии, заголовков и (опционально) тела.

HTTP-ответ содержит код состояния, заголовки и тело.

cURL с флагом -v позволяет увидеть полный обмен.

DevTools (вкладка Network) дают наглядное представление о всех запросах и ответах в браузере.

// ============================================================
// Конец раздела 3
// ============================================================
