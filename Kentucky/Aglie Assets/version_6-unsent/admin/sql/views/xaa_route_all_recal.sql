create or replace view  xaa_route_all_recal as
--
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.3.29, JMM
	UPDATE02:	Added Route SYS Context, 2015.1.23, JMM
*/
select
	nm_ne_id_in,
	nm_ne_id_of,
	old_nm_slk,
	old_nm_end_slk,
	len,
	nvl(lag (tot) over (partition by nm_ne_id_in order by old_nm_slk),0) slk,
	tot end_slk
from (
		select 
			nm_ne_id_in,
			nm_ne_id_of,
			nm_slk old_nm_slk,
			nm_end_slk old_nm_end_slk,
			len,
			nvl(lag (len) over (partition by nm_ne_id_in order by nm_slk),0) tslk,
			nvl(sum (len) over (partition by nm_ne_id_in order by nm_slk),0) tot
		from (
			select --mem.*, neh.*,
				nm_ne_id_in,
				nm_ne_id_of
				,nm_slk
				, nm_end_slk
				,case when neh_old_ne_length is null then nvl(nm_end_slk - nm_slk,0)  else nvl(neh_old_ne_length,0) end len
			 from 
				nm_members_all mem,
				(select * from nm_element_history where neh_operation = 'B')  neh
			where 1=1
				and mem.nm_ne_id_of = neh.neh_ne_id_old(+)
				and mem.nm_obj_type in ('RT')
				and mem.nm_ne_id_in = (SYS_CONTEXT ('xaa_eff_date_context', 'route_id'))
				and mem.nm_type = 'G'
				and    nm_start_date <=                  (SYS_CONTEXT ('xaa_eff_date_context', 'date'))
				AND NVL (nm_end_date, TO_DATE ('1-JAN-2999')) >                (SYS_CONTEXT ('xaa_eff_date_context', 'date'))
			)
		)
--where nm_ne_id_in = 16557
;