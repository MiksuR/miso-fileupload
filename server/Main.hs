module Main where

import Control.Monad.IO.Class
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as BL
import Data.CaseInsensitive (mk)
import qualified Data.Text as T
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import Servant

import Common

uploadServer :: Server UploadAPI
uploadServer fileName fileBytes = do
  case fileName of
    Nothing -> return ()
    Just n -> liftIO $ BL.writeFile 
                ("uploads" ++ (T.unpack n)) 
                fileBytes
  return 0

staticServer :: Server Raw
staticServer = serveDirectoryWebApp "static"

server :: Server API
server = uploadServer :<|> staticServer

app :: Application
app = mw $ serve api server
  where
    mw = cors . const . Just $ 
        simpleCorsResourcePolicy {
          corsRequestHeaders = map (mk . C.pack)
            [ "Content-Type", "Content-Name" ]
        }

main :: IO ()
main = run 8000 app
