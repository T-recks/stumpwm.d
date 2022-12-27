(in-package :stumpwm-user)

;; TODO: organize and clean

(defmacro def-keys (keymap &body key-pairs)
  "KEY-PAIRS are of the form (string symbol) where STRING contains the key combination and SYMBOL is the function to call."
  (let ((definitions
          (mapcar (lambda (x) (list 'define-key keymap (list 'kbd (first x)) (second x)))
                  key-pairs)))
    `(progn ,@definitions)))

;; Browse somewhere
;; (define-key *root-map* (kbd "b") "colon1 exec qutebrowser http://www.")
;; Ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec urxvt -e ssh ")

;;;;;;;;;;;;;;;
;; key-modes ;;
;;;;;;;;;;;;;;;
(defcommand music-mode () ()
  (define-key *top-map* (kbd "F12") "print-random-note")
  (undefine-key *top-map* (kbd "F11")))

(defcommand language-mode () ()
  ;; toggle languages
  (def-keys *top-map*
    ("F12" "lang-menu")
    ("F11" "english")))
;; end key-modes

(eval-during-startup (language-mode))

;; terminal setup var and function setup for use in this config file
(defvar *terminal* "urxvt")
(defcommand exec-terminal (cmd) (:string)
  (run-commands (format nil "exec ~A -e ~A" *terminal* cmd)))
;; terminal binding
(define-key *root-map* (kbd "RET") "emacs -e \"(ansi-term my-term-shell)\"")
;; remove unused bindings
(define-key *root-map* (kbd "c") nil)
(undefine-key *root-map* (kbd "C-c"))

;; emacs
;; (undefine-key *root-map* (kbd "C-e"))
;; (undefine-key *root-map* (kbd "e"))
;; (define-key *root-map* (kbd "C-e") "emacs-connect")
;; (define-key *root-map* (kbd "e") "exec emacsclient -c")
;; (def-keys *root-map*
;;   ("C-e" "emacs-connect")
;;   ("e" "exec emacsclient -c"))

;; banish
(define-key *root-map* (kbd "b") "banish")

;;;;;;;;;;;;;;;;;;;;;
;; Window Creation ;;
;;;;;;;;;;;;;;;;;;;;;
(load-conf-file "windows.lisp")

(defparameter *window-specifications-list*
  '((emacs "emacs" (:class "Emacs"))
    (firefox "firefox" (:class "firefox"))
    (qutebrowser "qutebrowser" (:class "qutebrowser"))
    (zathura "zathura" (:class "Zathura"))
    (tor "tor" (:class "Tor Browser" :command "tor-browser"))
    (libreoffice "libreoffice" (:instance "libreoffice"))
    (htop "htop" (:class "URxvt" :title "htop" :command "exec-terminal htop"))))

(mapc (lambda (spec) (apply #'register-window-specification spec))
      *window-specifications-list*)

;; launch mode
(defparameter *launch-map* 
  (let ((k (make-sparse-keymap)))
    (def-keys k
      ("F" "exec firefox --private-window")
      ("m" "exec-terminal ncmpcpp")
      ("M" "exec thunderbird")
      ("n" "exec-terminal newsboat")
      ("N" "exec-terminal neofetch")
      ("i" "exec-terminal htop")
      ("r" "exec-terminal ranger")
      ;; ("m" "exec emacsclient -c -e '(unread-mail)'")
      ;; ("r" "exec redshift")
      ;; ("R" "exec killall redshift")
      ("x" "app-menu")
      ("s" "sys-menu"))
    k))

(def-quick-access-keys 
  '(("e" "emacs")
    ("f" "firefox")
    ("d" "zathura")
    ("b" "qutebrowser")
    ("t" "tor")
    ("o" "libreoffice")))

(define-key *root-map* (kbd "x") '*launch-map*)

;; swapping defaults
(undefine-key *root-map* (kbd "s"))
(undefine-key *root-map* (kbd "S"))
(undefine-key *root-map* (kbd "'"))
(undefine-key *root-map* (kbd "\""))
(def-keys *root-map*
  ("s" "hsplit")
  ("S" "vsplit")
  ("'" "windowlist-by-class")
  ("\"" "global-windowlist")
  ("r" "remove")
  ("R" "iresize"))
;; END Window Manipulation

;;;;;;;;;;;;;;;;;;;;;;;
;; Window Navigation ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; duplicating defaults
(define-key *root-map* (kbd "q") "only")

;; Vim bindings for frame movement
;; note that all of these except C-j replace default bindings,
;; but the functions they execute have other default bindings too
(undefine-key *root-map* (kbd "C-l"))
(undefine-key *root-map* (kbd "C-h"))
(undefine-key *root-map* (kbd "C-k"))
(def-keys *root-map*
  ;; vim navigation
  ("C-h" "move-focus left")
  ("C-j" "move-focus down")
  ("C-k" "move-focus up")
  ("C-l" "move-focus right")
  ;; more frame movement
  ("(" "exchange-direction left")
  (")" "exchange-direction right")
  ;; misc window management
  ("P" "pull-from-windowlist"))
;; END Window Navigation

;; bin menu
(define-key *root-map* (kbd "space") "run-shell-command")
;; clipboard
(define-key *root-map* (kbd "C-y") "show-clipboard-history")

;; some control commands
(def-keys *top-map*
  ("XF86ScreenSaver" "run-shell-command bash ~/.config/i3/scripts/lock/lock.sh")
  ("XF86MonBrightnessDown" "run-shell-command xbacklight -dec 5")
  ("XF86MonBrightnessUp" "run-shell-command xbacklight -inc 5")
  ("XF86AudioLowerVolume" "run-shell-command pactl set-sink-volume 0 -5%")
  ("XF86AudioRaiseVolume" "run-shell-command pactl set-sink-volume 0 +5%")
  ("XF86AudioMute" "run-shell-command amixer -q sset Master,0 toggle")
  ("XF86AudioPlay" "run-shell-command mpc toggle")
  ("XF86AudioNext" "run-shell-command mpc next")
  ("XF86AudioPrev" "run-shell-command mpc prev")
  ("XF86AudioStop" "run-shell-command mpc stop"))

