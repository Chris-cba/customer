CREATE OR REPLACE TRIGGER eam_ft_inv_type_grp_biu_trg
       BEFORE  INSERT OR UPDATE
         ON    EAM_FT_INV_TYPE_GROUPINGS_ALL
       FOR EACH ROW
DECLARE
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/icc/eam/admin/trg/eam_ft_inv_type_grp_biu_trg.trg-arc   1.0   Nov 28 2008 11:02:10   mhuitson  $
--       Module Name      : $Workfile:   eam_ft_inv_type_grp_biu_trg.trg  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:02:10  $
--       Date fetched Out : $Modtime:   Sep 24 2007 13:14:12  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--
   l_eftg_rec  eam_ft_inv_type_groupings_all%ROWTYPE;

BEGIN


   IF :NEW.eftg_id IS NULL THEN
      select eam_eftg_id_seq.NEXTVAL into :NEW.eftg_id from dual ;
   END IF;

   l_eftg_rec.eftg_inv_type         := :NEW.eftg_inv_type;
   l_eftg_rec.eftg_fk_column        := :NEW.eftg_fk_column;
   l_eftg_rec.eftg_descr_column     := :NEW.eftg_descr_column;   
   l_eftg_rec.eftg_parent_inv_type  := :NEW.eftg_parent_inv_type;
   l_eftg_rec.eftg_date_created     := :NEW.eftg_date_created;
   l_eftg_rec.eftg_date_modified    := :NEW.eftg_date_modified;
   l_eftg_rec.eftg_modified_by      := :NEW.eftg_modified_by;
   l_eftg_rec.eftg_created_by       := :NEW.eftg_created_by; 

   eam_asset.validate_eftg_rec(pi_eftg_rec => l_eftg_rec);

END eam_ft_inv_type_grp_biu_trg;
/
