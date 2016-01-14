--This removes the data and the attribute METC and METP

delete from nm_inv_item_groupings_all where iig_item_id in (select iit_ne_id from nm_inv_items_all where iit_inv_type = 'METC');
delete from nm_inv_items_all where iit_inv_type = 'METC';
delete from nm_inv_type_attribs_all where ita_inv_type = 'METC';

delete from nm_inv_type_groupings_all where itg_inv_type = 'METC';
delete from nm_inv_type_roles where itr_inv_type = 'METC';

delete from nm_inv_types_all where nit_inv_type = 'METC';

delete from nm_inv_items_all where iit_inv_type = 'METP';
delete from nm_inv_type_attribs_all where ita_inv_type = 'METP';

delete from nm_inv_type_groupings_all where itg_inv_type = 'METP';
delete from nm_inv_type_roles where itr_inv_type = 'METP';

delete from nm_inv_types_all where nit_inv_type = 'METP';

commit;