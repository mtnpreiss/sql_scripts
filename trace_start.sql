-- -----------------------------------------------------------------------------
-- trace.sql
-- startet dbms_monitor in der aktuellen Session
-- 17.11.2006 MP
-- -----------------------------------------------------------------------------

exec dbms_monitor.session_trace_enable();