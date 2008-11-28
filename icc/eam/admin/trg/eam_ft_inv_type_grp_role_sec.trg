CREATE OR REPLACE TRIGGER eam_ft_inv_type_grp_role_sec
       BEFORE  INSERT OR UPDATE OR DELETE
         ON    EAM_FT_INV_TYPE_GROUPINGS_ALL
       FOR EACH ROW
DECLARE
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/icc/eam/admin/trg/eam_ft_inv_type_grp_role_sec.trg-arc   1.0   Nov 28 2008 11:02:12   mhuitson  $
--       Module Name      : $Workfile:   eam_ft_inv_type_grp_role_sec.trg  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:02:12  $
--       Date fetched Out : $Modtime:   Sep 06 2007 15:16:34  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
--
BEGIN
--
   IF nm3user.is_user_unrestricted
    THEN
      RETURN;
   END IF;
--
   IF DELETING
    THEN
      l_inv_type := :OLD.EFTG_inv_type;
   ELSE
      l_inv_type := :NEW.EFTG_inv_type;
   END IF;
--
   IF NVL(nm3inv.get_inv_mode_by_role(l_inv_type,USER),nm3type.c_nvl) != nm3type.c_normal
    THEN
      RAISE_APPLICATION_ERROR(-20901,'You do not have permission via NM_INV_TYPE_ROLES to perform this action');
   END IF;
--
END eam_ft_inv_type_grp_role_sec;
/



