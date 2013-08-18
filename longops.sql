-- ----------------------------------------------------------------------------
-- longops.sql
-- liefert Informationen aus v$session_longops
-- ----------------------------------------------------------------------------

column sql_text format a200

select to_char(sysdate, 'hh24:mi:ss') current_time
     , to_char((sysdate + t.time_remaining/24/60/60), 'hh24:mi:ss') end_time
     , to_char(case when t.totalwork = 0 then 1
                    else t.sofar / t.totalwork
               end * 100, '990') percent
     , t.time_remaining
     , t.elapsed_seconds
     , ses.osuser
     , ses.program
     , t.*
     , substr(s.sql_text, 1, 200) sql_text
  from gv$session_longops t
 inner join 
       gv$session ses
    on (t.sid = ses.sid and t.inst_id = ses.inst_id)
  left outer join
       gv$sql s
    on (t.sql_id = s.sql_id and t.inst_id = s.inst_id)
 where time_remaining > 0
;

