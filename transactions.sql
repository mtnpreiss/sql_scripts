-- -----------------------------------------------------------------------------
-- transactions.sql
-- zeigt alle aktuellen Transaktionen und die zugehörigen Statements an 
-- (sofern auffindbar)
-- -----------------------------------------------------------------------------

set timin off

prompt
prompt ***********************************************
prompt * Aktive Transaktionen (inklusive Statements) *
prompt ***********************************************

column current_sql format a100
column prev_sql format a100

select to_char(sysdate, 'dd.mm.yyyy hh24:mi:ss') curtime
     , to_char(to_date(t.start_time, 'mm/dd/yy hh24:mi:ss'), 'dd.mm.yyyy hh24:mi:ss') starttime
     , t.used_ublk
     , t.used_urec
     , s.sid
     , s.serial#
     , s.username
     , s.program
     , t.*
     , substr(sql.sql_text, 1, 100) current_sql
     , substr(prev_sql.sql_text, 1, 100) prev_sql
  from gv$transaction t
 inner join 
       gv$session s
    on (t.addr = s.taddr and t.inst_id = s.inst_id)
  left outer join
       gv$sql sql
    on (s.sql_id = sql.sql_id
        and s.sql_child_number = sql.child_number)
  left outer join
       gv$sql prev_sql
    on (s.prev_sql_id = prev_sql.sql_id
        and s.prev_child_number = prev_sql.child_number)
;

set timin on

