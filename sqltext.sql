-- ----------------------------------------------------------------------------
-- sqltext.sql
-- liefert den Text zu einer Query
-- ----------------------------------------------------------------------------

-- sqlplus Variablen sichern
@ save_settings.sql

-- sqlplus Variablen setzen
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

-- sqlplus Variablen wiederherstellen
@ restore_settings.sql
