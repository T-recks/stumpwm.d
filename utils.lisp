(defmacro with-timeout (time &body form)
  `(let ((*timeout-wait* ,time))
     ,@form))

(defmacro eval-during-startup (&body form)
  "Only evaluate FORM if stumpwm has yet to complete initialization (i.e. loading init.lisp at startup). Use this macro when you want a form with a side-effect to be evaluated once during wm startup but not when config files are recompiled during runtime."
  (unless *stumpwm-initialized?* (first form)))

(defmacro set-unless (place value)
  `(unless ,place
     (setf ,place ,value)))
