CREATE OR REPLACE VIEW XODOT_RWY_POINT_LOCS (ASSET_INV_TYPE, ASSET_IIT_NE_ID, HWY, HWY_MP)as
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/rics_point_data/xodot_rwy_point_locs.vw-arc   3.0   Sep 10 2010 14:53:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_rwy_point_locs.vw  $
--       Date into PVCS   : $Date:   Sep 10 2010 14:53:24  $
--       Date fetched Out : $Modtime:   Sep 10 2010 12:54:56  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton           
--                        
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
c.iit_inv_type
       ,c.iit_ne_id    
       ,b.route_id
      , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(a.nm_begin_mp,b.nm_begin_mp)) - b.nm_begin_mp, 
               b.nm_slk + (b.nm_end_mp  - least(a.nm_end_mp, b.nm_end_mp))) start_point
FROM nm_members a
    , (SELECT ne_unique route_id
            , nm_slk
            , nm_end_slk
                , nm_end_slk - nm_slk section_length
                , nm_begin_mp
                , nm_end_mp
                , nm_ne_id_of
                , nm_cardinality
        FROM v_nm_hwy_nt
                , nm_members
        WHERE ne_id = nm_ne_id_in) b
    , nm_inv_items c
WHERE a.nm_ne_id_of = b.nm_ne_id_of
and a.nm_ne_id_in = c.iit_ne_id
and c.iit_inv_type  IN ('ATR','RLRD','LOCL','REST','STKP','MPST','CTLG','ROAD','ENGS','ICHG','UTLC','TRAI','VRTG','SUMT','OPOI','OUTP','NNBI','MSTR','RDBL','WATR','MPHS','SCAL','SNBR','POPL');
