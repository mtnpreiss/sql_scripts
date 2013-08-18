-- ----------------------------------------------------------------------------
-- sqlxplan_inst.sql
-- shows the execution plan for a query in the cache of a RAC instance 
-- (based on inst_id, sql_id, child_number)
-- s. http://jonathanlewis.wordpress.com/2011/08/16/dbms_xplan-4/#comment-41573
-- ----------------------------------------------------------------------------

select * 
  from table(dbms_xplan.display('gv$sql_plan_statistics_all'
                               , null
                               , null
                               , 'inst_id = &1 and sql_id = ''&2'' and CHILD_NUMBER = &3')
             );