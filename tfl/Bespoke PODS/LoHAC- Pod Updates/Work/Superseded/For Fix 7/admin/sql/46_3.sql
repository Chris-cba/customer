
CREATE OR REPLACE package body HIGHWAYS.xtfl_wo_trg_pkg as

FUNCTION GET_INV_DOMAIN_VALUE (PI_DOMAIN  IN     NM_INV_ATTRI_LOOKUP_ALL.IAL_DOMAIN%TYPE
                              ,PI_MEANING IN NM_INV_ATTRI_LOOKUP_ALL.IAL_MEANING%TYPE
                              ) RETURN NM_INV_ATTRI_LOOKUP_ALL.IAL_VALUE%TYPE IS
  CURSOR C1 (P_DOMAIN  IN NM_INV_ATTRI_LOOKUP_ALL.IAL_DOMAIN%TYPE
            ,P_MEANING IN NM_INV_ATTRI_LOOKUP_ALL.IAL_MEANING%TYPE) IS
    SELECT IAL_VALUE
    FROM   NM_INV_ATTRI_LOOKUP_ALL
    WHERE  IAL_DOMAIN = P_DOMAIN
    AND    UPPER(IAL_MEANING) = UPPER(P_MEANING);
  L_RETVAL     NM_INV_ATTRI_LOOKUP_ALL.IAL_VALUE%TYPE;
  L_RETMEANING NM_INV_ATTRI_LOOKUP_ALL.IAL_MEANING%TYPE;
BEGIN
  OPEN C1(P_DOMAIN   => PI_DOMAIN
         ,P_MEANING  => PI_MEANING);
  FETCH C1 INTO L_RETVAL;
  IF C1%NOTFOUND THEN
    CLOSE C1;
    RAISE_APPLICATION_ERROR(-20001, 'Inventory domain ' || PI_DOMAIN
                                    || ', meaning ' || PI_MEANING
                                    || ' not found.');
  END IF;
  CLOSE C1;
  RETURN L_RETVAL;
END GET_INV_DOMAIN_VALUE;


procedure update_invoice_status (p_wor_works_order_no WORK_ORDERS.WOR_WORKS_ORDER_NO%TYPE,
p_wor_con_id WORK_ORDERS.WOR_CON_ID%TYPE, 
p_invoice_status varchar2) as
l_flex_inv_type nm_inv_items_all.iit_inv_type%TYPE;
l_wo_col varchar2(30);
l_code NM_INV_ATTRI_LOOKUP_ALL.IAL_VALUE%TYPE;
begin

l_code := get_inv_domain_value ('INVOICE_STATUS',p_invoice_status );
-- date added for Invoice Status Effective Date
update work_orders set wor_char_attrib110 =  l_code, wor_date_attrib131 = trunc(sysdate) where wor_works_order_no = p_wor_works_order_no;

end update_invoice_status;

function get_invoice_col(p_wor_con_id WORK_ORDERS.WOR_CON_ID%TYPE, p_flex_col varchar2) return varchar2 as
l_flex_inv_type nm_inv_items_all.iit_inv_type%TYPE;
l_ret_col varchar2(30);
begin

select ita_attrib_name into l_ret_col from nm_inv_type_attribs where ita_inv_type = l_flex_inv_type
and ita_view_attri  = 'INVSTATUS';
return l_ret_col;

end get_invoice_col;

function is_user_non_tfl return boolean as
l_cnt number;
begin

--select any roles that makes them a TFL user
select count(*) into l_cnt from hig_user_roles where hur_username = user and
hur_role in ('LINK_DESK_OPERATOR');

if l_cnt <> 0 then
    return true;
end if;
return false;    

end is_user_non_tfl;

function is_non_commercial_team return boolean as
l_cnt number;
begin

--select any roles that makes them in the commercial team
-- removed LINK_DESK_OPERATOR as per considerations change
select count(*) into l_cnt from hig_user_roles where hur_username = user and
hur_role in ('ROUTE_MANAGER','SENIOR_NETWORK_ENGINEER','NETWORK_TECHNICIAN');

if l_cnt<> 0 then
    return true;
end if;
return false;    

end is_non_commercial_team;



end xtfl_wo_trg_pkg;
/


