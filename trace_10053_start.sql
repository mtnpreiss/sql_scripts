-- -----------------------------------------------------------------------------
-- trace_10053_start.sql
-- starts CBO trace.
-- -----------------------------------------------------------------------------

alter session set events '10053 trace name context forever, level 1';