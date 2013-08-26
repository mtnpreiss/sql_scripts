-- ----------------------------------------------------------------------------
-- cursql_topio.sql
-- shows the TOP buffer_gets consuming queries in the buffer cache
-- ordered by buffer_gets
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
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
     , s.optimizer_mode
     , s.optimizer_cost  
     , s.plan_hash_value
     , s.service
     , s.remote
  from gv$sql s
 where buffer_gets >= 1000
   and upper(s.parsing_schema_name) not like upper('%SYS%')
   and s.command_type not in (47, 170)
 order by s.buffer_gets desc;

-- restore sqlplus environment
@ restore_settings.sql