module Message (
    send
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


send :: SendForm -> IO (Responce String)
send sendForm = do
  let
      session_key = sfSessionKey sendForm
      message     = sfMessage sendForm
  pure (Responce 0 "" "")