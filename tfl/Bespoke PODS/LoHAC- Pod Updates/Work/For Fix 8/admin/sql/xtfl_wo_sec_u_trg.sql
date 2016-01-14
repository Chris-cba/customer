DROP TRIGGER HIGHWAYS.XTFL_WO_SEC_U_TRG;

CREATE OR REPLACE TRIGGER HIGHWAYS.xtfl_wo_sec_u_trg
BEFORE UPDATE OF wor_char_attrib110 ON HIGHWAYS.WORK_ORDERS REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
Declare 
l_nontfl  boolean;
l_nonct  boolean;
c_nontfl number;
c_nonct number;
c_user_id number;

BEGIN

select hus_user_id into c_user_id from hig_users where hus_username = user;

if highways.x_get_im_user_id = c_user_id then 
		l_nontfl  := xtfl_wo_trg_pkg.is_user_non_tfl;
		l_nonct  := xtfl_wo_trg_pkg.is_non_commercial_team;
else
	select count(*) into c_nontfl from hig_user_roles where hur_username in (select hus_username from hig_users where hus_user_id = highways.x_get_im_user_id) and hur_role in ('LINK_DESK_OPERATOR');
	select count(*) into c_nonct from hig_user_roles where hur_username in (select hus_username from hig_users where hus_user_id = highways.x_get_im_user_id) and hur_role in ('ROUTE_MANAGER','SENIOR_NETWORK_ENGINEER','NETWORK_TECHNICIAN');
	
	if c_nontfl = 0 then
		l_nontfl := false;
	else 
		l_nontfl := true;
	end if;
	
	if c_nonct = 0 then
		l_nonct := false;
	else 
		l_nonct := true;
	end if;
end if;

if l_nontfl and :NEW.wor_char_attrib110 in (XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('INVOICE_STATUS', 'Approved'),XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('INVOICE_STATUS', 'Rejected')) then
--change for revised old remains old
:NEW.wor_char_attrib110 := :OLD.wor_char_attrib110;
-- date added for Invoice Status Effective Date
:NEW.WOR_DATE_ATTRIB131 := trunc(SYSDATE);
--:NEW.wor_char_attrib110 := null;
elsif l_nonct = true and :NEW.wor_char_attrib110 = XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('INVOICE_STATUS', 'Rejected') 
then
:NEW.wor_char_attrib110 := XTFL_WO_TRG_PKG.GET_INV_DOMAIN_VALUE('INVOICE_STATUS', 'Rejected - Awaiting Commercial Review');
-- date added for Invoice Status Effective Date
:NEW.WOR_DATE_ATTRIB131 := trunc(SYSDATE);
end if;

end xtfl_wo_sec_u_trg;
/