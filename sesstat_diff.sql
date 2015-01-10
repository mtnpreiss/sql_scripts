-- ----------------------------------------------------------------------------
-- sesstat_diff.sql
-- simple Version der Bestimmung der Deltas in v$sesstat für eine andere
-- Session. Dabei werden in einem Schema mit Zugriff auf v$sesstat drei
-- Snapshots erzeugt (vor der Operation und nach den beiden Ausführungen), 
-- deren Unterschiede dann von der folgenden Query bestimmt werden. 
-- 05.11.2012 M.Preiss
-- ----------------------------------------------------------------------------

-- sqlplus Variablen sichern
@ save_settings.sql

undefine username
undefine osuser
undefine inst_id
undefine sid
undefine sort_order
undefine statname
set verify off
set pagesize 300

-- create table with v$sesstat results
drop table sesstat_snapshots;

create table sesstat_snapshots 
as
select 0 snapshot_id
     , systimestamp snapshot_timestamp
     , cast(null as varchar2(30)) snapshot_type
     , r.name
     , t.*
  from gv$sesstat t
  join gv$statname r
    on t.statistic# = r.statistic#
 where 1 = 0;

-- choose the session of interest
select username
     , osuser
     , status
     , inst_id
     , sid
  from gv$session
 where username like upper('%&&username%')
   and osuser like upper('%&&osuser%')
 order by username
        , osuser
        , status;

-- get initial stats
insert into sesstat_snapshots
select 1
     , systimestamp
     , 'start'     
     , r.name
     , t.*
  from gv$sesstat t
  join gv$statname r
    on t.statistic# = r.statistic#
 where t.inst_id = &&inst_id
   and t.sid = &&sid;

prompt *** Pause: nach Abschluss der ersten Operation in Session &sid durch Tastendruck beenden ***
pause   

-- get stats after first run
insert into sesstat_snapshots
select 2
     , systimestamp
     , 'after_1'
     , r.name
     , t.*
  from gv$sesstat t
  join gv$statname r
    on t.statistic# = r.statistic#
 where t.inst_id = &&inst_id
   and t.sid = &&sid;

prompt *** Pause: nach Abschluss der zweiten Operation in Session &sid durch Tastendruck beenden ***
pause   

-- get stats after second run
insert into sesstat_snapshots
select 3
     , systimestamp
     , 'after_2'
     , r.name
     , t.*
  from gv$sesstat t
  join gv$statname r
    on t.statistic# = r.statistic#
 where t.inst_id = &&inst_id
   and t.sid = &&sid;

-- check the differences
prompt *** Sortierung nach: ***
select 1 name
     , 2 value_first_run
	 , 3 value_second_run
  from dual;	 

with
snapshot_start as (
select t.* 
     , row_number() over (order by name) sorted_names
  from sesstat_snapshots t
 where snapshot_id = 1
)
,
snapshot_after1 as (
select * 
  from sesstat_snapshots 
 where snapshot_id = 2
)
,
snapshot_after2 as (
select * 
  from sesstat_snapshots 
 where snapshot_id = 3
)
,
results as (
select a.name
     , b.value - a.value value_first_run
     , c.value - b.value value_second_run
	 , a.sorted_names
  from snapshot_start a
  join snapshot_after1 b
    on (a.statistic# = b.statistic#)
  join snapshot_after2 c
    on (a.statistic# = c.statistic#)
)
select name
     , value_first_run  
     , value_second_run
  from results
 where (value_first_run <> 0 or value_second_run <> 0)
   and upper(name) like upper('%&statname%')
 order by case &sort_order when 1 then sorted_names when 2 then value_first_run when 3 then value_second_run end
;

-- sqlplus Variablen wiederherstellen
@ restore_settings.sql
