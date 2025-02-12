module User (
    registerUser
  , loginUser
  , getUsers
  ) where

import Data.Aeson
import Data.Time

import Database.SQLite.Simple
import DBInit (withConn)
import Crypto (sha1)

import Session
import Responce


data User = User {
    userId         :: Int
  , userName       :: String
  , userPassword   :: String
  , userAvatar     :: String
  , userCreateTime :: String
  }
    deriving (Show)

instance FromRow User where
  fromRow = User <$> field <*> field <*> field <*> field <*> field

instance FromJSON User where
  parseJSON (Object v) = User 
                           <$> v .: "id" 
                           <*> v .: "username"
                           <*> v .: "password"
                           <*> v .: "avatar"
                           <*> v .: "create_time"
  parseJSON _ = error "Error JSON"
instance ToJSON User where
  toJSON (User idS username password avatar create_time) = object [
        "id"          .= idS
      , "username"    .= username
      , "password"    .= password
      , "avatar"      .= avatar
      , "create_time" .= create_time
      ]


registerUser :: String -> String -> IO (Responce ReqFrom)
registerUser username password = do
  alredyExist <- findUserByLogin username
  let
    sha_password = sha1 password
  case alredyExist of
    (Just _) -> pure (Responce 1 "Пользователь с таким именем уже есть" (ReqFrom ""))
    Nothing -> do
      datetime <- getCurrentTime
      uid <- addUser (User 0 username sha_password "" (show datetime))
      session_key <- genSessionID uid

      pure (Responce 0 "" (ReqFrom session_key))


loginUser :: String -> String -> IO (Responce ReqFrom)
loginUser username password = do
  mbuser <- findUserByLogin username
  let
    sha_password = sha1 password
  case mbuser of
    Nothing -> pure (Responce 1 "Такой пользователь не зарегистрирован" (ReqFrom ""))
    (Just user) -> do
      if userPassword user /= sha_password then
        pure (Responce 1 "Неверный пароль" (ReqFrom ""))
      else do
        session_key <- genSessionID (userId user)
        pure (Responce 0 "" (ReqFrom session_key))


getUsers :: ReqFrom -> IO (Responce [User])
getUsers reqForm = do
  let
    session_key = reqSessionKey reqForm

  (checkSess, _) <- checkSession session_key

  if not checkSess then
    pure (Responce 1 "session key is not valid" [])
  else do
    users <- withConn $ \conn -> query conn "SELECT * FROM users" ()
    let
      users' = map (\user -> user {userPassword = ""}) users
    pure (Responce 0 "" users')


findUserByLogin :: String -> IO (Maybe User)
findUserByLogin login = do
    withConn $ \conn -> do
      resp <- query conn "SELECT * FROM users WHERE username = (?)" (Only login)
      pure $ firstOrNothing resp
  where
    firstOrNothing []    = Nothing
    firstOrNothing (x:_) = Just x


addUser :: User -> IO Int
addUser user = do
  let
    user_name = userName user
    user_pass = userPassword user

  user_id <- withConn $ \conn -> do
    datetime <- getCurrentTime

    execute conn
      "INSERT INTO users (username, userpass, avatar, create_date)\
      \ VALUES (?, ?, '', ?)"
      (user_name, user_pass, show datetime)

    putStrLn $ show datetime <> "| User success added"
    lastInsertRowId conn

  pure (fromIntegral user_id)

