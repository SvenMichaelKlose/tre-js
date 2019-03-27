(fn make-log-stream ()
  (make-stream :fun-in   []
               :fun-out  #'((c str)
                             (logwindow-add-string (? (string? c) c (char-string c))))
               :fun-eof  [identity t]))

(var *standard-log* (make-log-stream))
(= *standard-output* (make-log-stream))
(= *standard-error* (make-log-stream))

(var *logwindow* nil)

(var *terminal-css* {:margin       "0"
                     :background   "#000"
                     :color        "#0f0"
                     :white-space  "pre-wrap"
                     :font-family  "monospace"
                     :font-weight  "bold"
                     :width        "100%"})
 
(var *log-event-module* nil)

(fn open-log-window ()
  (unless *logwindow*
    (= *logwindow* (window.open "" "log" "width=1200, height=300, scrollbars=yes"))
    (let doc *logwindow*.document
      (document-extend doc)
      (= doc.title "Console")
      (doc.body.add (make-extended-element "div"))
      (doc.body.set-styles *terminal-css*)
      ,@(when *have-compiler?*
          '((let form (make-extended-element "form")
              (doc.body.add form)
              (with (txt    (make-extended-element "textarea" nil {:width  "98%"
                                                                   :height "12em"})
                     submit (make-extended-element "input" {:type  "submit"
                                                            :value "Evaluate..."}))
                (form.add txt)
                (form.add submit)
                (*event-manager*.init-document doc)
                (init-event-module *log-event-module* "log")
                (*log-event-module*.click [(_.discard)
                                           (_.send-natively nil)
                                           (with-stream-string s txt.value
                                             (@ (i (read-all s))
                                               (princ "* ")
                                               (print (eval (print i)))))]
                                          submit))))))))

(fn logwindow-add-string (x)
  (open-log-window)
  (*logwindow*.document.body.first-child.add-text x)
  (*logwindow*.scroll-to 0 document.body.scroll-height))

(fn log-message (x)
  (logwindow-add-string (+ x *terpri*))
  x)
