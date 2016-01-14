/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.12.26, JMM
*/

create or replace view XAA_ROUTE_SDO as
select
NE_id ROUTE_ID
, Geoloc
from 
V_nm_nlt_rt_rt_sdo
;