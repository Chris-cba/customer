DROP VIEW TRANSINFO.XODOT_EA_CW_DIST_REG_LOOKUP;

/* Formatted on 8/18/2010 12:26:24 PM (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW TRANSINFO.XODOT_EA_CW_DIST_REG_LOOKUP
(
   EA_NUMBER,
   MAINT_SECTION_CREW_ID,
   MAINT_DIST_ID,
   MAINT_REG_ID
)
AS
   SELECT   ea.NE_UNIQUE EA_NUMBER,
            cw.CREW MAINT_SECTION_CREW_ID,
            cw.district MAINT_DIST_ID,
            'REGION ' || reg.ne_unique MAINT_REG_ID
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


