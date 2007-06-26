--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_travel_time_create_nmg.sql	1.1 03/15/05
--       Module Name      : xmrwa_travel_time_create_nmg.sql
--       Date into SCCS   : 05/03/15 00:46:09
--       Date fetched Out : 07/06/06 14:38:35
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
INSERT INTO nm_mail_groups
SELECT nmg_id_seq.NEXTVAL
      ,'NET_NOTIFY_TRAVEL'
 FROM  DUAL
WHERE NOT EXISTS (SELECT 1 FROM nm_mail_groups WHERE nmg_name = 'NET_NOTIFY_TRAVEL')
/


--INSERT INTO nm_mail_users
--SELECT nmu_id_seq.NEXTVAL, 'Jon Mills', 'jmills@exor.com.au', 1
-- FROM  DUAL
--WHERE NOT EXISTS (SELECT 1 FROM nm_mail_users WHERE nmu_hus_user_id=1)
--/
--
--INSERT INTO nm_mail_group_membership
--SELECT nmg_id
--      ,nmu_id
-- FROM  nm_mail_groups, nm_mail_users
--WHERE  nmg_name = 'NET_NOTIFY_TRAVEL'
-- AND nmu_name = 'Jon Mills'
--/
--
