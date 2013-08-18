-- ----------------------------------------------------------------------------
-- sqlxplan.sql
-- liefert den Zugriffsplan für ein 
-- über sql_id und child_number bestimmtes Statement
-- ----------------------------------------------------------------------------

select plan_table_output
  from table( dbms_xplan.display_cursor ( '&1', '&2'));