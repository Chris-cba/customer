
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_tridweburl_sysopt.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_tridweburl_sysopt.sql
--       Date into SCCS   : 05/03/15 03:46:21
--       Date fetched Out : 07/06/06 14:40:40
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
INSERT INTO hig_options
      (hop_id
      ,hop_product
      ,hop_name
      ,hop_value
      ,hop_remarks
      ,hop_domain
      ,hop_datatype
      ,hop_mixed_case
      )
SELECT b.hop_id
      ,'TRID'
      ,'URL for TRID DAD (via LDAP)'
      ,'https://trid.transit.govt.nz/pls/nmcweb/'
      ,'URL for TRID DAD (via LDAP)'
      ,Null
      ,'VARCHAR2'
      ,'Y'
 FROM (SELECT 'TRIDWEBURL'   hop_id
        FROM  dual
      ) b
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options a
                   WHERE  a.hop_id = b.hop_id
                  )
/

