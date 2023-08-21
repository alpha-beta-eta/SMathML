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
<img width="479" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/084e4918-9c8e-4cd4-82df-8877bd03e777">

```
(&= (&+ (^ $e (i* $i $pi)) $1) $0)
```
<img width="221" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/399840b3-2129-48f3-9ada-ab3c91f2a170">

```
(&<=
 (^ (@ (&+ (i* (_ $x $1) (_ $y $1))
           ..c
           (i* (_ $x $n) (_ $y $n))))
    $2)
 (i* (@ (&+ (_^ $x $1 $2) ..c (_^ $x $n $2)))
     (@ (&+ (_^ $y $1 $2) ..c (_^ $y $n $2)))))
```
<img width="854" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/cd74b810-b7fb-4ec0-9c79-d21374d0d1e8">

```
(&= (sum (&= $n $0) inf
         (~ (^ (@ $-1) $n)
            (&+ (i* $2 $n) $1)))
    (~ $pi $4))
```
<img width="269" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/e932b8c6-e14e-468d-ae16-9109d4ee5b8d">

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
<img width="685" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/abde306a-d30f-41a9-a7df-cad7d8174432">

```
(deriv
 (det `((,$a ,$b ,$c)
        (,$d ,$e ,$f)
        (,$g ,$h ,$i)))
 (&+ (&- (i* $a (det `((,$e ,$f)
                       (,$h ,$i))))
         (i* $b (det `((,$d ,$f)
                       (,$g ,$i)))))
     (i* $c (det `((,$d ,$e)
                   (,$g ,$h)))))
 (&- (&+ (i* $a $e $i)
         (i* $b $f $g)
         (i* $c $d $h))
     (i* $c $e $g)
     (i* $a $f $h)
     (i* $b $d $i)))
```
<img width="799" alt="image" src="https://github.com/alpha-beta-eta/MathML/assets/95096031/9f0fd798-34c8-4722-a42d-a907c2c0f658">
