module Session (
    genSessionID
  , disableSession
  ) where

import System.Random
import Data.Time

import qualified Crypto.Hash.SHA1 as SHA1
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Base16 as BS16

import Database.SQLite.Simple
import DBInit (withConn)

genSessionID :: Int -> IO String
genSessionID uid = do
  session_seed <- getStdRandom random :: IO Int
  datetime <- getCurrentTime

  let session_key = BC.unpack $ BS16.encode $ SHA1.hash $ BC.pack $ show session_seed ++ show datetime

  withConn $ \conn -> do
    execute conn
      "INSERT INTO session_ids (is_active, owner_id, create_date, session_key) VALUES (1, ?, ?, ?)"
      (uid, show datetime, session_key)

    putStrLn $ show datetime <> "| Session success added"

  pure session_key


disableSession :: String -> IO ()
disableSession session_key = do
  withConn $ \conn -> do
    datetime <- getCurrentTime

    execute conn
      "UPDATE session_ids SET is_active = 0 WHERE session_key = (?)"
      (Only session_key)

    putStrLn $ show datetime <> "| Session success disabled"