-- ----------------------------------------------------------------------------
-- sysmetrics_hist.sql
-- shows the history of OS load per hour.
-- ----------------------------------------------------------------------------

prompt
prompt **************************************
prompt * load information for the last days *
prompt **************************************

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column os_load_max_n1 format 999.00
column os_load_max_n2 format 999.00
column os_load_avg_n1 format 999.00
column os_load_avg_n2 format 999.00

select time_range
     , round(max(case when instance_number = 1 then lios_per_sec_max else null end)) lios_per_sec_max_n1
     , round(max(case when instance_number = 2 then lios_per_sec_max else null end)) lios_per_sec_max_n2
     , round(max(case when instance_number = 1 then lios_per_sec_avg else null end)) lios_per_sec_avg_n1
     , round(max(case when instance_number = 2 then lios_per_sec_avg else null end)) lios_per_sec_avg_n2
     , round(max(case when instance_number = 1 then os_load_max else null end), 2) os_load_max_n1
     , round(max(case when instance_number = 2 then os_load_max else null end), 2) os_load_max_n2
     , round(max(case when instance_number = 1 then os_load_avg else null end), 2) os_load_avg_n1
     , round(max(case when instance_number = 2 then os_load_avg else null end), 2) os_load_avg_n2
  from (select to_char(round(begin_time, 'hh24'), 'dd.mm.yyyy hh24') time_range
             , instance_number
             , case when metric_id = 2030 
                    then maxval 
                    else null 
               end lios_per_sec_max       
             , case when metric_id = 2030 
                    then average 
                    else null 
               end lios_per_sec_avg       
             , case when metric_id = 2135 
                    then maxval 
                    else null 
               end os_load_max       
             , case when metric_id = 2135 
                    then average 
                    else null 
               end os_load_avg       
          from dba_hist_sysmetric_summary  
         where metric_id in (2030, 2135)
           and begin_time >= sysdate - 3
       )
 group by time_range
 order by time_range
;

-- restore sqlplus environment
@ restore_settings.sql

