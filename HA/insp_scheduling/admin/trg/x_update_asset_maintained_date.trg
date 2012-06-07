CREATE OR REPLACE TRIGGER x_update_asset_maintained_date
AFTER UPDATE
ON WORK_ORDER_LINES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
/******************************************************************************
   NAME:       x_update_asset_maintained_date
   PURPOSE:   The ‘Date Last Maintained’ value will be automatically updated when a Work Order Line associated with an Asset is completed.  
              The date will be updated to the Work Order Line completion date.  This should include both Defect and Cyclic Work Orders.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        31/MAY/2012   Paul Stanton     1. Created this trigger.
   
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/trg/x_update_asset_maintained_date.trg-arc   1.0   Jun 07 2012 08:08:58   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_update_asset_maintained_date.trg  $
--       Date into PVCS   : $Date:   Jun 07 2012 08:08:58  $
--       Date fetched Out : $Modtime:   Jun 06 2012 17:25:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2012
-----------------------------------------------------------------------------
--
******************************************************************************/


   CURSOR chk_asset_attrib (p_defect_id defects.def_defect_id%TYPE) IS
   SELECT * FROM nm_inv_type_attribs_all
   WHERE ita_inv_type = (SELECT iit_inv_type FROM nm_inv_items_all
                         WHERE iit_ne_id = (SELECT def_iit_item_id FROM defects
                                            WHERE def_defect_id = p_defect_id))
   AND ita_attrib_name = 'IIT_XTRA_DATE_1'
   AND ita_scrn_text = 'Date Last Maintained';

   
   CURSOR get_asset_id (p_defect_id defects.def_defect_id%TYPE) IS
   SELECT def_iit_item_id FROM defects
   WHERE def_defect_id = p_defect_id;
   
   l_asset_id nm_inv_items_all.iit_ne_id%TYPE;
   
      
BEGIN
nm_debug.debug_on;
nm_debug.debug('in trigger '||:new.wol_date_complete||' code '||:NEW.WOL_STATUS_CODE);
  IF :new.wol_date_complete IS NOT NULL AND :NEW.WOL_STATUS_CODE = 'COMPLETED' THEN
   nm_debug.debug('in the iif');
     FOR i in chk_asset_attrib(:new.wol_def_defect_id) LOOP
      nm_debug.debug('in the cursor');
        OPEN get_asset_id(:new.wol_def_defect_id);
        FETCH get_asset_id INTO l_asset_id;
        CLOSE get_asset_id;
     nm_debug.debug('update '||l_asset_id);
        UPDATE nm_inv_items_all
        SET IIT_XTRA_DATE_1 = :new.wol_date_complete
        WHERE iit_ne_id = l_asset_id;
  
     END LOOP;
  
  END IF;
  
END x_update_asset_maintained_date;
/