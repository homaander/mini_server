module Crypto (sha1) where

import qualified Crypto.Hash.SHA1 as SHA1
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Base16 as BS16

sha1 :: String -> String
sha1 = BC.unpack . BS16.encode . SHA1.hash . BC.pack