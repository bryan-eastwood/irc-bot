(defcommand ":about" (msg)
  (declare (ignore msg))
  (msg "I am a small irc bot written in Common Lisp."))

(defcommand ":source" (msg)
  (declare (ignore msg))
  (msg "https://github.com/bryan-eastwood/irc-bot/"))
