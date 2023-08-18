#lang racket
(provide (all-defined-out))
(require "mathml.rkt")
(define binomial-identity
  (: (^ (par0 (: :x :+ :y)) :n) :=
     (sum (: :k := :0) :n
          (: (comb :n :k) i*
             (^ :x (: :n :- :k)) i*
             (^ :y :k)))))
(define det3-identity
  (deriv
   (det `((,:a ,:b ,:c)
          (,:d ,:e ,:f)
          (,:g ,:h ,:i)))
   (: :a i* (det `((,:e ,:f)
                   (,:h ,:i)))
      :-
      :b i* (det `((,:d ,:f)
                   (,:g ,:i)))
      :+
      :c i* (det `((,:d ,:e)
                   (,:g ,:h))))
   (: :a i* :e i* :i :+
      :b i* :f i* :g :+
      :c i* :d i* :h :-
      :c i* :e i* :g :-
      :a i* :f i* :h :-
      :b i* :d i* :i)))
(define combinatorial-identity
  (let ((m-1 (: :m :- :1))
        (n-1 (: :n :- :1)))
    (: (comb :m :n) :=
       (comb m-1 n-1) :+
       (comb m-1 :n))))
(define computing-e
  (: (sum (: :n := :0) inf
          (inv (fact :n)))
     := :e))
(define fib-definition
  (let ((fib (lambda x*
               (ap0 '(mi "fib") (apply : x*)))))
    (: (fib :n) :=
       (choice
        `((,:0 ,(: cm :n := :0))
          (,:1 ,(: cm :n := :1))
          (,(: (fib :n :- :1) :+
               (fib :n :- :2))
           ,(: cm :n :>= :2)))))))
(define example0
  (: (sum (: :k := :1) :n (:cub :k)) :=
     (:sqr
      (brac
       (Mfrac (: :n i* (par0 (: :n :+ :1)))
              :2)))))
(define example1
  (: (lim :x :0
          (Mfrac (ap0 '(mi "sin") :x) :x))
     := :1))
(define example2
  (: (sum (: :n := :1) inf
          (inv (: :n i*
                  (par0 (: :n :+ :1)))))
     := :1))
(define linear-equations
  (let ((A11 (_ :A (: :1 cm :1)))
        (A1n (_ :A (: :1 cm :n)))
        (Am1 (_ :A (: :m cm :1)))
        (Amn (_ :A (: :m cm :n)))
        (x1 (_ :x :1))
        (xn (_ :x :n))
        (y1 (_ :y :1))
        (ym (_ :y :m)))
    (choice
     (list
      (list (: A11 i* x1) :+ ..c :+ (: A1n i* xn) := y1)
      (list ..v $ $ $ ..v $ ..v)
      (list (: Am1 i* x1) :+ ..c :+ (: Amn i* xn) := ym)))))
(define euler-identity
  (: (^ :e (: :i i* :pi)) :+ :1 := :0))
