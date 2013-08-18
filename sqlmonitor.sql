-- ----------------------------------------------------------------------------
-- sqlmonitor.sql
-- liefert sqlmonitor-Informationen zu einer sql_id
-- ----------------------------------------------------------------------------

undefine sql_id
undefine sql_exec_id
undefine inst_id

set verify off
set timin off
set longchunksize 10000000

column module format a20
column username format a20

alter session set nls_date_format = 'dd.mm.yyyy hh24:mi:ss';

select m.sid
     , ses.osuser
     , substr(ses.username, 1, 20) username
     , substr(ses.module, 1, 20) module
     , m.sql_id
     , m.sql_exec_id
     , s.inst_id
     , m.sql_exec_start 
     , m.last_refresh_time
     , m.status
     , round(m.ELAPSED_TIME/1000000) ela_secs_mon
     , round(s.ELAPSED_TIME/1000000) ela_secs_sql
     , substr(s.sql_text, 1, 100) sqltext
  from gv$sql_monitor m
     , gv$sql s
     , gv$session ses
 where m.sql_id = s.sql_id
   and m.sid = ses.sid
   and m.session_serial# = ses.serial#
   and s.inst_id = ses.inst_id
   and m.status = 'EXECUTING'
 order by m.sql_exec_start ;

accept sql_id prompt 'sql_id des statements: '
accept sql_exec_id prompt 'sql_exec_id des statements: '

select dbms_sqltune.report_sql_monitor('&&sql_id', sql_exec_id => '&&sql_exec_id', inst_id => NULL) from dual;
--> alternative Ausgabe als HTML m�glich

alter session set nls_date_format = 'dd.mm.yyyy';

set verify on
set timin on

undefine sql_id
undefine sql_exec_id

