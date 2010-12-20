-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/evaluation_views.sql-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   evaluation_views.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:32:02  $
--       Version          : $Revision:   3.0  $
--
-- THE FOLLOWING SCRIPT WILL PRODUCE 2 VIEWS THAT WILL HELP YOU ASSESS THE 
-- CURRENT STATE OF XSP DATA ON YOUR DATABASE.
-- 
-- The following show all invalid XSP/SUBCLASS combinations.
-- xsp_invalid_temp -- With ids
-- xsp_invalid_summary_temp -- a summary with counts
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
-- Create a temp table to allow you to do a number of checks without having to re-search.
--
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE xsp_temp';
EXCEPTION
WHEN OTHERS THEN
  NULL;
END;
/
CREATE TABLE xsp_temp
AS
   SELECT ad.iit_chr_attrib51 subclass, i.iit_x_sect xsp, i.iit_ne_id ne_id
     FROM nm_inv_items_all i,
          nm_members_all im,
          nm_members_all h,
          nm_nw_ad_link_all l,
          nm_inv_items_all ad
    WHERE     i.iit_x_sect IS NOT NULL
          AND i.iit_ne_id = im.nm_ne_id_in
          AND im.nm_ne_id_of = h.nm_ne_id_of
          AND h.nm_obj_type = 'SECT'
          AND h.nm_ne_id_in = l.nad_ne_id
          AND nad_iit_ne_id = ad.iit_ne_id
          AND NOT EXISTS
                     (SELECT 1
                        FROM nm_nw_xsp_temp
                       WHERE     nwx_nw_type = 'HERM'
                             AND nwx_nsc_sub_class = ad.iit_chr_attrib51
                             AND i.iit_x_sect = nwx_x_sect);
-- 

CREATE OR REPLACE VIEW xsp_invalid_temp AS
SELECT DISTINCT xsp, ne_id
FROM xsp_temp 
ORDER BY 1,2;

--

CREATE OR REPLACE VIEW xsp_invalid_summary_temp
AS
     SELECT subclass, xsp, COUNT (*) sx_count
       FROM xsp_temp
   GROUP BY subclass, xsp;
   
--