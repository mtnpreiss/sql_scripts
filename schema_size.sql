-- ----------------------------------------------------------------------------
-- schema_size.sql
-- shows information on the size of schemas.
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
column owner format a30

prompt
prompt ***************************
prompt * Groesse der DB-Schemata *
prompt ***************************
prompt

compute sum of seg_mbyte on report
compute sum of ts_mbyte on report

break on report

select t.owner
     , t.total_size seg_mbyte
     , t.segment_count segments
     , u.default_tablespace
     , df.mbyte ts_mbyte
     , df.max_bytes ts_max_mbyte
     , t.table_size
     , t.index_size
     , t.table_partition_size
     , t.index_partition_size
     , t.table_subpartition_size
     , t.index_subpartition_size
  from dba_users u
     , ( select owner
              , sum(segment_count) segment_count
              , max(table_size) table_size
              , max(index_size) index_size
              , max(table_partition_size) table_partition_size
              , max(index_partition_size) index_partition_size
              , max(table_subpartition_size) table_subpartition_size
              , max(index_subpartition_size) index_subpartition_size
              , sum(total_size) total_size
           from (select owner
                      , count(*) segment_count
                      , case when segment_type = 'TABLE' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end table_size
                      , case when segment_type = 'INDEX' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end index_size
                      , case when segment_type = 'TABLE PARTITION' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end table_partition_size
                      , case when segment_type = 'TABLE SUBPARTITION' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end table_subpartition_size
                      , case when segment_type = 'INDEX PARTITION' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end index_partition_size
                      , case when segment_type = 'INDEX SUBPARTITION' 
                             then round(sum(s.bytes)/1024/1024) 
                             else null 
                        end index_subpartition_size
                      , round(sum(bytes)/1024/1024) total_size   
                   from dba_segments s 
                  group by owner, segment_type  
                ) t                               
            group by owner
         ) t
     , (select f.tablespace_name
             , trunc(sum(f.bytes)/1024/1024) mbyte
             , round(sum(maxbytes)/1024/1024) max_bytes
          from dba_data_files f
         group by f.tablespace_name
        ) df
 where u.username = t.owner
   and u.default_tablespace = df.tablespace_name
   and u.account_status = 'OPEN'
 order by t.total_size desc;

-- restore sqlplus environment
@ restore_settings.sql

