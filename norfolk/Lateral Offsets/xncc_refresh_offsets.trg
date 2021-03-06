CREATE OR REPLACE TRIGGER xncc_refresh_offsets
   AFTER INSERT OR UPDATE
   ON NM_MEMBERS_ALL 
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/xncc_refresh_offsets.trg-arc   3.2   Jan 19 2011 16:39:30   Chris.Strettle  $
--       Module Name      : $Workfile:   xncc_refresh_offsets.trg  $
--       Date into PVCS   : $Date:   Jan 19 2011 16:39:30  $
--       Date fetched Out : $Modtime:   Jan 19 2011 16:37:42  $
--       PVCS Version     : $Revision:   3.2  $
--       Based on SCCS version : 
--
--   Author : Chris Strettle
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
   l_ne   int_array := nm3array.init_int_array;
BEGIN
   SELECT DISTINCT nm_ne_id_of
     BULK COLLECT INTO l_ne.ia
     FROM xncc_herm_xsp_temp;
   --
   FOR i IN 1 .. l_ne.ia.COUNT
   LOOP
      nm3sdo.change_affected_shapes (nm3nsgesu.get_esu_theme_id, l_ne.ia (i));
   END LOOP;
   --
   DELETE FROM xncc_herm_xsp_temp;
END;
/