-- -----------------------------------------------------------------------------
-- lastsql.sql
-- shows sql queries for the last <n> hours in a given schema
-- and a corresponding plan for a selected query.
-- -----------------------------------------------------------------------------

prompt
prompt ***************************************
prompt * SQL Queries der letzten <n> Stunden *
prompt ***************************************
prompt

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off

undefine sql_id
undefine child_number
undefine anzahl_stunden
col sql_text format a100

select parsing_schema_name
     , count(*)
  from gv$sql
 where parsing_schema_name is not null
   and last_active_time > sysdate - (1/24 * to_number(coalesce('&&anzahl_stunden', '1')))
 group by parsing_schema_name
 order by parsing_schema_name;

select sql_id
     , child_number
     , inst_id
     , parsing_schema_name
     , to_char(last_active_time, 'dd.mm.yyyy hh24:mi:ss') last_active_time
     , round(elapsed_time/1000000) elapsed_secs
     , executions
     , buffer_gets
     , substr(sql_text, 1, 100) sql_text
     , rows_processed
  from gv$sql 
 where parsing_schema_name like upper('%&schema%')
   and last_active_time > sysdate - (1/24 * to_number(coalesce('&anzahl_stunden', '1')))
 order by last_active_time
/

select * 
  from table(dbms_xplan.display('gv$sql_plan_statistics_all'
                               , null
                               , null
                               , 'sql_id = ''&sql_id'' and child_number = &child_number and inst_id = &inst_id')
             );
             
set verify on             

-- restore sqlplus environment
@ restore_settings.sql
