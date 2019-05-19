#!/usr/bin/env racket
#lang racket
;; tail recursion, length

(define (colatz n)
  (define (c-aux n len)
    (cond
      ((= n 1) len)
      ((even? n) (c-aux (arithmetic-shift n -1) (+ 1 len)))
      (else (c-aux (+ 1 (+ n n n)) (+ 1 len)))))
  (c-aux n 1))

(define (colatz-range n)
  (map (lambda (n) (list (colatz n) n)) (range 1 n)))


(time (argmax first (colatz-range 1000000)))
;;cpu time: 1712 real time: 1713 gc time: 565
;;'(525 837799)