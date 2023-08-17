#lang racket
(provide Xml)
(require "match.rkt")
;<xml> ::= <string>
;       |  (<tag> (<attr>*) <xml>*)
;<tag> ::= <symbol> | <a scheme value other than symbol>
;<attr> ::= (<symbol> <string>)
(define (Attr* attr*)
  (for-each
   (lambda (attr)
     (printf " ~s=~s" (car attr) (cadr attr)))
   attr*))
(define (Xml xml)
  (match xml
    ((,tag ,attr* . ,xml*)
     (guard (symbol? tag)) ;emmm
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