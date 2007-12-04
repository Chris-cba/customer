CREATE OR REPLACE TRIGGER A_I_HUS_interpath
           AFTER INSERT ON HIG_USERS
           FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/A_I_HUS_interpath.trg-arc   2.1   Dec 04 2007 08:41:52   Ian Turnbull  $
--       Module Name      : $Workfile:   A_I_HUS_interpath.trg  $
--       Date into PVCS   : $Date:   Dec 04 2007 08:41:52  $
--       Date fetched Out : $Modtime:   Dec 04 2007 08:41:30  $
--       PVCS Version     : $Revision:   2.1  $
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
   dbms_java.grant_permission('HIG_USER','SYS:java.io.FilePermission',l_INTERPATH,'read,write,delete');
end A_I_HUS_interpath;
/




