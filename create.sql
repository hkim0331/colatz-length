drop table if exists answers;
create table answers (
       id    integer primary key autoincrement,
       stat  int default 1, -- 0 for false otherwise true
       subj  varchar(32) default "colatz-range",
       user  varchar(32) not null,
       msec  int not null,
       upload_at timestamp default (datetime('now','localtime')),
       answer    text not null
       );
