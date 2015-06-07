(load "irc.lisp")

(defpackage :bot
  (:use :cl :irc))

(in-package :bot)

(defun read-message-loop ()
  (loop for msg = (parse-msg (receive-message *client*)) do
    (loop for function in *msg-hook* do
      (funcall function msg))
    (if (user-msg-p msg)
        (call-applicable-command msg))))

(read-message-loop)
