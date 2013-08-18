-- -----------------------------------------------------------------------------
-- segment_size.sql
-- shows information on the size of segments.
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
undefine owner
undefine segment_name
undefine tablespace_name
undefine segment_type
undefine min_size_mb

set verify off
set timin off

column owner format a30
column segment_name format a30

select owner
     , segment_name
     , segment_type
     , round(sum(bytes)/1024/1024) mb
     , count(*) segment_count
     , case when segment_type = 'TABLE' 
            then (select compression
                    from dba_tables t
                   where t.table_name = s.segment_name
                     and t.owner = s.owner) 
            when segment_type = 'TABLE PARTITION' 
            then (select cast(count(*) as varchar2(20)) 
                    from dba_tab_partitions t
                   where t.table_name = s.segment_name
                     and t.table_owner = s.owner
                     and compression = 'ENABLED') 
            when segment_type in ('INDEX', 'INDEX PARTITION' )
            then (select case when compression = 'ENABLED' 
                              then compression || ' - ' || prefix_length
                              else 'no index compression'
                         end
                    from dba_indexes t
                   where t.index_name = s.segment_name
                     and t.owner = s.owner) 
        else 'none' end compression
     , (select max(to_char(t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss'))
          from dba_tables t
         where t.table_name = s.segment_name
           and t.owner = s.owner) last_analyzed_table
     , (select max(to_char(t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss'))
          from dba_tab_partitions t
         where t.table_name = s.segment_name
           and t.table_owner = s.owner) last_analyzed_tab_partitions
  from dba_segments s
 where owner like upper('%&owner%')
   and segment_name like upper('%&segment_name%')
   and tablespace_name like upper('%&tablespace_name%')
   and segment_type like upper('%&segment_type')
 group by owner, segment_name, segment_type
having round(sum(bytes)/1024/1024) > to_number(coalesce('&min_size_mb', '1000'))
 order by round(sum(bytes)/1024/1024) desc;

set verify on
set timin on

-- restore sqlplus environment
@ restore_settings.sql
