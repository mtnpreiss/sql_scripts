-- ----------------------------------------------------------------------------
-- sesstat_diff.sql
-- simple Version der Bestimmung der Deltas in v$sesstat für eine andere
-- Session. Dabei werden in einem Schema mit Zugriff auf v$sesstat zwei
-- Snapshots erzeugt (vor und nach der Operation), deren Unterschiede dann
-- von der folgenden Query bestimmt werden. 
-- Stattdessen könnte man natürlich auch einfach Billingtons RUNSTAT-Script
-- verwenden ...
-- Die Hilfstabellen snap_begin und snap_end werden zu Beginn der Operation
-- gedropt.
-- 05.11.2012 M.Preiss
-- ----------------------------------------------------------------------------

-- sqlplus Variablen sichern
@ save_settings.sql

undefine username
undefine osuser
undefine inst_id
undefine sid
set verify off

drop table snap_begin;
drop table snap_end;

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

create table snap_begin as
select *
  from gv$sesstat
 where inst_id = &&inst_id
   and sid = &&sid;

prompt *** Pause: nach Abschluss der Operation in Session &sid durch Tastendruck beenden ***    
pause   

create table snap_end as
select *
  from gv$sesstat
 where inst_id = &inst_id
   and sid = &sid;
   
select sn.name
     , sb.value value_begin
     , se.value value_end
     , se.value - sb.value diff
  from v$statname sn
     , snap_begin sb
     , snap_end se
 where sn.statistic# = sb.statistic#
   and sn.statistic# = se.statistic#
   and sb.value <> se.value
   and abs(se.value - sb.value) > to_number(coalesce('&min_diff', '0'))
 order by abs(se.value - sb.value) desc;
   
-- sqlplus Variablen wiederherstellen
@ restore_settings.sql
