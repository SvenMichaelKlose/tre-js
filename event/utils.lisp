(document-extend)

(fn fire-event (elm typ)
  (!= (document.create-event "HTMLEvents")
    (!.init-event typ t t)
    (= !.event-name typ)
    (elm.dispatch-event !)))

(fn fire-mousemove-event ()
  (!? *last-hovered*
    (fire-event ! "mousemove")))

(fn fire-document-modified-event (elm)  ; TODO: What's "elm" for?
  (fire-event elm "document-modified"))

(fn fire-text-modified-event (elm)
  (fire-event elm "text-modified"))

(fn force-mousemove-event ()
  (do-wait 1
    (fire-mousemove-event)))

(fn event-left-button? e
  (== e.button 1))

(fn event-right-button? e
  (!= e.button 1))

(var *key-stats* (make-array))
(var *last-click-shift-down?* nil)
(var *shift-down?* nil)
(var *ctrl-down?* nil)
(var *alt-down?* nil)

(fn get-key-stat (code)
  (unless (undefined? (aref *key-stats* code))
    (aref *key-stats* code)))

(fn update-keystat (evt)
  (= (aref *key-stats* evt.key-code) (eql evt.type "keydown"))
  (= *shift-down?* (get-key-stat 16)
     *ctrl-down?*  (get-key-stat 17)
     *alt-down?*   (get-key-stat 18)))

(document.keyup update-keystat)
(document.keydown update-keystat)

(var *pointer-x* 0)
(var *pointer-y* 0)

(document.mousemove [(= *pointer-x* _.page-x
                        *pointer-y* _.page-y)])

(document.click [(log-message "trclick")(= *last-click-shift-down?* (log-message *shift-down?*)]))

(var *last-hovered* nil)
(document.mouseover [= *last-hovered* _.target])
