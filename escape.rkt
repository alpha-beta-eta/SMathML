#lang racket
(provide (all-defined-out))
(define (escape s)
  (define l (string-length s))
  (let iter ((i 0))
    (unless (= i l)
      (let ((c (string-ref s i)))
        (case c
          ((#\") (printf "&quot;"))
          ((#\<) (printf "&lt;"))
          ((#\&) (printf "&amp;"))
          ((#\\) (printf "\\\\"))
          (else (printf "~a" c))))
      (iter (+ i 1)))))
(define (escape*)
  (escape (read-line))
  (newline)
  (escape*))