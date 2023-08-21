#lang racket
(provide (all-defined-out))
(require "mathml.rkt")
(define comb-def
  (&= (comb $n $k)
      (~ (fact $n)
         (i* (fact $k)
             (fact (@ (&- $n $k)))))))
(define comb-id
  (&= (comb $m $n)
      (&+ (comb (&- $m $1) (&- $n $1))
          (comb (&- $m $1) $n))))
(define binomial-id
  (&= (^ (@ (&+ $x $y)) $n)
      (sum (&= $k $0) $n
           (i* (comb $n $k)
               (^ $x (&- $n $k))
               (^ $y $k)))))
(define ex0
  (&= (sum (&= $n $1) inf
           (inv (i* $n (@ (&+ $n $1)))))
      $1))
(define ex1
  (&= (sum (&= $k $1) $n (^ $k $2))
      (~ (i* $n (@ (&+ $n $1))
             (@ (&+ (i* $2 $n) $1)))
         $6)))
(define ex2
  (&cm (&= (sum (&= $n $0) inf (^ $x $n))
           (inv (&- $1 $x)))
       (&< (ver0 $x) $1)))
(define euler-id
  (&= (&+ (^ $e (i* $i $pi)) $1) $0))
(define ex3
  (&= (sum (&= $k $1) $n (^ $k $3))
      (^ (pare (sum (&= $k $1) $n $k))
         $2)))
(define e-def
  (lim $n inf
       (^ (pare (&+ $1 (inv $n)))
          $n)))
(define compute-e
  (sum (&= $n $0) inf
       (inv (fact $n))))
(define cauchy-ineq
  (&<=
   (^ (@ (&+ (i* (_ $x $1) (_ $y $1))
             ..c
             (i* (_ $x $n) (_ $y $n))))
      $2)
   (i* (@ (&+ (_^ $x $1 $2) ..c (_^ $x $n $2)))
       (@ (&+ (_^ $y $1 $2) ..c (_^ $y $n $2))))))
(define pi-series
  (&= (sum (&= $n $0) inf
           (~ (^ (@ $-1) $n)
              (&+ (i* $2 $n) $1)))
      (~ $pi $4)))
(define fib-def
  (let ((fib (lambda (x)
               (ap '(mi "fib") (@ x)))))
    (&= (fib $n)
        (choice
         `((,$0 ,(: cm (&= $n $0)))
           (,$1 ,(: cm (&= $n $1)))
           (,(&+ (fib (&- $n $1))
                 (fib (&- $n $2)))
            ,(: cm (&>= $n $2))))))))
