CREATE OR REPLACE  VIEW XODOT_EA_CW_DIST_REG_LOOKUP
(
   EA_NUMBER,
   MAINT_SECTION_CREW_ID,
   MAINT_DIST_ID,
   MAINT_REG_ID,
   ea_ne_id
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/roadside_barrier/admin/views/xodot_ea_cw_dist_reg_lookup.vw-arc   1.0   Oct 22 2010 10:54:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_ea_cw_dist_reg_lookup.vw  $
--       Date into PVCS   : $Date:   Oct 22 2010 10:54:14  $
--       Date fetched Out : $Modtime:   Oct 22 2010 10:17:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton           
--                                   
--                        
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
   ea.NE_UNIQUE EA_NUMBER,
            cw.CREW MAINT_SECTION_CREW_ID,
            cw.district MAINT_DIST_ID,
            reg.ne_unique MAINT_REG_ID,
            ea.ne_id
     FROM   v_nm_seea_seea_nt ea,
            nm_members cm,
            v_nm_SECW_SECW_NT cw,
            v_nm_dist_dist_nt dist,
            nm_members rm,
            v_nm_REG_REG_NT reg
    WHERE       cm.nm_obj_type = 'SECW'
            AND cm.nm_ne_id_in = cw.ne_id
            AND ea.ne_id = cm.nm_ne_id_of
            AND cw.District = dist.ne_unique
            AND rm.nm_obj_type = 'REG'
            AND dist.ne_id = rm.nm_ne_id_of
            AND rm.nm_ne_id_in = reg.ne_id;