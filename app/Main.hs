{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Web.Scotty
import Network.Wai.Handler.Warp

import Auth
import Responce
import Message
import User


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
    regForm <- jsonData
    resp <- liftIO $ register regForm
    json resp

  post "/login" $ do
    loginForm <- jsonData
    resp <- liftIO $ login loginForm
    json resp

  post "/logout" $ do
    reqForm <- jsonData
    resp <- liftIO $ logout reqForm
    json resp

  post "/get" $ do
    reqForm <- jsonData
    resp <- liftIO $ getMessages reqForm
    json resp

  post "/get_users" $ do
    reqForm <- jsonData
    resp <- liftIO $ getUsers reqForm
    json resp

  post "/send" $ do
    sendForm <- jsonData
    resp <- liftIO $ send sendForm
    json resp

  get "/" $ do
    html $ mconcat [
        "<h1>" <> "Scotty, Index me up!" <> "</h1>"
      ]