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
(define (set-attr* xml x v)
  (match xml
    ((,tag ,attr* . ,xml*)
     `(,tag ,(attr*-set attr* x v) . ,xml*))
    (,str
     (guard (string? str))
     (error 'set-attr* "does not apply to string ~s" str))))
(define (symbol-append . x*)
  (string->symbol
   (apply string-append
          (map symbol->string x*))))
(define (mapi f l)
  (let m ((i 0) (l l))
    (if (null? l)
        '()
        (cons (f (car l) i)
              (m (+ i 1) (cdr l))))))
(define (Ttable Td)
  (define (Tt table)
    (match table
      ((mtable ,attr* . ,r*)
       `(mtable ,attr* . ,(mapi Tr r*)))))
  (define (Tr r i)
    (match r
      ((mtr ,attr* . ,d*)
       `(mtr ,attr* .
             ,(mapi (lambda (d j) (Td d i j)) d*)))))
  Tt)
(define Ttle
  (Ttable (lambda (d i j)
            (if (even? j)
                (set-attr* d 'columnalign "right")
                d))))