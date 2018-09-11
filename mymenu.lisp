(defparameter *app-menu* '(("urxvt" "urxvt")
                           ("Internet"
                            ("Firefox" "firefox")
                            ("Qutebrowser" "qutebrowser"))
                           ("Graphics"
                            ("GIMP" "gimp"))
                           ("Mathematics"
                            ("Maxima" "wxmaxima"))
                           ("Office Applications"
                            ("Emacs" "emacs")
                            ("Libre Office" "libreoffice"))
                           ("Tools"
                            ("VirtualBox" "VirtualBox"))))

(defparameter *sys-menu* '(("Toggle Heads" nil (toggle-heads))
                           ("Shutdown" "shutdown now")
                           ("Reboot" "reboot")
                           ("Kill Xorg" "pkill x")))

(defparameter *lang-menu* '(("Greek" nil (greek))
                            ("English" nil (english))
                            ("German" nil (german))))

(defparameter *bin-menu*
  (with-open-file (file "~/.stumpwm.d/bin.lisp")
    (mapcar #'pathname-name (read file))))

(defun write-bin (&optional (filename "bin.lisp"))
  "Fetch all programs in /usr/bin/ and wite them as a list to FILENAME."
  (with-open-file (file filename :direction :output :if-exists :overwrite :if-does-not-exist :create)
    (let ((programs (directory "/usr/bin/*")))
      (print programs file)
      (format nil "Wrote programs to ~a." filename))))

(defun pick (options)
  (let ((selection (stumpwm::select-from-menu (current-screen) options "")))
    (cond ((null selection)
           (throw 'stumpwm::error "Abort."))
          ((stringp selection)
           selection)
          (t (let ((shell-command (second selection)))
               (cond ((or (stringp shell-command)
                          (null shell-command))
                      selection)
                     (t (pick (rest selection)))))))))

(defun my-menu (menu)
  (let ((choice (pick menu)))
    (cond ((stringp choice)
           (run-shell-command choice))
          ((listp choice)
           (let ((shell-command (second choice))
                 (sexp (third choice)))
             (if sexp
                 (eval sexp)
                 (run-shell-command shell-command)))))))

;; function for generating an application menu
(defcommand app-menu () ()
  (my-menu *app-menu*))

(defcommand sys-menu () ()
  (my-menu *sys-menu*))

(defcommand lang-menu () ()
  (my-menu *lang-menu*))

(defcommand program-menu () ()
  (my-menu *bin-menu*))