-- ----------------------------------------------------------------------------
-- cursql_schema.sql
-- current queries for a schema.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off

column parsing_schema_name format a60

select parsing_schema_name
     , count(*) query_count
     , round(sum(elapsed_time)/1000000) elapsed_time
  from gv$sql
 group by parsing_schema_name
 order by 2 desc;

-- restore sqlplus environment
@ restore_settings.sql
 
@ cursql