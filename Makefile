DEST=/srv/colatz-hkim
DB=colatz.db

run:
	racket colatz-length.rkt

create:
	sqlite3 ${DB} < create.sql
	sqlite3 ${DB} < seed-user.sql

init:
	install -m 0644 ${DB} ${DEST}/

install: colatz-length.rkt
	install -m 0755 $^ ${DEST}/
	racket ${DEST}/colatz-length.rkt

#colatz-range: colatz-range.rkt
#	raco exe $^

clean:
	${RM} *~ colatz-range
