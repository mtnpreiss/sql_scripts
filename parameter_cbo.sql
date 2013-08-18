-- -----------------------------------------------------------------------------
-- parameter_cbo.sql
-- shows CBO parameters for a session.
-- -----------------------------------------------------------------------------

prompt
prompt ********************
prompt * current sessions *
prompt ********************
prompt

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off
column osuser         format a30
column username       format a20
column machine        format a30
column module         format a40

undefine sid
set timin off

select s.osuser
     , s.username
     , s.sid
     , s.machine
     , s.module
  from v$session s
 where s.username is not null
 order by s.osuser
        , s.username
        , s.sid;

prompt ****************************************
prompt * CBO parameters for the given session *
prompt ****************************************
prompt

select name
     , value
  from v$ses_optimizer_env
 where sid = &&sid
 order by name
;

prompt *********************************************
prompt * parameters differing from system settings *
prompt *********************************************
prompt
select name
     , value
  from v$ses_optimizer_env
 where sid = &sid
 minus 
select name
     , value
  from v$sys_optimizer_env
 order by 1  
;
 
undefine sid
set timin on

-- restore sqlplus environment
@ restore_settings.sql
