#!/usr/bin/env racket
#lang racket
(require memoize)

(define (colatz n)
  (define (c-aux n ret)
    (if (= n 1)
     ret
     (c-aux (if (even? n) 
                  (arithmetic-shift n -1)
                  (/ (+ 1 (* 3 n)) 2))
            (if (even? n)
                  (+ 1 ret)
                  (+ 2 ret)))))
  (c-aux n 1))

(define (colatz-range n)
  (map (lambda (n) (list (colatz n) n)) (range (/ n 2) n)))

(time (argmax first (colatz-range 1000000)))
