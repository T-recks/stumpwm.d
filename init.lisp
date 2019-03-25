;; -*-lisp-*-
;;
(use-package :stumpwm)
(in-package :stumpwm-user)

;; var for loading config files
(defvar *confdir* "~/.stumpwm.d")
(defun conf-file (filename)
  (format nil "~A/~A" *confdir* filename))
(defun load-conf-file (filename)
  (load (conf-file filename)))

;; swank setup
(defcommand load-swank () ()
  (load-conf-file "swank-setup.lisp"))
(load-swank)

;; fonts
(set-font '("-windows-dina-medium-r-normal--13-100-96-96-c-80-iso8859-1" "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso10646-1"))

;; other modules
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

;; config files to load
(mapc #'load-conf-file
      '("modeline.lisp"
        "lang.lisp"
        "mymenu.lisp"
        ;; "theme.lisp"
        "keys.lisp"
        "st.lisp"))

;; other files
(load "~/acc.lisp")
(load "~/Study/units.lisp")

;; change the prefix key to something else
(set-prefix-key (kbd "C-z"))

;; run-or-raise
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

;; activate mode-line
(enable-mode-line (current-screen) (current-head) t)

;; message settings
(setf *message-window-padding* 25)

;; toggle heads
(defcommand toggle-heads () ()
  (let ((attached-monitors (- (length (stumpwm::group-heads (current-group))) 1)))
    (if (equal attached-monitors 1)
        (progn
          (run-shell-command "xrandr --output VGA1 --off")
          (refresh-heads))
        (progn
          (run-shell-command "xrandr --output VGA1 --left-of LVDS1 --auto")
          (refresh-heads)))))

;; prompt the user for an interactive command. The first arg is an
;; optional initial contents.
(defcommand colon1 (&optional (initial "")) (:rest)
  (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
    (when cmd
      (eval-command cmd t))))

;; Web jump (works for Google and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
    (substitute #\+ #\Space search)
    (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "google" "qutebrowser http://www.google.fr/search?q=")

;; C-t M-s is a terrble binding, but you get the idea.
;; (define-key *root-map* (kbd "M-s") "google")

;;; Define window placement policy...

;; Clear rules
(clear-window-placement-rules)

;; Last rule to match takes precedence!
;; TIP: if the argument to :title or :role begins with an ellipsis, a substring
;; match is performed.
;; TIP: if the :create flag is set then a missing group will be created and
;; restored from *data-dir*/create file.
;; TIP: if the :restore flag is set then group dump is restored even for an
;; existing group using *data-dir*/restore file.
(define-frame-preference "Default"
  ;; frame raise lock (lock AND raise == jumpto)
  (0 t nil :class "Konqueror" :role "...konqueror-mainwindow")
  (1 t nil :class "XTerm"))

(define-frame-preference "Ardour"
  (0 t   t   :instance "ardour_editor" :type :normal)
  (0 t   t   :title "Ardour - Session Control")
  (0 nil nil :class "XTerm")
  (1 t   nil :type :normal)
  (1 t   t   :instance "ardour_mixer")
  (2 t   t   :instance "jvmetro")
  (1 t   t   :instance "qjackctl")
  (3 t   t   :instance "qjackctl" :role "qjackctlMainForm"))

(define-frame-preference "Shareland"
  (0 t   nil :class "XTerm")
  (1 nil t   :class "aMule"))

;; (define-frame-preference "Emacs"
  ;; (1 t t :restore "emacs-editing-dump" :title "...xdvi")
  ;; (2 t t :create "emacs-dump" :class "Emacs"))

;; (define-frame-preference "Browse"
  ;; (2 t t :create t :class "qutebrowser")
  ;; (2 t t :create t :class "Waterfox"))

(define-frame-preference "Mail"
  (0 t t :create t :instance "Mail")
  (0 t t :create t :instance "claws-mail"))

(defcommand now-playing () ()
  (message "~A" (run-shell-command "mpc --format \"[[%artist% - ]%title%]\"| head -1" T)))

