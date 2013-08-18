-- -----------------------------------------------------------------------------
-- locks_ddl.sql
-- shows ddl-locks for all users except SYS and XDB
-- -----------------------------------------------------------------------------

select *
  from dba_ddl_locks
 where lower(owner) not in ('sys', 'xdb')
 order by session_id, name;