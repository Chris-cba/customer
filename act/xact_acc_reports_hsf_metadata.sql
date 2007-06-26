
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_acc_reports_hsf_metadata.sql	1.1 03/15/05
--       Module Name      : xact_acc_reports_hsf_metadata.sql
--       Date into SCCS   : 05/03/15 03:47:25
--       Date fetched Out : 07/06/06 14:33:39
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------

INSERT INTO hig_system_favourites
      (hsf_user_id
      ,hsf_parent
      ,hsf_child
      ,hsf_descr
      ,hsf_type
      )
SELECT 1
      ,'ROOT'
      ,'ACC_REPORTS'
      ,'Accident Reports'
      ,'F'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_system_favourites
                   WHERE  hsf_parent = 'ROOT'
                    AND   hsf_child  = 'ACC_REPORTS'
                  )
/

INSERT INTO hig_system_favourites
      (hsf_user_id
      ,hsf_parent
      ,hsf_child
      ,hsf_descr
      ,hsf_type
      )
SELECT 1
      ,'ACC_REPORTS'
      ,hmo_module
      ,hmo_title
      ,'M'
 FROM  hig_modules
WHERE  hmo_module LIKE 'XACT%'
 AND   hmo_application = 'ACC'
 AND   hmo_use_gri     = 'Y'
 AND   NOT EXISTS (SELECT 1
                    FROM  hig_system_favourites
                   WHERE  hsf_parent = 'ACC_REPORTS'
                    AND   hsf_child  = hmo_module
                  )
/

