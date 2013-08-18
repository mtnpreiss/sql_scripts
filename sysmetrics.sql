-- -----------------------------------------------------------------------------
-- sysmetrics.sql
-- liefert aus V$SYSMETRIC_HISTORY load- und logon-Informationen 
-- für die letzte Stunde
-- -----------------------------------------------------------------------------

prompt
prompt ****************************************************
prompt * load- und logon-Informationen der letzten Stunde *
prompt ****************************************************

set pages 100
column os_load_n1 format 999.99
column os_load_n2 format 999.99

select time_range
     , max(case when inst_id = 1 then logon_count else null end) session_count_n1
     , max(case when inst_id = 2 then logon_count else null end) session_count_n2
     , round(max(case when inst_id = 1 then lios_per_sec else null end)) lios_per_sec_n1
     , round(max(case when inst_id = 2 then lios_per_sec else null end)) lios_per_sec_n2
     , round(max(case when inst_id = 1 then os_load else null end), 2) os_load_n1
     , round(max(case when inst_id = 2 then os_load else null end), 2) os_load_n2
  from (select to_char(begin_time, 'dd.mm.yyyy hh24:mi') time_range
             , inst_id
             , case when metric_id = 2103 
                    then value 
                    else null 
               end logon_count
             , case when metric_id = 2030 
                    then value 
                    else null 
               end lios_per_sec
             , case when metric_id = 2135 
                    then value 
                    else null 
               end os_load       
          from gv$sysmetric_history      
         where metric_id in (2103, 2030, 2135)
       )
 group by time_range
having max(os_load) > 0
 order by time_range
;

