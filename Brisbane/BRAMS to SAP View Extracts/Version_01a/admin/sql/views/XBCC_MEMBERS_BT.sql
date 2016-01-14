 Create or replace view XBCC_MEMBERS_BT as
 SELECT     *
     FROM nm_members_all
    WHERE nm_start_date <=  TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'END'), 'DD-MON-YYYY')			 
		AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >   TO_DATE (SYS_CONTEXT ('XBCC_DATES', 'START'), 'DD-MON-YYYY');