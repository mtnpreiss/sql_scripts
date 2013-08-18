-- -----------------------------------------------------------------------------
-- dependencies.sql
-- shows dependencies for a given object.
-- -----------------------------------------------------------------------------

select * 
  from dba_dependencies
 where upper(referenced_name) = upper('&referenced_name')
 order by owner
        , name;
