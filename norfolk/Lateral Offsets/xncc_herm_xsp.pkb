CREATE OR REPLACE PACKAGE BODY XNCC_HERM_XSP
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/xncc_herm_xsp.pkb-arc   3.2   Jan 13 2011 11:09:58   Chris.Strettle  $
--       Module Name      : $Workfile:   xncc_herm_xsp.pkb  $
--       Date into PVCS   : $Date:   Jan 13 2011 11:09:58  $
--       Date fetched Out : $Modtime:   Jan 13 2011 11:07:22  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.2  $';

  g_package_name CONSTANT varchar2(30) := 'XNCC_HERM_XSP';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
/* Formatted on 11/01/2011 13:36:34 (QP5 v5.149.1003.31008) */
PROCEDURE gen_herm_xsp
AS
   /*

   Script to generate all possible combinations of xsp, cardinality and start date for a specific datum.
   Note that the datum direction relative to the Hermis section can chnage over time. Some route members may
   have different cardinality on the same date. In this case, it is important to ensure that only one row exists
   for each xsp and start date for each datum.

   This table will need to be maintained such that if the sub-class of a route is changed, new offset values are calculated.
   Changes of this type will result in changes to the actual lateral offsets of the assets.

   */
   lf                VARCHAR2 (1) := CHR (13);
   table_not_found   EXCEPTION;
   PRAGMA EXCEPTION_INIT (table_not_found, -942);
BEGIN
   EXECUTE IMMEDIATE 'truncate table herm_xsp';
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

PROCEDURE gen_xncc_herm_xsp_temp
AS
   lf                VARCHAR2 (1) := CHR (13);
   table_not_found   EXCEPTION;
   PRAGMA EXCEPTION_INIT (table_not_found, -942);
BEGIN
  BEGIN
     EXECUTE IMMEDIATE 'DROP TABLE xncc_herm_xsp_temp CASCADE CONSTRAINTS';

  EXCEPTION
     WHEN table_not_found THEN
     NULL;
     WHEN OTHERS THEN
     raise_application_error (-20001,
                             'Failed to drop existing xncc_herm_xsp_temp table'); 
  END;
  --
  BEGIN
     EXECUTE IMMEDIATE  ' CREATE GLOBAL TEMPORARY TABLE XNCC_HERM_XSP_TEMP'  || lf
                     || '(NM_NE_ID_OF  INTEGER    NOT NULL)'                 || lf
                     || ' ON COMMIT DELETE ROWS'                             || lf
                     || ' NOCACHE';
  EXCEPTION
     WHEN OTHERS
     THEN
        raise_application_error (-20001,
                                 'Failed to create xncc_herm_xsp_temp');
  END;
END;

--
-----------------------------------------------------------------------------
--
PROCEDURE ins_herm_xsp AS
BEGIN
INSERT INTO herm_xsp
            (hxo_ne_id_of, hxo_nwx_x_sect, hxo_start_date, hxo_end_date,
             hxo_offset, hxo_xsp_offset, hxo_herm_dir_flag, hxo_xsp_descr)
   WITH datum_xsp AS
        (SELECT nm_ne_id_of, nwx_x_sect,
                NVL (nwx_offset, 0) * nm_cardinality herm_x_sect, nwx_descr,
                NVL (nwx_offset, 0) offset, nm_cardinality,
                nm_start_date nm_start_date, nm_end_date,
                ROW_NUMBER () OVER (
                     PARTITION BY 
                         nm_ne_id_of, nwx_x_sect, nm_start_date ORDER BY nm_start_date,nm_end_date DESC) rn
           FROM nm_members_all, nm_elements_all, nm_xsp
          WHERE nm_obj_type = 'SECT'
            AND nm_ne_id_in = ne_id
            AND ne_sub_class = nwx_nsc_sub_class
            AND nwx_nw_type = 'HERM')
   SELECT   nm_ne_id_of, nwx_x_sect, MIN (nm_start_date), MAX (nm_end_date),
            herm_x_sect, offset, nm_cardinality, nwx_descr
       FROM (SELECT *
               FROM datum_xsp
              WHERE rn = 1)
   GROUP BY nm_ne_id_of,
            nwx_x_sect,
            herm_x_sect,
            nwx_descr,
            offset,
            nm_cardinality;

