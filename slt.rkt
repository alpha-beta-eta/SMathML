#lang racket
(provide (all-defined-out))
(require "match.rkt")
;<xml> ::= <string>
;       |  (<symbol> (<attr>*) <xml>*)
;<attr> ::= (<symbol> <string>)
;<binding> ::= (<symbol> <handler>)
;           |  (<symbol> *preorder* <handler>)
;           |  ((default) <handler>)
;           |  ((text) <text-handler>)
;<handler> : <symbol> * <attr>* * <xml>* -> <xml>
;<text-handler> : <string> -> <string>
(define (T style*)
  (define default-handler
    (let ((default-binding (assoc '(default) style*)))
      (match default-binding
        (((default) *preorder* ,handler) handler)
        (((default) ,handler)
         (lambda (tag attr* . xml*)
           (apply handler tag attr* (map transform xml*)))))))
  (define text-handler
    (cadr (assoc '(text) style*)))
  (define Style*
    (map
     (lambda (binding)
       (match binding
         ((,tag *preorder* ,handler)
          (cons tag handler))
         ((,tag ,handler)
          (cons tag
                (lambda (tag attr* . xml*)
                  (apply handler tag attr*
                         (map transform xml*)))))))
     (filter (lambda (style) (symbol? (car style)))
             style*)))
  (define (transform xml)
    (match xml
      ((,tag ,attr* . ,xml*)
       (let ((binding (assq tag Style*)))
         (if binding
             (apply (cdr binding) tag attr* xml*)
             (apply default-handler tag attr* xml*))))
      (,str (text-handler str))))
  transform)
(define (attr*-set attr* x v)
  (cond ((null? attr*)
         (list (list x v)))
        ((eq? (caar attr*) x)
         (cons (list x v) (cdr attr*)))
        (else
         (cons (car attr*)
               (attr*-set (cdr attr*) x v)))))
(define (symbol-append . x*)
  (string->symbol
   (apply string-append
          (map symbol->string x*))))