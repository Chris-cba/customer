/* ************************************************************
	Object:		Create Table z_nm_sgns_nw as(select * from v_nm_sgns_nw where IIT_DESCR = 'AUTO POPULATED BY XODOT_FILL_SGNS');
	Purpose:	Copies the relevant items to a temporary table so that the originals can be deleted
	Notes:		z_nm_sgns_nw_err used to hold row errors that might happen during the move.
	Created:	2015.09.03	J.Mendoza
************************************************************* */
Create Table z_nm_sgns_nw as(select * from v_nm_sgns_nw where IIT_DESCR = 'AUTO POPULATED BY XODOT_FILL_SGNS');
Create Table z_nm_sgns_nw_err as (select * from v_nm_sgns_nw where 1= 2);

/* ************************************************************
	Object:		Nm3inv.delete_inv_items
	Purpose:	To removed the existing INV SGNS with an IIT_DESCR = 'AUTO POPULATED BY XODOT_FILL_SGNS'
	Notes:		
	Created:	2015.09.03	J.Mendoza
************************************************************* */
begin
	Nm3inv.delete_inv_items(pi_inv_type		=> 'SGNS'
							,pi_cascade 		=> false -- Not needed since not a hierarchical asset
							,pi_where          	=> q'[IIT_DESCR = 'AUTO POPULATED BY XODOT_FILL_SGNS']'
                          );
end;

/* ************************************************************
	Object:		AdHoc
	Purpose:	To recreate the Removed SGNS Assets from the data  z_nm_sgns_nw
	Notes:		
	Created:	2015.09.03	J.Mendoza
************************************************************* */
DECLARE
	cursor c_cur   is	select * from z_nm_sgns_nw;
	n_temp number;	
BEGIN
	for r_row in c_cur loop
		begin
			-- 	We need to delete the SNEA record auto created with the SNGN via trigger XODOT_ASSET_B_MEMBER_INS 
			--	otherwise I cannot locate the item at the same start date.
		
			delete from nm_members_all 
				where 	1=1
						and nm_obj_type = 'SNEA' 
						and nm_ne_id_of = r_row.NE_ID_OF
						and nm_start_date = r_row.IIT_START_DATE 
						and nm_begin_mp = r_row.NM_BEGIN_MP
						and nm_end_mp = r_row.NM_END_MP;
		
			n_temp := nm3api_inv_sgns.ins (
						   p_effective_date					=> 		r_row.IIT_START_DATE
						  ,p_admin_unit               		=> 		r_row.IIT_ADMIN_UNIT
						  ,p_descr                     		=> 		'AUTO POPULATED BY XODOT_FILL_SGNS'
						  ,p_note                          	=> 		'AUTO SEPARATED'
						   -- <FLEXIBLE ATTRIBUTES>
						  ,pf_hwy_ea_no                  	=>		r_row.HWY_EA_NO
						  ,pf_mjr_sign_cnt                	=>		r_row.MJR_SIGN_CNT
						  ,pf_mnr_sign_cnt                 	=>		r_row.MNR_SIGN_CNT
						   -- </FLEXIBLE ATTRIBUTES>          		
						   -- <LOCATION DETAILS>              		
						  ,p_element_ne_id                  =>		r_row.NE_ID_OF
						  ,p_element_begin_mp               =>		r_row.NM_BEGIN_MP
						  ,p_element_end_mp                 =>		r_row.NM_END_MP
						   -- </LOCATION DETAILS>
						  ); 
		exception when others then
			insert into z_nm_sgns_nw_err values r_row;
			commit;
		end;
	end loop;
End;

/* ************************************************************
	Object:		DROP TABLES
	Purpose:	After verifying the procedure's results, uncomment and drop the holding tables
	Notes:		
	Created:	2015.09.03	J.Mendoza
************************************************************* */

--Drop Table z_nm_sgns_nw;
--Drop z_nm_sgns_nw_err
