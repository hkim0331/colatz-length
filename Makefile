DEST=/srv/colatz-hkim
DB=colatz.db

debug:
	racket colatz.rkt

create:
	sqlite3 ${DB} < create.sql
	sqlite3 ${DB} < seed-user.sql

init:
	install -m 0644 ${DB} ${DEST}/

install: colatz.rkt
	install -m 0755 $^ ${DEST}/
	sed -i.bak -e "s|href='/|href='/ch/|g" \
		-e "s|action='/|action='/ch/|g" ${DEST}/colatz.rkt

run: install
	racket ${DEST}/colatz.rkt

stop:

clean:
	${RM} *~ *.bak
