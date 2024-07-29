# API


## Регистрация
```
Запрос:
POST /register
  {
    "username": "...",
    "password": "*SHA1_PASS*"
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." | "",
    "data": {
      "session_key": "..."
    }
  }
```

## Вход
```
Запрос:
POST /login
  {
    "username": "...",
    "password": "*SHA1_PASS*"
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." | "",
    "data": {
      "session_key": "..."
    }
  }
```

## Выход
```
Запрос:
POST /logout
  {
    "session_key": "..."
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." | "",
    "data": ""
  }
```

## Отправка сообщеения
```
Запрос:
POST /send
  {
    "session_key": "...",
    "message": "..."
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." | "",
    "data": ""
  }
```

## Получение сообщения
```
Запрос:
POST /get
  {
    "session_key": "..."
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." |" ",
    "data": {
      "messages": [
        {'user_id':..., 'body':'...', 'send_time':'YYYY-MM-DD HH:MM:SS'},
        ..
      ]
    }
  }
```

## Получить список всех пользователей
```
Запрос:
POST /get_users
  {
    "session_key": "..."
  }

Ответ:
  {
    "error": 1 | 0,
    "message": "..." | "",
    "data": [
      {'user_id':...,'avatar':'...','login':'...','create_time':'YYYY-MM-DD HH:MM:SS'},
      ...
    ]
  }
```