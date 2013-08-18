-- -----------------------------------------------------------------------------
-- scheduler_jobs.sql
-- shows information on scheduler jobs.
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set timin off
set verify off

column program_owner format a30
column program_name format a60
column job_action format a100
column job_name format a50
column schedule_name format a30
column repeat_interval format a100
column log_date format a40

select owner
     , job_name
     , enabled
  from dba_scheduler_jobs
 order by owner
        , job_name;

accept job_name prompt 'Name of the job: '

prompt
prompt **********************
prompt * Basisinformationen *
prompt **********************

select owner
     , job_name
     , job_creator
     , program_owner
     , program_name    
     , job_type
     , job_action
     , number_of_arguments     
     , comments
  from dba_scheduler_jobs
 where job_name like '%&&job_name%'
   and owner not like 'SYS%'
 order by owner
        , job_name;

prompt 
prompt ************
prompt * Zeitplan *
prompt ************

select owner
     , job_name
     , schedule_name
     , start_date
     , repeat_interval
     , enabled
     , state
     , last_start_date
     , next_run_date
  from dba_scheduler_jobs
 where job_name like '%&job_name%'
   and owner not like 'SYS%' 
 order by owner
        , job_name;
 
prompt
prompt *************
prompt * Statistik *
prompt *************

select owner
     , job_name
     , run_count
     , failure_count
     , last_run_duration
  from dba_scheduler_jobs
 where job_name like '%&job_name%'
   and owner not like 'SYS%'
 order by owner
        , job_name;


prompt
prompt ************
prompt * Historie *
prompt ************

select log_id
     , log_date
     , owner
     , job_name
     , status
     , error#
     , run_duration
  -- , req_start_date     --> geforderter Ausführungstermin
  -- , actual_start_date  --> tatsächlicher Ausführungstermin
  -- , additional_info    --> ausführliche Fehlermeldung
  from dba_scheduler_job_run_details
 where job_name like '%&job_name%'
   and log_date >= trunc(sysdate) - nvl('&anzahl_tage', 0)
 order by owner
        , job_name
        , log_date;

set timin on
set verify on

-- restore sqlplus environment
@ restore_settings.sql
