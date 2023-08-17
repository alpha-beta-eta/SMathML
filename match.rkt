#lang racket
(provide match)
(define-syntax match
  (syntax-rules (guard)
    ((_ v) (error 'match "~s" v))
    ((_ v (pat (guard g ...) e ...) cs ...)
     (let ((fk (lambda () (match v cs ...))))
       (ppat v pat (if (and g ...) (let () e ...) (fk)) (fk))))
    ((_ v (pat e ...) cs ...)
     (let ((fk (lambda () (match v cs ...))))
       (ppat v pat (let () e ...) (fk))))))
(define-syntax ppat
  (syntax-rules (unquote)
    ((_ v () kt kf) (if (null? v) kt kf))
    ((_ v (unquote var) kt kf) (let ((var v)) kt))
    ((_ v (x . y) kt kf)
     (if (pair? v)
         (let ((vx (car v)) (vy (cdr v)))
           (ppat vx x (ppat vy y kt kf) kf))
         kf))
    ((_ v lit kt kf) (if (eqv? v (quote lit)) kt kf))))