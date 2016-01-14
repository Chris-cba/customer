create or replace
PROCEDURE GRANT_ROLE_PRIVS (p_username VARCHAR2, a_role IN VARCHAR2, admin_option in VARCHAR2 DEFAULT NULL) IS
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