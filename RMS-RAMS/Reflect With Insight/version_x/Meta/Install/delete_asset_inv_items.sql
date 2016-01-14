delete from  NM_INV_itEm_GROUPINGs_all where iig_item_id in
  (select iit_ne_id from nm_inv_items_all where iit_inv_type in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE'));

delete from nm_members_all where nm_obj_type  in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');

delete from nm_inv_items_all where iit_inv_type in ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');

Commit;