end;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_herm_xsp( p_ne_id nm_elements.ne_id%TYPE 
                         , p_ne_id_new nm_elements.ne_id%TYPE
                         , p_effective_date DATE DEFAULT SYSDATE) AS
BEGIN

IF  nm3get.get_ne(pi_ne_id => p_ne_id_new, pi_raise_not_found => FALSE).ne_nt_type = 'ESU'
OR p_ne_id_new IS NULL
THEN
         INSERT INTO herm_xsp( hxo_ne_id_of
                             , hxo_nwx_x_sect
                             , hxo_start_date
                             , hxo_offset
                             , hxo_end_date
                             , hxo_xsp_offset
                             , hxo_herm_dir_flag
                             , hxo_xsp_descr)
         SELECT NVL(p_ne_id_new, p_ne_id)
              , nwx_x_sect
              , p_effective_date
              , nwx_offset*nm_cardinality
              , nm_end_date
              , nwx_offset
              , nm_cardinality 
              , nwx_descr
  FROM nm_nw_xsp, nm_elements, nm_members_all
  WHERE ne_id = nm_ne_id_in
  AND   nwx_nsc_sub_class = ne_sub_class
  AND nm_ne_id_of = p_ne_id
  AND nm_obj_type = 'SECT'
  AND nwx_nw_type = 'HERM'
  AND nm_end_date IS NULL
  AND NOT EXISTS (SELECT 'X'
                    FROM herm_xsp 
                   WHERE hxo_ne_id_of = p_ne_id_new 
                     AND hxo_nwx_x_sect = nwx_x_sect
                     AND hxo_start_date = p_effective_date);
--
  close_herm_xsp(p_ne_id => p_ne_id);
--
end if;       

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_herm_xsp( p_ne_id_in nm_elements.ne_id%TYPE 
                           , p_ne_id_of nm_elements.ne_id%TYPE
                           , p_nm_cardinality nm_members_all.nm_cardinality%TYPE
                           , p_effective_date DATE DEFAULT SYSDATE) AS
BEGIN
--
         INSERT INTO herm_xsp( hxo_ne_id_of
                             , hxo_nwx_x_sect
                             , hxo_start_date
                             , hxo_offset
                             , hxo_end_date
                             , hxo_xsp_offset
                             , hxo_herm_dir_flag
                             , hxo_xsp_descr)
         SELECT p_ne_id_of
              , nwx_x_sect
              , p_effective_date
              , nwx_offset*p_nm_cardinality
              , NULL nm_end_date
              , nwx_offset
              , p_nm_cardinality nm_cardinality 
              , nwx_descr
  FROM nm_nw_xsp, nm_elements
  WHERE ne_id = p_ne_id_in
  AND  nwx_nsc_sub_class = ne_sub_class
  AND NOT EXISTS (SELECT 'X'
                    FROM herm_xsp 
                   WHERE hxo_ne_id_of = p_ne_id_of 
                     AND hxo_nwx_x_sect = nwx_x_sect
                     AND hxo_start_date = p_effective_date);
--
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_herm_xsp( p_ne_id nm_elements.ne_id%TYPE
                         ) AS
BEGIN
  IF nm3get.get_ne_all(p_ne_id).ne_nt_type = 'ESU' 
  THEN
           DELETE FROM herm_xsp
           WHERE hxo_ne_id_of = p_ne_id;
           
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_herm_xsp( p_ne_id nm_elements.ne_id%TYPE
                        ) AS
BEGIN
  IF nm3get.get_ne_all(p_ne_id).ne_nt_type = 'ESU' 
  THEN
     UPDATE herm_xsp
        SET hxo_end_date = nm3user.get_effective_date
      WHERE hxo_ne_id_of = p_ne_id
        AND hxo_end_date IS NULL;
           
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE unclose_herm_xsp( p_ne_id nm_elements.ne_id%TYPE
                         ) AS
BEGIN
  IF nm3get.get_ne_all(p_ne_id).ne_nt_type = 'ESU' 
  THEN
     UPDATE herm_xsp
     SET hxo_end_date = NULL
     where hxo_ne_id_of = p_ne_id;
           
  END IF;
END;
--
-----------------------------------------------------------------------------
--
END XNCC_HERM_XSP;
/
