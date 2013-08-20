-- -----------------------------------------------------------------------------
-- db_info.sql
-- shows basic information on instance and database.
-- Based on a script by Tim Hall.
-- -----------------------------------------------------------------------------

prompt
prompt ******************
prompt * DB-Information *
prompt ******************
prompt

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set feedback off
set timin off

col value format 999999999999999
col datafile format a80
col member format a80

select *
  from v$database;

select *
  from gv$instance;

select *
  from v$version;

select *
  from gv$sga a;

select substr(c.name,1,60) controlfile
     , nvl(c.status,'unknown') status
  from v$controlfile c
 order by 1;

select substr(d.name,1,60) datafile
     , nvl(d.status,'unknown') status
     , d.enabled
     , round(d.bytes/1024/1024) size_mb
  from v$datafile d
 order by 1;

select lf.group#
     , lf.member
     , l.status
     , l.sequence#
     , l.first_change#
     , to_char(first_time, 'dd.mm.yyyy hh24:mi:ss') first_time
  from v$logfile lf
     , v$log l
 where l.group# = lf.group#
 order by lf.group#
        , lf.member;

set feedback on
set timin on

-- restore sqlplus environment
@ restore_settings.sql
