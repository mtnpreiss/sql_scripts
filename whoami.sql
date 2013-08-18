-- ----------------------------------------------------------------------------
-- whoami.sql
-- information on the current user
-- s. http://uhesse.wordpress.com/2012/03/01/oracle-database-whoami/
-- ----------------------------------------------------------------------------

-- save sqlplus environment
@ save_settings.sql

-- set sqlplus environment
set serveroutput on

begin
    dbms_output.put_line('USER: '||sys_context('userenv','session_user'));
    dbms_output.put_line('SESSION ID: '||sys_context('userenv','sid'));
    dbms_output.put_line('CURRENT_SCHEMA: '||sys_context('userenv','current_schema'));
    dbms_output.put_line('INSTANCE NAME: '||sys_context('userenv','instance_name'));
    -- dbms_output.put_line('DATABASE ROLE: '||sys_context('userenv','database_role'));
    dbms_output.put_line('OS USER: '||sys_context('userenv','os_user'));
    dbms_output.put_line('CLIENT IP ADDRESS: '||sys_context('userenv','ip_address'));
    dbms_output.put_line('SERVER HOSTNAME: '||sys_context('userenv','server_host'));
    dbms_output.put_line('CLIENT HOSTNAME: '||sys_context('userenv','host'));
end;
/

-- restore sqlplus environment
@ restore_settings.sql
