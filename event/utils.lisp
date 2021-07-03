(fn fire-event (elm typ)
  (!= (document.create-event "HTMLEvents")
    (!.init-event typ t t)
    (= !.event-name typ)
    (elm.dispatch-event !)))

(var *last-hovered* nil)
(((document-extend document).get "html").mouseover [= *last-hovered* _.target])

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

(var *last-click-shift-down?* nil)
(var *shift-down?* nil)

(fn event-shift-down? e)
(fn event-ctrl-down? e)
(fn event-alt-down? e)

(fn event-left-button? e
  (== e.button 1))

(var *pointer-x* 0)
(var *pointer-y* 0)

(((document-extend document).get "html").mousemove
  [(= *pointer-x* _.page-x
      *pointer-y* _.page-y)])
