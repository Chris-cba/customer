create or replace view X_WO_TFL_WT_IM511003_NOBUD as
--
--
Select DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          works_order_status,
          substr(CONTRACT_CODE,instr(CONTRACT_CODE,'_')+1) con_code,
            0 number_of_lines,
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
		--(select XIMF_MAI_WO_ALL_ATTR_NO_SEC.* from XIMF_MAI_WO_ALL_ATTR_NO_SEC, work_order_lines where  works_order_number = wol_works_order_no and   WOL_STATUS_CODE = 'DRAFT') wor
          XIMF_MAI_WO_ALL_ATTR_NO_SEC wor
          ,work_order_lines          
    WHERE     1=1
           --
          AND wor.works_order_number=WOL_WORKS_ORDER_NO(+)
         AND WOL_BUD_ID is null
         AND works_order_status = 'DRAFT'      
		and WOR_CHAR_ATTRIB118 is not null
         AND UPPER(NVL (works_order_description, 'Empty')) NOT LIKE UPPER('%**Cancelled**%')
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          and    date_raised >= (select min( ST_RANGE)from   X_LOHAC_DateRANGE_WOWT003)    
          and (x_get_im_user_id in (Select HUS_USER_ID from X_LOHAC_NoBudget_Security) OR x_get_im_user_id = ORIGINATOR_ID)
          AND WOr.NETWORK_ELEMENT_ID in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
		  --
	Union ALL
		--
		select * from X_WO_TFL_WT_IM511003_FULL where 1=1 and  nvl(WOR_CHAR_ATTRIB118 , 'BLANK') in ('PROD', 'DRAFT')
          ;
