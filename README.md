# API


## Регистрация
```
POST /register
  ->  "{
         "username": "...",
         "password": "...",
         "confirm_password": "..."
       }"

  <- "{
        "error": 1|0
        "message": "..."|""
        "data": {
          "session_key": "..."
        }
      }"
```

## Вход
```
POST /login
  -> "{
        "username": "...",
        "password": "..."
      }"

  <- "{
        "error": 1|0
        "message": "..."|""
        "data": {
          "session_key": "..."
        }
      }"
```

## Выход
```
POST /logout
  -> "{
        "session_key": "..."
      }"

  <- "{
        "error": 1|0
        "message": "..."|""
        "data": ""
      }"
```

## Отправка сообщеения
```
POST /send
  -> "{
       "session_key": "..."
       "message": "..."
     }"

  <- "{
      "error": 1|0
      "message": "..."|""
      "data": ""
    }"
```

## Получение сообщения
```
POST /get
  -> "{
       "session_key": "..."
     }"

  <- "{
      "error": 1|0
      "message": "..."|""
      "data": {
        "messages": [
          {'user_id':...,'message_text':'...','send_time':'YYYY-MM-DD HH:MM:SS'}, 
          ..
        ]
      }
    }"
```

```
POST /getusers
  -> "{
       "session_key": "..."
     }"

  <- "{
      "error": 1|0
      "message": "..."|""
      "data": {
        'users': [
          {'user_id':...,'avatar':'...','login':'...','create_time':'YYYY-MM-DD HH:MM:SS'},
          ...
        ]
      }
    }"
```