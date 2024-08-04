module Session (
    genSessionID
  , disableSession
  , checkSession
  ) where

import System.Random
import Data.Time

import Data.Aeson

import Database.SQLite.Simple
import DBInit (withConn)
import Crypto (sha1)


data Session = Session {
    sessID         :: Int
  , sessIsActive   :: Int
  , sessOwnerID    :: Int
  , sessCreateTime :: String
  , sessSessionKey :: String
  }
    deriving (Show)

instance FromRow Session where
  fromRow = Session <$> field <*> field <*> field <*> field <*> field

instance FromJSON Session where
  parseJSON (Object v) = Session 
                           <$> v .: "id"
                           <*> v .: "is_active"
                           <*> v .: "owner_id"
                           <*> v .: "create_time"
                           <*> v .: "session_key"
  parseJSON _ = error "Error JSON"
instance ToJSON Session where
  toJSON (Session sess_id is_active owner_id create_time session_key) = object [
        "id"          .= sess_id
      , "is_active"   .= is_active
      , "owner_id"    .= owner_id
      , "create_time" .= create_time
      , "session_key" .= session_key
      ]


genSessionID :: Int -> IO String
genSessionID uid = do
  session_seed <- getStdRandom random :: IO Int
  datetime <- getCurrentTime

  let session_key = sha1 $ show session_seed ++ show datetime

  withConn $ \conn -> do
    execute conn
      "INSERT INTO session_ids (is_active, owner_id, create_date, session_key)\
      \ VALUES (1, ?, ?, ?)"
      (uid, show datetime, session_key)

    putStrLn $ show datetime <> "| Session success added"

  pure session_key


checkSession :: String -> IO (Bool, Int)
checkSession session_key = do
  -- datetime <- getCurrentTime
  session <- (
      withConn $ \conn -> 
        query conn "SELECT * FROM session_ids\
        \ WHERE is_active=1 AND session_key=(?)"
        (Only session_key)
    ) :: IO [Session]

  if null session then
    pure (False, 0)
  else
    pure (True, sessOwnerID $ head session)


disableSession :: String -> IO ()
disableSession session_key = do
  withConn $ \conn -> do
    datetime <- getCurrentTime

    execute conn
      "UPDATE session_ids SET is_active = 0 WHERE session_key = (?)"
      (Only session_key)

    putStrLn $ show datetime <> "| Session success disabled"