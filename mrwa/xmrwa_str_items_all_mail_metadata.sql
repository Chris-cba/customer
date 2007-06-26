
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_str_items_all_mail_metadata.sql	1.1 03/15/05
--       Module Name      : xmrwa_str_items_all_mail_metadata.sql
--       Date into SCCS   : 05/03/15 00:46:05
--       Date fetched Out : 07/06/06 14:38:29
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
INSERT INTO nm_mail_groups
      (nmg_id
      ,nmg_name
      )
SELECT nm3seq.next_nmg_id_seq
      ,'STR_TOP_USERS'
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_mail_groups
                   WHERE  nmg_name = 'STR_TOP_USERS'
                  )
/

