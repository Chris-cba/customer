CREATE OR REPLACE VIEW xexor_links_for_dtims AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_links_for_dtims.vw	1.1 03/14/05
--       Module Name      : xexor_links_for_dtims.vw
--       Date into SCCS   : 05/03/14 23:11:04
--       Date fetched Out : 07/06/06 14:33:52
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       ne_link.ne_id
      ,ne_link.ne_unique
      ,ne_link.ne_descr
      ,ne_link.ne_no_start start_node
      ,ne_link.ne_no_end   end_node
      ,ne_link.ne_length ne_length_m
      ,nm_ne_id_in route_ne_id
      ,ne_road.ne_unique route_ne_unique
      ,nm_seq_no route_seq_no
      ,nm_slk route_begin_mp
      ,nm_end_slk route_end_mp
 FROM  nm_elements ne_link
      ,nm_members
      ,nm_elements ne_road
WHERE  ne_link.ne_nt_type  = 'LINK'
 AND   nm_ne_id_of = ne_link.ne_id
 AND   nm_ne_id_in = ne_road.ne_id
ORDER BY ne_unique
/
