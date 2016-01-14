create index xbcc_idx_nm_date_modified on nm_members_all(nm_obj_type,nm_date_modified);

--create index xbcc_idx_IIT_date_modified on nm_inv_items_all(iit_date_modified);
create index xbcc_idx_IIT_date_modified on nm_inv_items_all(iit_inv_type,iit_date_modified);

create index xbcc_idx_ne_date_modified on nm_elements_all(ne_date_modified);

--create index xbcc_idx_ne_date_start on nm_elements_all(ne_start_date);

--create index xbcc_idx_nm_obj_ne_id_in on nm_members_all(nm_obj_type,nm_ne_id_in);

create index xbcc_idx_ne_id_in_chr on nm_members_all(to_char(nm_ne_id_in));
create index xbcc_idx_nm_date_modified on nm_members_all(nm_obj_type,nm_date_modified);

--testing

create index xbcc_idx_nm_date_mod_id_of on nm_members_all(nm_ne_id_of,nm_obj_type,nm_date_modified);