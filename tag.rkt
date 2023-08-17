#lang racket
(provide (all-defined-out))
(define (make-xml-tag name)
  (lambda (#:attr* [attr* '()] . xml*)
    `(,name ,attr* . ,xml*)))
(define-syntax-rule
  (define-xml-tag* (id name) ...)
  (begin
    (define id (make-xml-tag 'name))
    ...))
