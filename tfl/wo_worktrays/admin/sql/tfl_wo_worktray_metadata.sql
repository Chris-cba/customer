--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/wo_worktrays/admin/sql/tfl_wo_worktray_metadata.sql-arc   3.0   Oct 25 2010 10:21:32   Ian.Turnbull  $
--       Module Name      : $Workfile:   tfl_wo_worktray_metadata.sql  $
--       Date into PVCS   : $Date:   Oct 25 2010 10:21:32  $
--       Date fetched Out : $Modtime:   Oct 25 2010 10:17:10  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_modules
SET TERM OFF


INSERT INTO hig_modules
(hmo_module
,hmo_title
,hmo_filename
,hmo_module_type
,hmo_fastpath_invalid
,hmo_use_gri
,hmo_application)
select 'IM511001','Work Order To Instruct - Work Tray','511000:IM511001','WEB','Y','N','IM' from dual
where not exists (select 1 from hi_modules
                  where hmo_module = 'IM511001');

INSERT INTO hig_modules
(hmo_module
,hmo_title
,hmo_filename
,hmo_module_type
,hmo_fastpath_invalid
,hmo_use_gri
,hmo_application)
select 'IM511002','Re-Submitted Work Orders Report - Work Tray','511000:IM511002','WEB','Y','N','IM' from dual
where not exists (select 1 from hi_modules
                  where hmo_module = 'IM511002');
				  


INSERT INTO hig_modules
(hmo_module
,hmo_title
,hmo_filename
,hmo_module_type
,hmo_fastpath_invalid
,hmo_use_gri
,hmo_application)
select 'IM511003','Work Order - Draft Status - Work Tray','511000:IM511003','WEB','Y','N','IM'
where not exists (select 1 from hi_modules
                  where hmo_module = 'IM511003');


SET TERM ON
PROMPT hig_module_roles
SET TERM OFF			  


insert into hig_module_roles
(HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'IM511001', 'MAI_USER','NORMAL' from dual
where not exists (select 1 from hig_module_roles
                  where hmr_module = 'IM511001'
				  and hmr_role = 'MAI_USER');

insert into hig_module_roles
(HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'IM511002', 'MAI_USER','NORMAL' from dual
where not exists (select 1 from hig_module_roles
                  where hmr_module = 'IM511002'
				  and hmr_role = 'MAI_USER');
				  
insert into hig_module_roles
(HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'IM511002', 'MAI_USER','NORMAL' from dual
where not exists (select 1 from hig_module_roles
                  where hmr_module = 'IM511002'
				  and hmr_role = 'MAI_USER');				  