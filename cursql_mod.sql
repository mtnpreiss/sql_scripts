-- ----------------------------------------------------------------------------
-- cursql_mod.sql
-- current queries for a module.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off

column module format a60

select module
     , round(sum(elapsed_time)/1000000) elapsed_time
  from gv$sql
 group by module
 order by 2 desc;

-- restore sqlplus environment
@ restore_settings.sql
 
-- call detail script 
@ cursql