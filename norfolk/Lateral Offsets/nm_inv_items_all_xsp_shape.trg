CREATE OR REPLACE TRIGGER nm_inv_items_all_xsp_shape
AFTER UPDATE
OF IIT_X_SECT
ON NM_INV_ITEMS_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/nm_inv_items_all_xsp_shape.trg-arc   3.0   Feb 16 2011 14:27:22   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_inv_items_all_xsp_shape.trg  $
--       Date into PVCS   : $Date:   Feb 16 2011 14:27:22  $
--       Date fetched Out : $Modtime:   Feb 16 2011 14:26:16  $
--       Version          : $Revision:   3.0  $
--
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
BEGIN
  nm3sdo_dynseg.update_xsp( :new.iit_ne_id
                          , :new.iit_inv_type
                          , :new.iit_x_sect
                          , :new.iit_start_date
                          );
end;
/