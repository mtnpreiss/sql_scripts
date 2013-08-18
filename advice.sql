-- -----------------------------------------------------------------------------
-- advice.sql
-- shows the content of some v$advice% views.
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set timin off
set feedback off

prompt
prompt *******************
prompt * db_cache_advice *
prompt *******************

select *
  from v$db_cache_advice;

prompt
prompt *********************
prompt * pga_target_advice *
prompt *********************

select *
  from v$pga_target_advice;

prompt
prompt **********************
prompt * shared_pool_advice *
prompt **********************

select *
  from v$shared_pool_advice;

-- restore sqlplus environment
@ restore_settings.sql
