-- ----------------------------------------------------------------------------
-- index_build.sql
-- shows index segments that are currently created (segment_type = 'TEMPORARY')
-- ----------------------------------------------------------------------------

select segment_name
     , segment_type
     , bytes
     , blocks
  from dba_segments
 where segment_type = 'TEMPORARY';
