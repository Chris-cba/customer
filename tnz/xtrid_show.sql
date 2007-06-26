CREATE OR REPLACE PROCEDURE xtrid_show (p_id NUMBER) IS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtrid_show.sql	1.1 03/15/05
--       Module Name      : xtrid_show.sql
--       Date into SCCS   : 05/03/15 03:46:23
--       Date fetched Out : 07/06/06 14:40:43
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
BEGIN
   xtnz_lar_mail_merge.show_single_inv_item_details(pi_iit_ne_id=>p_id);
END xtrid_show;
/
