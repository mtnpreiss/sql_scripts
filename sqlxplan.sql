-- ----------------------------------------------------------------------------
-- sqlxplan.sql
-- shows the execution plan for a query in the cache (based on sql_id 
-- and child_number)
-- ----------------------------------------------------------------------------

select plan_table_output
  from table( dbms_xplan.display_cursor ( '&1', '&2'));