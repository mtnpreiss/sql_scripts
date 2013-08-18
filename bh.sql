-- -----------------------------------------------------------------------------
-- bh.sql
-- shows objects with more than 10000 blocks in the buffer cache.
-- s. http://jonathanlewis.wordpress.com/2006/11/02/but-its-in-the-manual/ 
-- --> Join with data_object_id = dictionary object number of the segment
--     that contains the object
--
--              status information:
--              * free - Not currently in use
--              * xcur - Exclusive
--              * scur - Shared current
--              * cr - Consistent read
--              * read - Being read from disk
--              * mrec - In media recovery mode
--              * irec - In instance recovery mode
--
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column object_name format a30

prompt
prompt *************************************************************************
prompt * listet Objekte auf, zu denen mehr als 10000 Blocks im Cache vorliegen *
prompt *************************************************************************
prompt

prompt -----------------------------------

prompt * free - Not currently in use
prompt * xcur - Exclusive
prompt * scur - Shared current
prompt * cr   - Consistent read
prompt * read - Being read from disk
prompt * mrec - In media recovery mode
prompt * irec - In instance recovery mode

prompt -----------------------------------

select bh.inst_id
     , o.owner
     , o.data_object_id
     , o.object_name
     , o.subobject_name
     , count(*) block_cnt
     , sum(decode(bh.status, 'free', 1, 0)) as free
     , sum(decode(bh.status, 'xcur', 1, 0)) as xcur
     , sum(decode(bh.status, 'scur', 1, 0)) as scur
     , sum(decode(bh.status, 'cr', 1, 0)) as cr
     , sum(decode(bh.status, 'read', 1, 0)) as read
     , sum(decode(bh.status, 'mrec', 1, 0)) as mrec
     , sum(decode(bh.status, 'irec', 1, 0)) as irec
     , sum(case when dirty = 'y' then 1 else 0 end) dirty_block
     , sum(case when temp = 'y' then 1 else 0 end) temp_block
     , sum(case when direct = 'y' then 1 else 0 end) direct_block
  from gv$bh bh, dba_objects o
 where o.data_object_id = bh.objd
   and o.owner not in ('SYS')
 group by bh.inst_id
        , o.owner
        , o.object_name
        , o.subobject_name
        , o.data_object_id
having count(*) > 10000
 order by bh.inst_id, count(*) desc;

-- restore sqlplus environment
@ restore_settings.sql

