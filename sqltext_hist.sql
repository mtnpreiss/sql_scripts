-- ----------------------------------------------------------------------------
-- sqltext_hist.sql
-- shows the text for a sql query in AWR.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off
set timin off
set long 10000000

set pages 100

select sql_text
  from dba_hist_sqltext
 where sql_id = '&sql_id';

set verify on
set timin on

-- restore sqlplus environment
@ restore_settings.sql
