create or replace view x_rms_rsd_idap as
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
,	RSIN.IIT_NUM_ATTRIB16	Inspection_ID
,	RSIN.IIT_CHR_ATTRIB27	Inspection_Type
,	RSIN.IIT_DATE_ATTRIB88	Inspection_Completion_Date
,	RSIN.IIT_DATE_ATTRIB89	Inspection_Completion_Time
,	RSIN.IIT_CHR_ATTRIB28	Inspection_Number
,	RSIN.IIT_CHR_ATTRIB66	Inspection_Comments
,	ele.member_unique		ne_unique
, 	ele.ne_descr			ne_descr
from 	
nm_inv_items RSD	
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSIN') RSIN	
, (select distinct iit_ne_id,  member_unique, ne_descr from v_nm_rsd_nw, nm_elements where ne_unique = member_unique) ele
where 1=1--	
and RSD.IIT_INV_TYPE = 'RSD'	
--	
--	
and rsd.iit_primary_key = rsin.iit_foreign_key
and rsd.iit_ne_id = ele.iit_ne_id(+)
;