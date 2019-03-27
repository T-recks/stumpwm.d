;; -*-lisp-*-
;;
(use-package :stumpwm)
(in-package :stumpwm-user)

;; Config Loading
(defvar *confdir* "~/.stumpwm.d")

(defun conf-file (filename)
  (format nil "~A/~A" *confdir* filename))

(defun load-conf-file (filename)
  (load (conf-file filename)))

;; Swank Setup
(defcommand load-swank () ()
  (load-conf-file "swank-setup.lisp"))
(load-swank)

;; Fonts
(set-font "-windows-dina-medium-r-normal--13-100-96-96-c-80-iso8859-1")

;; Contribe Modules
(mapc #'load-module
      '("globalwindows"
        "battery-portable"
        "cpu"
        "clipboard-history"
        ;; "mem"
        ;; "command-history"
        ))

;; start the polling timer process
(clipboard-history:start-clipboard-manager)

;; Config Files
(mapc #'load-conf-file
      '("modeline.lisp"
        "lang.lisp"
        "mymenu.lisp"
        ;; "theme.lisp"
        "keys.lisp"
        "st.lisp"
        "placement.lisp"
        ))

;; Utility Files
(load "~/acc.lisp")
(load "~/Study/units.lisp")

;; Prefix Key
(set-prefix-key (kbd "C-z"))

;; Run-or-raise
;; TODO: make this concise.
(defcommand emacs-connect () ()
  "Identical to emacs function except it runs emacsclient -c"
  (run-or-raise "emacsclient -c" '(:class "Emacs")))
(defcommand raise-qutebrowser () ()
  (run-or-raise "qutebrowser" '(:class "qutebrowser")))
(defcommand raise-firefox () ()
  (run-or-raise "firefox" '(:class "Firefox")))
(defcommand raise-zathura () ()
  (run-or-raise "zathura" '(:class "Zathura")))
(defcommand raise-tor () ()
  (run-or-raise "tor-browser" '(:class "Tor Browser")))
(defcommand raise-calc () ()
  (run-or-raise "libreoffice" '(:class "libreoffice-calc")))

;; Message Padding
(setf *message-window-padding* 25)

;; Misc Commands
(defcommand toggle-heads () ()
  (let ((attached-monitors (- (length (stumpwm::group-heads (current-group))) 1)))
    (if (equal attached-monitors 1)
        (progn
          (run-shell-command "xrandr --output VGA1 --off")
          (refresh-heads))
        (progn
          (run-shell-command "xrandr --output VGA1 --left-of LVDS1 --auto")
          (refresh-heads)))))

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

