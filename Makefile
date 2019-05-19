DEST=/srv/colatz-hkim
DB=colatz-range.db

run:
	racket colatz-range.rkt

create:
	sqlite3 ${DB} < create.sql
	sqlite3 ${DB} < seed-user.sql

init:
	install -m 0644 ${DB} ${DEST}/

install: colatz-range
	install -m 0755 $^ ${DEST}/

colatz-range: colatz-range.rkt
	raco exec $^

clean:
	${RM} *~ colatz-range
