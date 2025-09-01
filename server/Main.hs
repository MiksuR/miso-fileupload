{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Monad.IO.Class
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as BL
import Data.CaseInsensitive (mk)
import Data.Proxy
import qualified Data.Text as T
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import Servant
import Servant.API

type UploadAPI = Header "Content-Name" T.Text :> ReqBody '[OctetStream] BL.ByteString :> Post '[JSON] Integer

-- Add Raw API endpoint for serving markdown and the app
type API = "upload" :> UploadAPI :<|> Raw

api :: Proxy API
api = Proxy

uploadServer :: Server UploadAPI
uploadServer fileName fileBytes = do
  case fileName of
    Nothing -> return ()
    Just n -> liftIO $ BL.writeFile 
                ("uploads/" ++ (T.unpack n))
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
main = putStrLn "Serving at http://localhost:8000/index.html" >> run 8000 app

