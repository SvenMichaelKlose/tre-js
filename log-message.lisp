(fn make-log-stream ()
  (make-stream :fun-in   []
               :fun-out  #'((c str)
                             (logwindow-add-string (? (string? c) c (char-string c))))
               :fun-eof  [identity t]))

(var *standard-log* (make-log-stream))
(= *standard-output* (make-log-stream))
(= *standard-error* (make-log-stream))

(fn logwindow-add-string (x)
  (console.log x)
  x)

(fn log-message (x)
  (logwindow-add-string (+ x *terpri*))
  x)
