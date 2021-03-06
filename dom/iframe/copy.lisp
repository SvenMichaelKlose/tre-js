(fn copy-head-and-body (from-doc to-doc &key (remove-if t))
  (with (srchead   (from-doc.get "head")
         srcbody   (from-doc.get "body")
         desthead  (to-doc.get "head")
         destbody  (to-doc.get "body"))
    (awhen remove-if
      (? (eq t !)
         (desthead.remove-children)
         (do-children (i desthead)
           (& (funcall ! i)
              (i.remove)))))
    (@ [desthead.add _] (srchead.child-list))
    (@ [destbody.add _] (srcbody.child-list))))

(fn copy-iframe-to-document (iframe html-document &key (remove-if t))
  (let from-doc (iframe-document iframe)    ; TODO: Redux.
    (document-extend from-doc)
    (copy-head-and-body (iframe-document iframe) html-document :remove-if remove-if))
  (document-extend html-document))
