-- -----------------------------------------------------------------------------
-- xplan.sql
-- zeigt den Execution Plan des zuletzt erklärten Statements an
-- <  07.2005 MP
-- -----------------------------------------------------------------------------
select *
  from table(dbms_xplan.display);

/*
-- advanced liefert Query Block Name, Outline Data, Predicate Information, 
-- Column Projection Information
select *
  from table(dbms_xplan.display(NULL, NULL, 'advanced'));
*/  
