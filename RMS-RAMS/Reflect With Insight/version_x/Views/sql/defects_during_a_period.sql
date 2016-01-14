create or replace view x_rms_rsd_ddap as
select 	
	RSD.IIT_CHR_ATTRIB26	Vendor_Code
,	RSD.IIT_NUM_ATTRIB25	Reference_id
,	RSD.IIT_CHR_ATTRIB56	Road_Number
,	RSD.IIT_CHR_ATTRIB28	Road_Maintenance_Segment
,	RSD.IIT_DATE_ATTRIB86	Date_of_creation
,	RSD.IIT_NUM_ATTRIB17	Longitude
,	RSD.IIT_NUM_ATTRIB18	Latitude
,	RSD.IIT_CHR_ATTRIB29	LGA
,	RSD.IIT_CHR_ATTRIB27	Asset_type_code
,	RSD.IIT_NUM_ATTRIB16	Key_ID
,	RSD.IIT_CHR_ATTRIB58	Asset_description
,	RSDE.IIT_CHR_ATTRIB27	Defect_Number
,	RSDE.IIT_NUM_ATTRIB24	Defect_ID
,	RSDE.IIT_DATE_ATTRIB86	Date_Raised
,	RSDE.IIT_DATE_ATTRIB87	Time_Raised
,	RSDE.IIT_CHR_ATTRIB28	Cause_Of_Defect
,	RSDE.IIT_CHR_ATTRIB29	Reoccurring_Defect
,	RSDE.IIT_CHR_ATTRIB30	Defect_Type
,	RSDE.IIT_NUM_ATTRIB16	Position_within_Location
,	RSDE.IIT_DATE_ATTRIB88	Defect_Completion_Date
,	RSDE.IIT_DATE_ATTRIB89	Defect_Completion_Time
,	RSDE.IIT_NUM_ATTRIB16	Estimated_Quantity_for_repair
,	RSDE.IIT_CHR_ATTRIB31	Unit_of_Measure
,	RSDE.IIT_NUM_ATTRIB16	Estimated_Second_Quantity
,	RSDE.IIT_CHR_ATTRIB32	Second_Unit_of_Measure
,	RSDE.IIT_CHR_ATTRIB56	Defect_Comments	
,	ele.member_unique		ne_unique
, 	ele.ne_descr			ne_descr
from 	
nm_inv_items RSD	
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSDE') RSDE	
, (select distinct iit_ne_id,  member_unique, ne_descr from v_nm_rsd_nw, nm_elements where ne_unique = member_unique) ele
where 1=1--	
and RSD.IIT_INV_TYPE = 'RSD'	
--	
--	
and rsd.iit_primary_key = rsde.iit_foreign_key
and rsd.iit_ne_id = ele.iit_ne_id(+)
;