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

(def-lang-kbmap (german "de")
  (xmodmap)
  ;; the following functions swap C-z and C-y functionality
  ;; for the sake of my muscle memory...
  (set-prefix-key (kbd "C-y"))
  (undefine-key *root-map* (kbd "C-y"))
  (define-key *root-map* (kbd "C-z") "show-clipboard-history"))

(def-lang-kbmap (english "us")
  (xmodmap)
  ;; ... and these reverse the swap
  (undefine-key *root-map* (kbd "C-z"))
  (define-key *root-map* (kbd "C-y") "show-clipboard-history")
  (set-prefix-key (kbd "C-z")))

(def-lang-kbmap (greek "gr"))
