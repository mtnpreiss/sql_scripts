-- -----------------------------------------------------------------------------
-- trace_start.sql
-- starts sql trace for the current session.
-- -----------------------------------------------------------------------------

exec dbms_monitor.session_trace_enable();