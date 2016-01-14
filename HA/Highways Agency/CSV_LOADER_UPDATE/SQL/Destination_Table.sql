SET DEFINE OFF;
Insert into NM_LOAD_DESTINATIONS
   (NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC, NLD_VALIDATION_PROC)
 Values
   (NLD_ID_SEQ.nextval, 'V_HA_UPDATE_INV', 'VHUI', 'x_ha_update_inv_item.p_update', 'x_ha_update_inv_item.p_validate');
COMMIT;
