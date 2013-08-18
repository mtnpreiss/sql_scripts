-- ----------------------------------------------------------------------------
-- cursessions.sql
-- liefert diverse Informationen zu den Sessions in der Datenbank
-- aus v$session, v$sesstat, v$sql, v$sess_time_model
-- ----------------------------------------------------------------------------

set verify off
set pages 300

column sql_text_akt format a100
column sql_text_last format a100
column module format a50
column wait_class format a30
column username format a30

undefine sid

select to_char(sysdate, 'hh24:mi:ss') curtime
     , s.inst_id
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
     , s.last_call_et
     , s.blocking_session_status
     , s.blocking_session
     , s.wait_class
     , s.wait_time
     , s.event
     , s.seconds_in_wait
     , s.state
     , dbt.dbtime
     , sqlt.sqltime
     , s.sql_id
     , s.sql_child_number
     , substr(sql_akt.sql_text, 1, 100) sql_text_akt
     , sql_akt.executions
     , sql_akt.buffer_gets
     , round(sql_akt.elapsed_time/1000000) ela_secs
     , sql_akt.rows_processed
     , s.prev_sql_id
     , s.prev_child_number
     , substr(sql_hist.sql_text, 1, 100) sql_text_last
     , sql_hist.executions executions_last
     , sql_hist.buffer_gets buffer_gets_last
     , round(sql_hist.elapsed_time/1000000) ela_secs_last
     , sql_hist.rows_processed rows_processed_last
     , sort.tablespace
     , sort.contents
     , sort.extents
     , sort.blocks
     , pga_cur.cur_pga_mb
     , pga_max.max_pga_mb
  from gv$session s
  left outer join (select sid
                        , inst_id
                        , round(value/1024/1024) cur_pga_mb
                     from gv$sesstat
                    where statistic# = 25) pga_cur
    on (s.sid = pga_cur.sid and s.inst_id = pga_cur.inst_id)
  left outer join (select sid
                        , inst_id
                        , round(value/1024/1024) max_pga_mb
                     from gv$sesstat
                    where statistic# = 26) pga_max
    on (s.sid = pga_max.sid and s.inst_id = pga_max.inst_id)
  left outer join gv$sql sql_akt
    on (s.sql_id = sql_akt.sql_id and s.sql_child_number = sql_akt.child_number and s.inst_id = sql_akt.inst_id)
  left outer join gv$sql sql_hist
    on (s.prev_sql_id = sql_hist.sql_id and s.prev_child_number = sql_hist.child_number and s.inst_id = sql_hist.inst_id)
  left outer join (select sid
                        , inst_id
                        , round(value/1000000) dbtime
                     from gv$sess_time_model
                    where stat_name = 'DB time') dbt
    on (s.sid = dbt.sid and s.inst_id = dbt.inst_id)
  left outer join (select sid
                        , inst_id
                        , round(value/1000000) sqltime
                     from gv$sess_time_model
                    where stat_name = 'sql execute elapsed time') sqlt
    on (s.sid = sqlt.sid and s.inst_id = sqlt.inst_id)
  left outer join (select session_addr
                        , inst_id
                        , max(tablespace) tablespace
                        , max(contents) contents
                        , max(extents) extents
                        , max(blocks) blocks
                     from gv$sort_usage
                    group by session_addr, inst_id) sort
    on (s.saddr = sort.session_addr and s.inst_id = sort.inst_id)
 where (s.username like upper('%&username%') or s.username is null)
   and (upper(s.status) like case when upper('&status') = 'ACTIVE' then 'ACTIVE' else '%' end or s.status is null)
   and (upper(s.osuser) like upper('%&osuser%') or s.osuser is null)
   and s.type = 'USER'
   and to_char(s.sid) like ('%&sid%')
 order by s.username, s.osuser, s.module
;

