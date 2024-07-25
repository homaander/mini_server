module Responce where

import Data.Aeson


data ToJSON a => Responce a = Responce {
    respError   :: Int
  , respMessage :: String
  , respData    :: a
  }
    deriving (Show)

instance (ToJSON a, FromJSON a) => FromJSON (Responce a) where
  parseJSON (Object v) = Responce 
                           <$> v .: "error"
                           <*> v .: "message"
                           <*> v .: "data"
  parseJSON _ = error "Error JSON"
instance (ToJSON a, FromJSON a) => ToJSON (Responce a) where
  toJSON (Responce errorS message dataS) = object [
      "error"   .= errorS
    , "message" .= message
    , "data"    .= dataS
    ]

data ReqFrom = ReqFrom {
    reqSessionKey :: String
  }
    deriving (Show)

instance FromJSON ReqFrom where
  parseJSON (Object v) = ReqFrom 
                           <$> v .: "session_key"
  parseJSON _ = error "Error JSON"
instance ToJSON ReqFrom where
  toJSON (ReqFrom session_key) = object [
            "session_key"    .= session_key
          ]

respOk :: Responce String
respOk = Responce 0 "success" ""

respDefault :: String -> Responce String
respDefault = Responce 0 "success"