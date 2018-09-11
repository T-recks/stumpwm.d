(in-package :stumpwm)

(load "~/.emacs.d/elpa/slime-20180820.2223/swank-loader.lisp")
(swank-loader:init)

(defcommand swank-start () ()
  (if (and (boundp '*server-running*) *server-running*)
      (echo-screen "Swank server already running.")
      (progn
        (swank:create-server :port 4004)
        (message "Starting swank on localhost:4004.")
        (defparameter *server-running* t))))

(defcommand swank-stop () ()
  (if (and (boundp '*server-running*) *server-running*)
      (progn
        (message "Stopping swank on localhost:4004.")
        (swank:stop-server 4004)
        (defparameter *server-running* nil))
      (message "No server running.")))

(defcommand swank-toggle () ()
  (if *server-running*
      (stop-swank)
      (start-swank)))

(defcommand swank-restart () ()
  (stop-swank)
  (start-swank))

(defcommand swank-status () ()
  (if *server-running*
      (message "Swank is currently running on localhost:4004.")
      (message "Swank is not currently running.")))

(unless (boundp '*server-running*)
  (start-swank))
