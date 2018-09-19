{-
 Copyright (c) 2012-2017 "JUSPAY Technologies"
 JUSPAY Technologies Pvt. Ltd. [https://www.juspay.in]
 This file is part of JUSPAY Platform.
 JUSPAY Platform is free software: you can redistribute it and/or modify
 it for only educational purposes under the terms of the GNU Affero General
 Public License (GNU AGPL) as published by the Free Software Foundation,
 either version 3 of the License, or (at your option) any later version.
 For Enterprise/Commerical licenses, contact <info@juspay.in>.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  The end user will
 be liable for all damages without limitation, which is caused by the
 ABUSE of the LICENSED SOFTWARE and shall INDEMNIFY JUSPAY for such
 damages, claims, cost, including reasonable attorney fee claimed on Juspay.
 The end user has NO right to claim any indemnification based on its use
 of Licensed Software. See the GNU Affero General Public License for more details.
 You should have received a copy of the GNU Affero General Public License
 along with this program. If not, see <https://www.gnu.org/licenses/agpl.html>.
-}

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
