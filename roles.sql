-- -----------------------------------------------------------------------------
-- roles.sql
-- zeigt die Rollen und Systemprilivegien des users an
-- -----------------------------------------------------------------------------

prompt
prompt ********************************************
prompt * Rollen und Systemprilivegien des Schemas *
prompt ********************************************
prompt

SELECT rp.*
     , case when sr.role is not null then 'active' else 'not enabled' end status
  FROM user_role_privs rp
  left outer join
       session_roles sr
    on (rp.granted_role = sr.role);



SELECT *
  FROM user_sys_privs a;



