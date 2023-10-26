#lang racket
(provide Tm)
(require "mathml.rkt" "slt.rkt")
(define math-style*
  `(((default)
     *preorder*
     ,(lambda (tag attr* . xml*)
        (cond ((eq? tag 'math) `(,tag ,attr* . ,xml*))
              ((memq tag '(merror mfrac mi mmultiscripts mn mo mover
                                  mpadded mphantom mroot mrow
                                  ms mspace msqrt mstyle msub msubsup
                                  msup mtable mtd mtext mtr munder
                                  munderover))
               (Math `(,tag ,attr* . ,xml*)))
              (else `(,tag ,attr* . ,(map Tm xml*))))))
    ((text) ,(lambda (str) str))))
(define Tm (T math-style*))