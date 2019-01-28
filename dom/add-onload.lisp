(fn add-onload (fun)
  (alet window.onload
    (= window.onload [(& ! (funcall !))
                      (funcall fun)])))
