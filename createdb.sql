create table account(
id serial primary key,
name varchar(128),
first_name varchar(128),
last_name varchar(128),
pass varchar(64),
status_onl int
);

create table session
(
id serial primary key,
id_account int not null,
token varchar(256),
time_begins timestamp,
time_end timestamp
);

create table session_note
(session_id int not null,
note_id int not null);

--(for another user)
--privelege 0-not readed
--1-can read
--2 can read and write

create table note
(
id serial primary key,
account_id int not null,
privelege int,
text varchar(256),
img bytea,
date timestamp
)

--add relations
alter table session ADD CONSTRAINT fk_session_account FOREIGN KEY (id_account) references account(id);
alter table session_note ADD CONSTRAINT fk_session_note FOREIGN KEY (note_id) references note(id);
alter table session_note ADD CONSTRAINT fk_session_note2 FOREIGN KEY (session_id) references session(id);
alter table note ADD CONSTRAINT fk_note_account FOREIGN KEY (account_id) references account(id);
