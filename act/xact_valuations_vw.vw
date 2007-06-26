CREATE OR REPLACE FORCE VIEW xact_valuations_vw AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_valuations_vw.vw	1.1 03/14/05
--       Module Name      : xact_valuations_vw.vw
--       Date into SCCS   : 05/03/14 23:11:03
--       Date fetched Out : 07/06/06 14:33:51
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT Valuations view
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
       par.iit_ne_id iit_ne_id_parent
      ,par.iit_inv_type iit_inv_type_parent
      ,par.iit_start_date iit_start_date_parent
      ,par.iit_admin_unit iit_admin_unit_parent
      ,SUBSTR(nm3ausec.get_nau_unit_code(par.iit_admin_unit),1,10) nau_unit_code_parent
      ,par.iit_descr iit_descr_parent
      ,xval.*
 FROM  v_nm_val xval
      ,nm_inv_items par
      ,nm_inv_item_groupings iig
WHERE  xval.iit_ne_id    = iig.iig_item_id
 AND   iig.iig_parent_id = par.iit_ne_id
/
