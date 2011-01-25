DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/herm_xsp.sql-arc   3.2   Jan 25 2011 11:57:54   Chris.Strettle  $
--       Module Name      : $Workfile:   herm_xsp.sql  $
--       Date into PVCS   : $Date:   Jan 25 2011 11:57:54  $
--       Date fetched Out : $Modtime:   Jan 25 2011 11:54:02  $
--       PVCS Version     : $Revision:   3.2  $
--       Based on SCCS version : 
--
--   Author : Chris Strettle
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
   /*
   Script to generate all possible combinations of xsp, cardinality and start date for a specific datum.
   Note that the datum direction relative to the Hermis section can chnage over time. Some route members may
   have different cardinality on the same date. In this case, it is important to ensure that only one row exists
   for each xsp and start date for each datum.

   This table will need to be maintained such that if the sub-class of a route is changed, new offset values are calculated.
   Changes of this type will result in changes to the actual lateral offsets of the assets.
   */
--
-------------------------------------------------------------------------
--
   lf                VARCHAR2 (1) := CHR (13);
   table_not_found   EXCEPTION;
   PRAGMA EXCEPTION_INIT (table_not_found, -942);
BEGIN
--
   EXECUTE IMMEDIATE 'TRUNCATE TABLE herm_xsp';
--
EXCEPTION
   WHEN table_not_found
   THEN
      BEGIN
         EXECUTE IMMEDIATE   '  CREATE TABLE herm_xsp '                                        || lf
                          || '( hxo_ne_id_of      NUMBER,   '                                  || lf
                          || '  hxo_nwx_x_sect    VARCHAR2(4),  '                              || lf
                          || '  hxo_start_date    DATE,  '                                     || lf
                          || '  hxo_offset        NUMBER,  '                                   || lf
                          || '  hxo_end_date      DATE,  '                                     || lf
                          || '  hxo_xsp_offset    NUMBER,  '                                   || lf
                          || '  hxo_herm_dir_flag INTEGER,   '                                 || lf
                          || '  hxo_xsp_descr     VARCHAR2(80),  '                             || lf
                          || ' PRIMARY KEY (hxo_ne_id_of, hxo_nwx_x_sect, hxo_start_date ))  ' || lf
                          || ' ORGANIZATION INDEX INCLUDING hxo_end_date OVERFLOW ';
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20001,
                                     'Failed to create XSP offset map');
      END;
END;
/
DECLARE
   table_not_found   EXCEPTION;
   PRAGMA EXCEPTION_INIT (table_not_found, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE xncc_herm_xsp_temp CASCADE CONSTRAINTS';
EXCEPTION
WHEN table_not_found THEN
   NULL;
END;
/

CREATE GLOBAL TEMPORARY TABLE XNCC_HERM_XSP_TEMP
(NM_NE_ID_OF  INTEGER    NOT NULL)
ON COMMIT DELETE ROWS
NOCACHE;
/

CREATE OR REPLACE FORCE VIEW HERM_XSP_DT
(
   HXO_NE_ID_OF,
   HXO_NWX_X_SECT,
   HXO_START_DATE,
   HXO_OFFSET,
   HXO_END_DATE,
   HXO_XSP_OFFSET,
   HXO_HERM_DIR_FLAG,
   HXO_XSP_DESCR
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/herm_xsp.sql-arc   3.2   Jan 25 2011 11:57:54   Chris.Strettle  $
--       Module Name      : $Workfile:   herm_xsp.sql  $
--       Date into PVCS   : $Date:   Jan 25 2011 11:57:54  $
--       Date fetched Out : $Modtime:   Jan 25 2011 11:54:02  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
--
   SELECT HXO_NE_ID_OF,
          HXO_NWX_X_SECT,
          HXO_START_DATE,
          HXO_OFFSET,
          HXO_END_DATE,
          HXO_XSP_OFFSET,
          HXO_HERM_DIR_FLAG,
          HXO_XSP_DESCR
     FROM herm_xsp
    WHERE hxo_start_date <= (SELECT nm3context.get_effective_date FROM DUAL)
          AND NVL (hxo_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >
                 (SELECT nm3context.get_effective_date FROM DUAL);
/

