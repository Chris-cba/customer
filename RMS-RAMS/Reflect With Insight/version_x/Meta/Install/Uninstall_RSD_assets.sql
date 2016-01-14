delete from NM_INV_TYPE_GROUPINGS_ALL where itg_parent_inv_type = 'RSD';
delete from NM_INV_TYPE_ROLES  where ITR_INV_TYPE in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');
delete from nm_inv_nw_all  where nin_nit_inv_code in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');
delete from NM_INV_TYPE_ATTRIBS_ALL where ITA_INV_TYPE in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');
delete from NM_INV_TYPES where NIT_INV_TYPE in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');

delete from NM_INV_ATTRI_LOOKUP_ALL where ial_domain in ('PROVIDER', 'RSD_YN')
delete from NM_INV_DOMAINS where id_domain in ('PROVIDER', 'RSD_YN')

commit;