-- -----------------------------------------------------------------------------
-- source.sql
-- shows the code for a given object
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off
column text format a300

prompt ***************************
prompt * code of a pl/sql object *
prompt ***************************
prompt

select line, text 
  from dba_source
 where upper(owner) = upper('&owner')
   and upper(name) = upper('&name')
   and upper(text) like upper('%&text%')
   and line between to_number(coalesce('&rows_from', '0')) and to_number(coalesce('&rows_to', '100000'));

set verify on

-- restore sqlplus environment
@ restore_settings.sql