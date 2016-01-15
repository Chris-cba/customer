--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/hbud/Version_X/admin/sql/hbud_uninstall.sql-arc   1.0   Jan 15 2016 19:32:38   Sarah.Williams  $
--       Module Name      : $Workfile:   hbud_uninstall.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 19:32:38  $
--       Date fetched Out : $Modtime:   Sep 09 2010 20:39:44  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
drop table XODOT_HBUD_EXTRACT
/

drop package xodot_hbud_extract_process
/

drop role TI_APPROLE_HBUD_ADMIN
/

drop role TI_APPROLE_HBUD_USER
/

delete from HIG_MODULE_ROLES
WHERE HMR_MODULE = 'HBUD_LIST'
AND HMR_ROLE = 'TI_APPROLE_HBUD_ADMIN'
/

delete from HIG_MODULE_ROLES
WHERE HMR_MODULE = 'HBUD_RUN'
AND HMR_ROLE = 'TI_APPROLE_HBUD_ADMIN'
/

delete FROM HIG_ROLES
WHERE HRO_ROLE = 'TI_APPROLE_HBUD_USER'
/

delete FROM HIG_ROLES
WHERE HRO_ROLE = 'TI_APPROLE_HBUD_ADMIN'
/

delete FROM HIG_STANDARD_FAVOURITES
WHERE HSTF_PARENT = 'HBUD'
AND  HSTF_CHILD = 'HBUD_LIST'
/


delete FROM HIG_STANDARD_FAVOURITES
WHERE HSTF_PARENT = 'HBUD'
AND  HSTF_CHILD = 'HBUD_RUN'
/

delete FROM HIG_STANDARD_FAVOURITES
WHERE HSTF_PARENT = 'FAVOURITES'
AND  HSTF_CHILD = 'HBUD'
/


delete FROM GRI_MODULES
WHERE GRM_MODULE = 'HBUD_RUN'
/

delete FROM HIG_MODULES
WHERE HMO_MODULE = 'HBUD_LIST'
/

delete FROM HIG_MODULES
WHERE HMO_MODULE = 'HBUD_RUN'
/

delete FROM HIG_PRODUCTS
WHERE HPR_PRODUCT = 'HBUD'
/



