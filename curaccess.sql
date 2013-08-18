-- ----------------------------------------------------------------------------
-- curaccess.sql
-- shows execution plans containing a given object.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off

column object_owner format a15
column sql_text format a1000
column object_owner format a30

prompt
prompt *****************************************
prompt * object is used in the following plans *
prompt *****************************************

with 
plan_data as (
select /*+ materialize */
       distinct
       p.sql_id
     , p.child_number
     , p.object_owner
     , p.object_name 
  from gv$sql_plan p
 where p.object_name like upper('%&object_name%')
   and p.object_owner <> 'SYS'
)
select plan.sql_id
     , plan.child_number
     , plan.object_owner
     , plan.object_name 
     , sql.executions
     , sql.buffer_gets
     , round(sql.buffer_gets/nullif(sql.executions, 0)) lios_per_exec
     , round(sql.elapsed_time/1000000) ela_secs
     , round(sql.elapsed_time/1000000/nullif(sql.executions, 0)) ela_per_exec
     , sql.rows_processed
     , to_char(sql.last_active_time, 'dd.mm.yyyy hh24:mi:ss') last_active_time
     , sql.sql_text
  from plan_data plan
     , gv$sql sql
 where plan.sql_id = sql.sql_id
   and plan.child_number = sql.child_number
 order by plan.object_owner
        , plan.object_name 
        , sql.buffer_gets desc
/

-- restore sqlplus environment
@ restore_settings.sql
