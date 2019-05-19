#!/usr/bin/env racket
#lang racket
;; tail recursion

(define (c-aux n ret)
  (cond
    ((= n 1) ret)
    ((even? n) (c-aux (/ n 2) (cons n ret)))
    (else (c-aux (+ 1 (* n 3)) (cons n ret)))))

(define (colatz n)
  (c-aux n '(1)))

(define (colatz-range n)
  (map (lambda (n) (list (length (colatz n)) n)) (range 1 n)))

(time (argmax first (colatz-range 1000000)))
;;cpu time: 2961 real time: 2971 gc time: 570
;;'(525 837799)

