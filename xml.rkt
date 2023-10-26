#lang racket
(provide Xml)
(require "match.rkt")
;<xml> ::= <string>
;       |  (<symbol> (<attr>*) <xml>*)
;<attr> ::= (<symbol> <string>)
(define (Attr* attr*)
  (for-each
   (lambda (attr)
     (printf " ~s=~s" (car attr) (cadr attr)))
   attr*))
(define (Xml xml)
  (match xml
    ((,tag ,attr* . ,xml*)
     (if (null? xml*)
         (begin
           (printf "<~s" tag)
           (Attr* attr*)
           (printf "/>"))
         (begin
           (printf "<~s" tag)
           (Attr* attr*)
           (printf ">")
           (for-each Xml xml*)
           (printf "</~s>" tag))))
    (,str
     (guard (string? str))
     (printf "~a" str))))