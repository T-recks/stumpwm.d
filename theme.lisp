(in-package :stumpwm)

(defun xorg-color-path (file)
  (concatenate 'string "~/.config/xorg/Xresources/colors/" file))
    
(defun xresource-location (theme)
  (flet ((themep (x) (equal x theme))
         (theme-in (ls) (member theme ls)))
    (cond ((themep 'solarized-light) (xorg-color-path "solarized/Xresources.light"))
          ((themep 'solarized-dark) (xorg-color-path "solarized/Xresources.dark"))
          ((themep 'challenger-deep) (xorg-color-path "challenger-deep.Xresources"))
          ((theme-in '(gruvbox-light-hard
                       gruvbox-light-medium
                       gruvbox-light-soft))
           (xorg-color-path "gruvbox/gruvbox-light.xresources"))
          ((theme-in '(gruvbox-dark-hard
                       gruvbox-dark-medium
                       gruvbox-dark-soft))
           (xorg-color-path "gruvbox/gruvbox-dark.xresources")))))

(defcommand load-theme (theme) ()
  (let ((command-one (format nil "xrdb -merge ~A" (xresource-location theme)))
        (command-two (format nil "emacsclient -e \"(load-theme (intern ~A))\"" theme)))
    (progn
      (run-shell-command command-one)
      (run-shell-command command-two)
      theme)))
