# MathML

This is just an attempt to use MathML with Scheme.  
Here are some examples:

```
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
    :b :i* :d :i* :i))
```

```
(let ((m-1 (: :m :- :1))
      (n-1 (: :n :- :1)))
  (: (:comb :m :n) :=
     (:comb m-1 n-1) :+
     (:comb m-1 :n)))
```

```
(: (:Sum (: :k := :1) :n)
   (:cub :k) :=
   (:sqr
    (:brack
     (Mfrac (: :n :i*
               (:paren0 :n :+ :1))
            :2))))
```

```
(let ((fib (lambda x*
             (:ap0 :fib (apply : x*)))))
  (: (fib :n) :=
     (:choice
      (list
       (list :0 (: :cm :n := :0))
       (list :1 (: :cm :n := :1))
       (list (: (fib :n :- :1) :+
                (fib :n :- :2))
             (: :cm :n :>= :2))))))
```

```
(: (:Sum (: :n := :0) :inf)
   (:inv (: :n :!)) := :e)
```
