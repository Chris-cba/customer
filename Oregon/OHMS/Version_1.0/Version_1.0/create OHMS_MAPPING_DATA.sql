insert into HPMS_TABLE
select 4, HT_HC_ID, 'OHMS_SECTIONS', HT_INCLUDE, HT_TEMPLATE, HT_HL_ID
from HPMS_TABLE where ht_id = 1;


insert into HPMS_column
select HCL_ID + 30, 4, HCL_NAME, HCL_LOCATION_COL, HCL_TYPE, HCL_SIZE
from  HPMS_column where hcl_ht_id = 1;


insert into HPMS_PROCEDURE
select 4, 4, HP_PROCEDURE, 'OHMS_SUBMIT_SECTIONS', HP_MVIEW_CREATES, HP_TABLE_CREATES
from  HPMS_PROCEDURE where  HP_ID = 1;

create table OHMS_SUBMIT_SECTIONS as select * from HPMS_SUBMIT_SECTIONS where 1 = 2;

insert into HPMS_MAPPING
select 
HM_ID+300, HM_HCL_ID+30, HM_HDI_ID+100, HM_ITEM, HM_ITEM_VALUE, 
HM_ITEM_ATTRIBUTE, HM_ITEM_WHERE, HM_ITEM_FUNCTION, HM_XSP, 
HM_ITEM_TYPE, HM_ITEM_FORMULA, HM_JOIN_TYPE
from HPMS_MAPPING
where hm_hcl_id in
(
    select hcl_id
    from HPMS_COLUMN
        where HCL_HT_ID = 1
);


-- Now need to make changes to use OHMS instead of HPMS.


update  HPMS_MAPPING
set hm_item = 'OHMS'
where hm_item like 'HPMS'
and HM_ITEM_VALUE = 'SAMP_ID'
and HM_ITEM_FUNCTION = 'COUNT_RANGE'
and hm_hcl_id in
(
    select hcl_id
    from HPMS_COLUMN
    where HCL_HT_ID = 4 
);


exec XNA_HPMS.table_validate(4)


