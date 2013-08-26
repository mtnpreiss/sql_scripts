-- ----------------------------------------------------------------------------
-- sessmetrics.sql
-- shows the acivity of current user sessions.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column module format a50
column username format a30
column cpu format 99999

prompt
prompt ************************************************
prompt * load Informationen zu den laufenden Sessions *
prompt ************************************************

select round(m.cpu) cpu
     , m.physical_reads 
     , m.logical_reads 
     , round(m.pga_memory / 1024 / 1024) pga_mb
     , s.sid
     , s.serial#
     , s.username
     , s.status
     , s.osuser
     , s.machine
     , s.terminal
     , s.program
     , s.module
     , s.logon_time
     , s.sql_id
     , substr(sql_akt.sql_text, 1, 100) sql_text_akt
  from gv$sessmetric m
 inner join
       gv$session s
    on (m.session_id = s.sid
        and m.serial_num = s.serial#
        and m.inst_id = s.inst_id)
  left outer join gv$sql sql_akt
    on (s.sql_id = sql_akt.sql_id 
        and s.sql_child_number = sql_akt.child_number
        and s.inst_id = sql_akt.inst_id)
 where s.username is not null
   and (m.cpu > 0 or m.physical_reads > 0 or m.logical_reads > 0)
 order by m.cpu desc, m.physical_reads desc, m.logical_reads desc
;

-- restore sqlplus environment
@ restore_settings.sql