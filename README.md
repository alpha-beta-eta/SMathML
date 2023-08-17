# MathML
This is just an attempt to use MathML with Scheme.
Here are some arbitrary examples:
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
<img width="849" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/97899fb4-12bd-4b90-93f5-4f44f390fcec">
```
(let ((m-1 (: :m :- :1))
      (n-1 (: :n :- :1)))
  (: (:comb :m :n) :=
     (:comb m-1 n-1) :+
     (:comb m-1 :n)))
```
<img width="541" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/02dfa345-ac81-41bc-855c-c1bf15241408">
```
(: (:Sum (: :k := :1) :n)
   (:cub :k) :=
   (:sqr
    (:brack
     (Mfrac (: :n :i*
               (:paren0 :n :+ :1))
            :2))))
```
<img width="382" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/673e48e5-9b0b-4241-aad8-fb1e28e75924">
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
<img width="733" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/88655d05-2ed8-43f9-975b-7ab4fc3c3278">
```
(: (:Sum (: :n := :0) :inf)
   (:inv (: :n :!)) := :e)
```
<img width="195" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/4814ba32-2c4c-4d16-9f2c-e256314d08cc">
