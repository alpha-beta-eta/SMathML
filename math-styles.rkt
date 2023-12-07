#lang racket
(provide Tm)
(require "mathml.rkt" "slt.rkt")
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
              (else `(,tag ,attr* . ,(map Tm xml*))))))))
;token elements: mtext mi mn mo mspace ms
(define mtext-style*
  `(((default)
     *preorder*
     ,(lambda (tag attr* . xml*)
        (cond ((memq tag '(mtext mi mn mo mspace ms)) `(,tag ,attr* . ,xml*))
              (else `(,tag ,attr* . ,(map Tx xml*))))))
    ((text) ,(lambda (str) (% str)))))
(define Tm (T math-style*))
(define Tx (T mtext-style*))