SELECT nm_debug.get_version FROM DUAL;

--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_tnzimsbat_sysopt.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_tnzimsbat_sysopt.sql
--       Date into SCCS   : 05/03/15 03:46:20
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
SELECT 'TNZIMSBAT'
      ,'XTNZ'
      ,'ARCIms Batch File Name'
      ,Null
      ,'The name of the batch file which is run to recreate the ArcIMS service'
      ,Null
      ,'VARCHAR2'
      ,'Y'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options
                   WHERE  hop_id = 'X_INSTANCE'
                  )
/
