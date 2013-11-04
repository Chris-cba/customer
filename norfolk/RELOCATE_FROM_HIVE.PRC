CREATE OR REPLACE PROCEDURE Relocate_From_Hive ( gis_session_id IN NUMBER ) IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/norfolk/RELOCATE_FROM_HIVE.PRC-arc   1.0   Nov 04 2013 15:28:20   Rob.Coupe  $
--       Module Name      : $Workfile:   RELOCATE_FROM_HIVE.PRC  $
--       Date into PVCS   : $Date:   Nov 04 2013 15:28:20  $
--       Date fetched Out : $Modtime:   Nov 04 2013 15:27:20  $
--       PVCS Version     : $Revision:   1.0  $
--
  -----------------------
  RELOCATE_FROM_HIVE
  NORFOLK network repair
    Created by RC
  -----------------------
*/

  l_ne_id         NUMBER;

  l_ne            nm_elements_all%ROWTYPE;
  l_temp_no       NUMBER;
  l_iit_ne_id     Nm3type.tab_number;
  l_nm_ne_id      Nm3type.tab_number;
  l_nm_inv_type   Nm3type.tab_varchar4;
  l_nm_start      Nm3type.tab_number;
  l_nm_date       Nm3type.tab_date;
  l_nm_end_date   Nm3type.tab_date;
  l_nm_end        Nm3type.tab_number;
  l_nm_au         Nm3type.tab_number;
  l_rowcnt        Nm3type.tab_number;

  l_nnah_row NM_NORFOLK_ASSET_HIVES%ROWTYPE;

  l_route_length NUMBER;

CURSOR c_ne IS
  SELECT gdo_pk_id
  FROM gis_data_objects
  WHERE gdo_session_id = gis_session_id;

CURSOR c_mem (c_ne_id IN NUMBER )
  IS
    SELECT l.iit_ne_id
         , r.pl_ne_id
         , l.iit_inv_type
         , r.pl_start
         , GREATEST(iit_start_date, e.ne_start_date)
         , NULL
         , r.pl_end
         , iit_admin_unit
         , rownum rowcounter
      FROM NM_NORFOLK_HIVED_ASSETS l,
           TABLE (Get_Inv_Location (ne_id, pl_start, pl_end).npa_placement_array
                 ) r,
           nm_elements e
      WHERE l.ne_id = c_ne_id
      AND   e.ne_id = r.pl_ne_id;
      
FUNCTION get_hive( p_ne_id IN NUMBER ) RETURN NM_NORFOLK_ASSET_HIVES%ROWTYPE IS
CURSOR c1 (c_ne_id IN NUMBER ) IS
  SELECT * FROM NM_NORFOLK_ASSET_HIVES
  WHERE nnah_ne_id = c_ne_id;
retval NM_NORFOLK_ASSET_HIVES%ROWTYPE;
BEGIN
  OPEN c1 ( p_ne_id );
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR(-20002, 'Hive for ne_id = '||TO_CHAR(p_ne_id)||' cannot be found');
  END IF;
  CLOSE c1;
  RETURN retval;
END;

BEGIN

  FOR irec IN c_ne LOOP

    l_nnah_row := get_hive ( irec.gdo_pk_id );

    l_ne  := Nm3get.get_ne (irec.gdo_pk_id);
    
--  remove all the shapes of all assets on the hived route.

    drop_shapes_on_hive( irec.gdo_pk_id );

--        

    l_ne_id := l_ne.ne_id;

    l_route_length := Nm3net.Get_Ne_Length( l_ne_id );

    IF l_route_length != l_nnah_row.nnah_ne_length THEN

      RAISE_APPLICATION_ERROR( -20003, 'Length has changed - relocating assets will be unlreliable');

    END IF;


    DELETE FROM nm_members_all
    WHERE nm_ne_id_in IN ( SELECT iit_ne_id
                           FROM  NM_NORFOLK_HIVED_ASSETS
                           WHERE ne_id = l_ne_id );


    OPEN  c_mem (l_ne.ne_id);
    FETCH c_mem
    BULK COLLECT INTO
            l_iit_ne_id
          , l_nm_ne_id
          , l_nm_inv_type
          , l_nm_start
          , l_nm_date
          , l_nm_end_date
          , l_nm_end
          , l_nm_au
          , l_rowcnt;
      CLOSE c_mem;

     FORALL i IN 1 .. l_iit_ne_id.COUNT
         INSERT INTO NM_MEMBERS_ALL
                     (nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type,
                      nm_begin_mp, nm_start_date, nm_end_date, nm_end_mp,
                      nm_slk, nm_cardinality, nm_admin_unit, nm_seq_no, nm_true
                     )
              VALUES (l_iit_ne_id (i), l_nm_ne_id (i), 'I', l_nm_inv_type (i),
                      l_nm_start (i), l_nm_date (i), NULL, l_nm_end (i),
                      NULL, 1, l_nm_au (i), l_rowcnt(i), NULL );

     UPDATE  NM_NORFOLK_ASSET_HIVES
     SET nnah_used = 'Y'
     WHERE nnah_ne_id = l_ne_id;

  END LOOP;

END;
/

