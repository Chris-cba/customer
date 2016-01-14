

delete from nm_members_all where nm_obj_type = 'OP';
commit;
delete from nm_inv_items_all where iit_inv_type = 'OP';
commit;
delete from NM_MRG_NIT_DERIVATION_NW where nmndn_nmnd_nit_inv_type = 'OP';
commit;
delete from NM_MRG_ITA_DERIVATION where nmid_ita_inv_type = 'OP';
commit;
delete from NM_MRG_NIT_DERIVATION where nmnd_nit_inv_type = 'OP';
commit;
--delete from nm_mrg_query_attribs where nqa_nmq_id = l_merge_id;
--delete from nm_mrg_query_types where nqt_nmq_id = l_merge_id;
--delete from nm_mrg_query_roles where nqro_nmq_id = l_merge_id;

declare
l_merge_id number;
begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY where NMQ_UNIQUE = 'TYPEOP';
	exception when others then null;
end;

delete from nm_mrg_query_all where nmq_id = l_merge_id;
commit;
end;
/

delete from nm_inv_type_roles where itr_inv_type = 'OP';
commit;
delete from nm_inv_type_attribs_all where ita_inv_type = 'OP';
commit;
delete from nm_inv_nw_all where nin_nit_inv_code = 'OP';
commit;
delete from nm_inv_types_all where nit_inv_type = 'OP';
commit;

