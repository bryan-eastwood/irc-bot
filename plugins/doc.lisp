(defun document (function)
  (if (fboundp function)
      (documentation function 'function)))

(defcommand ":doc" (msg)
  (let ((doc (document (intern (string-upcase (cadr (words msg)))))))
    (if doc
        (msg (remove #\newline doc))
        (msg "No documentation present."))))
