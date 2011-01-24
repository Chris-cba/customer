-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/subclass_update.sql-arc   3.1   Jan 24 2011 17:37:08   Chris.Strettle  $
--       Module Name      : $Workfile:   subclass_update.sql  $
--       Date into PVCS   : $Date:   Jan 24 2011 17:37:08  $
--       Date fetched Out : $Modtime:   Jan 24 2011 17:36:14  $
--       Version          : $Revision:   3.1  $
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
ALTER TRIGGER B_UPD_NM_ELEMENTS DISABLE;

UPDATE nm_elements_all
SET ne_sub_class = ( SELECT SUBSTR (iit_chr_attrib51, 1, 2) 
                       FROM nm_nw_ad_link_all, nm_inv_items_all 
                      WHERE nad_ne_id = ne_id 
                        AND nad_iit_ne_id = iit_ne_id 
                        AND nad_gty_type = 'SECT' 
                        AND nad_inv_type = 'HERM' )
WHERE EXISTS  ( SELECT 'X' 
                  FROM nm_nw_ad_link_all, nm_inv_items_all, nm_type_subclass
                 WHERE nad_ne_id = ne_id 
                   AND nad_iit_ne_id = iit_ne_id 
                   AND nad_gty_type = 'SECT' 
                   AND nad_inv_type = 'HERM' 
                   AND nsc_nw_type = nad_inv_type
                   AND nsc_sub_class = iit_chr_attrib51);

ALTER TRIGGER B_UPD_NM_ELEMENTS ENABLE;

COMMIT;