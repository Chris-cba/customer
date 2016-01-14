    With 
    Date_range as (
        select * from X_LOHAC_DateRANGE_WK
        ) 
    ,Haud_a
        AS (            select wor_works_order_no haud_pk_id, WOR_CHAR_ATTRIB110 HAUD_NEW_VALUE, WOR_DATE_ATTRIB131 HAUD_TIMESTAMP
          from work_orders
          where 1=1
             AND WOR_CHAR_ATTRIB110 in  ('REV', 'REVUPD','REVCOMM','APPCOMM','APP','REJCOMM','REJ','INTREJ','APPUN')
             AND WOR_DATE_ATTRIB131 BETWEEN (select min(st_range) from Date_range) AND (select max(end_range) from Date_range)
            )            
      , haud as (
          select h.*, range_value from haud_a h, Date_range 
          where   HAUD_TIMESTAMP BETWEEN st_range AND end_range 
          )
--
,claim_rank as (select a.*, case when woc_claim_type = 'F' then 999 else nvl(woc_interim_no,0) end woc_rank from work_order_claims a)
--
, claims as
(
		select a.woc_works_order_no, a.woc_interim_no, a.woc_rank, woc_claim_value, nvl(claim_previous,0) claim_previous from
            (select woc_works_order_no, woc_interim_no, woc_rank, woc_claim_value
            , lag(woc_claim_value) over (partition by woc_works_order_no order by  woc_rank Asc)  as claim_previous 
            from claim_rank
            order by woc_works_order_no, woc_claim_type, woc_rank asc) a
            , (select woc_works_order_no, max(woc_rank) woc_rank from claim_rank group by woc_works_order_no) b
        where 1=1
        and a.woc_works_order_no = b.woc_works_order_no
        and a.woc_rank = b.woc_rank
        --and a.woc_works_order_no in ('NW1_HLSC/5')
        )
--
, main as (
SELECT distinct
    '<p title="Click for forms"  id="'||works_order_number||'"  onmouseover="showWOLDetails(this);">'||  WORKs_ORDER_NUMBER||'</p>' WORKS_ORDER_NUMBER
    ,decode( DECODE (mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'), wor.works_order_number),
                    'TRUE', 'Y','N'),
            'N',
        '<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
        ,'<a href="javascript:showWODefOnMap('''||WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map
    ,decode(im_framework.has_doc(works_order_number,'WORK_ORDERS'),0,
        '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" title="No Documents">'
        ,'<a href="javascript:showWODocAssocs('''||works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24 src="/im4_framework/images/mfopen.gif" title="Show Documents"></a>') DOCS
    ,(select ial_meaning from nm_inv_attri_lookup where ial_domain = 'INVOICE_STATUS' and ial_value = wor_char_attrib110) INVOICE_STATUS
    ,wor_char_attrib111 INVOICE_STATUS_DESCRIPTION
    ,works_order_description
    , claim_previous Previous_Claim_Amount
    , woc_claim_value New_Claim_Amount
    , WOR_CHAR_ATTRIB111  Claim_Comments
     ,bud.work_category_description  Budget_Description
    , 'BOQ' BOQ
        ,WOR_CHAR_ATTRIB115    "Correct area of work "
        ,WOR_CHAR_ATTRIB116    "Quality of Work OK"
        ,WOR_CHAR_ATTRIB70    "Correct BOQ_Uplifts" 
        ,WOR_CHAR_ATTRIB113    "Before After Photos Present"
        ,WOR_CHAR_ATTRIB114 "Certification Comments"
--,(select hus_name from hig_audits, hig_users where haud_pk_id = haud.haud_pk_id and haud_timestamp = haud.haud_timestamp and haud_new_value = haud.haud_new_value and haud_attribute_name = haud.haud_attribute_name and  rownum =1) Reviewed_By
,  (select HUS_NAME from hig_users where hus_user_id = WOR_NUM_ATTRIB04 )  Reviewed_By
        , works_order_number wor_number
--
    FROM imf_mai_work_orders_all_attrib wor,
        imf_mai_work_order_lines wol,
        haud
    ,claims        
    ,imf_mai_budgets bud
        ,pod_nm_element_security,
        pod_budget_security
 	WHERE	1=1
		and wol.budget_id = bud.budget_id
		AND works_order_number = haud_pk_id
		AND works_order_number = claims.woc_works_order_no(+)
		AND works_order_number = work_order_number
		AND pod_nm_element_security.element_id = wol.network_element_id
		AND pod_budget_security.BUDGET_CODE = wol.work_category
		AND  WOR_CHAR_ATTRIB110 = haud_new_value
		AND range_value = :P60_DAYS
		AND haud.haud_new_value = :P60_PRIORITY)     
-- 
Select * from main;
