CREATE OR REPLACE VIEW xexor_lanes_for_dtims AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_lanes_for_dtims.vw	1.1 03/14/05
--       Module Name      : xexor_lanes_for_dtims.vw
--       Date into SCCS   : 05/03/14 23:11:03
--       Date fetched Out : 07/06/06 14:33:51
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
      ,lane_width
      ,lane_naasra_class
      ,lane_pave_type
      ,ne_id_of datum_ne_id
      ,datum_ne_unique
      ,nm_begin_mp datum_begin_mp
      ,nm_end_mp datum_end_mp
      ,route_ne_unique
      ,route_ne_id
      ,route_slk_start
      ,route_slk_end
 FROM  v_nm_lane_nw
/

