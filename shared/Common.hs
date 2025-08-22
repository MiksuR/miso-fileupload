{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Common where

import Data.ByteString.Lazy (ByteString)
import Data.Text (Text)
import Data.Proxy
import Servant.API

type UploadAPI = Header "Content-Name" Text :> ReqBody '[OctetStream] ByteString :> Post '[JSON] Integer

-- Add Raw API endpoint for serving markdown and the app
type API = "upload" :> UploadAPI :<|> Raw

api :: Proxy API
api = Proxy
