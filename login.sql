-- ----------------------------------------------------------------------------
-- login.sql
-- defines sql*plus settings.
-- ----------------------------------------------------------------------------

-- For backward compatibility
SET PAGESIZE 14
SET SQLPLUSCOMPATIBILITY 8.1.7

-- Used by Trusted Oracle
COLUMN ROWLABEL FORMAT A15

-- Used for the SHOW ERRORS command
COLUMN LINE/COL FORMAT A8
COLUMN ERROR    FORMAT A65  WORD_WRAPPED

-- Used for the SHOW SGA command
COLUMN name_col_plus_show_sga FORMAT a24

-- Defaults for SHOW PARAMETERS
COLUMN name_col_plus_show_param FORMAT a36 HEADING NAME
COLUMN value_col_plus_show_param FORMAT a30 HEADING VALUE

-- Defaults for SET AUTOTRACE EXPLAIN report
COLUMN id_plus_exp FORMAT 990 HEADING i
COLUMN parent_id_plus_exp FORMAT 990 HEADING p
COLUMN plan_plus_exp FORMAT a60
COLUMN object_node_plus_exp FORMAT a8
COLUMN other_tag_plus_exp FORMAT a29
COLUMN other_plus_exp FORMAT a44

-- user settings
set lines 2000
set tab off
set pages 50
set timing on
set long 100000000

-- data dictionary tables
column host format a200
column column_name format a30
column object_name format a30
column plan_plus_exp format a100
column comments format a200
column location format a200
column high_value format a100
column external_name format a60
column directory_path format a200
column qualified_col_name format a50

col username format a30
col password format a30

-- title
define gname=idle
column global_name new_value gname
select lower(user) || '@' ||
       substr(global_name,1,decode(dot,0,length(global_name),dot-1)) global_name
  from (select global_name
             , instr(global_name,'.') dot 
          from global_name);
host title &gname
