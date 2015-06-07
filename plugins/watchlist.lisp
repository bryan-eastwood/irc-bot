(if *watchlist*
  (push
    (lambda (msg)
      (if (and (user-msg-p msg) (member (user msg) *watchlist* :test #'string=))
          (multiple-value-bind (sec min hour day month year)
              (decode-universal-time (get-universal-time))
            (with-open-file (log "logs/watchlist.log"
                :direction :output
                :if-exists :append
                :if-does-not-exist :create)
              (format log "[~a:~a:~a ~a/~a/~a] (~a) ~{~a~^ ~}~%"
                hour min sec month day year (user msg) (words msg))))))
    *msg-hook*))
