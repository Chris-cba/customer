CREATE OR REPLACE FORCE VIEW nm_node_points (
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/rta/716658/nm_node_points.vw-arc   1.0   Mar 17 2009 16:21:46   cstrettle  $
--       Module Name      : $Workfile:   nm_node_points.vw  $
--       Date into PVCS   : $Date:   Mar 17 2009 16:21:46  $
--       Date fetched Out : $Modtime:   Mar 17 2009 16:05:18  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--
  no_node_id,
  no_node_name,
  no_start_date,
  no_end_date,
  no_np_id,
  no_descr,
  no_node_type,
  no_date_created,
  no_date_modified,
  no_modified_by,
  no_created_by,
  no_purpose,
  np_grid_east,
  np_grid_north
  )
AS
  SELECT "NO_NODE_ID",
         "NO_NODE_NAME",
         "NO_START_DATE",
         "NO_END_DATE",
         "NO_NP_ID",
         "NO_DESCR",
         "NO_NODE_TYPE",
         "NO_DATE_CREATED",
         "NO_DATE_MODIFIED",
         "NO_MODIFIED_BY",
         "NO_CREATED_BY",
         "NO_PURPOSE",
         "NP_GRID_EAST",
         "NP_GRID_NORTH"
  FROM nm_nodes_all, nm_points
  WHERE np_id = no_np_id
        AND no_start_date <= (SELECT nm3context.get_effective_date
                              FROM DUAL)
        AND NVL (no_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
             (SELECT nm3context.get_effective_date
              FROM DUAL);