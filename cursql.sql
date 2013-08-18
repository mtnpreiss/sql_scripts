-- ----------------------------------------------------------------------------
-- cursql.sql
-- shows information on cached queries.
-- ----------------------------------------------------------------------------

-- sqlplus Variablen sichern
@ save_settings.sql

-- sqlplus Variablen setzen
undefine module
undefine sql_id
undefine schema
undefine sql_text
undefine command_type
undefine ela_sec

set verify off
set pagesize 200

column module format a20
column sorts format 9999999
column row_cnt format 9999999
column execs format 99999999
column parsing_schema_name format a30
column row_cnt format 999999999
column sql_text format a70
column cn format 999
column service format a25
column first_load_time format a30

select to_char(sysdate, 'hh24:mi:ss') curtime
     , s.inst_id
     , s.sql_id   
     , s.child_number cn
     , s.parsing_schema_name
     , substr(s.module, 1, 20) module
     , substr(s.sql_text, 1, 70) sql_text
     , round(s.elapsed_time/1000000) elapsed_time
     , round(s.elapsed_time/1000000/nullif(s.executions, 0)) ela_per_exec
     , s.executions
     , s.px_servers_executions
     , s.buffer_gets
     , s.rows_processed
     , round(s.buffer_gets/nullif(s.rows_processed, 0)) lio_per_row
     , round(s.buffer_gets/nullif(s.executions, 0)) lio_per_exec
     , round(s.cpu_time/1000000) cpu_time
     , round(s.concurrency_wait_time/1000000) concurrency_wait_time
     , round(s.user_io_wait_time/1000000) user_io_wait_time
     , round(s.plsql_exec_time/1000000) plsql_exec_time
     , to_char(s.last_active_time, 'dd.mm.yyyy hh24:mi:ss') last_active_time
     , s.first_load_time
     , s.sorts
     , s.fetches
     , round(s.rows_processed/ nullif(s.fetches, 0), 0) rows_per_fetch
     , s.disk_reads
     , s.direct_writes
     , coalesce (a.name, to_char(s.command_type) ) command_type
     , s.optimizer_mode
     , s.optimizer_cost  
     , s.plan_hash_value
     , s.service
     , s.remote
     /*
     , s.sql_profile
     , s.sql_patch
     , s.sql_plan_baseline
     */
     /* nur 11g
     , s.io_interconnect_bytes
     , s.io_disk_bytes
     */ 
  from gv$sql s
  left outer join
       audit_actions a
    on (s.command_type = a.action)
 where (upper(s.module) like upper('%&&module%') or '&module' is null)
   and round(s.elapsed_time/1000000) >= to_number(coalesce('&ela_sec', '100'))
   and upper(s.parsing_schema_name) like upper('%&schema%')
   and s.sql_id like ('%&sql_id%')
   and upper(s.sql_fulltext) like upper('%&sql_text%')
   and s.command_type != case when upper('&command_type') = 'ALL' then -1 else 47 end
 order by s.elapsed_time desc;

-- sqlplus Variablen wiederherstellen
@ restore_settings.sql


