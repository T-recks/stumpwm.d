(defvar *current-lang* "us")

(defun setxkbmap (lang)
  (run-shell-command (format nil "setxkbmap ~A" lang)))

(defcommand xmodmap () ()
  (run-shell-command "xmodmap ~/.Xmodmap"))

(defcommand english () ()
  (setxkbmap "us")
  (xmodmap)
  (setf *current-lang* "us"))
(defcommand greek () ()
  (setxkbmap "gr")
  (setf *current-lang* "gr"))
(defcommand german () ()
  (setxkbmap "de")
  (setf *current-lang* "de"))
