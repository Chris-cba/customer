create or replace
package body XNORFOLK_USER_ROLE as


procedure MAIN(p_user IN varchar2, p_role IN varchar2, p_command IN varchar2, admin_option in VARCHAR2 DEFAULT NULL) as
--Commands are:
-- GRANT
-- REVOKE

	Cursor cur_user_role(cp_user in varchar2, cp_role IN varchar2) is
		select * from hig_user_roles where hur_username = cp_user and  hur_role in cp_role;
		
	
	E_Command_Unknown 		Exception;
	E_Unknown_Role			Exception;
	E_Unknown_User			Exception;
	
	p_test_num				number;
	
Begin
	Case p_command
	
	When 'GRANT' then
		select  count(*) into p_test_num from hig_roles where hro_role = p_role;
		if p_test_num = 0 then  -- does the user exist?
			Raise E_Unknown_Role;
		else
			select count(*)into p_test_num from hig_users where hus_username = p_user;
			if p_test_num = 0 then  -- does the role exist?
				Raise E_Unknown_User;
			else
					select count (*) into p_test_num from hig_user_roles where hur_username = p_user and  hur_role in p_role;
				if p_test_num <> 0 then
					null;  -- do nothing, the item already exits
				else
					GRANT_ROLE(p_user, p_role, admin_option);
				end if;
			end if;
		end if;
	When 'REVOKE' then 
		select  count(*) into p_test_num from hig_roles where hro_role = p_role;
		if p_test_num = 0 then  -- does the user exist?
			Raise E_Unknown_Role;
		else
			select count(*)into p_test_num from hig_users where hus_username = p_user;
			if p_test_num = 0 then  -- does the role exist?
				Raise E_Unknown_User;
			else
				REVOKE_ROLE(p_user, p_role);
				
			end if;
		end if;
		
		commit;
	else
		raise E_Command_Unknown;
	
	end case;
	
EXCEPTION

when E_Command_Unknown then
	raise_application_error(-20001, 'Unknown Command: ' || p_command);
when E_Unknown_Role then 
	raise_application_error(-20002, 'Unknown User Role: ' || p_role);
when E_Unknown_User then 
	raise_application_error(-20002, 'Unknown User: ' || p_user);
when others  then
	raise_application_error(SQLCODE, SQLERRM);

end;


PROCEDURE GRANT_ROLE (p_username VARCHAR2, a_role IN VARCHAR2, admin_option in VARCHAR2 DEFAULT NULL) as
--
  ddl_error exception;
  pragma    exception_init( ddl_error, -20001 );
  ddl_errm  varchar2(70);
--
  proc_input varchar2(200) := '';
  return_val integer;
--
  cursor c1 is
    select privilege
    from   dba_sys_privs
    where  grantee = a_role;
--
-- This cursor delivers all the object privileges associated with
-- the role, but only those which are relevent to the schema which
-- owns this dataset. The implication is that all objects ought to
-- be owned in the same schema.
--
  cursor c2 is
    select d.privilege, d.owner, d.table_name
    from dba_tab_privs d
    where d.grantee = a_role
    and d.owner = ( select Sys_Context('NM3_SECURITY_CTX','USERNAME') from user_objects o
                    where o.object_name = 'HIG_OPTIONS'
                    and o.object_type = 'TABLE'
                    union
                    select o.table_owner from user_synonyms o
                    where o.synonym_name = 'HIG_OPTIONS');
--
begin

--
  if admin_option = 'YES' then
     proc_input := 'GRANT '||a_role||' TO '||p_username||' WITH ADMIN OPTION';
  else
     proc_input := 'GRANT '||a_role||' TO '||p_username;
  end if;

  hig.execute_ddl(proc_input);

  INSERT INTO hig_user_roles
         (hur_username
         ,hur_role
         ,hur_start_date
         )
  SELECT  p_username
         ,a_role
         ,Trunc(SYSDATE)
   FROM   DUAL
  WHERE NOT EXISTS (SELECT 1
                     FROM  hig_user_roles
                    WHERE  hur_username = p_username
                     AND   hur_role     = a_role
                   );

  
