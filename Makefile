DEST=/srv/colatz-hkim
DB=colatz.db

debug:
	racket colatz.rkt

create:
	sqlite3 ${DB} < create.sql

init:
	install -m 0644 ${DB} ${DEST}/

install: colatz.rkt
	install -m 0755 $^ ${DEST}/
	sed -i.bak -e "s|href='/|href='/ch/|g" \
		-e "s|action='/|action='/ch/|g" ${DEST}/colatz.rkt

start: install
	racket ${DEST}/colatz.rkt

stop:
	kill `lsof -i:8002 | grep 8002 | awk '{print $2}'`

restart: stop start

clean:
	${RM} *~ *.bak
