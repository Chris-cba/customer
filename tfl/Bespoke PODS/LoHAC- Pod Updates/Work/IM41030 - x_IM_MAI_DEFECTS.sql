create or replace view  x_IM_MAI_DEFECTS as
select * from imf_mai_defects a, POD_NM_ELEMENT_SECURITY b
where 1=1
and A.NETWORK_ELEMENT_ID = b.ELEMENT_ID
;