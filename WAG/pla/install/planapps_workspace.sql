set serveroutput on size 1000000
set feedback off
-- Workspace, user group and user export
-- Generated 2010.01.29 12:29:25 by ADMIN
-- This script can be run in sqlplus as the owner of the Oracle Apex owner.
begin
    wwv_flow_api.set_security_group_id(p_security_group_id=>1298226100743415);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API will cause only meta data inserts.
prompt  Creating workspace PLANAPPS...
begin
wwv_flow_fnd_user_api.create_company (
  p_id                      => 1298312861743418,
  p_provisioning_company_id => 1298226100743415,
  p_short_name              => 'PLANAPPS',
  p_first_schema_provisioned=> 'NM4200I',
  p_company_schemas         => 'NM4200I',
  p_expire_fnd_user_accounts=> '',
  p_account_lifetime_days=> '',
  p_fnd_user_max_login_failures=> '');
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
----------------
-- U S E R S
-- User repository for use with apex cookie based authenticaion.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id      => '1298107563743415',
  p_user_name    => 'ADMIN',
  p_first_name   => '',
  p_last_name    => '',
  p_description  => '',
  p_email_address=> 'you@youraddress.com',
  p_web_password => '05F34C6DE6AC45CEED36841426254984',
  p_web_password_format => 'HEX_ENCODED_DIGEST_V2',
  p_group_ids    => '',
  p_developer_privs=> 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema=> 'NM4200I',
  p_account_locked=> 'N',
  p_account_expiry=> to_date('201001291227','YYYYMMDDHH24MI'),
  p_failed_access_attempts=> 0,
  p_change_password_on_first_use=> 'N',
  p_first_password_use_occurred=> 'Y',
  p_allow_access_to_schemas => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id      => '1311700557752607',
  p_user_name    => 'PLANAPPS',
  p_first_name   => '',
  p_last_name    => '',
  p_description  => '',
  p_email_address=> 'you@youraddress.com',
  p_web_password => '96DA711FACBA4EDEA034FF3121C1DD9C',
  p_web_password_format => 'HEX_ENCODED_DIGEST_V2',
  p_group_ids    => '',
  p_developer_privs=> 'CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema=> 'nm4100i',
  p_account_locked=> 'N',
  p_account_expiry=> to_date('201001291228','YYYYMMDDHH24MI'),
  p_failed_access_attempts=> 0,
  p_change_password_on_first_use=> 'N',
  p_first_password_use_occurred=> 'N',
  p_allow_access_to_schemas => '');
end;
/
commit;
set feedback on
prompt  ...done
