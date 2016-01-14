create or replace PROCEDURE REVOKE_ROLE_PRIVS (p_username VARCHAR2, l_role in VARCHAR) IS
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

/