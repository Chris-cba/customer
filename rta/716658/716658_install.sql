--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/rta/716658/716658_install.sql-arc   1.0   Mar 17 2009 16:30:24   cstrettle  $
--       Module Name      : $Workfile:   716658_install.sql  $
--       Date into PVCS   : $Date:   Mar 17 2009 16:30:24  $
--       Date fetched Out : $Modtime:   Mar 17 2009 16:13:10  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--
PROMPT **----------- START CREATE NM_NODE_POINTS SCRIPT --------------**

PROMPT DROP NM_NODE_POINTS VIEW  
BEGIN
--
EXECUTE IMMEDIATE 'DROP VIEW NM_NODE_POINTS';
--
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/
--
--------------------------------------------------------------------------------
--
PROMPT CREATE NM_NODE_POINTS VIEW
@nm_node_points.vw
--
PROMPT CREATE NM_NODE_POINTS_INSTEAD_TRG Trigger
@nm_node_points_instead_trg.trg
--
PROMPT **----------- END CREATE NM_NODE_POINTS SCRIPT --------------**