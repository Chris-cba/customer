
declare
l_merge_id number;
begin
    begin
    select nmq_id into l_merge_id from NM_MRG_QUERY where NMQ_UNIQUE = 'TYPEOP_BD';
end;

delete from nm_members where nm_obj_type = 'OPBD';
delete from nm_inv_items where iit_inv_type = 'OPBD';
delete from NM_MRG_NIT_DERIVATION_NW where nmndn_nmnd_nit_inv_type = 'OPBD';
delete from NM_MRG_ITA_DERIVATION where nmid_ita_inv_type = 'OPBD';
delete from NM_MRG_NIT_DERIVATION where nmnd_nit_inv_type = 'OPBD';
delete from nm_mrg_query_attribs where nqa_nmq_id = l_merge_id;
delete from nm_mrg_query_types where nqt_nmq_id = l_merge_id;
delete from nm_mrg_query_roles where nqro_nmq_id = l_merge_id;
delete from nm_mrg_query where nmq_id = l_merge_id;
delete from nm_inv_type_roles where itr_inv_type = 'OPBD';
delete from nm_inv_type_attribs where ita_inv_type = 'OPBD';
delete from nm_inv_types where nit_inv_type = 'OPBD';
end;