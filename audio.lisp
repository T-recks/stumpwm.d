(defun def-volcontrol (channel amount)
  "Commands for controling the volume"
  (define-stumpwm-command
	(concat "amixer-" channel "-" (or amount "toggle")) ()
	(echo-string
	 (current-screen)
	 (concat channel " " (or amount "toggled") "
    "
			 (run-shell-command
			  (concat "amixer sset " channel " " (or amount "toggle") "| grep '^[ ]*Front'") t)))))

(defvar amixer-channels '("PCM" "Master" "Headphone"))
(defvar amixer-options '(nil "1+" "1-"))

(let ((channels amixer-channels))
  (loop while channels do
		(let ((options amixer-options))
		  (loop while options do
				(def-volcontrol (car channels) (car options))
				(setq options (cdr options))))
		(setq channels (cdr channels))))

(define-stumpwm-command "amixer-sense-toggle" ()
  (echo-string
   (current-screen)
   (concat "Headphone Jack Sense toggled
    "
		   (run-shell-command "amixer sset 'Headphone Jack Sense' toggle" t))))

(define-key *top-map* (kbd "XF86AudioLowerVolume")   "amixer-PCM-1-")
(define-key *top-map* (kbd "XF86AudioRaiseVolume")   "amixer-PCM-1+")
(define-key *top-map* (kbd "XF86AudioMute")          "amixer-PCM-toggle")

(define-key *top-map* (kbd "C-XF86AudioLowerVolume") "amixer-Master-1-")
(define-key *top-map* (kbd "C-XF86AudioRaiseVolume") "amixer-Master-1+")
(define-key *top-map* (kbd "C-XF86AudioMute")        "amixer-Master-toggle")

(define-key *top-map* (kbd "M-XF86AudioLowerVolume") "amixer-Headphone-1-")
(define-key *top-map* (kbd "M-XF86AudioRaiseVolume") "amixer-Headphone-1+")
(define-key *top-map* (kbd "M-XF86AudioMute")        "amixer-Headphone-toggle")


