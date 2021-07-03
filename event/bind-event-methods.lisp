(defmacro bind-event-methods (event-module &rest event-types)
  `(progn
     ,@(@ [`((car this._elements).add-event-listener ,(downcase (symbol-name _))
                                                     (bind (slot-value this ',($ '_ _))))]
          event-types)))

(defmacro bind-event-methods-element (elm &rest event-types)
  `(progn
     ,@(@ [`((slot-value ,elm 'add-event-listener) ,(downcase (symbol-name _))
                                                   (= (slot-value this ',($ '_ _)) (bind (slot-value this ',($ '_ _))))
                                                   ,elm)]
          event-types)))

(defmacro unbind-event-methods (elm &rest event-types)
  `(progn
     ,@(@ [`((slot-value ,elm 'remove-event-listener) ,(downcase (symbol-name _))
                                                      (slot-value this ',($ '_ _))
                                                      ,elm)]
          event-types)))
