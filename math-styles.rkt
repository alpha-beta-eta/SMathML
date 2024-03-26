#lang racket
(provide Tm)
(require "mathml.rkt" "slt.rkt")
(define (Mid id) (Mi (symbol->string id)))
(define (Mnum n) (Mn (number->string n)))
(define (Mint n)
  (if (< n 0)
      (&- (Mnum (- n)))
      (Mnum n)))
(define (Mrat n)
  (let* ((a (numerator n))
         (b (denominator n)))
    (if (< a 0)
        (&- (~ (Mnum (- a)) (Mnum b)))
        (~ (Mnum a) (Mnum b)))))
(define math-style*
  `(((default)
     *preorder*
     ,(lambda (tag attr* . xml*)
        (cond ((eq? tag 'math) `(,tag ,attr* . ,(map Tx xml*)))
              ((memq tag '(merror mfrac mi mmultiscripts mn mo mover
                                  mpadded mphantom mroot mrow
                                  ms mspace msqrt mstyle msub msubsup
                                  msup mtable mtd mtext mtr munder
                                  munderover))
               (Math (Tx `(,tag ,attr* . ,xml*))))
              (else `(,tag ,attr* . ,(map Tm xml*))))))
    ((text) ,(lambda (text)
               (cond ((string? text) text)
                     ((symbol? text) (Math (Mid text)))
                     ((integer? text) (Math (Mint text)))
                     ((rational? text) (Math (Mrat text)))
                     (else (error 'Tm "unknown element ~s" text)))))
    ))
;token elements: mtext mi mn mo mspace ms
(define mtext-style*
  `(((default)
     *preorder*
     ,(lambda (tag attr* . xml*)
        (cond ((memq tag '(mtext mi mn mo mspace ms)) `(,tag ,attr* . ,xml*))
              (else `(,tag ,attr* . ,(map Tx xml*))))))
    ((text) ,(lambda (text)
               (cond ((string? text) (% text))
                     ((symbol? text) (Mid text))
                     ((integer? text) (Mint text))
                     ((rational? text) (Mrat text))
                     (else (error 'Tm "unknown element ~s" text)))))))
(define Tm (T math-style*))
(define Tx (T mtext-style*))