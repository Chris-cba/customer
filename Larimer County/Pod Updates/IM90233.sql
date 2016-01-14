Select b.aal_meaning "Severity",nvl(sev_Count,0) "Severity Count" from 
(
select aal_meaning,sev_Count
from XLAR_MV_LCRB_ACC_SEV_3_YEAR
,acc_attr_lookup
where aia_value=aal_value
and aal_aad_id='ASEV'
and alo_ne_id=:P6_PARAM1
) a
, (select * from acc_attr_lookup where aal_aad_id='ASEV') b
where a.aal_meaning(+) = b.aal_meaning
order by b.aal_meaning
