CREATE OR REPLACE VIEW xtnz_load_inv_on_route AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_load_inv_on_route.vw	1.1 03/15/05
--       Module Name      : xtnz_load_inv_on_route.vw
--       Date into SCCS   : 05/03/15 03:46:10
--       Date fetched Out : 07/06/06 14:40:32
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
       SUBSTR(ne_group,1,3)     state_hwy
      ,SUBSTR(ne_name_1,1,4)    start_rs
      ,ne_length                start_mp
      ,SUBSTR(ne_sub_class,1,1) start_cwy
      ,SUBSTR(ne_name_1,1,4)    end_rs
      ,ne_length                end_mp
      ,SUBSTR(ne_sub_class,1,1) end_cwy
      ,TO_NUMBER(Null)          iit_ne_id
      ,ne_nt_type               iit_inv_type
      ,TO_DATE(null)            nm_start_date
 FROM  nm_elements_all
WHERE  1=2
/
