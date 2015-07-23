update nm_nodes_all set no_end_date = null where no_node_id in (351358, 351359, 351360, 351361);
commit;


update nm_node_usages_all  set nnu_end_date = null where nnu_no_node_id in (351358, 351359, 351360, 351361);
commit;


update nm_elements_all set ne_end_date = null where ne_id in (1432114                ,
1432115 ,               
1432116, 1429784 );
commit;


update nm_inv_items_all set iit_end_date = null where iit_ne_id in (
select nm_ne_id_in from nm_members_all where nm_ne_id_of in (1432114                ,
1432115 ,               
1432116) and nm_type = 'I');
commit;


update nm_members_all set nm_end_date = null where nm_ne_id_of in (1432114                ,
1432115 ,               
1432116,
1429784 );
commit;

update nm_nlt_rfi_grfi_sdo set end_date = null where ne_id = 1429784;
commit;

delete from nm_element_history where neh_ne_id_old in  (1432114                ,
1432115 ,               
1432116,
1429784);
commit;

