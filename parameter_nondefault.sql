-- -----------------------------------------------------------------------------
-- parameter_nondefault.sql
-- gibt alle Parameter aus, deren Werte nicht den defaults entsprechen
-- 07.05.2009 MP
-- -----------------------------------------------------------------------------

prompt
prompt ***********************************
prompt * non-default instance parameters *
prompt ***********************************
prompt

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column name format a50
column value format a200

select name
     , value
  from v$system_parameter
 where isdefault = 'FALSE'
 order by name;
 
-- restore sqlplus environment
@ restore_settings.sql
 