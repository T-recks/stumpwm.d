;; -*-lisp-*-
;;
(in-package :stumpwm)

;; var for loading config files
(defvar *confdir* "~/.stumpwm.d")
(defun conf-file (filename)
  (format nil "~A/~A" *confdir* filename))
(defun load-conf-file (filename)
  (load (conf-file filename)))

;; swank setup
(load-conf-file "swank-setup.lisp")

;; fonts
(require :clx-truetype)
(load-module "ttf-fonts")
(set-font (make-instance 'xft:font :family "DejaVu Sans Mono" :subfamily "Book" :size 11))

;; other modules
(load-module "globalwindows")
(load-module "battery-portable")
(load-module "cpu")
;; (load-module "mem")
;; (load-module "command-history")
(load-module "clipboard-history")
;; start the polling timer process
(clipboard-history:start-clipboard-manager)

;; config files to load
(load-conf-file "modeline.lisp")
(load-conf-file "lang.lisp")
(load-conf-file "mymenu.lisp")
;;(load-conf-file "theme.lisp")
(load-conf-file "keys.lisp")

;; change the prefix key to something else
(set-prefix-key (kbd "C-z"))

;; emacs
(defcommand emacs-connect () ()
  "Identical to emacs function except it runs emacsclient -c"
  (run-or-raise "emacsclient -c" '(:class "Emacs")))

;; activate mode-line
(enable-mode-line (current-screen) (current-head) t)

;; message settings
(setf *message-window-padding* 25)

;; toggle heads
(defcommand toggle-heads () ()
  (let ((attached-monitors (- (length (group-heads (current-group))) 1)))
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

;; Read some doc
(define-key *root-map* (kbd "d") "exec zathura")
;; Browse somewhere
(define-key *root-map* (kbd "b") "colon1 exec qutebrowser http://www.")
;; Ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec urxvt -e ssh ")
;; Lock screen
;; (define-key *root-map* (kbd "C-l") "exec xlock")

;; Web jump (works for Google and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
    (substitute #\+ #\Space search)
    (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "google" "qutebrowser http://www.google.fr/search?q=")

;; C-t M-s is a terrble binding, but you get the idea.
(define-key *root-map* (kbd "M-s") "google")

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

