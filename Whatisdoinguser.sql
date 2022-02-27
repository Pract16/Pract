create schema control;
create table control.control(id serial,user_id int not null, id_note int, whatdoing varchar(128), date timestamp);
--USES Triggers
