/*
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
*/

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




