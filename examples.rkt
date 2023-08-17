#lang racket
(provide (all-defined-out))
(require "mathml.rkt")
(define example0
  (: (:Sum (: :k := :1) :n)
     (:sqr :k) :=
     (Mfrac (: :n :i*
               (:paren0 :n :+ :1) :i*
               (:paren0 :2 :i* :n :+ :1))
            :6)))
(define example1
  (:deriv
   (:det `((,:a ,:b ,:c)
           (,:d ,:e ,:f)
           (,:g ,:h ,:i)))
   (: :a :i* (:det `((,:e ,:f)
                     (,:h ,:i)))
      :-
      :b :i* (:det `((,:d ,:f)
                     (,:g ,:i)))
      :+
      :c :i* (:det `((,:d ,:e)
                     (,:g ,:h))))
   (: :a :i* :e :i* :i :+
      :b :i* :f :i* :g :+
      :c :i* :d :i* :h :-
      :c :i* :e :i* :g :-
      :a :i* :f :i* :h :-
      :b :i* :d :i* :i)))
(define example2
  (let ((m-1 (: :m :- :1))
        (n-1 (: :n :- :1)))
    (: (:comb :m :n) :=
       (:comb m-1 n-1) :+
       (:comb m-1 :n))))
(define example3
  (: (:Sum (: :k := :1) :n)
     (:cub :k) :=
     (:sqr
      (:brack
       (Mfrac (: :n :i*
                 (:paren0 :n :+ :1))
              :2)))))
(define example4
  (: (:Lim :x :0)
     (Mfrac (:ap0 :sin :x) :x)
     := :1))
(define example5
  (let ((fib (lambda x*
               (:ap0 :fib (apply : x*)))))
    (: (fib :n) :=
       (:choice
        (list
         (list :0 (: :cm :n := :0))
         (list :1 (: :cm :n := :1))
         (list (: (fib :n :- :1) :+
                  (fib :n :- :2))
               (: :cm :n :>= :2)))))))
(define example6
  (:seq :alpha :beta :gamma :delta :epsilon
        :zeta :eta :theta :iota :kappa
        :lambda :mu :nu :xi :omicron :pi
        :rho :sigma :tau :upsilon :phi
        :chi :psi :omega))
(define example7
  (:seq :Alpha :Beta :Gamma :Delta :Epsilon
        :Zeta :Eta :Theta :Iota :Kappa
        :Lambda :Mu :Nu :Xi :Omicron :Pi
        :Rho :Sigma :Tau :Upsilon :Phi
        :Chi :Psi :Omega))
(define example8
  (: (:Sum (: :n := :1) :inf)
     (:inv (: :n :i* (:paren0 :n :+ :1)))
     := :1))
(define example9
  (: (Msup :e (: :i :i* :pi)) :+ :1 := :0))
(define example10
  (: (:Sum (: :n := :0) :inf)
     (:inv (: :n :!)) := :e))
(define example11
  (: (:Lim :n :inf)
     (Msup (:paren :1 :+ (:inv :n)) :n)
     := :e))
(define example12
  (: (:type :f :A :B) :cm
     :x ::-> (:ap0 :f :x)))
