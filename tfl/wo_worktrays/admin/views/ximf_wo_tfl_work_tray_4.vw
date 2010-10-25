CREATE OR REPLACE FORCE VIEW XIMF_WO_TFL_WORK_TRAY_4
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
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
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/wo_worktrays/admin/views/ximf_wo_tfl_work_tray_4.vw-arc   3.0   Oct 25 2010 10:21:34   Ian.Turnbull  $
--       Module Name      : $Workfile:   ximf_wo_tfl_work_tray_4.vw  $
--       Date into PVCS   : $Date:   Oct 25 2010 10:21:34  $
--       Date fetched Out : $Modtime:   Oct 25 2010 10:17:12  $
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
     FROM ximf_mai_work_orders_all_attr wor, ximf_mai_work_order_lines wol
    WHERE wor.works_order_number = work_order_number
          AND works_order_status = 'DRAFT'
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          AND wor.works_order_number NOT LIKE '%LS%';