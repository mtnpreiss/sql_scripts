-- ----------------------------------------------------------------------------
-- parameter_hidden.sql
-- shows hidden/underscore parameters
-- has to be executed as sys (or someone how has access on x$ structures)
-- ----------------------------------------------------------------------------

col ksppinm format a50
col ksppstvl format a50

select a.ksppinm
     , b.ksppstvl
  from x$ksppi a
     , x$ksppsv b
 where a.indx = b.indx 
   and substr(a.ksppinm,1,1) = '_'
   and upper(a.ksppinm) like upper('%&parameter_text%')
 order by a.ksppinm
/