CREATE
OR REPLACE FUNCTION hasura.selectmynote(account_idd integer) RETURNS SETOF hasura.viewnote LANGUAGE plpgsql AS $ function $ begin return query (
  select
    id,
    account_id,
    text,
    img,
    date
  from
    data.note
  where
    account_id = account_idd
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.addnote(
  account_id integer,
  textn character varying,
  imgn bytea
) RETURNS SETOF hasura.notehasura LANGUAGE plpgsql AS $ function $ declare datatimeN timestamp;
id_note int;
id_sess int;
begin
SELECT
  NOW() :: timestamp into datatimeN;
insert into
  data.note(account_id, privelege, text, img, date)
values
  (account_id, 0, textN, imgN, datatimeN) returning id into id_note;
select
  id
from
  data.session
where
  id_account = account_id
  and time_end is null
limit
  1 into id_sess;
insert into
  data.session_note
values(id_sess, id_note);
insert into
  data.note_permission
values(account_id, account_id, id_note, 'owner');
insert into
  control.control(user_id, whatdoing, date)
values
  (
    account_id,
    'user with account id=' || account_id || ' create note with id= ' || id_note || '.',
    datatimeN
  );
return query (
    select
      *
    from
      data.note
    where
      id = id_note
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.beginonline(id_account integer, passwd character varying) RETURNS SETOF hasura.tokentable LANGUAGE plpgsql AS $ function $ declare datatimeB timestamp;
tokenl varchar(256);
begin if(
  passwd = (
    select
      pass
    from
      data.account
    where
      id = id_account
  )
) then
SELECT
  NOW() :: timestamp into datatimeB;
update
  data.account
set
  status_onl = 1
where
  id = id_account;
insert into
  data.session(id_account, token, time_begins, time_end)
values
  (id_account, uuid_generate_v4(), datatimeB, NULL) returning token into tokenl;
insert into
  control.control(user_id, whatdoing, date)
values
  (
    id_account,
    'account with id=' || id_account || ' begin your session online',
    datatimeB
  );
  else
insert into
  control.control(user_id, whatdoing, date)
values
  (
    0,
    'trying sign into account id=' || id_account || ' with faile password= ' || passwd || '.',
    datatimeB
  );
end if;
return query (
  select
    *
  from
    data.session
  where
    token = tokenl
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.createaccount(
  namen character varying,
  first_namen character varying,
  last_namen character varying,
  passn character varying
) RETURNS SETOF hasura.users LANGUAGE plpgsql AS $ function $ declare id_u int;
date timestamp;
begin
SELECT
  NOW() :: timestamp into date;
insert into
  data.account(name, first_name, last_name, pass, status_onl)
values
  (nameN, first_nameN, last_nameN, passN, 0) returning id into id_u;
insert into
  control.control(user_id, whatdoing, date)
values
  (
    id_u,
    'created account with FIO=' || nameN || ' ' || first_nameN || ' ' || last_nameN || ' and passwd=' || passN || '.',
    date
  );
return query (
    select
      *
    from
      data.account
    where
      id = id_u
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.deleteaccount(id_account integer) RETURNS SETOF hasura.users LANGUAGE plpgsql AS $ function $ declare date timestamp;
begin
SELECT
  NOW() :: timestamp into date;
delete from
  data.account
where
  id = id_account;
insert into
  control.control(user_id, whatdoing, date)
values
  (
    id_account,
    'account with id=' || id_account || ' was deleted',
    date
  );
return query (
    select
      *
    from
      data.account
    where
      id = id_account
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.deletenote(id_accountn integer, id_noten integer) RETURNS SETOF hasura.notehasura LANGUAGE plpgsql AS $ function $ declare id_session int;
datatimeN timestamp;
permissions varchar(64);
begin
select
  permission
from
  data.note_permission
where
  id_user = id_accountn
  and id_note = id_noten into permissions;
if(
    permissions = 'owner'
    or permissions = 'editor'
  ) then
SELECT
  NOW() :: timestamp into datatimeN;
select
  id
from
  data.session
where
  id_account = id_accountn
  and time_end is null
limit
  1 into id_session;
delete from
  data.note
where
  id = id_noten;
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || ' delete note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || '.',
    datatimeN
  );
  else
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    account_id,
    'user with account id=' || id_accountn || 'try delete note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || ' and FAILED',
    datatimeN
  );
end if;
return query (
  select
    *
  from
    data.note
  where
    id = id_noten
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.editshare(
  id_account integer,
  id_dependet_user integer,
  id_notel integer,
  perms character varying
) RETURNS SETOF hasura.share LANGUAGE plpgsql AS $ function $ declare id_session int;
datatimeN timestamp;
permissions varchar(64);
begin
select
  permission
from
  data.note_permission
where
  id_user = id_accountn
  and id_note = id_noten into permissions;
if(permissions = 'owner') then
SELECT
  NOW() :: timestamp into datatimeN;
select
  id
from
  data.session
where
  id_account = id_accountn
  and time_end is null
limit
  1 into id_session;
update
  data.note_permission
set
  id_user = id_account,
  id_dependet_user = id_dependet_user,
  id_noteL = id_note,
  permission = perms;
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || ' alter note with id= ' || id_noten || ' share with user id = ' || id_dependet_user || 'in session = ' || id_session || '.',
    datatimeN
  );
  else
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || 'try share note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || ' and FAILED',
    datatimeN
  );
end if;
return query (
  select
    *
  from
    data.note_permission
  where
    id_user = id_account
    and id_note = id_notel
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.endonline(tokenl character varying) RETURNS SETOF hasura.tokentable LANGUAGE plpgsql AS $ function $ declare datatimeE timestamp;
id_session int;
id_acc int;
begin
SELECT
  NOW() :: timestamp into datatimeE;
update
  data.account
set
  status_onl = 0
where
  id = (
    select
      id_account
    from
      data.session
    where
      token = tokenl
    limit
      1
  ) returning id into id_acc;
update
  data.session
set
  time_end = datatimeE
where
  token = tokenl returning id into id_session;
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_acc,
    id_session,
    'account with id=' || id_acc || ' end your session id = ' || id_session || '.',
    datatimeE
  );
return query (
    select
      *
    from
      data.session
    where
      token = tokenl
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.selectnote(id_accountn integer) RETURNS SETOF hasura.viewnote LANGUAGE plpgsql AS $ function $ begin return query (
  select
    id,
    account_id,
    text,
    img,
    date
  from
    data.note
  where
    account_id not in (
      select
        id_dependet_user
      from
        data.note_permission
      where
        permission is null
        and id_dependet_user = id_accountn
    )
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.sharenote(
  id_accountn integer,
  id_dependet_user integer,
  id_noten integer,
  perms character varying
) RETURNS SETOF hasura.share LANGUAGE plpgsql AS $ function $ declare id_session int;
datatimeN timestamp;
permissions varchar(64);
begin
select
  permission
from
  data.note_permission
where
  id_user = id_accountn
  and id_note = id_noten into permissions;
if(permissions = 'owner') then
SELECT
  NOW() :: timestamp into datatimeN;
select
  id
from
  data.session
where
  id_account = id_accountn
  and time_end is null
limit
  1 into id_session;
insert into
  data.note_permission
values(id_accountn, id_dependet_user, id_noten, perms);
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || ' alter note with id= ' || id_noten || ' share with user id = ' || id_dependet_user || 'in session = ' || id_session || '.',
    datatimeN
  );
  else
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || 'try share note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || ' and FAILED',
    datatimeN
  );
end if;
return query (
  select
    *
  from
    data.note_permission
  where
    id_user = id_accountn
    and id_note = id_noten
);
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.updateaccount(
  id_account integer,
  namen character varying,
  first_namen character varying,
  last_namen character varying,
  passn character varying
) RETURNS SETOF hasura.users LANGUAGE plpgsql AS $ function $ declare date timestamp;
begin
SELECT
  NOW() :: timestamp into date;
update
  data.account
set
  name = nameN,
  first_name = first_nameN,
  last_name = last_nameN,
  pass = passN
where
  id = id_account;
insert into
  control.control(user_id, whatdoing, date)
values
  (
    id_account,
    'account with id=' || id_account || 'was updates your data',
    date
  );
return query (
    select
      *
    from
      data.account
    where
      id = id_account
  );
end;
$ function $

CREATE
OR REPLACE FUNCTION hasura.updatenote(
  id_accountn integer,
  id_noten integer,
  textn character varying,
  imgn bytea
) RETURNS SETOF hasura.notehasura LANGUAGE plpgsql AS $ function $ declare datatimeN timestamp;
permissions varchar(64);
id_session int;
begin
select
  permission
from
  data.note_permission
where
  id_user = id_accountn
  and id_note = id_noten into permissions;
if(
    permissions = 'owner'
    or permissions = 'editor'
  ) then
SELECT
  NOW() :: timestamp into datatimeN;
Update
  data.note
set
  text = textN,
  img = imgN
where
  id = id_noten;
select
  id
from
  data.session
where
  id_account = id_accountn
  and time_end is null
limit
  1 into id_session;
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    id_accountn,
    id_session,
    'user with account id=' || id_accountn || ' update note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || '.',
    datatimeN
  );
  else
insert into
  control.control(user_id, id_session, whatdoing, date)
values
  (
    account_id,
    'user with account id=' || id_accountn || 'try update note with id= ' || id_noten || ' with permissions = ' || permissions || 'in session = ' || id_session || ' and FAILED',
    datatimeN
  );
end if;
return query (
  select
    *
  from
    data.note
  where
    id = id_noten
);
end;
$ function $
