--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/hbud/install/hbudroles.sql-arc   3.0   Sep 09 2010 14:52:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   hbudroles.sql  $
--       Date into PVCS   : $Date:   Sep 09 2010 14:52:48  $
--       Date fetched Out : $Modtime:   Sep 09 2010 14:39:48  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
rem --------------------------------------------------------------------------
rem	Create a role for granting to the HBUD administrator.

set feedback off

PROMPT CREATE ROLE TI_APPROLE_HBUD_ADMIN;
CREATE ROLE TI_APPROLE_HBUD_ADMIN;
BEGIN
   EXECUTE IMMEDIATE 'grant TI_APPROLE_HBUD_ADMIN to '||USER;
   EXECUTE IMMEDIATE 'grant TI_APPROLE_HBUD_ADMIN to '||USER||' with admin option';
END;
/

GRANT SELECT ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT INSERT ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT UPDATE ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT DELETE ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT LOCK ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE ANY TABLE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE ANY VIEW TO TI_APPROLE_HBUD_ADMIN;
GRANT EXECUTE ANY PROCEDURE TO TI_APPROLE_HBUD_ADMIN;
GRANT SELECT ANY SEQUENCE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE SESSION TO TI_APPROLE_HBUD_ADMIN;

GRANT ALTER SESSION TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE PUBLIC SYNONYM TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE TRIGGER TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE SEQUENCE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE ROLE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE SYNONYM TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE PROCEDURE TO TI_APPROLE_HBUD_ADMIN;
GRANT CREATE USER TO TI_APPROLE_HBUD_ADMIN;
GRANT GRANT ANY PRIVILEGE TO TI_APPROLE_HBUD_ADMIN;
GRANT GRANT ANY ROLE TO TI_APPROLE_HBUD_ADMIN;
GRANT DROP PUBLIC SYNONYM TO TI_APPROLE_HBUD_ADMIN;
GRANT DROP USER TO TI_APPROLE_HBUD_ADMIN;
GRANT ALTER USER TO TI_APPROLE_HBUD_ADMIN;



rem --------------------------------------------------------------------------
rem	Create a role for granting to readonly users.

PROMPT CREATE ROLE TI_APPROLE_HBUD_USER;
CREATE ROLE TI_APPROLE_HBUD_USER;
BEGIN
   EXECUTE IMMEDIATE 'grant TI_APPROLE_HBUD_USER to '||USER;
   EXECUTE IMMEDIATE 'grant TI_APPROLE_HBUD_USER to '||USER||' with admin option';
END;
/

GRANT SELECT ANY TABLE TO TI_APPROLE_HBUD_USER;
GRANT LOCK ANY TABLE TO TI_APPROLE_HBUD_USER;
GRANT CREATE TABLE TO TI_APPROLE_HBUD_USER;
GRANT CREATE VIEW  TO TI_APPROLE_HBUD_USER;
GRANT SELECT ANY SEQUENCE TO TI_APPROLE_HBUD_USER;
GRANT EXECUTE ANY PROCEDURE TO TI_APPROLE_HBUD_USER;
GRANT CREATE SESSION TO TI_APPROLE_HBUD_USER;

rem --------------------------------------------------------------------------

rem ---------------------------------------------------------------------------
rem These roles can now be assigned to Oracle users.

-- Grant all the privs for each role
BEGIN
   FOR cs_rec IN (SELECT hus_username,hro_role,hus_start_date
                   FROM  hig_users
                        ,hig_roles
                  WHERE  hus_username = USER
                  UNION ALL
                  SELECT hus_username,'JAVA_ADMIN',hus_start_date
                   FROM  hig_users
                  WHERE  hus_username = USER
                 )
    LOOP
      grant_role_to_user (p_user       => cs_rec.hus_username
                         ,p_role       => cs_rec.hro_role
                         ,p_admin      => TRUE
                         ,p_start_date => cs_rec.hus_start_date
                         );
   END LOOP;
END;
/
--
COMMIT;




REM End of command file
REM
