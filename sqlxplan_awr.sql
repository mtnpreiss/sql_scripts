-- ----------------------------------------------------------------------------
-- sqlxplan_awr.sql
-- liefert die Zugriffspl�ne f�r ein im AWR vorliegendes Statement
-- (bestimmt �ber sql_id)
-- ----------------------------------------------------------------------------

select *
  from table(dbms_xplan.display_awr('&1'));

