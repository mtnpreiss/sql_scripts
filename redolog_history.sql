-- -----------------------------------------------------------------------------
-- redolog_history.sql
-- shows information on redo log volume and log switches.
-- -----------------------------------------------------------------------------

prompt
prompt *******************
prompt * redo log volume *
prompt *******************
prompt

select a.*
     , round(a.count# * (select avg(bytes) from v$log)/1024/1024) daily_avg_mb
  from (select to_char(first_time,'yyyy-mm-dd') day
             , count(1) count#
             , min(recid) min#
             , max(recid) max#
          from v$log_history
         group by to_char(first_time,'yyyy-mm-dd')
         order by 1 desc
        ) a
 where rownum <= 30;
 
prompt
prompt *********************
prompt * last log switches *
prompt *********************
prompt
 
select a.*
     , round(a.count# * (select avg(bytes) from v$log)/1024/1024) daily_avg_mb
  from (select to_char(first_time,'yyyy-mm-dd hh24') day
             , count(1) count#
             , min(recid) min#
             , max(recid) max#
          from v$log_history
         group by to_char(first_time,'yyyy-mm-dd hh24')
         order by 1 desc
       ) a
where rownum <= 30; 

prompt
prompt *************************
prompt * log switch intervalle *
prompt *************************
prompt

select to_char(first_time,'dd.mm.yyyy hh24:mi:ss') first_time
     , round(24 * 60 * (lead(first_time,1) over (order by first_time) - first_time)) minutes
  from v$log_history v
 where first_time >= trunc(sysdate) - 3
 order by first_time desc nulls first;
