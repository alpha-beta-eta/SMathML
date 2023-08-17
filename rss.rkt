#lang racket
(provide (all-defined-out))
(define (Rss #:version [version "2.0"] channel)
  `(rss ((version ,version)) ,channel))
(define (Title str) `(title () ,str))
(define (Link str) `(link () ,str))
(define (Description str) `(description () ,str))
(define (Channel #:title title #:link link #:description description . xml*)
  `(channel () ,(Title title) ,(Link link) ,(Description description) . ,xml*))
(define (RC #:version [version "2.0"]
            #:title title #:link link #:description description
            . xml*)
  (Rss #:version version
       (keyword-apply
        Channel '(#:description #:link #:title) (list description link title)
        xml*)))
(define (Item . xml*) `(item () . ,xml*))
(define (PubDate str) `(pubDate () ,str))