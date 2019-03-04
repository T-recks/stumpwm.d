(in-package :stumpwm-user)

(defmacro def-keys (map &body key-pairs)
  (let ((definitions
          (mapcar (lambda (x) (list 'define-key map (list 'kbd (first x)) (second x)))
                  key-pairs)))
    `(progn ,@definitions)))

;; Read some doc
(define-key *root-map* (kbd "d") "exec zathura")
;; Browse somewhere
;; (define-key *root-map* (kbd "b") "colon1 exec qutebrowser http://www.")
;; Ssh somewhere
(define-key *root-map* (kbd "C-s") "colon1 exec urxvt -e ssh ")
;; Lock screen
;; (define-key *root-map* (kbd "C-l") "exec xlock")

;; toggle languages
(def-keys *top-map*
  ("F12" "lang-menu")
  ("F11" "english"))

;; terminal setup var and functio setup for use in this config file
(defvar *terminal* "urxvt")
(defcommand exec-terminal (cmd) (:string)
  (run-commands (format nil "exec ~A -e ~A" *terminal* cmd)))
;; terminal binding
(define-key *root-map* (kbd "RET") "exec emacsclient -c -e \"(ansi-term my-term-shell)\"")
;; remove unused bindings
(define-key *root-map* (kbd "c") nil)
(undefine-key *root-map* (kbd "C-c"))

;; emacs
(undefine-key *root-map* (kbd "C-e"))
(undefine-key *root-map* (kbd "e"))
;; (define-key *root-map* (kbd "C-e") "emacs-connect")
;; (define-key *root-map* (kbd "e") "exec emacsclient -c")
(def-keys *root-map*
  ("C-e" "emacs-connect")
  ("e" "exec emacsclient -c"))

;; banish
(define-key *root-map* (kbd "b") "banish")

;; raise
(def-keys *root-map*
  ("C-b" "raise-qutebrowser")
  ("C-f" "raise-firefox")
  ("C-d" "raise-zathura")
  ("C-t" "raise-tor")
  ("C-x" "raise-calc"))

;; dmenu
(define-key *root-map* (kbd "space") "exec dmenu_run")
;; clipboard
(define-key *root-map* (kbd "C-y") "show-clipboard-history")

;; swapping defaults
(undefine-key *root-map* (kbd "s"))
(undefine-key *root-map* (kbd "S"))
(undefine-key *root-map* (kbd "'"))
(undefine-key *root-map* (kbd "\""))
;; (undefine-key *root-map* (kbd "r"))
;; (undefine-key *root-map* (kbd "R"))
(def-keys *root-map*
  ("s" "hsplit")
  ("S" "vsplit")
  ("'" "windowlist-by-class")
  ("\"" "global-windowlist")
  ("'" "grouplist")
  ("\"" "gselect")
  ("r" "remove")
  ("R" "iresize"))

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

;; some control commands
(def-keys *top-map*
  ("XF86ScreenSaver" "run-shell-command bash ~/.config/i3/scripts/lock/lock.sh")
  ("XF86MonBrightnessDown" "run-shell-command xbacklight -dec 5")
  ("XF86MonBrightnessUp" "run-shell-command xbacklight -inc 5")
  ("XF86AudioLowerVolume" "run-shell-command amixer -q sset Master,0 1- unmute")
  ("XF86AudioRaiseVolume" "run-shell-command amixer -q sset Master,0 1+ unmute")
  ("XF86AudioMute" "run-shell-command amixer -q sset Master,0 toggle")
  ("XF86AudioPlay" "run-shell-command mpc toggle")
  ("XF86AudioNext" "run-shell-command mpc next")
  ("XF86AudioPrev" "run-shell-command mpc prev")
  ("XF86AudioStop" "run-shell-command mpc stop"))

;; launch mode
(defvar *launch-map* nil)
(setf *launch-map*
      (let ((k (make-sparse-keymap)))
        (def-keys k
          ("b" "exec qutebrowser")
          ("d" "exec zathura")
          ("f" "exec firefox")
          ("F" "exec firefox --private-window")
          ;; ("e" "exec emacsclient -ca \"\"")
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

(define-key *root-map* (kbd "x") '*launch-map*)
