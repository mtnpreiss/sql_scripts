-- -----------------------------------------------------------------------------
-- table_size.sql
-- liefert Informationen zur Größe einer Tabelle und der zugehörigen Indizes
-- -----------------------------------------------------------------------------

undefine owner
undefine table_name

set verify off
set timin off

column table_name format a30
column segment_name format a30
column owner format a20

select s.owner
     , s.segment_name table_name
     , s.segment_name
     , s.segment_type
     , round(sum(s.bytes)/1024/1024) segment_size
  from dba_segments s
 where s.owner like upper('&&owner')
   and s.segment_name like upper('&&table_name') 
   and s.segment_type like 'TABLE%'
 group by s.owner
        , s.segment_name
        , s.segment_type
 order by 1, 2, 4 desc, 5 desc;

with
indexes as (
select /*+ materialize */
       owner
     , index_name
     , table_name
  from dba_indexes
 where owner like upper('&owner')
   and table_name like upper('&table_name') 
)
select s.owner
     , i.table_name
     , s.segment_name
     , s.segment_type
     , round(sum(s.bytes)/1024/1024) segment_size
  from dba_segments s
     , indexes i
 where s.owner = i.owner
   and s.segment_name = i.index_name
   and s.segment_type like 'INDEX%'
 group by s.owner
        , i.table_name
        , s.segment_name
        , s.segment_type
 order by 1, 2, 4 desc, 5 desc;

set verify on
set timin on

