Create or replace view X_LOHAC_NoBudget_Security as
	select distinct HUS_USER_ID,HUR_USERNAME  
	from hig_user_roles, hig_users
	where HUR_USERNAME = HUS_Username
		and (HUR_ROLE in ('LINK_DESK_OPERATOR', 'ASSISTANT_COMMERCIAL_MANAGER'))
;


