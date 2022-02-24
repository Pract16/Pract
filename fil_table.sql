insert into account(name, first_name, last_name, pass, status_onl) values
('TestName', 'TestFirstName', 'TestLastName', 'p@ssw0rd', 0),
('TestName2', 'TestFirstName2', 'TestLastName2', 'p@ssw0rd2', 0),
('TestName3', 'TestFirstName3', 'TestLastName3', 'p@ssw0rd3', 0);

insert into note(account_id, privelege, text,img,date) values
(1,1,'SomeText',NULL,'2022-02-24 13:51:00'),(1,2,'SomeText3',NULL,'2022-02-24 13:51:00'),(1,2,'SomeText2',NULL,'2022-02-24 13:51:00');

insert into session(id_account,token,time_begins,time_end) values
(1,uuid_generate_v4(), '2022-02-24 13:51:00', '2022-02-24 13:51:30'),
(1,uuid_generate_v4(), '2022-02-24 13:52:00', '2022-02-24 13:52:30'),
(1,uuid_generate_v4(), '2022-02-24 13:53:00', '2022-02-24 13:53:30');

insert into session_note values
(1,1),(2,2),(3,3);
