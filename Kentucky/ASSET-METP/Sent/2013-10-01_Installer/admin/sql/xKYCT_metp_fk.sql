create or replace function xKYTC_METP_fk(s_METC varchar2) return number
as

n_fk number;

begin

n_fk := 0;

select min(iit_ne_id) into n_fk from nm_inv_items where iit_inv_type = 'METP' and IIT_CHR_ATTRIB26 = s_METC;

if n_fk is null then 
    n_fk := 0;
    end if;
return n_fk;
exception when  others then 
	return 0;
end;

/