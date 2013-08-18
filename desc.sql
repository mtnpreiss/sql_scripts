-- -----------------------------------------------------------------------------
-- desc.sql
-- erweitertes <desc>-Script von Tom Kyte
-- -----------------------------------------------------------------------------

column data_type format a30
column data_length format 999999
column degree format a10
column segment_name format a40
column low_value_formatted format a60
column high_value_formatted format a60
column data_default format a30
column search_condition format a100

set pages 200
set timin off
set verify off

prompt *******************************************************************************************************

prompt
prompt informationen zur tabelle: &&1
prompt
prompt dba_tables
prompt

select owner
     , table_name
     , tablespace_name
     , pct_free
  from dba_tables
 where table_name = upper('&1')
 order by owner
        , table_name;

select owner
     , num_rows
     , blocks
     , avg_row_len
     , degree
     , to_char(last_analyzed, 'dd.mm.yyyy hh24:mi:ss') last_analyzed
     , compression
  from dba_tables
 where table_name = upper('&1')
 order by owner
        , table_name;

prompt
prompt dba_segments
prompt

select owner
     , segment_name
     , segment_type
     , tablespace_name
     , count(distinct partition_name) partition_count
     , round(sum(bytes)/1024/1024) mb
     , sum(blocks) blocks
     , sum(extents) extents
  from dba_segments
 where segment_name = upper('&1')
 group by owner
        , segment_name
        , segment_type
        , tablespace_name;

prompt
prompt dba_tab_cols
prompt

select owner
     , column_name
     , data_type
     , data_length
     , data_precision
     , data_scale
     , nullable
     , column_id
     , default_length
     , data_default
     , num_distinct
     , low_value
     , high_value
     , display_raw(low_value, data_type) low_value_formatted
     , display_raw(high_value, data_type) high_value_formatted
     , density
     , num_nulls
     , num_buckets
     , to_char(last_analyzed, 'dd.mm.yyyy hh24:mi:ss') last_analyzed
     , sample_size
     , character_set_name
     , char_col_decl_length
     , global_stats
     , user_stats
     , avg_col_len
     , char_length
     , char_used
     , v80_fmt_image
     , data_upgraded
     , hidden_column
     , virtual_column
     , segment_column_id
     , internal_column_id
     , histogram
  from dba_tab_cols
 where table_name = upper('&1')
 order by owner
        , column_id;

prompt
prompt -------------------------------------------------------------------------------------------------------

prompt
prompt dba_indexes
prompt

select owner
     , index_name
     , index_type
     , uniqueness
     , compression
     , prefix_length
     , tablespace_name
     --, pct_threshold
     --, include_column
     , pct_free
     , logging
     , blevel
     , leaf_blocks
     , distinct_keys
     , avg_leaf_blocks_per_key
     , avg_data_blocks_per_key
     , clustering_factor
     , status
     , num_rows
     , sample_size
     , to_char(last_analyzed, 'dd.mm.yyyy hh24:mi:ss') last_analyzed
     , degree
     , partitioned
     , temporary
     , generated
     , secondary
     , user_stats
     , global_stats
     -- , funcidx_status
     -- , join_index
     -- , iot_redundant_pkey_elim
     , dropped
     -- , visibility
  from dba_indexes
 where table_name = upper('&1')
 order by owner
        , index_name;

prompt
prompt dba_ind_columns
prompt

select index_owner
     , index_name
     , column_name
     , column_position
     , column_length
     , char_length
     , descend
  from dba_ind_columns
 where table_name = upper('&1')
 order by index_owner
        , index_name
        , column_position;

prompt
prompt -------------------------------------------------------------------------------------------------------

prompt
prompt dba_constraints
prompt

select owner
     , constraint_name
     , constraint_type
     , search_condition
     , r_owner
     , r_constraint_name
     , delete_rule
     , status
     , deferrable
     , deferred
     , validated
     , generated
     , bad
     , rely
     , last_change
     , index_owner
     , index_name
     , invalid
     , view_related
  from dba_constraints
 where table_name = upper('&1')
 order by owner
        , constraint_name;

prompt
prompt -------------------------------------------------------------------------------------------------------

prompt
prompt dba_triggers
prompt

select trigger_name
     , trigger_type
     , triggering_event
     , trigger_body
  from dba_triggers
 where table_name = upper('&1')
/

prompt
prompt -------------------------------------------------------------------------------------------------------

prompt
prompt dba_external_locations
prompt

select d.directory_path || '/' || el.location "path to file of external table"
  from dba_external_locations el
     , dba_directories d
 where d.directory_name = el.directory_name
   and d.owner = el.directory_owner
   and el.table_name = upper('&1')
/

prompt

prompt *******************************************************************************************************

set verify on
set timin on


