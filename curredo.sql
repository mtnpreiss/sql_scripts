-- -----------------------------------------------------------------------------
-- curredo.sql
-- shows the redo size of current sessions.
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
col program format a40
col redo format 9999999999999999
col module format a60
col osuser format a20
col username format a30

-- distinct, um die gv$sql-Duplikate (mehrere child_cursor) zu unterdrücken
select distinct
       ss.value redo
     , s.inst_id
     , s.sid
     , s.osuser
     , s.username
     , s.module
     , s.machine
     , s.program
     , s.status
     , replace(substr(sql.sql_text, 1, 70), chr(10), '') sql_text
  from gv$sesstat ss
  join gv$statname sn
    on (ss.statistic# = sn.statistic# and ss.inst_id = sn.inst_id)
  join gv$session s
    on (ss.sid = s.sid and ss.inst_id = s.inst_id)
  left outer join
       gv$sql sql
    on (s.sql_id = sql.sql_id and s.inst_id = sql.inst_id)
 where s.type <> 'BACKGROUND'
   and name = 'redo size'
 order by value desc;

-- restore sqlplus environment
@ restore_settings.sql
 