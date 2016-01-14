 create  or replace    type typ_sap_sync_record is 
	object( o_INDICATOR  varchar2(1), o_BRAMS_ID number(10), o_OBJECT varchar2(30), o_NAME varchar2(30), o_START number(18,2), o_END number(18,2)
	CONSTRUCTOR FUNCTION typ_sap_sync_record RETURN SELF AS RESULT
	);
    
    create type typ_sap_sync_list is table of typ_sap_sync_record ;