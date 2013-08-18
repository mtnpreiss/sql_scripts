-- -----------------------------------------------------------------------------
-- endtrace.sql
-- beendet Tracing auf Session-Ebene
-- <  07.2006 MP
-- 20.11.2006 MP: mit dbms_monitor-Package
-- -----------------------------------------------------------------------------

exec dbms_monitor.SESSION_TRACE_DISABLE()