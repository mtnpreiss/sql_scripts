-- ----------------------------------------------------------------------------
-- sqlxplan_awr.sql
-- liefert die Zugriffspläne für ein im AWR vorliegendes Statement
-- (bestimmt über sql_id)
-- ----------------------------------------------------------------------------

select *
  from table(dbms_xplan.display_awr('&1'));

