SET DEFINE OFF;
Insert into NM_LOAD_DESTINATIONS
   (NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC, NLD_VALIDATION_PROC)
 Values
   (NLD_ID_SEQ.nextval, 'X_V_INV_ITEM_LOADER', 'VIIL', 'x_ctdot_ploc_inv_load.p_load_inv', 'x_ctdot_ploc_inv_load.p_validate_inv');
COMMIT;

Insert into NM_LOAD_DESTINATIONS
   (NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC, NLD_VALIDATION_PROC)
 Values
   (NLD_ID_SEQ.nextval, 'X_V_LOAD_INV_MEM_ON_ELEMENT_P', 'VLMP', 'x_ctdot_ploc_inv_load.p_load_loc', 'x_ctdot_ploc_inv_load.p_validate_loc');
COMMIT;