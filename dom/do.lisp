(defmacro do-children ((iter parent &optional (result nil)) &body body)
  `(@ (,iter (array-list (slot-value ,parent 'child-nodes)) ,result)
     ,@body))
