(in-package :stumpwm-user)

(load "~/.emacs.d/elpa/slime-20200530.1629/swank-loader.lisp")

(swank-loader:init)

(defcommand swank-start () ()
  (if (and (boundp '*server-running*) *server-running*)
      (message "Swank server already running.")
      (progn
        (swank:create-server :port 4004 :dont-close t)
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
      (swank-stop)
      (swank-start)))

(defcommand swank-restart () ()
  (swank-stop)
  (swank-start))

(defcommand swank-status () ()
  (if (swank::default-connection)
      (message "Swank is currently running on localhost:4004.")
      (message "Swank is not currently running.")))

(unless (boundp '*server-running*)
  (swank-start))
