-- -----------------------------------------------------------------------------
-- index_unusable.sql
-- shows all indexes, index partitions and index subpartitions 
-- with status = 'UNUSABLE'
-- -----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set timin off
set feedback 1

prompt
prompt ***************
prompt * dba_indexes *
prompt ***************

select owner
     , index_name
  from dba_indexes
 where status = 'UNUSABLE'
 order by owner
        , index_name;

prompt
prompt **********************
prompt * dba_ind_partitions *
prompt **********************

select index_owner
     , index_name
     , count(*) cnt
  from dba_ind_partitions
 where status = 'UNUSABLE'
 group by index_owner
        , index_name
 order by index_owner
        , index_name;

prompt
prompt *************************
prompt * dba_ind_subpartitions *
prompt *************************

select index_owner
     , index_name
     , count(*) cnt
  from dba_ind_subpartitions
 where status = 'UNUSABLE'
 group by index_owner
        , index_name
 order by index_owner
        , index_name;
        

-- restore sqlplus environment
@ restore_settings.sql
