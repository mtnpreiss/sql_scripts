-- -----------------------------------------------------------------------------
-- table_partitions.sql
-- liefert Informationen zu Tabellenpartitionen
-- -----------------------------------------------------------------------------

set verify off
set timin off

column high_value format a90
undefine table_name
undefine table_owner

select owner
     , table_name
  from dba_part_tables   
 where owner like upper('%&&table_owner%')
   and table_name = upper('&&table_name') ;

select partitioning_type
     , subpartitioning_type
     , partition_count
     , def_subpartition_count
     , partitioning_key_count
     , subpartitioning_key_count
     , status
     , def_tablespace_name
     , def_pct_free
     , def_pct_used
     , def_ini_trans
     , def_max_trans
     , def_initial_extent
     , def_next_extent
     , def_min_extents
     , def_max_extents
     , def_max_size -- (11g)
     , def_pct_increase
     , def_freelists
     , def_freelist_groups
     , def_logging
     , def_compression
     , def_compress_for -- (11g)
     , def_buffer_pool
     , ref_ptn_constraint_name -- (11g)
     , INTERVAL -- (11g)
  from dba_part_tables
 where table_name = upper('&table_name')
   and owner like upper('%&table_owner%');
   
select column_name
     , column_position
  from dba_part_key_columns  
 where name = upper('&table_name') 
   and owner like upper('%&table_owner%');
  
select partition_name
     , subpartition_count
     , num_rows
     , blocks
     , sample_size
     , last_analyzed
     , avg_row_len
     , high_value
     , partition_position
     , tablespace_name
     , pct_free
     , logging
     , compression
     , compress_for -- (11g)
     , empty_blocks
     , avg_space
     , chain_cnt
     , global_stats
     , user_stats
  from dba_tab_partitions
 where table_name = upper('&table_name') 
   and table_owner like upper('%&table_owner%') 
 order by partition_position;
 
set verify on   
set timin on

/*
DBA_IND_PARTITIONS
DBA_IND_SUBPARTITIONS
DBA_LOB_PARTITIONS
DBA_LOB_SUBPARTITIONS
DBA_PART_COL_STATISTICS
DBA_PART_HISTOGRAMS
DBA_PART_INDEXES
DBA_PART_KEY_COLUMNS
DBA_PART_LOBS
DBA_SUBPARTITION_TEMPLATES
DBA_SUBPART_COL_STATISTICS
DBA_SUBPART_HISTOGRAMS
DBA_SUBPART_KEY_COLUMNS
*/

