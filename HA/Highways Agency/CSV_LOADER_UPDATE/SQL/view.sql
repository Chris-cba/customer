create or replace view v_ha_update_inv  as
select 'U' operation, a.* from nm_inv_items a where 1=2
;

