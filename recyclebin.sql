-- -----------------------------------------------------------------------------
-- recyclebin.sql
-- shows objects in the recyclebin and their size.
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
col original_name format a30

with 
blocksize as (
select value blk_size
  from v$parameter 
 where name = 'db_block_size'
)
select owner
     , original_name
     , ts_name
     , count(*) obj_count
     , round(sum(space) * (select blk_size from blocksize)/1024/1024) space_mb
  from dba_recyclebin
 group by owner
        , original_name
        , ts_name
 order by 5 desc;
 
-- restore sqlplus environment
@ restore_settings.sql 