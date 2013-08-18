-- ----------------------------------------------------------------------------
-- sqltext.sql
-- liefert den Text zu einer Query
-- ----------------------------------------------------------------------------

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

