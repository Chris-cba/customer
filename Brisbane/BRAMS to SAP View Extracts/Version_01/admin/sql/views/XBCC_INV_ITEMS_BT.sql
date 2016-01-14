 Create or replace view XBCC_INV_ITEMS_BT as
 SELECT     *
     FROM nm_inv_items_all
    WHERE iit_start_date <=  TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'END'), 'DD-MON-YYYY')			 
		AND NVL (iit_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >   TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'START'), 'DD-MON-YYYY');