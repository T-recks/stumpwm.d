(in-package :stumpwm)

;; toggle languages
(define-key *top-map* (kbd "F12") "lang-menu")
(define-key *top-map* (kbd "F11") "english")

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
(define-key *root-map* (kbd "C-e") "emacs-connect")
(define-key *root-map* (kbd "e") "exec emacsclient -c")

;; dmenu
(define-key *root-map* (kbd "space") "exec dmenu_run")
;; clipboard
(define-key *root-map* (kbd "C-y") "show-clipboard-history")

;; swapping defaults
(undefine-key *root-map* (kbd "s"))
(undefine-key *root-map* (kbd "S"))
(define-key *root-map* (kbd "s") "hsplit")
(define-key *root-map* (kbd "S") "vsplit")
(undefine-key *root-map* (kbd "'"))
(undefine-key *root-map* (kbd "\""))
(define-key *root-map* (kbd "'") "windowlist-by-class")
(define-key *root-map* (kbd "\"") "global-windowlist")
(define-key *groups-map* (kbd "'") "grouplist")
(define-key *groups-map* (kbd "\"") "gselect")
;; (undefine-key *root-map* (kbd "r"))
;; (undefine-key *root-map* (kbd "R"))
(define-key *root-map* (kbd "r") "remove")
(define-key *root-map* (kbd "R") "iresize")

;; duplicating defaults
(define-key *root-map* (kbd "q") "only")

;; Vim bindings for frame movement
;; note that all of these except C-j replace default bindings,
;; but the functions they execute have other default bindings too
(undefine-key *root-map* (kbd "C-l"))
(undefine-key *root-map* (kbd "C-h"))
(undefine-key *root-map* (kbd "C-k"))
(define-key *root-map* (kbd "C-h") "move-focus left")
(define-key *root-map* (kbd "C-j") "move-focus down")
(define-key *root-map* (kbd "C-k") "move-focus up")
(define-key *root-map* (kbd "C-l") "move-focus right")
;; more frame movement
(define-key *root-map* (kbd "(") "exchange-direction left")
(define-key *root-map* (kbd ")") "exchange-direction right")

;; misc window management
(define-key *root-map* (kbd "P") "pull-from-windowlist")

;; some control commands
(define-key *top-map* (kbd "XF86ScreenSaver") "run-shell-command bash ~/.config/i3/scripts/lock/lock.sh")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "run-shell-command xbacklight -dec 5")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "run-shell-command xbacklight -inc 5")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "run-shell-command amixer -q sset Master,0 1- unmute")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "run-shell-command amixer -q sset Master,0 1+ unmute")
(define-key *top-map* (kbd "XF86AudioMute") "run-shell-command amixer -q sset Master,0 toggle")
(define-key *top-map* (kbd "XF86AudioPlay") "run-shell-command mpc toggle")
(define-key *top-map* (kbd "XF86AudioNext") "run-shell-command mpc next")
(define-key *top-map* (kbd "XF86AudioPrev") "run-shell-command mpc prev")
(define-key *top-map* (kbd "XF86AudioStop") "run-shell-command mpc stop")

;; launch mode
(defvar *launch-map* nil)
(setf *launch-map*
  (let ((c (make-sparse-keymap)))
    (define-key c (kbd "b") "exec qutebrowser")
    (define-key c (kbd "f") "exec firefox")
    (define-key c (kbd "F") "exec firefox --private-window")
    ;; (define-key c (kbd "e") "exec emacsclient -ca \"\"")
    (define-key c (kbd "m") "exec-terminal ncmpcpp")
	(define-key c (kbd "M") "exec thunderbird")
	(define-key c (kbd "n") "exec-terminal newsboat")
	(define-key c (kbd "N") "exec-terminal neofetch")
    (define-key c (kbd "i") "exec-terminal htop")
    (define-key c (kbd "r") "exec-terminal ranger")
    ;; (define-key c (kbd "m") "exec emacsclient -c -e '(unread-mail)'")
    ;; (define-key c (kbd "r") "exec redshift")
    ;; (define-key c (kbd "R") "exec killall redshift")
	(define-key c (kbd "x") "app-menu")
    (define-key c (kbd "s") "sys-menu")
    c))

(define-key *root-map* (kbd "x") '*launch-map*)
