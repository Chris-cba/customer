 Create or replace view XBCC_ELEMENTS_BT as
 SELECT     *
     FROM nm_elements_all
    WHERE ne_start_date <=  TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'END'), 'DD-MON-YYYY')			 
		AND NVL (ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >   TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'START'), 'DD-MON-YYYY');