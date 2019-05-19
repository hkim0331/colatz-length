#!/usr/bin/env racket
#lang racket
;; normal recursion

(define (colatz n)
  (cond
    ((= n 1) '(1))
    ((even? n) (cons n (colatz (/ n 2))))
    (else (cons n (colatz (+ 1 (* 3 n)))))))

(define (colatz-range n)
  (map (lambda (n) (list (length (colatz n)) n)) (range 1 n)))

(time (argmax first (colatz-range 1000000)))
;;cpu time: 4868 real time: 4868 gc time: 405
;;'(525 837799)
