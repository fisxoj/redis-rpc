;;;; redis-rpc.asd

(asdf:defsystem #:redis-rpc
  :description "Describe redis-rpc here"
  :author "Matt Novenstern <fisxoj@gmail.com>"
  :license "LLGPLv3+"
  :depends-on (#:cl-redis
               #:jonathan
               #:uuid
	       #:bordeaux-threads)
  :serial t
  :components ((:file "package")
               (:file "redis-rpc")))
