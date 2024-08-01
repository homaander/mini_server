module Message (
    send
  , getMessages
  , SendForm(..)
  ) where

import Data.Aeson

import Database.SQLite.Simple
import DBInit (withConn)

import Data.Time

import Responce
import Session


data SendForm = SendForm {
    sfSessionKey :: String
  , sfMessage    :: String
  }
    deriving (Show)

instance FromJSON SendForm where
  parseJSON (Object v) = SendForm 
                           <$> v .: "session_key"
                           <*> v .: "message"
  parseJSON _ = error "Error JSON"
instance ToJSON SendForm where
  toJSON (SendForm session_key message) = object [
        "session_key" .= session_key
      , "message"     .= message
      ]

data Message = Message {
    msgID       :: Int
  , msgUserID   :: Int
  , msgBody     :: String
  , msgSendTime :: String
  }
    deriving (Show)

instance FromRow Message where
  fromRow = Message <$> field <*> field <*> field <*> field

instance FromJSON Message where
  parseJSON (Object v) = Message 
                           <$> v .: "id"
                           <*> v .: "user_id"
                           <*> v .: "body"
                           <*> v .: "send_time"
  parseJSON _ = error "Error JSON"
instance ToJSON Message where
  toJSON (Message msg_id user_id body send_time) = object [
        "id"        .= msg_id
      , "user_id"   .= user_id
      , "body"      .= body
      , "send_time" .= send_time
      ]


send :: SendForm -> IO (Responce String)
send sendForm = do
  let
    session_key = sfSessionKey sendForm
    message     = sfMessage sendForm

  (checkSess, user_id) <- checkSession session_key

  if not checkSess
    then pure (Responce 1 "session key is not valid" [])
    else do
      _ <- withConn $ \conn -> do
        datetime <- getCurrentTime

        execute conn
          "INSERT INTO messages (owner_id, body, send_date) VALUES (?, ?, ?)"
          (user_id, message, show datetime)

      pure (Responce 0 "" "OK")


getMessages :: ReqFrom -> IO (Responce [Message])
getMessages reqForm = do
  let
    session_key = reqSessionKey reqForm
  (checkSess, _) <- checkSession session_key

  if not checkSess
    then pure (Responce 1 "session key is not valid" [])
    else do
      messages <- withConn $ \conn -> query conn "SELECT * FROM messages" ()

      -- print messages
      pure (Responce 0 "" messages)