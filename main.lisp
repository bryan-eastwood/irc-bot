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

(if (= 0 (sb-posix:fork))
    (progn
      (sb-posix:setsid)
      (read-message-loop)
      (when (/= 0 (sb-posix:fork))
        (sb-ext:exit)))
    (sb-ext:exit))
