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
<img width="764" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/ad52348d-2cd8-4526-b8df-511066131d28">

```
(let ((m-1 (: :m :- :1))
      (n-1 (: :n :- :1)))
  (: (:comb :m :n) :=
     (:comb m-1 n-1) :+
     (:comb m-1 :n)))
```
<img width="504" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/2966f780-6b5d-4a78-85c6-c725b044e132">

```
(: (:Sum (: :k := :1) :n)
   (:cub :k) :=
   (:sqr
    (:brack
     (Mfrac (: :n :i*
               (:paren0 :n :+ :1))
            :2))))
```
<img width="358" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/2278ed39-5e25-454f-9ea2-669b8075e6b5">

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
<img width="671" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/89c4a91a-c5de-47c2-9137-7dbc9ea3f70b">

```
(: (:Sum (: :n := :0) :inf)
   (:inv (: :n :!)) := :e)
```
<img width="191" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/67e953e8-409b-4308-a9fd-e84e06da15d5">
