CREATE OR REPLACE VIEW xexor_xsp_for_dtims AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_xsp_for_dtims.vw	1.1 03/14/05
--       Module Name      : xexor_xsp_for_dtims.vw
--       Date into SCCS   : 05/03/14 23:11:06
--       Date fetched Out : 07/06/06 14:33:53
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       xsr_x_sect_value
      ,xsr_descr
 FROM  xsp_restraints
WHERE  xsr_ity_inv_code = 'LANE'
/
