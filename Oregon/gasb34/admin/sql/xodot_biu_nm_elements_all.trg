CREATE OR REPLACE TRIGGER XODOT_BIU_NM_ELEMENTS_ALL  
BEFORE INSERT OR UPDATE OF NE_NAME_2 ON NM_ELEMENTS_ALL
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/gasb34/admin/sql/xodot_biu_nm_elements_all.trg-arc   3.0   Sep 15 2010 09:57:56   ian.turnbull  $
--       Module Name      : $Workfile:   xodot_biu_nm_elements_all.trg  $
--       Date into PVCS   : $Date:   Sep 15 2010 09:57:56  $
--       Date fetched Out : $Modtime:   Sep 15 2010 09:54:04  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
--    XODOT_AIU_NM_ELEMENTS_ALL
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
   
     
IF xodot_gasb34_package.g_in_process = FALSE THEN

   IF :NEW.ne_nt_type = 'TRNF' THEN
      IF :old.NE_NAME_2 IS NULL AND :new.NE_NAME_2 IS NOT NULL THEN
         -- If Transefer date is populated for the 1st time then  
           
           -- for each member we will update the Reason for Change (NE_NAME_2)
		   -- with Official Transfer Type (NE_VERSION_NO) of the TRNF group
		   -- and the Document ID (NE_GROUP)
		   -- with Official Transfer ID (NE_NSG_REF) of the TRNF group
		   
            xodot_gasb34_package.pop_table(p_NE_VERSION_NO => NVL(:new.NE_VERSION_NO, :old.ne_version_no),
			                               p_NE_NSG_REF => NVL(:new.NE_NSG_REF, :old.NE_NSG_REF),
			                               p_ne_id => :new.ne_id);		   
           
		   
		   
      ELSE
        -- Transfer date already populated
        -- Do Nothing
        null;

      END IF;

   END IF;	  
END IF;   

END xodot_transfer_trg;
/