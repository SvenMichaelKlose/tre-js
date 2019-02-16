; TODO: Why is this wrapping to NATIVE-*?

(fn tre-add-event-listener (typ fun elm)
  (native-add-event-listener elm typ fun))

(fn tre-remove-event-listener (typ fun elm)
  (native-remove-event-listener elm typ fun))

(fn tre-stop-event (evt)
  (native-stop-event evt))
