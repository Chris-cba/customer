CREATE OR REPLACE VIEW xexor_traf_counts_for_dtims AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_traf_counts_for_dtims.vw	1.1 03/14/05
--       Module Name      : xexor_traf_counts_for_dtims.vw
--       Date into SCCS   : 05/03/14 23:11:05
--       Date fetched Out : 07/06/06 14:33:53
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       iit_ne_id
      ,iit_x_sect
      ,SEG_AADT
      ,SEG_PCT_HEAVY
      ,ne_id_of datum_ne_id
      ,datum_ne_unique
      ,nm_begin_mp datum_begin_mp
      ,nm_end_mp datum_end_mp
      ,route_ne_unique
      ,route_ne_id
      ,route_slk_start
      ,route_slk_end
 FROM  v_nm_seg_nw
WHERE  nm_begin_mp < nm_end_mp
 AND   nm_begin_mp >= 0
 AND   SEG_AADT IS NOT NULL
/

