-- ----------------------------------------------------------------------------
-- sqlxplan_awr.sql
-- shows the execution plan for a query saved in the AWR (based on sql_id)
-- ----------------------------------------------------------------------------

select *
  from table(dbms_xplan.display_awr('&1'));

