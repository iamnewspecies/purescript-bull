
var Queue = require('bull');

var _newQueue = function(name) {
    return function(options) {
        return function() {
          return (new Queue(name, {redis : options}));
        }
    }
}

var addJob = function(queue) {
    return function(job) {
        return function(options) {
          return queue.add(job, options);
        }
    }
}

var process = function(queue) {
    return function(handler) {
      var execute = function(d) {
        return handler.processor(d)();
      }
      return queue.process(execute);
    }
}
 
var clean = function(queue) {
    return function(grace) {
        return function(status) {
            return function(limit) {
                return queue.clean(grace, status, limit);
            }
        }
    }
}
 
var close = function(queue) {
    return queue.close();
}
 
var getJob = function(queue) {
    return function(jobId) {
        return queue.getJob(jobId);
    }

}
 
var getJobs = function(queue) {
    return function(types) {
        return function(start) {
            return function(end) {
                return function(asc) {
                    return queue.getJobs(types, start, end, asc);
                }
            }
        }
    }
}
 
var getRepeatableJobs = function(queue) {
    return function(start) {
        return function(end) {
            return function(asc) {
                return queue.getRepeatableJobs(start, end, asc);
            }
        }
    }
}
 
var removeRepeatable = function(queue) {
    return function(name) {
        return function(repeatOpts) {
            return queue.removeRepeatable(name, repeatOpts);
        }
    }
}
 
var getJobCounts = function(queue) {
    return queue.getJobCounts();
}
 
var getCompletedCount = function(queue) {
    return queue.getCompletedCount();
}
 
var getFailedCount = function(queue) {
    return queue.getFailedCount();
}
 
var getDelayedCount = function(queue) {
    return queue.getDelayedCount();
}
 
var getActiveCount = function(queue) {
    return queue.getActiveCount();
}
 
var getWaitingCount = function(queue) {
    return queue.getWaitingCount();
}
 
var getPausedCount = function(queue) {
    return queue.getPausedCount();
}
 
var getWaiting = function(queue) {
    return function(start) {
        return function(end) {
            return queue.getWaiting(start, end);   
        }
    }
}
 
var getActive = function(queue) {
    return function(start) {
        return function(end) {
            return queue.getActive(start, end);
        }
    }
}
 
var getDelayed = function(queue) {
    return function(start) {
        return function(end) {
            return queue.getDelayed(start, end);
        }
    }
}
 
var getCompleted = function(queue) {
    return function(start) {
        return function(end) {
            return queue.getCompleted(start, end);
        }
    }
}
 
var getFailed = function(queue) {
    return function(start) {
        return function(end) {
            return queue.getFailed(start, end);
        }
    }
}

_newQueue("harsha")()

exports._newQueue = _newQueue;
exports.addJobJ = addJob;
exports.processJ = process;
exports.getJobsJ = getJobs;
exports.getJobJ = getJob;
exports.cleanJ = clean;
exports.closeJ = close;
exports.getRepeatableJobsJ = getRepeatableJobs;
exports.removeRepeatableJ = removeRepeatable;
exports.getJobCountsJ = getJobCounts;
exports.getCompletedCountJ = getCompletedCount;
exports.getFailedCountJ = getFailedCount;
exports.getDelayedCountJ = getDelayedCount;
exports.getActiveCountJ = getActiveCount;
exports.getWaitingCountJ = getWaitingCount;
exports.getPausedCountJ = getPausedCount;
exports.getWaitingJ = getWaiting;
exports.getActiveJ = getActive;
exports.getDelayedJ = getDelayed;
exports.getCompletedJ = getCompleted;
exports.getFailedJ = getFailed;




