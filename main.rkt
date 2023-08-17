#lang racket
(require "match.rkt" "xml.rkt" "css.rkt" "emit.rkt" "html.rkt"
         "slt.rkt" "mathml.rkt" "math-styles.rkt"
         (except-in "svg.rkt" A Script Style Title)
         "automatic-numbering.rkt" "escape.rkt" racket/date)
(provide
 (all-from-out
  "match.rkt" "xml.rkt" "css.rkt" "emit.rkt" "html.rkt"
  "slt.rkt" "mathml.rkt" "math-styles.rkt" "svg.rkt"
  "automatic-numbering.rkt" "escape.rkt")
 (all-defined-out))
(define TmPrelude
  (compose Tm Prelude))
(define TnTmPrelude
  (compose Tn Tm Prelude))
(define now (current-date))
(define (current-date-string #:format [format 'rfc2822])
  (parameterize ((date-display-format format))
    (date->string now #t)))