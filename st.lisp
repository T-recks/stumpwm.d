(defcommand cuis-start () ()
  (let ((squeak-vm "~/Builds/cuis/cogspur/squeak")
        (cuis-img "~/Builds/cuis/Cuis-Smalltalk-Dev/Cuis5.0-3564.image"))
   (run-shell-command (format nil "~A ~A" squeak-vm cuis-img))))
