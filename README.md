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
