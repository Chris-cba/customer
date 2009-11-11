
prompt Deleting all CA and PINV Inventory
prompt NM_MEMBERS_ALL
delete nm_members_all 
where  nm_type = 'I' 
and    nm_obj_type in ('CA','PINV');
commit;
prompt NM_INV_ITEMS_ALL
delete nm_inv_items_all
where  iit_inv_type in ('PINV','CA');
commit;
prompt Create 1 CA per Anchor Section (This may take some time ...)
declare
  l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
  g_rec_ne nm_elements_all%ROWTYPE;
begin
  for c1rec in (select ne_id from nm_elements_all where ne_nt_type = 'ROAD' and ne_type = 'S' and ne_end_date is null)
  loop
    g_rec_ne := nm3get.get_ne_all (pi_ne_id => c1rec.ne_id);
    --
    NM3API_INV_CA.ins (p_iit_ne_id => l_iit_ne_id
                      ,p_effective_date => g_rec_ne.ne_start_date
                      ,p_admin_unit => xbc_create_securing_inv.find_corresponding_au(g_rec_ne.ne_admin_unit,'DINV')
                      ,p_descr => g_rec_ne.ne_unique
                      ,p_note => g_rec_ne.ne_nt_type
                      ,p_element_ne_id => g_rec_ne.ne_id
                      );
    commit;
  end loop;
end;
/
prompt Create 1 PINV per Anchor Section (This may take some time ...)
declare
  l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
  g_rec_ne nm_elements_all%ROWTYPE;
begin
  for c1rec in (select ne_id from nm_elements_all where ne_nt_type = 'ROAD' and ne_type = 'S' and ne_end_date is null)
  loop
    g_rec_ne := nm3get.get_ne_all (pi_ne_id => c1rec.ne_id);
    --
    NM3API_INV_PINV.ins (p_iit_ne_id => l_iit_ne_id
	                  ,p_effective_date => g_rec_ne.ne_start_date
	                  ,p_admin_unit => 164
	                  ,p_descr => g_rec_ne.ne_unique
	                  ,p_note => g_rec_ne.ne_nt_type
	                  ,p_element_ne_id => g_rec_ne.ne_id
                        ); 
    commit;
  end loop;
end;
/
prompt Summary
select 'Anchor Sections' ITEMS, count(*) from nm_elements_all where ne_nt_type = 'ROAD' and ne_type = 'S' and ne_end_date is null
union
select 'CA Items',count(*) from nm_inv_items where iit_inv_type = 'CA'
UNION
select 'PINV Items',count(*) from nm_inv_items where iit_inv_type = 'PINV';
exit;
/