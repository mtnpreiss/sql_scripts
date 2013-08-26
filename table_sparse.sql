-- -----------------------------------------------------------------------------
-- table_sparse.sql
-- shows tables with a size bigger than the expected size based on
-- the number of rows and the avg_row_len. This can be a symptom of
-- direct path inserts (and be fixed with an ALTER TABLE ... MOVE), but of 
-- course there are also other possible reason for this pattern (old statistics, 
-- LOBS with out of line storage etc.)
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column segment_name format a30

prompt ** a small pct value is not always a sign for fragmentation  **

with
basedata as (
select owner
     , segment_name
     , segment_type
     , sum(bytes) bytes
     , round(sum(bytes)/1024/1024) mb
     , (select max(num_rows)
          from dba_tables t
         where t.table_name = s.segment_name
           and t.owner = s.owner) num_rows
     , (select max(avg_row_len)
          from dba_tables t
         where t.table_name = s.segment_name
           and t.owner = s.owner) avg_row_len
  from dba_segments s
 where segment_type like upper('%TABLE%')
 group by owner, segment_name, segment_type
having round(sum(bytes)/1024/1024) > 1000
)
select owner
     , segment_name
     , segment_type
     , mb
     , num_rows
     , avg_row_len
     , round(num_rows/mb) rows_per_mb
     , round((num_rows * avg_row_len)/1024/1024) netto_bytes
  -- , bytes
     , round(num_rows * avg_row_len/bytes * 100) pct
  from basedata
 where round(num_rows * avg_row_len/bytes * 100) < 70
 order by mb desc;

-- restore sqlplus environment
@ restore_settings.sql
