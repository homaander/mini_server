# API

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


POST /logout
  -> "{
        "logoutSessionKey": "..."
      }"

  <- "{
        "respError": 1|0
        "respMessage": "..."|""
        "respData": ""
      }"


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

POST /get
  -> "{
       "getSessionKey": "..."
     }"

  <- "{
      "respError": 1|0
      "respMessage": "..."|""
      "respData": "{'messages': [{'user_id':...,'message_text':'...','send_time':'YYYY-MM-DD HH:MM:SS'}, ...]}"
    }"

POST /getusers
  -> "{
       "getSessionKey": "..."
     }"

  <- "{
      "respError": 1|0
      "respMessage": "..."|""
      "respData": "{'users': [{'user_id':...,'avatar':'...','login':'...','create_time':'YYYY-MM-DD HH:MM:SS'}, ...]}"
    }"