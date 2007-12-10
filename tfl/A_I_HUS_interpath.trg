CREATE OR REPLACE TRIGGER A_I_HUS_interpath
           AFTER INSERT ON HIG_USERS
           FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/A_I_HUS_interpath.trg-arc   2.2   Dec 10 2007 09:45:42   Ian Turnbull  $
--       Module Name      : $Workfile:   A_I_HUS_interpath.trg  $
--       Date into PVCS   : $Date:   Dec 10 2007 09:45:42  $
--       Date fetched Out : $Modtime:   Dec 10 2007 09:45:30  $
--       PVCS Version     : $Revision:   2.2  $
--
--
--   Author : ITurnbull
--
-----------------------------------------------------------------------------
  l_interpath varchar2(200) ;
  
begin 
-- 
  SELECT huo_value
  into l_interpath
  FROM hig_user_options
 WHERE huo_hus_user_id = 1
   AND huo_id = 'INTERPATH';
--   
 insert into hig_user_options
   select :new.hus_user_id, 'INTERPATH',l_interpath
   from dual 
   where not exists ( select 1 from hig_user_options where huo_hus_user_id = :new.hus_user_id and huo_id = 'INTERPATH');
-- 
   dbms_java.grant_permission(:new.hus_username,'SYS:java.io.FilePermission',l_INTERPATH,'read,write,delete,execute');
--  
end A_I_HUS_interpath;
/




