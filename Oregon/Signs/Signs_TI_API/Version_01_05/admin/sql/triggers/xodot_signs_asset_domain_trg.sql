create or replace trigger xodot_signs_asset_domain_trg 
after insert or update or delete
on NM_INV_ITEMS_ALL
for each row when(
	new.iit_inv_type in ('SNAC','SNCS','SIGN','SNGR','SUPP')
	or old.iit_inv_type in ('SNAC','SNCS','SIGN','SNGR','SUPP')  -- In case it is deleted
	)
	
/*	
The purpose of this trigger is to populate Transinfo Domains from assets.  
	Asset				Domain
-------------------------------------
	SNAC				SIGN_ACTN
	SNCS				SIGN_CAUSE
	SIGN				SIGN_STD
	SNGR				SIGN_STD_GRAPH
	SUPP				SIGN_SUPP
*/

/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	
	
	file: xodot_signs_asset_domain_trg.sql
	Author: JMM
	UPDATE01:	Original, 2015.03.23, JMM
	UPDATE02:	Minor Update due to asset meta changes, 2015.04.10, JMM
*/

	declare
		rt_inv_domains NM_INV_ATTRI_LOOKUP_ALL%rowtype;
		gs_domain_name varchar2(30);
		gs_domain_val varchar2(30);
		
		function get_domain_name (s_asset_name varchar2) return varchar2 is
			s_ret_val varchar2(30) := 'N/A';
			begin
			case upper(s_asset_name)
				when	'SNAC'	then		s_ret_val :=	'SIGN_ACTION'		;
				when	'SNCS'	then		s_ret_val :=	'SIGN_CAUSE'		;
				when	'SIGN'	then		s_ret_val :=	'SIGN_STD'		;
				--when	'SNGR'	then		s_ret_val :=	'SIGN_STD_GRPH'	;
				when	'SNGR'	then		s_ret_val :=	'SIGN_STD_GRAPH'	;
				when	'SUPP'	then		s_ret_val :=	'SIGN_SUPP'		;
			end case;
			return s_ret_val;
		end get_domain_name;
		
		function get_domain_val (s_asset_name varchar2) return varchar2 is
			s_ret_val varchar2(30) := 'N/A';
			begin
			if deleting then 
				case upper(s_asset_name)
					when	'SNAC'	then		s_ret_val :=	:old.IIT_CHR_ATTRIB26		;
					when	'SNCS'	then		s_ret_val :=	:old.IIT_CHR_ATTRIB26		;
					when	'SIGN'	then		s_ret_val :=	:old.IIT_CHR_ATTRIB26		;
					when	'SNGR'	then		s_ret_val :=	:old.IIT_CHR_ATTRIB26	;
					when	'SUPP'	then		s_ret_val :=	:old.IIT_CHR_ATTRIB26		;
				end case;
			else
				case upper(s_asset_name)
					when	'SNAC'	then		s_ret_val :=	:new.IIT_CHR_ATTRIB26		;
					when	'SNCS'	then		s_ret_val :=	:new.IIT_CHR_ATTRIB26	;
					when	'SIGN'	then		s_ret_val :=	:new.IIT_CHR_ATTRIB26		;
					when	'SNGR'	then		s_ret_val :=	:new.IIT_CHR_ATTRIB26	;
					when	'SUPP'	then		s_ret_val :=	:new.IIT_CHR_ATTRIB26		;
				end case;
			end if;
			return s_ret_val;
		end get_domain_val;
		 
		function set_domain_rows return NM_INV_ATTRI_LOOKUP_ALL%rowtype is  
			r_return  NM_INV_ATTRI_LOOKUP_ALL%rowtype;
			n_seq number := 0;
			
			begin
			
			
			select nvl(max(ial_seq),0) into n_seq from NM_INV_ATTRI_LOOKUP_ALL where ial_domain = gs_domain_name;
			
			r_return.ial_domain 		:=	gs_domain_name;
			r_return.ial_value 			:=	gs_domain_val;
			r_return.ial_dtp_code 		:=	null;
			r_return.ial_start_date 	:=	:new.iit_start_date;
			r_return.ial_end_date 		:=	:new.iit_end_date;
			r_return.ial_seq			:=	n_seq +1;
			r_return.ial_nva_id 		:=	null;
			r_return.ial_date_created 	:=	:new.iit_date_created;
			r_return.ial_date_modified 	:=	:new.iit_date_modified;
			r_return.ial_modified_by 	:=	:new.iit_modified_by;
			r_return.ial_created_by 	:=	:new.iit_created_by;
			
			case :new.iit_inv_type
				when	'SNAC'	then
					r_return.ial_meaning := substr(:new.IIT_CHR_ATTRIB26,1,80);					
				when	'SNCS'	then
					r_return.ial_meaning := substr(:new.IIT_CHR_ATTRIB26,1,80);
				when	'SIGN'	then
					/*
						SIGN_STRRM_NO  
						+ HT 
						+ WD 
						+ COLOR
						+ STD_SIGN_TYP 
						+ SIGN_DESC
					*/

					r_return.ial_meaning := substr(
													substr(:new.IIT_CHR_ATTRIB27,1,7) || '|' ||
													substr(to_char(:new.IIT_NUM_ATTRIB101),1,3) || '|' ||
													substr(to_char(:new.IIT_NUM_ATTRIB100),1,3) || '|' ||
													substr(:new.IIT_CHR_ATTRIB29,1,20) || '|' ||
													substr(:new.IIT_CHR_ATTRIB30,1,7) || '|' ||
													substr(:new.IIT_CHR_ATTRIB56,1,50) 
													,1,80);
				when	'SNGR'	then
					r_return.ial_meaning := substr(:new.IIT_CHR_ATTRIB57,1,80);
				when	'SUPP'	then
					r_return.ial_meaning := substr(:new.IIT_CHR_ATTRIB56,1,80);
				
			end case;
			
			return r_return;
		end set_domain_rows;
		--------------------------------------------------------------
		---------------------MAIN SECTION-----------------------------
		--------------------------------------------------------------
	begin

		
	if Deleting then
		gs_domain_name:= get_domain_name(:old.iit_inv_type);
		gs_domain_val:= get_domain_val(:old.iit_inv_type);
		delete from NM_INV_ATTRI_LOOKUP_ALL where ial_domain = gs_domain_name and ial_value = gs_domain_val;
	elsif inserting then
		gs_domain_name:= get_domain_name(:new.iit_inv_type);
		gs_domain_val:= get_domain_val(:new.iit_inv_type);
		rt_inv_domains := set_domain_rows;
		insert into NM_INV_ATTRI_LOOKUP_ALL values rt_inv_domains;
	elsif updating then  
		gs_domain_name:= get_domain_name(:new.iit_inv_type);
		gs_domain_val:= get_domain_val(:new.iit_inv_type);
		rt_inv_domains := set_domain_rows;
		update NM_INV_ATTRI_LOOKUP_ALL set row = rt_inv_domains where ial_domain = gs_domain_name and ial_value = gs_domain_val;		
	end if;
	
	
end xodot_signs_asset_domain_trg;
/
