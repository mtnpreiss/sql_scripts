-- -----------------------------------------------------------------------------
-- trace_stop.sql
-- stops sql trace for the current session.
-- -----------------------------------------------------------------------------

exec dbms_monitor.session_trace_disable()