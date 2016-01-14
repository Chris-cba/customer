-- NON LS
select '<p title="Click for forms"  id="'||works_order_number||'"  onmouseover="showWOLDetails(this);">'||  WORKs_ORDER_NUMBER||'</p>' WORKS_ORDER_NUMBER
,WORKS_ORDER_DESCRiption description
,works_order_number wor_number
,number_of_lines
,order_estimated_cost estimated_cost
,date_raised
,WOR_CHAR_ATTRIB118 "Task Order Status"
, decode(works_order_has_shape,'N',
              '<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
             ,'<a href="javascript:showWODefOnMap('''||WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map
,decode(x_im_wo_has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" title="No Documents">'
,'<a href="javascript:showWODocAssocs('''||works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24 src="/im4_framework/images/mfopen.gif" title="Show Documents"></a>') DOCS
,APEX_ITEM.CHECKBOX(101,
                    WORKS_ORDER_NUMBER,
                    'class="selectme" title="Click to Instruct WO" onclick="openConfirmBox(''Instruct Work Order?'');"',                    
                    '1',
                    ':',
                    'f101_' || ROWNUM
                   )  "Instruct" 
,APEX_ITEM.CHECKBOX(102,
                    works_order_number,
                      'class="selectme" title="Click to Hold/Reject WO" onclick="openHoldRejectDialog();"',
                    '1',
                    ':',
                    'f102_' || ROWNUM
                   )  "Hold/Reject" 
,APEX_ITEM.CHECKBOX(103,
                    WORKS_ORDER_NUMBER,
                    'class="selectme" title="Click to Forward WO" onclick="openForwardToDialog();"',
                    '1',
                    ':',
                    'f103_' || ROWNUM
                   )  "Forward" 
,APEX_ITEM.CHECKBOX(103,
                   WORKS_ORDER_NUMBER,
                    'title="Click to Authorise WO" class="authchk" onclick="openAuthoriseDialog();"' || decode( authorised_by_id,null,null,'disabled="true" checked'),
                    authorised_by_id,
                    ':',
                    'f103_' || ROWNUM
                   ) "authorised"   
from X_WO_TFL_WT_IM511003_ALL
where (select range_value from X_LOHAC_DateRANGE_WOWT003 where date_raised between st_range and end_range) =  :P3_days
AND con_code not in ('HLSC', 'HLSR', 'SLSC', 'SLSR')


--LS change con code where from not in to in

select '<p title="Click for forms"  id="'||works_order_number||'"  onmouseover="showWOLDetails(this);">'||  WORKs_ORDER_NUMBER||'</p>' WORKS_ORDER_NUMBER
,WORKS_ORDER_DESCRiption description
,works_order_number wor_number
,number_of_lines
,order_estimated_cost estimated_cost
,date_raised
,WOR_CHAR_ATTRIB118 "Task Order Status"
, decode(works_order_has_shape,'N',
              '<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
             ,'<a href="javascript:showWODefOnMap('''||WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map
,decode(x_im_wo_has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" title="No Documents">'
,'<a href="javascript:showWODocAssocs('''||works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24 src="/im4_framework/images/mfopen.gif" title="Show Documents"></a>') DOCS
,APEX_ITEM.CHECKBOX(101,
                    WORKS_ORDER_NUMBER,
                    'class="selectme" title="Click to Instruct WO" onclick="openConfirmBox(''Instruct Work Order?'');"',                    
                    '1',
                    ':',
                    'f101_' || ROWNUM
                   )  "Instruct" 
,APEX_ITEM.CHECKBOX(102,
                    works_order_number,
                      'class="selectme" title="Click to Hold/Reject WO" onclick="openHoldRejectDialog();"',
                    '1',
                    ':',
                    'f102_' || ROWNUM
                   )  "Hold/Reject" 
,APEX_ITEM.CHECKBOX(103,
                    WORKS_ORDER_NUMBER,
                    'class="selectme" title="Click to Forward WO" onclick="openForwardToDialog();"',
                    '1',
                    ':',
                    'f103_' || ROWNUM
                   )  "Forward" 
,APEX_ITEM.CHECKBOX(103,
                   WORKS_ORDER_NUMBER,
                    'title="Click to Authorise WO" class="authchk" onclick="openAuthoriseDialog();"' || decode( authorised_by_id,null,null,'disabled="true" checked'),
                    authorised_by_id,
                    ':',
                    'f103_' || ROWNUM
                   ) "authorised"   
from X_WO_TFL_WT_IM511003_ALL
where (select range_value from X_LOHAC_DateRANGE_WOWT003 where date_raised between st_range and end_range) =  :P13_days
AND con_code in ('HLSC', 'HLSR', 'SLSC', 'SLSR')


---
---
---
--LS
