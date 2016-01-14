create or replace function xKYTC_hath_fk(s_hatt varchar2) return number
as

n_fk number;

begin

n_fk := 0;

select iit_ne_id into n_fk from nm_inv_items where iit_inv_type = 'HATH' and IIT_CHR_ATTRIB26 = s_hatt;

if n_fk is null then 
    n_fk := 0;
    end if;
return n_fk;
exception when  others then 
	return 0;
end;

/