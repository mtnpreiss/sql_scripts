-- -----------------------------------------------------------------------------
-- tablespace_size.sql
-- liefert die Größe der Tablespaces in der Datenbank
-- -----------------------------------------------------------------------------

column owner format a30
col used_percent format 00.00

with
metrics as (
select tablespace_name 
     , used_space
     , tablespace_size
     , used_percent
  from dba_tablespace_usage_metrics
)
,
segments as (
select tablespace_name
     , sum(blocks) seg_blocks
     , round(sum(bytes)/1024/1024) seg_mb
     , count(*) seg_count
  from dba_segments s
 group by tablespace_name
)
select s.tablespace_name
     , s.seg_mb
     , s.seg_count
     , s.seg_blocks
     , m.used_space m_blocks
     , m.tablespace_size
     , round(m.used_percent, 2) used_percent
  from segments s
  join metrics m
    on (s.tablespace_name = m.tablespace_name)
 order by s.seg_mb desc
;

