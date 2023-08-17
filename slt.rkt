#lang racket
(provide (all-defined-out))
(require "match.rkt")
;<xml> ::= <string> | <symbol> | <number> | <boolean> | <vector>
;       |  (<tag> (<attr>*) <xml>*)
;<tag> ::= <symbol> | <a scheme value other than symbol>
;<attr> ::= (<symbol> <string>)
;<binding> ::= (<symbol> <handler>)
;           |  (<symbol> *preorder* <handler>)
;           |  ((default) <handler>)
;           |  ((default) *preorder* <handler>)
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
           (apply handler tag attr* (map transform xml*))))
        (,else
         (lambda (tag attr* . xml*)
           `(,tag ,attr* . ,(map transform xml*)))))))
  (define text-handler
    (let ((text-binding (assoc '(text) style*)))
      (if text-binding
          (cadr text-binding)
          identity)))
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
;; (define (attr*-set attr* x v)
;;   (cond ((null? attr*)
;;          (list (list x v)))
;;         ((eq? (caar attr*) x)
;;          (cons (list x v) (cdr attr*)))
;;         (else
;;          (cons (car attr*)
;;                (attr*-set (cdr attr*) x v)))))
(define (attr*-set attr* . xv*)
  (define (s a* x v)
    (if (eq? v #f)
        a*
        (let s ((a* a*) (x x) (v v))
          (cond ((null? a*)
                 (list (list x v)))
                ((eq? (caar a*) x)
                 (cons (list x v) (cdr a*)))
                (else
                 (cons (car a*)
                       (s (cdr a*) x v)))))))
  (if (null? xv*)
      attr*
      (let iter ((x (car xv*))
                 (v (cadr xv*))
                 (xv* (cddr xv*))
                 (a* attr*))
        (if (null? xv*)
            (s a* x v)
            (iter (car xv*) (cadr xv*) (cddr xv*)
                  (s a* x v))))))
(define (set-attr* xml . xv*)
  (match xml
    ((,tag ,attr* . ,xml*)
     `(,tag ,(apply attr*-set attr* xv*) . ,xml*))
    (,str
     (guard (string? str))
     `(div ,(apply attr*-set '() xv*) ,str))))
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
  (define (Tt tag attr* . r*)
    `(mtable ,attr* . ,(mapi Tr r*)))
  (define (Tr r i)
    (apply
     (lambda (tag attr* . d*)
       `(mtr ,attr* .
             ,(mapi (lambda (d j) (Td d i j)) d*)))
     r))
  (T `((mtable *preorder* ,Tt))))
(define Ttle
  (Ttable (lambda (d i j)
            (if (even? j)
                (set-attr* d 'columnalign "right")
                d))))