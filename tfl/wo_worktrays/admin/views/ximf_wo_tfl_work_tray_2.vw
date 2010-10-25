CREATE OR REPLACE FORCE VIEW XIMF_WO_TFL_WORK_TRAY_2
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   DEFECT_PRIORITY,
   HAUD_TIMESTAMP,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/wo_worktrays/admin/views/ximf_wo_tfl_work_tray_2.vw-arc   3.0   Oct 25 2010 10:21:32   Ian.Turnbull  $
--       Module Name      : $Workfile:   ximf_wo_tfl_work_tray_2.vw  $
--       Date into PVCS   : $Date:   Oct 25 2010 10:21:32  $
--       Date fetched Out : $Modtime:   Oct 25 2010 10:17:10  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--   
   DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          wol.defect_priority,
          haud_timestamp,
          authorised_by_id,
          DECODE (
             mai_sdo_util.
             wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                           wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
          wor.estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          ximf_mai_work_order_lines wol,
          imf_mai_defect_repairs def,
          imf_mai_budgets bud,
          imf_net_network_members net,
          hig_audits_vw
    WHERE     wor.works_order_number = work_order_number
          AND wol.defect_id = def.defect_id(+)
          AND wol.budget_id = bud.budget_id
          AND wor.works_order_number = haud_pk_id
          AND haud_table_name = 'WORK_ORDERS'
          AND wol.network_element_id = child_element_id
          AND parent_group_type = 'HMBG'
          AND works_order_status = 'DRAFT'
          --and nvl(defect_priority,'Non Defective') = :P10_PRIORITY
          AND WOR_CHAR_ATTRIB100 = 'RDY'
          AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
          AND haud_timestamp =
                 (SELECT MAX (haud_timestamp)
                    FROM hig_audits_vw
                   WHERE     haud_pk_id = wor.works_order_number
                         AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                         AND haud_new_value = 'RDY')
          AND haud_old_value IN ('REJ', 'HLD');