-- -----------------------------------------------------------------------------
-- table_stats_global.sql
-- compares the statistics on table blocks with the segment size
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

col owner format a30
col table_name format a30
col max_date_high_value format a30

with
basedata as (
select owner
     , segment_name
     , segment_type
     , round(sum(bytes)/1024/1024) mb
     , count(*) segment_count
     , sum(blocks) blocks
     , (select max(blocks)
          from dba_tables t
         where t.table_name = s.segment_name
           and t.owner = s.owner) blocks_stats
     , (select max(to_char(t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss'))
          from dba_tables t
         where t.table_name = s.segment_name
           and t.owner = s.owner) last_analyzed_table
     , (select max(to_char(t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss'))
          from dba_tab_partitions t
         where t.table_name = s.segment_name
           and t.table_owner = s.owner) last_analyzed_tab_partitions
     , (select max(display_raw(high_value, data_type))
          from dba_tab_columns t
          join dba_part_key_columns c
            on (t.owner = c.owner
                and t.table_name = c.name
                and t.column_name = c.column_name)
         where t.table_name = s.segment_name
           and t.owner = s.owner
           and t.data_type = 'DATE') max_date_high_value
  from dba_segments s
 where owner like upper('%&owner%')
   and segment_name like upper('%&segment_name%')
   and segment_type like ('TABLE%')
 group by owner, segment_name, segment_type
having round(sum(bytes)/1024/1024) > to_number(coalesce('&min_size_mb', '10000'))
 order by round(sum(bytes)/1024/1024) desc
)
select t.owner
     , t.segment_name table_name
     , t.segment_type table_type
     , t.mb
     , t.segment_count
     , t.blocks
     , t.blocks_stats
     , round((blocks_stats/blocks) * 100) pct_stats_blocks     
     , last_analyzed_table
     , last_analyzed_tab_partitions
     , round(sysdate - to_date(last_analyzed_table, 'yyyy-mm-dd hh24:mi:ss')) days_since_analyzed
     , max_date_high_value
  from basedata t
;

-- restore sqlplus environment
@ restore_settings.sql
