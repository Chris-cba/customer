-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/Reverse_lat_offsets.sql-arc   3.0   Mar 04 2011 14:08:14   Ade.Edwards  $
--       Module Name      : $Workfile:   Reverse_lat_offsets.sql  $
--       Date into PVCS   : $Date:   Mar 04 2011 14:08:14  $
--       Date fetched Out : $Modtime:   Mar 04 2011 13:23:38  $
--       Version          : $Revision:   3.0  $
--       Author           : Chris Strettle
--
-- Script will switch all offset layers offsets from right to left / left to right of the ESU.
-- 
--
-------------------------------------------------------------------------
TRUNCATE TABLE herm_xsp;
--
UPDATE nm_nw_xsp
SET nwx_offset = nwx_offset * (-1);
--
BEGIN
XNCC_HERM_XSP.INS_HERM_XSP;
END;
/
--
BEGIN
--
NM_DEBUG.DEBUG_ON;
--
FOR i IN (  SELECT DISTINCT nith_nit_id
              FROM nm_inv_themes, nm_themes_all
             WHERE nith_nth_theme_id = nth_theme_id
               AND nth_xsp_column = 'IIT_X_SECT')
LOOP
  BEGIN
    NM3SDO_DYNSEG.SET_OFFSET_FLAG_ON;
    NM3LAYER_TOOL.REFRESH_ASSET_LAYER(i.nith_nit_id);
    NM_DEBUG.DEBUG(i.nith_nit_id || ' layer successfully reversed');
  EXCEPTION
  WHEN OTHERS THEN
    NM_DEBUG.DEBUG(i.nith_nit_id || ' layer failed to refresh due to the following error:');
    NM_DEBUG.DEBUG(SQLERRM);
    
  END;
END LOOP;
--
NM_DEBUG.DEBUG_OFF;
--
NM3SDO_DYNSEG.SET_OFFSET_FLAG_OFF;
--
COMMIT;
--
END;
/
