DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/herm_xsp.sql-arc   3.0   Jan 19 2011 11:40:16   Mike.Alexander  $
--       Module Name      : $Workfile:   herm_xsp.sql  $
--       Date into PVCS   : $Date:   Jan 19 2011 11:40:16  $
--       Date fetched Out : $Modtime:   Jan 19 2011 11:39:54  $
--       PVCS Version     : $Revision:   3.0  $
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

DROP TABLE xncc_herm_xsp_temp CASCADE CONSTRAINTS;
/

CREATE GLOBAL TEMPORARY TABLE XNCC_HERM_XSP_TEMP
(NM_NE_ID_OF  INTEGER    NOT NULL)
ON COMMIT DELETE ROWS
NOCACHE;
/

