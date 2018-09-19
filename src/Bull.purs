module Bull where

import Prelude
import Control.Monad.Aff (Aff, attempt)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (Error)
import Control.Promise (Promise, toAff)
import Data.Either (Either)
import Data.Foreign (Foreign)
import Data.Options (Option, Options, opt, options)

foreign import _newQueue :: forall e. String -> Foreign -> Eff ( queue :: QUEUE | e ) QueueConn
foreign import addJobJ :: forall job. QueueConn -> job -> Foreign -> Promise job
foreign import processJ :: forall job. QueueConn -> Foreign -> Promise Unit
foreign import getJobsJ :: forall job. QueueConn -> Array String -> Number -> Number -> Boolean -> Promise (Array job)
foreign import getJobJ :: forall job. QueueConn -> String -> Promise job
foreign import cleanJ :: QueueConn -> Number -> String -> Number -> Promise (Array Number)
foreign import closeJ :: QueueConn -> Promise Unit
foreign import getRepeatableJobsJ :: forall job. QueueConn -> Number -> Number -> Boolean -> Promise (Array job)
foreign import removeRepeatableJ :: QueueConn -> String -> Promise Unit
foreign import getJobCountsJ :: QueueConn -> Promise { waiting:: Number, active:: Number, completed:: Number, failed:: Number, delayed:: Number}
foreign import getCompletedCountJ :: QueueConn -> Promise Number
foreign import getFailedCountJ :: QueueConn -> Promise Number
foreign import getDelayedCountJ :: QueueConn -> Promise Number
foreign import getActiveCountJ :: QueueConn -> Promise Number
foreign import getWaitingCountJ :: QueueConn -> Promise Number
foreign import getPausedCountJ :: QueueConn -> Promise Number
foreign import getWaitingJ :: forall job. QueueConn -> Number -> Number -> Promise (Array job)
foreign import getActiveJ :: forall job. QueueConn -> Number -> Number -> Promise (Array job)
foreign import getDelayedJ :: forall job. QueueConn -> Number -> Number -> Promise (Array job)
foreign import getCompletedJ :: forall job. QueueConn -> Number -> Number -> Promise (Array job)
foreign import getFailedJ :: forall job. QueueConn -> Number -> Number -> Promise (Array job)

foreign import data QUEUE :: Effect

data QueueConnOpts
data AddJobOpts
data ProcessorOpts
foreign import data QueueConn :: Type 

host :: Option QueueConnOpts String
host = opt "host"

port :: Option QueueConnOpts Int
port = opt "port"

db :: Option QueueConnOpts Int
db = opt "db"

delay :: Option AddJobOpts Int
delay = opt "delay"

repeat :: Option AddJobOpts {cron :: String}
repeat = opt "repeat"

processor :: forall e a. Option ProcessorOpts (a -> Eff e Unit)
processor = opt "processor"

getConn :: forall e. String -> Options QueueConnOpts -> Aff ( queue :: QUEUE | e ) QueueConn
getConn name opts = (liftEff <<< (_newQueue name)  <<< options) opts

addJob :: forall job e. QueueConn -> job -> Options AddJobOpts -> Aff ( queue :: QUEUE | e ) (Either Error job)
addJob queueConn job opts = attempt $ toAff $ addJobJ queueConn job (options opts)

process :: forall options e. QueueConn -> Options ProcessorOpts -> Aff ( queue :: QUEUE | e ) (Either Error Unit)
process queueConn p = attempt $ toAff $ processJ queueConn (options p)

getJobs :: forall job e. QueueConn -> Array String -> Number -> Number -> Boolean -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getJobs queueConn types start end asc = attempt $ toAff $ getJobsJ queueConn types start end asc

getJob :: forall job e. QueueConn -> String -> Aff ( queue :: QUEUE | e ) (Either Error job)
getJob queueConn jobId = attempt $ toAff $ getJobJ queueConn jobId

clean :: forall e. QueueConn -> Number -> String -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array Number))
clean queueConn grace status limit = attempt $ toAff $ cleanJ queueConn grace status limit

close :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Unit)
close queueConn = attempt $ toAff $ closeJ queueConn

getRepeatableJobs :: forall job e. QueueConn -> Number -> Number -> Boolean -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getRepeatableJobs queueConn start end asc = attempt $ toAff $ getRepeatableJobsJ queueConn start end asc

removeRepeatable :: forall e. QueueConn -> String -> Aff ( queue :: QUEUE | e ) (Either Error Unit)
removeRepeatable queueConn name = attempt $ toAff $ removeRepeatableJ queueConn name

getJobCounts :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error { waiting:: Number, active:: Number, completed:: Number, failed:: Number, delayed:: Number})
getJobCounts queueConn = attempt $ toAff $ getJobCountsJ queueConn

getCompletedCount :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getCompletedCount queueConn = attempt $ toAff $ getCompletedCountJ queueConn

getFailedCount :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getFailedCount queueConn = attempt $ toAff $ getFailedCountJ queueConn

getDelayedCount :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getDelayedCount queueConn = attempt $ toAff $ getDelayedCountJ queueConn

getActiveCount :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getActiveCount queueConn = attempt $ toAff $ getActiveCountJ queueConn

getWaitingCount :: forall e. QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getWaitingCount queueConn = attempt $ toAff $ getWaitingCountJ queueConn

getPausedCount :: forall e.  QueueConn -> Aff ( queue :: QUEUE | e ) (Either Error Number)
getPausedCount queueConn = attempt $ toAff $ getPausedCountJ queueConn

getWaiting :: forall job e. QueueConn -> Number -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getWaiting queueConn start end = attempt $ toAff $ getWaitingJ queueConn start end

getActive :: forall job e. QueueConn -> Number -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getActive queueConn start end = attempt $ toAff $ getActiveJ queueConn start end

getDelayed :: forall job e. QueueConn -> Number -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getDelayed queueConn start end = attempt $ toAff $ getDelayedJ queueConn start end

getCompleted :: forall job e. QueueConn -> Number -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getCompleted queueConn start end = attempt $ toAff $ getCompletedJ queueConn start end

getFailed :: forall job e. QueueConn -> Number -> Number -> Aff ( queue :: QUEUE | e ) (Either Error (Array job))
getFailed queueConn start end = attempt $ toAff $ getFailedJ queueConn start end

