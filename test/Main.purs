module Bull.Test where

import Prelude

import Bull (QUEUE, addJob, delay, getConn, host, port, process, processor)
import Control.Monad.Aff (launchAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log, CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Foreign (Foreign)
import Data.Options ((:=))
import Data.Show (class Show)
import Debug.Trace (spy)

getProcessorFunction :: forall a e. {data :: String | a} -> Eff (console :: CONSOLE | e ) Unit
getProcessorFunction a = (pure $ spy a.data) *> pure unit        


main :: forall e. Eff ( exception :: EXCEPTION, queue :: QUEUE | e ) Unit
main = do
    _ <- launchAff do
            conn <- getConn "queue name" ((host := "127.0.0.1") <> (port := 6379))
            job <- addJob conn ({awesome : "I am"}) ((delay := 0 ))
            pure unit
    pure unit

processJob :: forall e. Eff ( exception :: EXCEPTION, queue :: QUEUE | e ) Unit
processJob = do
    _ <-  launchAff do
            conn <- getConn "queue name" ((host := "127.0.0.1") <> (port := 6379))
            _ <- process conn (processor := getProcessorFunction )
            pure unit
    pure unit
