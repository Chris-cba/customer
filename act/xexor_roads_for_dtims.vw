CREATE OR REPLACE VIEW xexor_roads_for_dtims AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_roads_for_dtims.vw	1.1 03/14/05
--       Module Name      : xexor_roads_for_dtims.vw
--       Date into SCCS   : 05/03/14 23:11:05
--       Date fetched Out : 07/06/06 14:33:52
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       ne_id
      ,ne_unique
      ,ne_descr
      ,nm3net.get_max_true (ne_id) maximum_true_distance_km
 FROM  nm_elements
WHERE  ne_nt_type = 'ROAD'
ORDER BY ne_unique
/
