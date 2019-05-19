#!/usr/bin/env racket
#lang racket

(require db (planet dmac/spin))

(define *db* (sqlite3-connect #:database "colatz-range.db"))

(define (auth? user password)
  (query-maybe-value 
    *db*
    "select id from users where user=$1 and password=$2" user password))

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
programmed by hkimura, 2019-05-15. 途中から miyakawa.
</div></html>")

(define html
  (lambda body
    (format "~a~a~a"
            header
            (string-join body)
            footer)))

(define (error msg)
  (format
   "<p style='color:red;'>~a</p><p><a href='/upload'>やり直し</a></p>"
   msg))

(get "/"
  (lambda (req)
    (html
      "hello")))

(get "/upload"
  (lambda (req)
    (html
      (with-output-to-string
        (lambda ()
          (displayln "<form method='post' action='/exec'>")
          (displayln "<p>name <input name='user'></p>")
          (displayln "<p>password <input name='password' type='password'></p>")
          (displayln "<p>your answer:<br><textarea name='answer' rows='10' cols='40'>")
          (displayln "</textarea></p>")
          (displayln "<p><input type='submit'></p>")
          (displayln "</form>"))))))

(post "/exec"
  (lambda (req)
    (html
      (if (not (auth? (params req 'user) (params req 'password)))
        (error "username or password is bad.")
        (let ((user (params req 'user))
              (answer (params req 'answer)))
          ;; FIXME
          ;; 解答チェックして、OKならばデータベースに入れる。
          (format "~a ~a" user answer)))
      )))

(displayln "server starts at port 8000")
(run #:listen-ip "127.0.0.1" #:port 8000)
