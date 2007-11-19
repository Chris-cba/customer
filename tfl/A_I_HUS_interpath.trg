CREATE OR REPLACE TRIGGER A_I_HUS_interpath
           AFTER INSERT ON HIG_USERS
           FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/A_I_HUS_interpath.trg-arc   2.0   Nov 19 2007 13:31:48   smarshall  $
--       Module Name      : $Workfile:   A_I_HUS_interpath.trg  $
--       Date into PVCS   : $Date:   Nov 19 2007 13:31:48  $
--       Date fetched Out : $Modtime:   Nov 19 2007 08:28:46  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : ITurnbull
--
-----------------------------------------------------------------------------
  l_interpath varchar2(200) ;
  
begin 
  SELECT huo_value
  into l_interpath
  FROM hig_user_options
 WHERE huo_hus_user_id = 1
   AND huo_id = 'INTERPATH';
   dbms_java.grant_permission(:new.hus_username,'SYS:java.io.FilePermission',l_INTERPATH,'read');
end A_I_HUS_interpath;
/
