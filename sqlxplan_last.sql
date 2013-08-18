-- ----------------------------------------------------------------------------
-- sqlxplan_last.sql
-- shows the execution plan with rowsource statistics for the last query 
-- executed by the session (if rowsource statistics are collected by
-- statistics_level or gather_plan_statistics hint).
-- ----------------------------------------------------------------------------

select * 
  from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST'));
