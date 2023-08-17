#lang racket
(require "match.rkt" "xml.rkt" "css.rkt" "emit.rkt" "html.rkt"
         "slt.rkt" "mathml.rkt" "math-styles.rkt"
         (except-in "svg.rkt" A Script Style Title)
         "automatic-numbering.rkt" "escape.rkt" racket/date
         "graphics.rkt" "tag.rkt")
(provide
 (all-from-out
  "match.rkt" "xml.rkt" "css.rkt" "emit.rkt" "html.rkt"
  "slt.rkt" "mathml.rkt" "math-styles.rkt" "svg.rkt"
  "automatic-numbering.rkt" "escape.rkt" "graphics.rkt"
  "tag.rkt")
 (all-defined-out))
(define TmPrelude
  (compose Tm Prelude))
(define TnTmPrelude
  (compose Tn Tm Prelude))
(define now (current-date))
(define (current-date-string #:format [format 'rfc2822])
  (parameterize ((date-display-format format))
    (date->string now #t)))
(define Γ $Gamma:normal)
(define Δ $Delta:normal)
(define Θ $Theta:normal)
(define Λ $Lambda:normal)
(define Ξ $Xi:normal)
(define Π $Pi:normal)
(define Σ $Sigma:normal)
(define Φ $Phi:normal)
(define Ψ $Psi:normal)
(define Ω $Omega:normal)
(define (map* f . x*) (map f x*))
(define (map-toggle flag proc lst)
  (cond ((null? lst) '())
        (flag (cons (proc (car lst))
                    (map-toggle (not flag) proc (cdr lst))))
        (else (cons (car lst)
                    (map-toggle (not flag) proc (cdr lst))))))
(define (LINK title link)
  (A title #:attr* `((href ,link))))
(define (TITLE title link)
  (H2 (LINK title link)))
(struct state (idt ctx) #:transparent)
(define inline-tags
  (make-parameter
   (seteq
    'pre 'textarea 'script 'style
    'b 'i 'em 'strong 'span 'a 'u 's
    'code 'kbd 'samp 'var
    'abbr 'cite 'q 'sub 'sup 'small 'mark
    'del 'ins 'time 'wbr 'br
    'bdi 'bdo 'data 'ruby 'rt 'rp
    'img 'input 'output 'select 'button 'label
    'mi 'mn 'mo 'ms 'mtext 'mspace 'annotation
    'tspan 'textPath
    'math 'svg)))
(define (inline? tag)
  (set-member? (inline-tags) tag))
(define (inline-element? tag attr*)
  (and (inline? tag)
       (not (and (eq? tag 'math)
                 (for/or ([a (in-list attr*)])
                   (and (eq? (car a) 'display)
                        (equal? (cadr a) "block")))))
       (not (and (eq? tag 'svg)
                 (for/or ([a (in-list attr*)])
                   (and (eq? (car a) 'style)
                        (string-contains? (cadr a) "display: block")))))))
(define (XML xml)
  (define (fdown seed tag attr* xml*)
    (define idt (state-idt seed))
    (define ctx (state-ctx seed))
    (define child-inline?
      (inline-element? tag attr*))
    (cond
      [(eq? ctx 'inline)
       (void)]
      [(eq? ctx 'block-nl)
       (display (make-string idt #\space))]
      [else
       (unless child-inline?
         (newline)
         (display (make-string idt #\space)))])
    (printf "<~a" tag)
    (for ([a (in-list attr*)])
      (printf " ~a=~s" (car a) (cadr a)))
    (cond
      [(null? xml*)
       (display "/>")
       (when (and (not (eq? ctx 'inline)) (not child-inline?))
         (newline))
       seed]
      [else
       (display ">")
       (cond
         [(eq? ctx 'inline) (state idt 'inline)]
         [child-inline?     (state idt 'inline)]
         [else              (state (+ idt 2) 'block)])]))
  (define (fup seed enjoying tag attr* xml*)
    (when (pair? xml*)
      (when (eq? (state-ctx enjoying) 'block-nl)
        (display (make-string (state-idt seed) #\space)))
      (printf "</~a>" tag)
      (when (and (not (eq? (state-ctx seed) 'inline))
                 (not (inline-element? tag attr*)))
        (newline)))
    (cond
      [(eq? (state-ctx seed) 'inline) seed]
      [(inline-element? tag attr*)
       (state (state-idt seed) 'mixed)]
      [else
       (state (state-idt seed) 'block-nl)]))
  (define (fhere seed xml)
    (define ctx (state-ctx seed))
    (when (eq? ctx 'block-nl)
      (display (make-string (state-idt seed) #\space)))
    (display xml)
    (if (eq? ctx 'inline)
        seed
        (state (state-idt seed) 'mixed)))
  (Fold fdown fup fhere (state 0 'block-nl) xml))
