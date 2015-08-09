# redis-rpc

redis-rpc provides a sliphod interface to use redis as an rpc broker.  I built it to talk to a node server for rendering javascript templates to a lisp process.

To use it

## `start`
```lisp
(redis-rpc:start "response_channel")
```

## `call`
Calls a rpc function through `channel`, passing `args` to it.
```lisp
(redis-rpc:call "request_channel" "function_call"
  (lambda (message) (getf :|content| message))
  4 "banana")
```

So, if our remote function looks like
```lisp
(defun function_call (num word)
  (format nil "~d ~as" num word))
```

Then the `lambda` should get '4 bananas' back as a response.
