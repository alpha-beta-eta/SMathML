#lang racket
(provide Tm set-compact eqn* deriv^ deriv^0
         set-mathvariant set-style)
(require "mathml0.rkt" "slt.rkt" "html.rkt")
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
(define mathml-tag*
  (list->seteq
   '(merror
     mfrac mi mmultiscripts mn mo mover
     mpadded mphantom mroot mrow
     ms mspace msqrt mstyle msub msubsup
     msup mtable mtd mtext mtr munder
     munderover maction menclose mfenced
     #;mprescripts)))
;; (define math-style*
;;   `(((default)
;;      *preorder*
;;      ,(lambda (tag attr* . xml*)
;;         (cond ((eq? tag 'math) `(,tag ,attr* . ,(map Tx xml*)))
;;               ((set-member? mathml-tag* tag)
;;                (Math (Tx `(,tag ,attr* . ,xml*))))
;;               (else `(,tag ,attr* . ,(map Tm xml*))))))
;;     ((text) ,(lambda (text)
;;                (cond ((string? text) text)
;;                      ((symbol? text) (Math (Mid text)))
;;                      ((integer? text) (Math (Mint text)))
;;                      ((rational? text) (Math (Mrat text)))
;;                      (else (error 'Tm "unknown element ~s" text)))))))
;; ;token elements: mtext mi mn mo mspace ms
;; (define token-tag*
;;   (seteq 'mtext 'mi 'mn 'mo 'mspace 'ms))
;; (define mtext-style*
;;   `(((default)
;;      *preorder*
;;      ,(lambda (tag attr* . xml*)
;;         (cond ((memq tag '(mi mn mo ms mspace mtext))
;;                `(,tag ,attr* . ,xml*))
;;               (else `(,tag ,attr* . ,(map Tx xml*))))))
;;     ((text) ,(lambda (text)
;;                (cond ((string? text) (% text))
;;                      ((symbol? text) (Mid text))
;;                      ((integer? text) (Mint text))
;;                      ((rational? text) (Mrat text))
;;                      (else (error 'Tm "unknown element ~s" text)))))))
;; (define Tm (T math-style*))
;; (define Tx (T mtext-style*))
(define (Tm xml)
  (define (wrap text)
    (cond
      ((symbol? text) (Mid text))
      ((integer? text) (Mint text))
      ((rational? text) (Mrat text))
      (else (error 'Tm "unknown element ~s" text))))
  (define (G xml)
    (match xml
      (`(,tag ,attr* . ,xml*)
       (cond ((eq? tag 'math)
              `(,tag ,attr* . ,(map M xml*)))
             ((set-member? mathml-tag* tag)
              (Math (M xml)))
             (else
              `(,tag ,attr* . ,(map G xml*)))))
      (text
       (if (string? text)
           text
           (Math (wrap text))))))
  (define (M xml)
    (match xml
      (`(,tag ,attr* . ,xml*)
       (if (memq tag '(mi mn mo ms mspace mtext))
           xml
           `(,tag ,attr* . ,(map M xml*))))
      (text
       (if (string? text)
           (Mtext text)
           (wrap text)))))
  (G xml))
(define (set-compact op)
  (set-attr* op 'lspace "0" 'rspace "0"))
(define (set-mathvariant i v)
  (set-attr* i 'mathvariant v))
(define (set-style x style)
  (set-attr* x 'style style))
(define-syntax-rule (eqn* (x ...) ...)
  (MB (set-attr*
       (&Table (x ...) ...)
       'columnalign "right center left"
       'displaystyle "true")))
(define (deriv^ x . y*)
  (set-attr*
   (apply
    Mtable
    (Mtr (Mtd $) (Mtd x))
    (map (lambda (y)
           (Mtr (Mtd $=) (Mtd y)))
         y*))
   'displaystyle "true"
   'columnalign "center left"))
(define (deriv^0 x . y*)
  (set-attr*
   (apply
    Mtable
    (Mtr (Mtd $) (Mtd x))
    (map2 (lambda (= y)
            (Mtr (Mtd =) (Mtd y)))
          y*))
   'displaystyle "true"
   'columnalign "center left"))
