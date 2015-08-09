;;;; redis-rpc.lisp

(in-package #:redis-rpc)

(defvar *connection* nil)
(defvar *callback-table* (make-hash-table :test 'equal))

(defun start (channel &rest keys)
  "Subscribe to a channel to expect callbacks on"
  (declare (optimize (debug 3)))
  (setf *connection* (apply #'redis:connect keys))
  (bt:make-thread
   (lambda ()
     (redis:with-connection ()
       (red:subscribe channel)
       (loop for msg = (redis:expect :anything)
	  for parsed = (jonathan:parse (third msg))
	  for callback-id = (getf parsed :|i|)

	  do (funcall (gethash callback-id *callback-table* #'identity) msg)
	  do (remhash callback-id *callback-table*))))
   :name "Redis sub thread"))

(defun call (function channel callback &rest args)
  "Call a remote =function= on =channel=.  =callback= will be called with the response message parsed back from json as the only argument.  =args= is a list of arguments to the call. "
  (redis:with-connection ()
    (let* ((id (format nil "~a" (uuid:make-v1-uuid)))
	   (message (list
		    :|i| id
		    :|f| function
		    :|a| args)))
      (setf (gethash id *callback-table*) callback)
      (red:publish channel (jonathan:to-json message)))))
