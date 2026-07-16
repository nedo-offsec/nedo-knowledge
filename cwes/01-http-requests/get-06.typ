// ============================================================
// Конспект: Web Requests – GET
// Модуль HTB Academy, Section 6/8
// ============================================================

#set page(
  margin: (x: 1.8cm, y: 2.2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "6.1.")

#align(center)[
  #text(size: 20pt, weight: "bold")[Web Requests]
  #text(size: 14pt)[GET]
]

#v(1.2em)

== Введение

При вводе URL в браузере по умолчанию отправляется *GET-запрос* для получения ресурса. На вкладке *Network* в DevTools можно увидеть все запросы, которые отправляет страница, включая дополнительные (например, к API). Это помогает понять, как работает веб-приложение.

== HTTP Basic Auth

*Basic-аутентификация* – это встроенный в HTTP механизм защиты страниц/каталогов на уровне веб-сервера (без участия приложения). Сервер возвращает заголовок `WWW-Authenticate: Basic`, а клиент должен отправить заголовок `Authorization: Basic <base64-креды>`.

=== Пример без аутентификации

```bash
$ curl -i http://<SERVER_IP>:<PORT>/
HTTP/1.1 401 Authorization Required
WWW-Authenticate: Basic realm="Access denied"
Access denied
```

=== Аутентификация через cURL (флаг -u)

```bash
$ curl -u admin:admin http://<SERVER_IP>:<PORT>/
<!DOCTYPE html>...
```

=== Аутентификация через URL (явная передача)

```bash
$ curl http://admin:admin@<SERVER_IP>:<PORT>/
<!DOCTYPE html>...
```

=== Аутентификация через заголовок Authorization (ручная установка)

Сначала получим Base64 от admin:admin (или возьмём из лога -v). Затем:

```bash
$ curl -H 'Authorization: Basic YWRtaW46YWRtaW4=' http://<SERVER_IP>:<PORT>/
```

#block(
inset: 0.5em,
stroke: gray + 0.5pt,
fill: rgb(240, 245, 255),
)[
Примечание: в современных приложениях чаще используют формы входа (POST) и сессионные куки, но Basic Auth иногда встречается (например, для админ-панелей).
]

=== Просмотр деталей с -v

```bash
$ curl -v http://admin:admin@<SERVER_IP>:<PORT>/
> GET / HTTP/1.1
> Authorization: Basic YWRtaW46YWRtaW4=
...
< HTTP/1.1 200 OK
```

Видно, что cURL автоматически добавляет заголовок Authorization.

== GET-параметры

GET-параметры передаются в строке запроса после ? (например, ?search=le). Они видны в URL, поэтому не подходят для передачи паролей, но удобны для поиска, фильтрации и навигации.

=== Пример с поиском городов

При вводе текста в поле поиска браузер отправляет GET-запрос к search.php?search=.... В DevTools (вкладка Network) виден этот запрос.

=== Копирование запроса как cURL

В DevTools правой кнопкой по запросу → Copy → Copy as cURL. Вставив в терминал, получим тот же ответ:

```bash
$ curl 'http://<SERVER_IP>:<PORT>/search.php?search=le' -H 'Authorization: Basic YWRtaW46YWRtaW4='
Leeds (UK)
Leicester (UK)
Можно удалить лишние заголовки, оставив только необходимые (например, Authorization).
```

=== Копирование как Fetch (JavaScript)

Copy → Copy as Fetch – скопирует код на JavaScript для отправки запроса из консоли браузера. Вставив в консоль (Ctrl+Shift+K) и выполнив, мы увидим ответ и сможем его проанализировать.

#block(
inset: 0.5em,
stroke: green + 0.5pt,
fill: rgb(240, 255, 240),
)[
Упражнение: откройте любой сайт, найдите GET-запрос в DevTools, скопируйте его как cURL и выполните в терминале; попробуйте также скопировать как Fetch и выполнить в консоли.
]

// ============================================================
// Конец раздела 6
// ============================================================
