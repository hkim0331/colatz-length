#!/usr/bin/env racket
#lang racket

(require db racket/system (planet dmac/spin))

(define VERSION "0.3.5")

;;CHANGE
(define DB
  (first
    (filter
      file-exists?
      '("/Users/hkim/ramdisk/colatz-length/colatz.db"
        "/home/hkim/ramdisk/colatz-length/colatz.db"
        "/srv/colatz-hkim/colatz.db"))))

(define db (sqlite3-connect #:database DB))

(define (auth? user password)
  (query-maybe-value
    db
    "select id from users where user=$1 and password=$2" user password))

(define (insert user answer msec)
  (query-exec
    db
    "insert into answers (user, answer, msec) values ($1, $2, $3)"
    user answer msec))

(define (answers)
  (query-rows
    db
    "select * from answers where subj='colatz-range' and stat='1' order by msec"))

(define (answer id)
  (query-row
   db
   "select * from answers where id=$1" id))

(define header
  "<!doctype html>
<html>
<head>
<meta charset='utf-8'/>
<meta name='viewport' content='width=device-width, initial-scale=1.0'/>
<link
 rel='stylesheet'
 href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'
 integrity='sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T'
 crossorigin='anonymous'/>
</head>
<body>
<div class='container'>
<h1>Colatz Range</h1>")

(define footer
  "<hr>
programmed by hkimura, 2019-05-15, 2019-05-19.
<a href='https://github.com/hkim0331/colatz-length.git'>github</a>
</div></html>")

(define html
  (lambda body
    (format "~a~a~a"
            header
            (string-join body)
            footer)))

(define (error msg)
  (format
    "<p style='color:red;'>~a</p><p><a href='/upload'>やり直す</a></p>"
    msg))

(define (save s)
  (let ((fname "/tmp/colatz.rkt"))
    (with-output-to-file fname
      (lambda ()
        (displayln s)))
    fname))

(define (msec s)
  (third (string-split s)))

;;FIXME: must return #f if error
(define (try answer)
  (let* ((fname (save answer))
         (s (with-output-to-string
             (lambda ()
               (system (format "racket ~a" fname))))))
        (system (format "rm -f ~a" fname))
        (msec s)))

;; list answers
(define-syntax-rule (inc n)
  (let ()
    (set! n (+ 1 n))
    n))

(get "/"
  (lambda (req)
    (html
     (with-output-to-string
       (lambda ()
         (let ((num 0))
           (displayln "<div class='table-responsive")
           (displayln "<table class='table table-striped'>")
           (displayln "<tr><td></td><td>user</td><td>msec</td><td>upload</td>")
           (for ([ans (answers)])
             (displayln
              (format
               "<tr><td>~a</td><td>~a</td><td stlye='width:6em; text-align:right'>~a</td><td><a href='/show/~a'>~a</a></td>"
               (inc num)
               (vector-ref ans 3)
               (vector-ref ans 4)
               (vector-ref ans 0)
               (vector-ref ans 5))))
           (displayln "</table>")
           (displayln "</div>")
           (displayln "new answer? <a href='/upload' class='btn btn-primary'>upload</a>")))))))

(get "/upload"
  (lambda (req)
    (html
      (with-output-to-string
        (lambda ()
          (displayln "<form method='post' action='/submit'>")
          (displayln "<p>name <input name='user'></p>")
          (displayln "<p>password <input name='password' type='password'></p>")
          (displayln "<p>your answer:関数を colayz-range として定義し、<br>")
          (displayln "最後に (time (argmax ...) の計測プログラムを入れてください。</p>")
          (displayln "<textarea name='answer' rows='10' cols='40'>")
          (displayln "(time (argmax first (colatz-range (range 1 1000000))))")
          (displayln "</textarea></p>")
          (displayln "<p><input type='submit' class='btn btn-primary'></p>")
          (displayln "</form>"))))))

(post "/submit"
  (lambda (req)
    (html
      (if (not (auth? (params req 'user) (params req 'password)))
        (error "username or password is bad.")
        (let* ((user (params req 'user))
               (answer (params req 'answer))
               (msec (try answer)))
          (if msec
            (begin
            (insert user answer msec)
            (format "<p>thank you. see the <a href='/'>results</a>.</p>"))
            (error "check your answer")))))))

(get "/show/:id"
     (lambda (req)
       (let ((ans (answer (params req 'id))))
         (html
          (with-output-to-string
            (lambda ()
              (display (format "<pre>~a</pre>" (vector-ref ans 6)))))))))

(displayln "server starts at port 8002")
(run #:listen-ip #f #:port 8002)
