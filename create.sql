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

drop table if exists users;
create table users (
       id    integer primary key autoincrement,
       user  varchar(32) not null,
       password  varcar(32) default "caps",
       create_at timestamp default (datetime('now', 'localtime')),
       update_at timestamp default ""
       );
