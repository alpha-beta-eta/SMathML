# MathML

This is just an attempt to use MathML with Scheme.
Here are some examples:

```
(&= (^ (@ (&+ $x $y)) $n)
    (sum (&= $k $0) $n
         (i* (comb $n $k)
             (^ $x (&- $n $k))
             (^ $y $k))))
```

```
(&= (&+ (^ $e (i* $i $pi)) $1) $0)
```

```
(&<=
 (^ (@ (&+ (i* (_ $x $1) (_ $y $1))
           ..c
           (i* (_ $x $n) (_ $y $n))))
    $2)
 (i* (@ (&+ (_^ $x $1 $2) ..c (_^ $x $n $2)))
     (@ (&+ (_^ $y $1 $2) ..c (_^ $y $n $2)))))
```

```
(&= (sum (&= $n $0) inf
         (~ (^ (@ $-1) $n)
            (&+ (i* $2 $n) $1)))
    (~ $pi $4))
```

```
(let ((fib (lambda (x)
             (ap '(mi "fib") (@ x)))))
  (&= (fib $n)
      (choice
       `((,$0 ,(: cm (&= $n $0)))
         (,$1 ,(: cm (&= $n $1)))
         (,(&+ (fib (&- $n $1))
               (fib (&- $n $2)))
          ,(: cm (&>= $n $2)))))))
```
