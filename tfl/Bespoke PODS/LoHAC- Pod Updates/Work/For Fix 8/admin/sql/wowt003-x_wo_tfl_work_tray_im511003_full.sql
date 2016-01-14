create or replace view X_WO_TFL_WT_IM511003_FULL as
--Made to acomindate a change to the pod design in the nobudget stack... Formerly X_WO_TFL_WT_IM511003_ALL
--
Select DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
		  works_order_status,
          substr(CONTRACT_CODE,instr(CONTRACT_CODE,'_')+1) con_code,
            (SELECT COUNT (*) FROM work_order_lines   WHERE wol_works_order_no = wor.works_order_number) number_of_lines,
          authorised_by_id,
              DECODE (
                 mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                            wor.works_order_number),
                 'TRUE', 'Y',
                 'N')
                 works_order_has_shape,
          wor.order_estimated_cost,
          wor.date_raised,
		  WOR_CHAR_ATTRIB118
     FROM 
			(select * from ximf_mai_work_orders_all_attr, work_order_lines where  works_order_number = wol_works_order_no and   WOL_STATUS_CODE = 'DRAFT') wor,
          --ximf_mai_work_orders_all_attr wor,  
          ximf_mai_work_order_lines wol
    WHERE     1=1
           --
          AND wor.works_order_number = wol.work_order_number
         AND works_order_status = 'DRAFT'       
		 and    date_raised >= (select min( ST_RANGE)from   X_LOHAC_DateRANGE_WOWT003) 
         AND UPPER(NVL (works_order_description, 'Empty')) NOT LIKE UPPER('%**Cancelled**%')
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          ;
