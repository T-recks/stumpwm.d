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

(defmacro defmenu ((command var) &body menu-entries)
  `(progn
     (defparameter ,var ',@menu-entries)
     (defcommand ,command () ()
       (my-menu ,var))))

(defmenu (app-menu *app-menu*)
  (("urxvt" "urxvt")
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

(defmenu (toggle-menu *toggle-menu*)
  (("left" nil (toggle-heads-left))
   ("right" nil (toggle-heads-right))))

(defmenu (sys-menu *sys-menu*)
  (("Toggle Heads" nil (toggle-heads))
   ("Shutdown" "shutdown now")
   ("Reboot" "reboot")
   ("Restart" "reboot")
   ("Kill Xorg" "pkill x")))

(defmenu (lang-menu *lang-menu*)
  (("German" nil (german))
   ("Greek" nil (greek))
   ("English" nil (english))))
