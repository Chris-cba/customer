-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/remove_metadata.sql-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   remove_metadata.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:39:24  $
--       Version          : $Revision:   3.0  $ 
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
ALTER TRIGGER nm_inv_items_mand_check DISABLE;

UPDATE nm_inv_items_all 
SET iit_chr_attrib51 = null
WHERE iit_inv_type = 'HERM'
AND iit_chr_attrib51 IS NOT NULL;

ALTER TRIGGER nm_inv_items_mand_check ENABLE;

DELETE 
FROM nm_inv_type_attribs 
WHERE ita_inv_type = 'HERM'
AND ita_attrib_name = 'IIT_CHR_ATTRIB51';

COMMIT;