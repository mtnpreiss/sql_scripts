-- -----------------------------------------------------------------------------
-- xplan.sql
-- shows the execution plan for the last explained query.
-- -----------------------------------------------------------------------------
select *
  from table(dbms_xplan.display);

/*
-- advanced liefert Query Block Name, Outline Data, Predicate Information, 
-- Column Projection Information
select *
  from table(dbms_xplan.display(NULL, NULL, 'advanced'));
*/  
