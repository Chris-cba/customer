create or replace view x_rms_rsd_adap as
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
,	RSDE.IIT_NUM_ATTRIB24	Defect_Type
,	RSDE.IIT_NUM_ATTRIB16	Position_within_Location
,	RSIC.IIT_NUM_ATTRIB16	Incident_number
,	RSIC.IIT_CHR_ATTRIB27	Incident_Type
,	RSIC.IIT_DATE_ATTRIB88	Incident_Description
,	RSRE.IIT_NUM_ATTRIB16	Request_Id
,	RSRE.IIT_CHR_ATTRIB27	Request_Type
,	RSRE.IIT_CHR_ATTRIB66	Request_Comments
,	RSIN.IIT_NUM_ATTRIB16	Inspection_Id
,	RSIN.IIT_CHR_ATTRIB27	Inspection_Number
,	RSIN.IIT_CHR_ATTRIB28	Inspection_Type
,	RSIN.IIT_CHR_ATTRIB66	Inspection_Comments
,	RSAM.IIT_NUM_ATTRIB24	Accomplishment_ID
,	RSAM.IIT_DATE_ATTRIB86	Accomplishment_Date
,	RSAM.IIT_NUM_ATTRIB16	Activity
,	RSAM.IIT_CHR_ATTRIB56	Activity_Name
,	RSAM.IIT_CHR_ATTRIB28	Activity_Type
,	RSAM.IIT_NUM_ATTRIB17	Quantity_Accomplished
,	RSAM.IIT_CHR_ATTRIB29	Unit_Of_Measure
,	RSAM.IIT_NUM_ATTRIB18	Second_Quantity
,	RSAM.IIT_CHR_ATTRIB30	Second_Unit_of_Measure
,	RSAM.IIT_CHR_ATTRIB57	Accomplishment_Comments
,	RSAM.IIT_NUM_ATTRIB19	Time_Work
,	RSAM.IIT_CHR_ATTRIB31	Completed
--
,	ele.member_unique		ne_unique
, 	ele.ne_descr			ne_descr
from 	
nm_inv_items RSD	
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSIC') RSIC
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSDE') RSDE
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSIN') RSIN
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSRE') RSRE
,(select * from nm_inv_items where IIT_INV_TYPE = 'RSAM') RSAM
, (select distinct iit_ne_id,  member_unique, ne_descr from v_nm_rsd_nw, nm_elements where ne_unique = member_unique) ele
where 1=1--	
and RSD.IIT_INV_TYPE = 'RSD'	
and rsam.IIT_DATE_ATTRIB86 is not null
--	
--	
and rsd.iit_primary_key = rsam.iit_foreign_key    -- we should only have rsam, the others are optional
and rsd.iit_primary_key = rsic.iit_foreign_key (+)
and rsd.iit_primary_key = rsde.iit_foreign_key (+)
and rsd.iit_primary_key = rsin.iit_foreign_key (+)
and rsd.iit_primary_key = rsre.iit_foreign_key (+)
and rsd.iit_ne_id = ele.iit_ne_id(+)
;