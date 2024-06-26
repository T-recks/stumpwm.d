;; -*-lisp-*-
;;
(defvar *stumpwm-initialized?* nil)

(use-package :stumpwm)
(in-package :stumpwm-user)

;; Config Loading
(defvar *confdir* "~/.stumpwm.d")

(defun conf-file (filename)
  (format nil "~A/~A" *confdir* filename))

(defun restarts-load (filename)
  (with-restarts-menu (load filename)))

(defun load-conf-file (filename)
  (restarts-load (conf-file filename)))

;; Prefix Key
;; Set this early in case later commands fail but stumpwm still launches,
;; Then my Ctrl-z muscle memory will not be frustrated by Ctrl-t default...
(set-prefix-key (kbd "C-z"))

;; Fonts
(set-font "-windows-dina-medium-r-normal--13-100-96-96-c-80-iso8859-1")

;; Contrib Modules
(mapc #'load-module
      '("globalwindows"
        "battery-portable"
        "cpu"
        "clipboard-history"
        "mem"
        "command-history"
        ))

;; start the polling timer process
(clipboard-history:start-clipboard-manager)

;; Config Files
(mapc #'load-conf-file
      '("utils.lisp"
        "modeline.lisp"
        "lang.lisp"
        "mymenu.lisp"
        ;; "theme.lisp"
        "keys.lisp"
        "st.lisp"
        "placement.lisp"
        "music.lisp"
        "acc.lisp"
        ))

;; Utility Files
(restarts-load "~/acc.lisp")
(restarts-load "~/Study/units.lisp")
(restarts-load "~/Code/lisp/notes.lisp")

;; Run-or-raise
;; TODO: make this concise.
(defcommand raise-qutebrowser () ()
  (run-or-raise "qutebrowser" '(:class "qutebrowser")))
(defcommand raise-firefox () ()
  (run-or-raise "firefox" '(:class "firefox")))
(defcommand raise-zathura () ()
  (run-or-raise "zathura" '(:class "Zathura")))

;; Message Padding
(setf *message-window-padding* 25)

;; Misc Commands
(defcommand toggle-heads () ()
  (let ((attached-monitors (- (length (stumpwm::group-heads (current-group))) 1)))
    (if (equal attached-monitors 1)
        (progn
          (run-shell-command "xrandr --output VGA1 --off")
          (refresh-heads)
          (run-shell-command "~/.fehbg"))
        (toggle-menu)
        )))

(defcommand toggle-heads-left () ()
  (progn
    (run-shell-command "xrandr --output VGA1 --left-of LVDS1 --auto")
    (refresh-heads)
    (run-shell-command "~/.fehbg")))

(defcommand toggle-heads-right () ()
  (progn
    (run-shell-command "xrandr --output VGA1 --right-of LVDS1 --auto")
    (refresh-heads)
    (run-shell-command "~/.fehbg")))

(defcommand colon1 (&optional (initial "")) (:rest)
  (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
    (when cmd
      (eval-command cmd t))))

(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
    (substitute #\+ #\Space search)
    (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "google" "qutebrowser http://www.google.fr/search?q=")

(defcommand now-playing () ()
  (message "~A" (run-shell-command "mpc --format \"[[%artist% - ]%title%]\"| head -1" T)))

(setf *stumpwm-initialized?* t)

;; Doing this last because it tends to be the most brittle part of this config.
;; If this last line fails but everything else succeeds, we might be lucky enough
;; to launch into a stumpwm xsession where everything else in this config is functional,
;; and can debug from there.
(load-conf-file "swank-setup.lisp")
