#lang racket
(provide (all-defined-out))
(require "xml.rkt" "css.rkt")
(define (size x)
  (cond ((pair? x) (+ (size (car x)) (size (cdr x))))
        ((null? x) 0)
        ((string? x) (string-length x))
        (else 1)))
#;
(define ((emit proc) exp path)
  (printf "size of [~a]: ~a\n" path (size exp))
  (with-output-to-file path
    (lambda () (proc exp))
    #:exists 'replace))
(define ((emit proc) exp path #:exists [flag #t])
  (define (emit-file)
    (printf "size of [~a]: ~a\n" path (size exp))
    (with-output-to-file path
    (lambda () (proc exp))
    #:exists 'replace))
  (if (file-exists? path)
      (if flag
          (emit-file)
          (printf "~s exists, emit cancelled\n" path))
      (emit-file)))
(define emitXml (emit Xml))
(define emitCss (emit Css))