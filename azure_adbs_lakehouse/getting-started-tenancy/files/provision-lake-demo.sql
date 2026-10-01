-- SQLcl script. Positional arguments are supplied by provision-lake-demo.sh:
-- 1 schema password, 2 Blob hostname, 3 storage account, 4 storage key,
-- 5 container, 6 database service alias.

whenever oserror exit failure rollback
whenever sqlerror exit sql.sqlcode rollback
-- Keep credentials supplied as positional arguments out of the SQLcl transcript.
set echo off feedback on verify off serveroutput on

define lake_demo_password = '&1'
define blob_host = '&2'
define storage_account = '&3'
define storage_key = '&4'
define blob_container = '&5'
define database_alias = '&6'

declare
  l_user_count pls_integer;
begin
  select count(*) into l_user_count from dba_users where username = 'LAKE_DEMO';

  if l_user_count > 0 then
    raise_application_error(-20001,
      'LAKE_DEMO already exists. Stop and inspect it; use a new dedicated lab database.');
  end if;

  if l_user_count = 0 then
    execute immediate 'create user LAKE_DEMO identified by "&lake_demo_password"';
  end if;
end;
/

grant resource, dwrole to LAKE_DEMO;
grant execute on dbms_cloud to LAKE_DEMO;
grant execute on dbms_cloud_ai to LAKE_DEMO;
grant unlimited tablespace to LAKE_DEMO;

begin
  ords_admin.enable_schema(
    p_schema              => 'LAKE_DEMO',
    p_enabled             => true,
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'LAKE_DEMO',
    p_auto_rest_auth      => false
  );
  commit;
end;
/

begin
  dbms_network_acl_admin.append_host_ace(
    host => '&blob_host',
    ace  => xs$ace_type(
      privilege_list => xs$name_list('connect', 'resolve'),
      principal_name => 'LAKE_DEMO',
      principal_type => xs_acl.ptype_db
    )
  );
exception
  when others then
    -- ORA-24243: this ACE is already present; allow safe re-runs.
    if sqlcode <> -24243 then raise; end if;
end;
/

connect LAKE_DEMO/"&lake_demo_password"@&database_alias

begin
  dbms_cloud.create_credential(
    credential_name => 'AZURE_BLOB_CRED',
    username        => '&storage_account',
    password        => '&storage_key'
  );
end;
/

prompt Azure Blob credential AZURE_BLOB_CRED has been created for LAKE_DEMO.
@@load-reference-tables.sql
exit success