--
  proc_input := '';
--
-- granting role doesnt grant privileges associated with that role !
--
  for c1_rec in c1
   loop
     EXECUTE IMMEDIATE 'GRANT '||c1_rec.privilege||' TO '||p_username;
     null;
  end loop;
 
--
  --object provileges
  FOR c2_rec IN c2
  LOOP
     EXECUTE IMMEDIATE 'GRANT ' || c2_rec.privilege
                   || ' ON ' || c2_rec.owner || '.' || c2_rec.table_name
                   || ' TO ' ||p_username;
    null;
  END LOOP;
  

--
exception
   when ddl_error then
      ddl_errm := substr( sqlerrm, 12, 70 );
      
      
   when others then
      
      null;
end;

PROCEDURE REVOKE_ROLE (p_username VARCHAR2, l_role in VARCHAR) as
--
  ddl_error exception;
  pragma    exception_init( ddl_error, -20001 );
  ddl_errm  varchar2(70);
--
  proc_input varchar2(200) := '';
  return_val integer;
--
-- Since role based privileges have been passed on to the user
-- in order to allow functions to work within db procedures,
-- they need to be revoked. However, the privileges to be revoked
-- may be granted in another role. In this case the privilege
-- should not be revoked. This is the same cursor as the previous
-- version but only considers the privileges which have been
-- allocated to the user in the first place (hence the join on the 
-- outside query ).
--
  cursor c1 is
    select d.privilege 
    from dba_sys_privs d, dba_sys_privs u
    where d.grantee = l_role
    and   u.grantee = p_username
    and   d.privilege = u.privilege
    and   d.privilege not in ( 
                   select s.privilege 
                   from dba_sys_privs s, dba_role_privs r
                   where r.granted_role = s.grantee
                   and   r.grantee = p_username
                   and   r.granted_role != d.grantee );
--
  cursor c2 is
     select p.privilege, p.table_name, p.owner  
     from dba_tab_privs p, dba_tab_privs u
     where p.grantee = l_role 
     and   u.grantee = p_username
     and   p.privilege  = u.privilege
     and   p.table_name = u.table_name
     and   p.owner      = u.owner
     and   p.owner = ( select Sys_Context('NM3_SECURITY_CTX','USERNAME') from user_objects o
                       where o.object_name = 'HIG_OPTIONS'
                       and o.object_type = 'TABLE'
                       union
                       select o.table_owner from user_synonyms o
                       where o.synonym_name = 'HIG_OPTIONS' )
     and   ( p.privilege, p.table_name, p.owner )  not in 
                     ( select t.privilege, t.table_name, t.owner
                       from dba_tab_privs t, dba_role_privs r
                       where r.granted_role = t.grantee
                       and   t.grantee = r.granted_role
                       and   r.granted_role != p.grantee );

begin
--message( 'removing '||l_role );
--message( ' ' );

  
--
  proc_input := '';
--
  
  for c1_rec in c1 loop
     proc_input := 'REVOKE '||c1_rec.privilege||' FROM '
                   || p_username;
     hig.execute_ddl(proc_input);
  end loop;

  --object privileges
  FOR c2_rec IN c2 LOOP
     proc_input :=    'REVOKE ' || c2_rec.privilege
                   || ' ON ' || c2_rec.owner || '.' || c2_rec.table_name
                   ||' FROM ' ||p_username;

     EXECUTE IMMEDIATE proc_input;
  END LOOP;

  
--
  DELETE
    hig_user_roles
  WHERE
    hur_username = p_username
  AND
    hur_role = l_role;

  proc_input :=
       'REVOKE '||l_role||' FROM '||p_username;
  hig.execute_ddl(proc_input);
  

--
exception
   when ddl_error then
	null;
   when others then
      null;
      
end;

procedure CSV_LOADER(p_rec XNORFOLK_V_USER_ROLE%rowtype) as

begin
	MAIN(p_rec.puser, p_rec.prole, p_rec.pcommand, p_rec.padmin_option);
end;


end XNORFOLK_USER_ROLE;

/