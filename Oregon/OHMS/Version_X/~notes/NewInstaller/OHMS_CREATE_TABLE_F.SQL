create table v_nm_ohms_turn_nw as
	select a.*, XNA_OHMS_GET_TLL(a.SAMP_ID) TLL,  XNA_OHMS_GET_TLR(a.SAMP_ID) TLR
	from V_NM_OHMS_NW a, OHMS_7_get_Turn_Urban B
	  where 1=2	  
	  and a.SAMP_ID = B.SAMP_ID  
	  ;