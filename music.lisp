(defcommand print-random-note () ()
  (with-timeout 8
    (message "~a" (random-elt *notes*))))
