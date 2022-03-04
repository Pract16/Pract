create table data.account(
id serial primary key,
name varchar(128),
first_name varchar(128),
last_name varchar(128),
pass varchar(64),
status_onl int
);

create table data.session
(
id serial primary key,
id_account int not null,
token varchar(256),
time_begins timestamp,
time_end timestamp
);

create table data.session_note
(session_id int not null,
note_id int not null);


create table data.note
(
id serial primary key,
account_id int not null,
text varchar(256),
img bytea,
date timestamp
)
--0 cant
--1 can
create table data.permission
(id serial primary key,
func varchar(128),
per int);

create table data.note_permission
(
id_user int,
id_dependet_user int,
id_note int,
permission varchar(64)
);

create table data.per_user(id_user int, id_per int);

--add relations
alter table data.session DROP CONSTRAINT fk_session_account, ADD CONSTRAINT fk_session_account FOREIGN KEY (id_account) references data.account(id) ON DELETE CASCADE;
alter table data.session_note DROP CONSTRAINT fk_session_note, ADD CONSTRAINT fk_session_note FOREIGN KEY (note_id) references data.note(id) ON DELETE CASCADE;
alter table data.session_note DROP CONSTRAINT fk_session_note2, ADD CONSTRAINT fk_session_note2 FOREIGN KEY (session_id) references data.session(id)  ON DELETE CASCADE;
alter table data.note DROP CONSTRAINT fk_note_account, ADD CONSTRAINT fk_note_account FOREIGN KEY (account_id) references data.account(id) ON DELETE CASCADE;

alter table data.note_permission DROP CONSTRAINT fk_note_permission, ADD CONSTRAINT fk_note_permission FOREIGN KEY (id_user) references data.account(id) ON DELETE CASCADE;
alter table data.note_permission DROP CONSTRAINT fk_note_permission2, ADD CONSTRAINT fk_note_permission2 FOREIGN KEY (id_dependet_user) references data.account(id) ON DELETE CASCADE;

