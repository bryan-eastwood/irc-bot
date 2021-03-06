(ql:quickload :trivial-irc)
(ql:quickload :cl-fad)
(ql:quickload :bordeaux-threads)

(defpackage :irc
  (:use :cl :trivial-irc :cl-fad :bt)
  (:export #:*client*
           #:*msg-hook*
           #:msg
           #:reload-plugins
           #:user-msg
           #:user-msg-p
           #:user
           #:call-applicable-command
           #:words
           #:parse-msg
           #:receive-message))

(in-package :irc)

(load "config.lisp")

(defclass msg ()
  ((raw :initarg :raw :accessor raw)))

(defclass user-msg (msg)
  ((user :initarg :user :accessor user)
   (words :initarg :words :accessor words)
   (text :initarg :text :accessor text)))

(defgeneric user-msg-p (msg))
(defgeneric call-applicable-command (msg))

(defvar *msg-hook* nil)
(defvar *commands* nil)
(defvar *client* (make-instance 'client
                                :log-pathname nil 
                                :nickname *nick*
                                :server *server*))

(connect *client*)
(send-join *client* *channel*)

(defun msg (msg &optional recipient)
  (send-privmsg *client* (or recipient *channel*) msg))

(defun split-seq (string seq)
  "Split a supplied string by a char sequence."
  (loop for i = 0 then (1+ j)
    as j = (position seq string :start i)
    collect (subseq string i j)
    while j))

(defun concatenate-words (words)
  (with-output-to-string (stream)
    (format stream "~{~a~^ ~}" words)))

(defmacro defcommand (name args &body body)
  `(push
    (cons ,name
      (lambda ,args
        ,@body)) *commands*))

(defun reload-plugins ()
  (mapcar #'load (list-directory "plugins/")))

(reload-plugins)

(defmethod user-msg-p ((msg msg))
  (eq (class-of msg) (class-of #.(make-instance 'user-msg))))

(defun parse-msg (text)
  (let ((split (split-seq text #\space)))
    (if (string= (cadr split) "PRIVMSG")
        (make-instance 'user-msg
          :raw text
          :user (subseq text 1 (position #\! text))
          :words (cons (subseq (cadddr split) 1) (cddddr split)))
        (make-instance 'msg
          :raw text))))

(defmethod call-applicable-command ((msg msg))
  (loop for command in *commands*
        when (string= (car command) (car (words msg))) return (make-thread (lambda () (funcall (cdr command) msg)))))
