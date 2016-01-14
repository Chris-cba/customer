declare
--
cursor c1 is
	select hus_username from hig_users where 
	hus_username in ('LOHACNE1'
					,'LOHACNE3'
					,'LOHACNW1'
					,'LOHACNW3'
					,'LOHACC1'
					,'LOHACC3'
					,'LOHACS1'
					,'LOHACS3'
					);
--
Begin
	for t_row in c1 loop
		Insert into IM_USER_TABS (IUT_HUS_USERNAME,IUT_IT_ID,IUT_SEQ,IUT_DISP_NAME,IUT_DESCR) values (t_row.hus_username,8,7,'LoHac_Exist_WIP','UserTab');		
		Insert into IM_USER_PODS (IUP_IP_ID,IUP_HUS_USERNAME,IUP_IT_ID,IUP_POD_POSITION,IUP_SOURCE_SEQ) values (331,t_row.hus_username,8,1,null);
		end loop;
	commit;
end;
/