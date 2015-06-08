(defvar *suggestions* (make-hash-table :test #'equalp))

(defcommand ":suggest" (msg)
  (push (concatenate-words (cdr (words msg))) (gethash (user msg) *suggestions*)))

(defcommand ":suggestions" (msg)
  (msg (format nil "Suggestions: (~a user~:*~p)" (hash-table-count *suggestions*)) (user msg))
  (loop for key being the hash-keys of *suggestions* using (hash-value value) do
    (loop for suggestion in value do
      (msg (format nil "[~a] ~a" key suggestion) (user msg)))))
