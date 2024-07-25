# API


## Регистрация
```
POST /register
  ->  "{
         "regUsername": "...",
         "regPassword": "...",
         "regSPassword": "..."
       }"

  <- "{
        "respError": 1|0
        "respMessage": "..."|""
        "respData": "{
          "session_key": "..."
        }"
      }"
```

## Вход
```
POST /login
  -> "{
        "authUsername": "...",
        "authPassword": "..."
      }"

  <- "{
        "respError": 1|0
        "respMessage": "..."|""
        "respData": "{
          "session_key": "..."
        }"
      }"
```

## Выход
```
POST /logout
  -> "{
        "logoutSessionKey": "..."
      }"

  <- "{
        "respError": 1|0
        "respMessage": "..."|""
        "respData": ""
      }"
```

## Отправка сообщеения
```
POST /send
  -> "{
       "sendSessionKey": "..."
       "sendMessage": "..."
     }"

  <- "{
      "respError": 1|0
      "respMessage": "..."|""
      "respData": ""
    }"
```

## Получение сообщения
```
POST /get
  -> "{
       "getSessionKey": "..."
     }"

  <- "{
      "respError": 1|0
      "respMessage": "..."|""
      "respData": "{'messages': [{'user_id':...,'message_text':'...','send_time':'YYYY-MM-DD HH:MM:SS'}, ...]}"
    }"
```

```
POST /getusers
  -> "{
       "getSessionKey": "..."
     }"

  <- "{
      "respError": 1|0
      "respMessage": "..."|""
      "respData": "{'users': [{'user_id':...,'avatar':'...','login':'...','create_time':'YYYY-MM-DD HH:MM:SS'}, ...]}"
    }"
```