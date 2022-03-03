
--create schema control;
create table control.control(id serial,user_id int not null, id_session int, whatdoing varchar(128), date timestamp);
alter table control.control ADD CONSTRAINT fk_control_user FOREIGN KEY (user_id) references data.account(id);
alter table control.control ADD CONSTRAINT fk_control_session FOREIGN KEY (id_session) references data.session(id);
--USES Triggers
