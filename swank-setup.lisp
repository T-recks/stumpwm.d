(in-package :stumpwm)

(load "~/.emacs.d/elpa/slime-20180820.2223/swank-loader.lisp")
(swank-loader:init)

(defun echo-screen (str)
  (echo-string (current-screen) str))

(defcommand start-swank () ()
  (if (and (boundp '*server-running*) *server-running*)
      (echo-screen "Swank server already running.")
      (progn
        (swank:create-server :port 4004)
        (echo-screen "Starting swank on localhost:4004.")
        (defparameter *server-running* t))))

(defcommand stop-swank () ()
  (if (and (boundp '*server-running*) *server-running*)
      (progn
        (echo-screen "Stopping swank on localhost:4004.")
        (swank:stop-server 4004)
        (defparameter *server-running* nil))
      (echo-screen "No server running.")))

(defcommand toggle-swank () ()
  (if *server-running*
      (stop-swank)
      (start-swank)))

(defcommand restart-swank () ()
  (stop-swank)
  (start-swank))

(defcommand status-swank () ()
  (if *server-running*
      (echo-screen "Swank is currently running on localhost:4004.")
      (echo-screen "Swank is not currently running.")))

(unless (boundp '*server-running*)
  (start-swank))
