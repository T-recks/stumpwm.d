;;; Define window placement policy...

;; Clear rules
(clear-window-placement-rules)

;; Last rule to match takes precedence!
;; TIP: if the argument to :title or :role begins with an ellipsis, a substring
;; match is performed.
;; TIP: if the :create flag is set then a missing group will be created and
;; restored from *data-dir*/create file.
;; TIP: if the :restore flag is set then group dump is restored even for an
;; existing group using *data-dir*/restore file.
;; (define-frame-preference "Emacs"
  ;; (1 t t :restore "emacs-editing-dump" :title "...xdvi")
  ;; (2 t t :create "emacs-dump" :class "Emacs"))

;; (define-frame-preference "Browse"
  ;; (2 t t :create t :class "qutebrowser")
  ;; (2 t t :create t :class "Waterfox"))

(define-frame-preference "Mail"
  (0 t t :create t :instance "Mail")
  (0 t t :create t :instance "claws-mail"))
