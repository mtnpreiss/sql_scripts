-- ----------------------------------------------------------------------------
-- sqltext.sql
-- shows the sql_text for a given sql_id.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off
set timin off
set long 10000000

set pages 100
column sql_fulltext format a200

select sql_fulltext
  from gv$sql
 where sql_id = '&sql_id';

set verify on
set timin on

-- restore sqlplus environment
@ restore_settings.sql
