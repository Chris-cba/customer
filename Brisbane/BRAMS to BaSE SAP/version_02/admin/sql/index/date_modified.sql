create index xbcc_idx_nm_date_modified on nm_members_all(nm_obj_type,nm_date_modified);

--create index xbcc_idx_IIT_date_modified on nm_inv_items_all(iit_date_modified);
create index xbcc_idx_IIT_date_modified on nm_inv_items_all(itt_inv_type,iit_date_modified);

create index xbcc_idx_ne_date_modified on nm_elements_all(ne_date_modified);