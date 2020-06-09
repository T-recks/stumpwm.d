(defclass window-specification ()
  ((name :initarg :name :accessor name :initform (error ":name missing"))
   (window-class :initarg :class :accessor window-class :initform nil)
   (window-instance :initarg :instance :accessor window-instance :initform nil)
   (window-type :initarg :type :accessor window-type)
   (window-role :initarg :role :accessor window-role)
   (window-title :initarg :title :accessor window-title)
   (command :initarg :command :accessor command :initform nil))
  (:documentation "Specifies the properties of some prototypical window, along with a command that produces a window meeting the specification. Can be used match windows to properties for the purpose of locating or generating windows."))

(defmethod initialize-instance :after ((x window-specification) &key)
  (with-slots ((name name)
               (class window-class)
               (command command)
               (instance window-instance))
      x
    (set-unless class name)
    (set-unless command (concat "exec " name))
    (set-unless instance name)))

(defun register-window-specification (tag name &optional (properties nil) (hashtable *window-specifications*))
  "Register the properties of some window to a global hashtable of window specifications."
  (setf (gethash tag hashtable)
        (make-instance 'window-specification
                       :name name
                       :class (getf properties :class)
                       :command (getf properties :command)
                       :title (getf properties :title))))

(defparameter *window-specifications* (make-hash-table :test 'eq)
  "Specifies what the observed properties of some windows are.")

(defun def-quick-access-keys (key-tag-pairs)
  (dolist (pair key-tag-pairs)
    (let ((key (first pair))
          (tag-name (second pair)))
      (def-keys *root-map*
        ((concat "C-" key)
         (concat "ror " tag-name))
        ((concat "C-" (string-upcase key))
         (concat "rop " tag-name)))
      (define-key *launch-map* (kbd key) (concat "exec-window " tag-name)))))

(defmacro with-window-spec ((tag-name window-spec-binding) &body body)
  (let ((window-spec (gensym "window-spec")))
    `(let* ((,window-spec (gethash (intern (string-upcase ,tag-name)) *window-specifications*))
            (,window-spec-binding ,window-spec))
       (if ,window-spec-binding
           ,@body
           (error "No window specification found for ~S" ,tag-name)))))

(defcommand ror (tag-name) (:string)
  (with-window-spec (tag-name window-spec)
    (run-or-raise (command window-spec) (list :class (window-class window-spec)
                                              :title (window-title window-spec)))))

(defcommand rop (tag-name) (:string)
  (with-window-spec (tag-name window-spec)
    (run-or-pull (command window-spec) (list :class (window-class window-spec)
                                             :title (window-title window-spec)))))

(defcommand exec-window (tag-name) (:string)
  (with-window-spec (tag-name window-spec)
    (run-shell-command (command window-spec))))
