CREATE OR REPLACE PACKAGE BODY XNCC_HERM_XSP
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/xncc_herm_xsp.pkb-arc   3.5   Feb 14 2011 12:09:08   Rob.Coupe  $
--       Module Name      : $Workfile:   xncc_herm_xsp.pkb  $
--       Date into PVCS   : $Date:   Feb 14 2011 12:09:08  $
--       Date fetched Out : $Modtime:   Feb 14 2011 12:07:46  $
--       Version          : $Revision:   3.5  $
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.5  $';

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
   SELECT   nm_ne_id_of, nwx_x_sect, MIN (nm_start_date) nm_start_date, MAX (nvl(nm_end_date, to_date('31-DEC-9999'))) nm_end_date,
            herm_x_sect, offset, nm_cardinality, nwx_descr
       FROM (SELECT nm_ne_id_of, 
                    nwx_x_sect, 
                    nm_start_date, 
                    decode(nm_end_date, to_date( '31-DEC-9999', 'DD-MON-YYYY'), NULL, nm_end_date ) nm_end_date, 
                    herm_x_sect, 
                    offset, 
                    nm_cardinality, 
                    nwx_descr
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
                         , p_effective_date DATE DEFAULT TRUNC(SYSDATE)) AS
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
                    FROM herm_xsp_dt
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
                           , p_effective_date DATE DEFAULT TRUNC(SYSDATE)) AS
BEGIN
--
   DELETE FROM herm_xsp 
   WHERE hxo_start_date = p_effective_date
   AND hxo_ne_id_of = p_ne_id_of;
   
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
                    FROM herm_xsp_dt
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
                        , p_end_date nm_elements.ne_end_date%TYPE DEFAULT NULL
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
                          , p_end_date nm_elements.ne_end_date%TYPE DEFAULT NULL
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
