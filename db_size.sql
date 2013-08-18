-- ----------------------------------------------------------------------------
-- db_size.sql
-- shows size information for the database.
-- ----------------------------------------------------------------------------

select to_char(sysdate, 'dd.mm.yyyy hh24:mi:ss') cur_time
     , a.all_mbytes
     , b.belegt_mbytes
  from (select round(sum(bytes)/1024/1024) all_mbytes
          from dba_data_files) a
     , (select round(sum(bytes)/1024/1024) used_mbytes
          from dba_segments) b;