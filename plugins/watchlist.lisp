(if *watchlist*
  (push
    (lambda (msg)
      (if (and (user-msg-p msg) (member (user msg) *watchlist* :test #'string=))
          (with-open-file (log "logs/watchlist.log"
              :direction :output
              :if-exists :append)
            (format log "[~a] ~{~a~^ ~}~%" (user msg) (words msg)))))
    *msg-hook*))
