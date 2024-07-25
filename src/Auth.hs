module Auth (
    login
  , logout
  , register
  , AuthForm (..)
  , RegForm (..)
  ) where

import Data.Aeson

import User
import Responce
import Session


data AuthForm = AuthForm {
    authUsername :: String
  , authPassword :: String
  }
    deriving (Show)

instance FromJSON AuthForm where
  parseJSON (Object v) = AuthForm 
                           <$> v .: "username" 
                           <*> v .: "password"
  parseJSON _ = error "Error JSON"
instance ToJSON AuthForm where
  toJSON (AuthForm username password) = object [
          "username"    .= username
        , "password"    .= password
        ]


data RegForm = RegForm {
    regUsername  :: String
  , regPassword  :: String
  }
    deriving (Show)

instance FromJSON RegForm where
  parseJSON (Object v) = RegForm 
                           <$> v .: "username" 
                           <*> v .: "password"
  parseJSON _ = error "Error JSON"
instance ToJSON RegForm where
  toJSON (RegForm username password) = object [
          "username"         .= username
        , "password"         .= password
        ]


login :: AuthForm -> IO (Responce ReqFrom)
login authForm = do
  let
        username = authUsername authForm
        password = authPassword authForm
  print password
  loginUser username password


logout :: ReqFrom -> IO (Responce String)
logout reqFrom = do
  let
    session_key = reqSessionKey reqFrom
  disableSession session_key
  pure (Responce 0 "success" "")


register :: RegForm -> IO (Responce ReqFrom)
register regForm = do
  let
    username  = regUsername regForm
    password  = regPassword regForm

  if length username < 3
    then pure (Responce 1 "Минимальная длинна логина: 3" (ReqFrom ""))

  else if length password < 40
    then pure (Responce 1 "Неверный формат пароля" (ReqFrom ""))

  else
    registerUser username password
