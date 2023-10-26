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
;(define ((T style*) xml)
;  (match xml
;    ((,tag ,attr* . ,xml*)
;     (cond
;       ((assq tag style*)
;        =>
;        (lambda (binding)
;          (match binding
;            ((,tag *preorder* ,handler)
;             (apply handler tag attr* xml*))
;            ((,tag ,handler)
;             (apply handler tag attr* (map (T style*) xml*))))))
;       ((assoc '(default) style*)
;        =>
;        (lambda (binding)
;          (match binding
;            (((default) *preorder* ,handler)
;             (apply handler tag attr* xml*))
;            (((default) ,handler)
;             (apply handler tag attr* (map (T style*) xml*))))))
;       (else
;        (error 'T "~s" tag))))
;    (,str
;     (guard (string? str))
;     (let ((binding (assoc '(text) style*)))
;       (if binding
;           ((cadr binding) str)
;           (error 'T "(text)"))))))
(define (T style*)
  (define default-binding
    (cdr (assoc '(default) style*)))
  (define default-preorder?
    (eq? (car default-binding) '*preorder*))
  (define default-handler
    (if (procedure? (car default-binding))
        (car default-binding)
        (cadr default-binding)))
  (define text-handler
    (cadr (assoc '(text) style*)))
  (define Style*
    (filter (lambda (style) (symbol? (car style)))
            style*))
  (define (transform xml)
    (match xml
      ((,tag ,attr* . ,xml*)
       (cond
         ((assq tag Style*)
          =>
          (lambda (binding)
            (match binding
              ((,tag *preorder* ,handler)
               (apply handler tag attr* xml*))
              ((,tag ,handler)
               (apply handler tag attr* (map transform xml*))))))
         (else
          (if default-preorder?
              (apply default-handler tag attr* xml*)
              (apply default-handler tag attr* (map transform xml*))))))
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
;(define style*
;  `((math *preorder* ,(lambda (tag attr* . xml*)
;                        `(,tag ,(attr*-set attr* 'display "inline")
;                               . ,xml*)))
;    ((default) ,(lambda (tag attr* . xml*)
;                  `(,tag ,attr* . ,xml*)))
;    ((text) ,(lambda (str) str))))