(defvar *mail* (make-hash-table :test #'equal))

(if *watchlist*
  (push
    (lambda (msg)
      (when (and (user-msg-p msg) (gethash (user msg) *mail*))
        (loop for mail in (gethash (user msg) *mail*) do
          (msg mail (user msg)))
        (remhash (user msg) *mail*)))
    *msg-hook*))

(defun concatenate-words (words)
  (with-output-to-string (stream)
    (format stream "~{~a~^ ~}" words)))

(defcommand ":mail" (msg)
  (push (concatenate-words (cddr (words msg))) (gethash (cadr (words msg)) *mail*)))
