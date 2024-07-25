{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Web.Scotty
import Network.Wai.Handler.Warp

import Data.Text.Lazy (Text)

import Auth
import Responce
import Message


opts :: Options
opts = Options 1 $ (
    setHost "0.0.0.0" 
    -- setHost "127.0.0.1" 
  . setPort 3000
  ) defaultSettings

main :: IO ()
main = scottyOpts opts $ do
  post "/test" $ do
      json respOk

  post "/register" $ do
    regForm <- jsonData :: ActionM RegForm
    resp <- liftIO $ register regForm
    json resp

  post "/login" $ do
    loginForm <- jsonData :: ActionM AuthForm
    resp <- liftIO $ login loginForm
    json resp

  post "/logout" $ do
    reqForm <- jsonData :: ActionM ReqFrom
    resp <- liftIO $ logout reqForm
    json resp

  post "/get" $ do
    reqForm <- jsonData :: ActionM ReqFrom
    -- resp <- liftIO $ logout reqForm
    -- json resp
    json respOk

  post "/send" $ do
    sendForm <- jsonData :: ActionM SendForm
    resp <- liftIO $ send sendForm
    json resp

  get "/" $ do
    html $ baseHTML "Main" [
        "<h1>" <> "Scotty, Index me up!" <> "</h1>"
      ]

baseHTML :: Text -> [Text] -> Text
baseHTML title tags = mconcat [
    "<!DOCTYPE html>"
  , "<html>"
  , "  <head>"
  , "    <title>" <> title <> "</title>"
  , "  </head>"
  , "  <body>"
  ,      mconcat tags
  , "  </body>"
  , "</html>"
  ]