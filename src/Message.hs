module Message (
    send
  , getMessages
  , SendForm(..)
  ) where

import Data.Aeson

import Database.SQLite.Simple
import DBInit (withConn)

import Responce
import Session
import User


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
  pure (Responce 0 "" "")

getMessages :: ReqFrom -> IO (Responce [Message])
getMessages reqForm = do
  let
    session_key = reqSessionKey reqForm

  messages <- withConn $ \conn -> query conn "SELECT * FROM messages" ()

  print messages
  pure (Responce 0 "" messages)