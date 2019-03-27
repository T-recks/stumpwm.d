(defvar *current-lang* "us")

(defun setxkbmap (lang)
  (run-shell-command (format nil "setxkbmap ~A" lang)))

(defcommand xmodmap () ()
  (run-shell-command "xmodmap ~/.Xmodmap"))

(defmacro def-lang-kbmap ((name kbmap) &body forms)
  `(defcommand ,name () ()
     (setxkbmap ,kbmap)
     ,@forms
     (setf *current-lang* ,kbmap)))

(def-lang-kbmap (english "us")
  (xmodmap))

(def-lang-kbmap (greek "gr"))

(def-lang-kbmap (german "de"))
