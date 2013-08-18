-- -----------------------------------------------------------------------------
-- unstable_plans.sql
-- shows information on queries with changed plans and increased runtime
-- in the scope of AWR-History
-- based on Kerry Osborne's script:
-- http://kerryosborne.oracle-guy.com/scripts/unstable_plans.sql
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set verify off

column min_etime format 999999.00
column max_etime format 999999.00
column norm_stddev_ela format 999999.00
column parsing_schema_name format a20

with
basedata
as
(
select * 
  from (select sql_id
             , max(parsing_schema_name) parsing_schema_name
             , sum(execs) executions
             , round(min(avg_etime), 2) min_etime
             , round(max(avg_etime), 2) max_etime
             , round(min(avg_lio)) min_lio
             , round(max(avg_lio)) max_lio
             , stddev_etime/case when min(avg_etime) = 0 then null else min(avg_etime) end norm_stddev_ela
          from (select sql_id
                     , plan_hash_value
                     , parsing_schema_name
                     , execs
                     , avg_etime
                     , avg_lio
                     , stddev(avg_etime) over (partition by sql_id) stddev_etime
                  from (select sql_id
                             , plan_hash_value
                             , max(parsing_schema_name) parsing_schema_name
                             , sum(nvl(executions_delta,0)) execs
                             , (sum(elapsed_time_delta)/
                                   decode(sum(nvl(executions_delta,0)),0,1,sum(executions_delta))/1000000) avg_etime
                             , sum((buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta))) avg_lio
                          from DBA_HIST_SQLSTAT S
                             , DBA_HIST_SNAPSHOT SS
                         where ss.snap_id = S.snap_id
                           and ss.instance_number = S.instance_number
                           and executions_delta > 0
                         group by sql_id, plan_hash_value
                        )
                )
         group by sql_id, stddev_etime
        )
 where norm_stddev_ela > nvl(to_number('&min_stddev'),2)
   and max_etime > nvl(to_number('&min_etime'),.1)
 order by norm_stddev_ela
)
select b.*
     , replace(substr(text.sql_text, 1, 70), chr(10), '') sql_text
  from basedata b
     , dba_hist_sqltext text
 where b.sql_id = text.sql_id(+)
 order by norm_stddev_ela desc
/

set verify on

-- restore sqlplus environment
@ restore_settings.sql
