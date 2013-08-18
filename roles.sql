-- -----------------------------------------------------------------------------
-- roles.sql
-- shows roles and system privileges for the current user.
-- -----------------------------------------------------------------------------

prompt
prompt ********************************************
prompt * Rollen und Systemprilivegien des Schemas *
prompt ********************************************
prompt

select rp.*
     , case when sr.role is not null then 'active' else 'not enabled' end status
  from user_role_privs rp
  left outer join
       session_roles sr
    on (rp.granted_role = sr.role);

select *
  from user_sys_privs a;
