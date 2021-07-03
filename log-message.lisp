(fn make-log-stream ()
  (make-stream :fun-in   []
               :fun-out  #'((c str)
                             (log-message (? (string? c) c (char-string c))))
               :fun-eof  [identity t]))

(var *standard-log* (make-log-stream))
(= *standard-output* (make-log-stream))
(= *standard-error* (make-log-stream))

(fn log-message (x)
  (console.log x)
  x)
