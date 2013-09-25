CREATE OR REPLACE PROCEDURE NORFOLK."REVERSE_HERMIS_SECTION" (p_ne_id IN NUMBER, p_batch_no IN INTEGER )
/*
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/norfolk/REVERSE_HERMIS_SECTION.prc-arc   1.0   Sep 25 2013 13:01:06   Rob.Coupe  $
--       Module Name      : $Workfile:   REVERSE_HERMIS_SECTION.prc  $
--       Date into PVCS   : $Date:   Sep 25 2013 13:01:06  $
--       Date fetched Out : $Modtime:   Sep 25 2013 13:00:00  $
--       PVCS Version     : $Revision:   1.0  $
--
  -----------------------
  REVERSE_HERMIS_SECTION
  NORFOLK network repair
    Created by RC
  -----------------------
*/
IS
  TYPE tab_nil  IS TABLE OF v_current_hermis_inv_data%ROWTYPE INDEX BY BINARY_INTEGER;
  l_tab_nil       tab_nil;
  l_ne            nm_elements_all%ROWTYPE   := Nm3get.get_ne (p_ne_id);
  l_temp_no       NUMBER;
  l_iit_ne_id     Nm3type.tab_number;
  l_nm_ne_id      Nm3type.tab_number;
  l_nm_inv_type   Nm3type.tab_varchar4;
  l_nm_start      Nm3type.tab_number;
  l_nm_date       Nm3type.tab_date;
  l_nm_end_date   Nm3type.tab_date;
  l_nm_end        Nm3type.tab_number;
  l_nm_au         Nm3type.tab_number;
  l_nm_seq_no     Nm3type.tab_number;

  l_start_ne      nm_elements.ne_id%TYPE;
--
/*
  CURSOR c_mem (c_ne_id IN NUMBER)
  IS
    SELECT 1,2,'A',0,SYSDATE, 1, 1
      FROM dual;
*/
  CURSOR c_mem (c_ne_id IN NUMBER,
                c_batch_no IN INTEGER)
  IS
    SELECT l.iit_ne_id
         , r.pl_ne_id
         , l.iit_inv_type
         , r.pl_start
         , iit_start_date
         , NULL
         , r.pl_end
         , iit_admin_unit
         , rownum nm_seq_no
      FROM HERMIS_INV_DATA l,
           TABLE (Get_Inv_Location (ne_id, pl_start, pl_end).npa_placement_array
                 ) r
      WHERE ne_id = c_ne_id
      AND batch_no = c_batch_no;


  CURSOR c_closed_mem (c_ne_id IN NUMBER,
                       c_batch_no IN INTEGER)
  IS
    SELECT l.iit_ne_id
         , nm_ne_id_of
         , l.iit_inv_type
         , r.pl_start
         , GREATEST( nm_start_date,  iit_start_date )
         , neh_effective_date
         , r.pl_end
         , iit_admin_unit
         , nm_seq_no
   FROM NM_MEMBERS_ALL,
        nm_element_history,
        HERMIS_INV_DATA l,
        TABLE (Get_Inv_Location (ne_id, pl_start, pl_end).npa_placement_array ) r
   WHERE nm_ne_id_in = c_ne_id
   AND l.batch_no = c_batch_no
   AND nm_ne_id_of = neh_ne_id_old
   AND nm_ne_id_in = ne_id
   AND pl_ne_id    = neh_ne_id_new
   AND iit_start_date < neh_effective_date
   AND nm_end_date    > iit_start_date
   AND neh_operation = 'R';

-------------------------------------------------------------------------
--
   FUNCTION get_start_node (p_ne_id IN NUMBER, p_start_ne IN NUMBER)
      RETURN NUMBER
   IS
     CURSOR c1
     IS
       SELECT DECODE (nm_cardinality, 1, ne_no_start, -1, ne_no_end)
         FROM nm_elements, nm_members
        WHERE nm_ne_id_in = p_ne_id
          AND nm_ne_id_of = ne_id
          AND ne_id = p_start_ne; --Nm3lrs.get_start (p_ne_id);
     retval   NUMBER;
   BEGIN
     OPEN c1;
     FETCH c1
      INTO retval;
     CLOSE c1;
     RETURN retval;
   END get_start_node;
---------------------------------------------------------------------------
  PROCEDURE add_log
     ( pi_batch_no         IN HERMIS_REVERSAL_LOG.hermis_batch_no%TYPE
     , pi_hermis_ne_id     IN HERMIS_REVERSAL_LOG.hermis_ne_id%TYPE
     , pi_hermis_operation IN HERMIS_REVERSAL_LOG.hermis_operation%TYPE
     , pi_hermis_success   IN HERMIS_REVERSAL_LOG.hermis_success%TYPE
     , pi_hermis_text      IN HERMIS_REVERSAL_LOG.hermis_text%TYPE )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_rec_hrl HERMIS_REVERSAL_LOG%ROWTYPE;
    l_seq NUMBER;
  BEGIN
    SELECT hermis_reversal_log_seq.NEXTVAL INTO l_seq FROM DUAL;
    l_rec_hrl.hermis_batch_no  := pi_batch_no;
    l_rec_hrl.hermis_ne_id     := pi_hermis_ne_id;
    l_rec_hrl.hermis_unique    := Nm3net.get_ne_unique (p_ne_id => pi_hermis_ne_id);
    l_rec_hrl.hermis_operation := pi_hermis_operation;
    l_rec_hrl.hermis_success   := pi_hermis_success;
    l_rec_hrl.hermis_text      := pi_hermis_text;
    l_rec_hrl.hermis_time      := SYSDATE;
    l_rec_hrl.hermis_seq       := l_seq;
    INSERT INTO HERMIS_REVERSAL_LOG
    VALUES l_rec_hrl;
    COMMIT;
  END add_log;
  -------------------------------------------------------------------------
  FUNCTION GET_FIRST_ELEMENT( p_ne_id IN NUMBER, p_no_id IN NUMBER) RETURN NUMBER  IS
  CURSOR c1 (c_ne_id IN NUMBER, c_no_id IN NUMBER ) IS
    SELECT nm_ne_id_of
    FROM nm_members, nm_elements
    WHERE ne_id = nm_ne_id_of
    AND   nm_ne_id_in = c_ne_id
    AND   DECODE( nm_cardinality, 1, ne_no_start, ne_no_end ) = c_no_id;

  retval NUMBER;
  BEGIN
    OPEN c1( p_ne_id, p_no_id );
    FETCH c1 INTO retval;
    IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR(-20002, 'Failed to find first element in route');
    END IF;
    CLOSE c1;
    RETURN retval;
  END;

-------------------------------------------------------------------------

  FUNCTION set_start_date( p_date IN DATE, p_ne_id IN NUMBER ) RETURN DATE IS
  retval DATE;
  BEGIN
    SELECT ne_start_date INTO retval
    FROM nm_elements_all
    WHERE ne_id = p_ne_id;

    IF retval < p_date THEN
      retval := p_date;
    END IF;
    RETURN retval;
  END;

-------------------------------------------------------------------------

FUNCTION lock_element ( p_ne_id IN NUMBER ) RETURN BOOLEAN IS
CURSOR c1 (c_ne_id IN NUMBER ) IS
  SELECT ne_id FROM nm_elements WHERE ne_id = c_ne_id FOR UPDATE OF ne_id NOWAIT;
dummy NUMBER;
l_nolock EXCEPTION;
PRAGMA EXCEPTION_INIT ( l_nolock, -54 );
BEGIN
  OPEN c1 ( p_ne_id );
  FETCH c1 INTO dummy;
  CLOSE c1;
  Nm3lock.lock_element_and_members(p_ne_id);
  RETURN TRUE;
EXCEPTION
  WHEN l_nolock THEN
    IF c1%isopen THEN
      CLOSE c1;
    END IF;
    add_log( p_batch_no, p_ne_id, 'No Lock available', 'N', 'ERROR' );
    RETURN FALSE;
  WHEN OTHERS THEN
    IF c1%isopen THEN
      CLOSE c1;
    END IF;
    add_log( p_batch_no, p_ne_id, SQLERRM, 'N', 'ERROR' );
    RETURN FALSE;
END;


-------------------------------------------------------------------------
--
BEGIN
--
-------------------------------------------------------------------------------
--
BEGIN

  SAVEPOINT start_of_procedure;

  IF Nm3net.get_max_slk( p_ne_id ) != Nm3net.Get_Ne_Length( p_ne_id ) THEN
    add_log(  p_batch_no, p_ne_id, 'Route length inconsistency', 'N', 'ERROR - Route length inconsistency between route and esu lengths' );
    RETURN;
  ELSIF Check_Route( p_ne_id ) != 'TRUE' THEN
    add_log(  p_batch_no, p_ne_id, 'Route measures', 'N', 'ERROR Route measures make this route unsuitable for the reversal process' );
    RETURN;
  END IF;

  IF lock_element( p_ne_id ) THEN
    add_log( p_batch_no, p_ne_id, 'Locked', 'Y', 'FINISH' );
  ELSE
    add_log( p_batch_no, p_ne_id, 'No Lock', 'N', 'ERROR' );
    RETURN;
  END IF;
-------------------------------------------------------------------------------

--swap nodes

  add_log(p_batch_no, p_ne_id,'SWAP NODES',NULL,'START');
--
  BEGIN
    l_temp_no        := l_ne.ne_no_start;
    l_ne.ne_no_start := l_ne.ne_no_end;
    l_ne.ne_no_end   := l_temp_no;
  EXCEPTION
    WHEN OTHERS THEN
    add_log(p_batch_no, p_ne_id,'SWAP NODES','N','ERROR - '||SQLERRM);
	ROLLBACK TO start_of_procedure;
    RETURN;
  END;
--
  add_log(p_batch_no, p_ne_id,'SWAP NODES','Y','FINISH');

-------------------------------------------------------------------------------
  add_log(p_batch_no, p_ne_id,'UPDATE CARDINALITY',NULL,'START');
--
  BEGIN
    UPDATE NM_MEMBERS_ALL
       SET nm_cardinality = nm_cardinality * (-1)
     WHERE nm_ne_id_in = l_ne.ne_id;
  EXCEPTION
    WHEN OTHERS THEN
    add_log(p_batch_no, p_ne_id,'UPDATE CARDINALITY','N','ERROR - '||SQLERRM);
	ROLLBACK TO start_of_procedure;
    RETURN;
  END;
--
  add_log(p_batch_no, p_ne_id,'UPDATE CARDINALITY','Y','FINISH');

-------------------------------------------------------------------------------
  add_log(p_batch_no, p_ne_id,'TEST NODE',NULL,'START');
--
  DECLARE
    L_NO_START EXCEPTION;
    PRAGMA EXCEPTION_INIT( L_NO_START, -20001 );
  BEGIN

    l_start_ne := Nm3lrs.get_start( p_ne_id );

  EXCEPTION

    WHEN L_NO_START THEN

--circular route, start not easily derived, get the first element from the original end node, now the start node

      L_START_NE := GET_FIRST_ELEMENT( p_ne_id, l_ne.ne_no_start );

  END;
--

  BEGIN
    l_temp_no := get_start_node (l_ne.ne_id, l_start_ne);
    IF l_temp_no != l_ne.ne_no_start
    THEN
      add_log(p_batch_no, p_ne_id,'TEST NODE','N','FINISH - Start is not the same - derived = '
                       || TO_CHAR (l_temp_no)
                       || ' actual = '
                       || TO_CHAR (l_ne.ne_no_start));
    ELSE
      add_log(p_batch_no, p_ne_id,'TEST NODE','Y','FINISH - Node OK');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      add_log(p_batch_no, p_ne_id, 'TEST NODE', 'N', 'ERROR - '||SQLERRM );
  	  ROLLBACK TO start_of_procedure;
  END;

-------------------------------------------------------------------------------
  add_log(p_batch_no, p_ne_id,'UPDATE ELEMENT NODES',NULL,'START');
--
  BEGIN
   UPDATE nm_elements_all
      SET ne_no_start = l_ne.ne_no_start,
          ne_no_end = l_ne.ne_no_end
    WHERE ne_id = l_ne.ne_id;
  EXCEPTION
    WHEN OTHERS THEN
    add_log(p_batch_no, p_ne_id,'UPDATE ELEMENT NODES','N','FINISH - '||SQLERRM);
	ROLLBACK TO start_of_procedure;
    RETURN;
  END;
  add_log(p_batch_no, p_ne_id,'UPDATE ELEMENT NODES','Y','FINISH');

-------------------------------------------------------------------------------
  add_log(p_batch_no, p_ne_id,'RESCALE ROUTE',NULL,'START');
--
  BEGIN
    Nm3rsc.rescale_route (l_ne.ne_id,
                          TRUNC (SYSDATE),
                          0,
                          NULL,
                          'N',
                          l_start_ne);
  EXCEPTION
    WHEN OTHERS THEN
    add_log(p_batch_no, p_ne_id,'RESCALE ROUTE','N','ERROR - '||SQLERRM);
	ROLLBACK TO start_of_procedure;
    RETURN;
  END;
  add_log(p_batch_no, p_ne_id,'RESCALE ROUTE','Y','FINISH');

-------------------------------------------------------------------------------
--  add_log(p_batch_no, p_ne_id,'TAKE COPY OF INV LOCATIONS',NULL,'START');
--  BEGIN
--    add_log(p_ne_id,'TAKE COPY OF INV LOCATIONS',NULL,'START');

--    copy_inv_locations;

--    add_log(p_ne_id,'TAKE COPY OF INV LOCATIONS','Y','FINISH');
--  EXCEPTION
--    WHEN OTHERS THEN
--      add_log(p_ne_id,'TAKE COPY OF INV LOCATIONS','N','ERROR - '||SQLERRM);
--      RETURN;
--  END;

-------------------------------------------------------------------------------
  add_log(p_batch_no, p_ne_id,'REMOVE INV LOCATIONS',NULL,'START');
  BEGIN
    DELETE FROM NM_MEMBERS_ALL a
          WHERE a.nm_type = 'I'
            AND a.nm_ne_id_of IN (SELECT b.nm_ne_id_of
                                    FROM NM_MEMBERS_ALL b
                                   WHERE b.nm_ne_id_in = l_ne.ne_id)
            AND EXISTS ( SELECT 1 FROM HERMIS_INV_DATA
			             WHERE ne_id = l_ne.ne_id );
--                         AND   s_timestamp = p_timestamp );
  EXCEPTION
    WHEN OTHERS THEN
      add_log(p_batch_no, p_ne_id,'REMOVE INV LOCATIONS','N','ERROR - '||SQLERRM);
	  ROLLBACK TO start_of_procedure;
      RETURN;
  END;
  add_log(p_batch_no, p_ne_id,'REMOVE INV LOCATIONS','Y','FINISH');
-------------------------------------------------------------------------------


  BEGIN

    add_log(p_batch_no, p_ne_id,'CREATE NEW MEMBS',NULL,'START');


    OPEN  c_mem (l_ne.ne_id, p_batch_no);
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
        , l_nm_seq_no;
    CLOSE c_mem;

    add_log(p_batch_no, p_ne_id,'CREATE NEW MEMBS - count = '||TO_CHAR(l_iit_ne_id.COUNT),NULL,'START');

--  ensure that the start date of the location does not pre-date the date of the element.

    FOR i IN 1..l_iit_ne_id.COUNT LOOP

      l_nm_date(i) := set_start_date( l_nm_date(i), l_nm_ne_id(i) );

    END LOOP;

    FORALL i IN 1 .. l_iit_ne_id.COUNT
       INSERT INTO NM_MEMBERS_ALL
                   (nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type,
                    nm_begin_mp, nm_start_date, nm_end_date, nm_end_mp,
                    nm_slk, nm_cardinality, nm_admin_unit, nm_seq_no, nm_true
                   )
            VALUES (l_iit_ne_id (i), l_nm_ne_id (i), 'I', l_nm_inv_type (i),
                    l_nm_start (i), l_nm_date (i), NULL, l_nm_end (i),
                    NULL, 1, l_nm_au (i), l_nm_seq_no(i), NULL );


  EXCEPTION
    WHEN OTHERS THEN
      add_log(p_batch_no, p_ne_id,'CREATE NEW MEMBS','N','ERROR  - '||SQLERRM);
 	  ROLLBACK TO start_of_procedure;
      RETURN;
  END;
  add_log(p_batch_no, p_ne_id,'CREATE NEW MEMBS','Y','FINISH');

--     for each of the route members on which there is an asset, where the route member is a result
--     of a replacement, and the date of the replacement post-dates the date of the asset, create
--     and end-dated asset location on the replaced route member.


  BEGIN

    add_log(p_batch_no, p_ne_id,'CREATE END-DATED MEMBS',NULL,'START');

    OPEN  c_closed_mem (l_ne.ne_id, p_batch_no);
    FETCH c_closed_mem
    BULK COLLECT INTO
          l_iit_ne_id
        , l_nm_ne_id
        , l_nm_inv_type
        , l_nm_start
        , l_nm_date
        , l_nm_end_date
        , l_nm_end
        , l_nm_au
        , l_nm_seq_no;
    CLOSE c_closed_mem;

    add_log(p_batch_no, p_ne_id,'CREATE END-DATED MEMBS - count = '||TO_CHAR(l_iit_ne_id.COUNT),NULL,'START');

--  ensure that the start date of the location does not pre-date the date of the element.

    FOR i IN 1..l_iit_ne_id.COUNT LOOP

/*
      add_log(p_batch_no, p_ne_id,'END-DATED MEMBS - '||TO_CHAR(l_nm_ne_id(i))||','||TO_CHAR(l_nm_inv_type(i))||','||
                                            TO_CHAR(l_nm_start(i)),NULL,'START');
*/
      l_nm_date(i) := set_start_date( l_nm_date(i), l_nm_ne_id(i) );

    END LOOP;

    add_log(PI_BATCH_NO=> p_batch_no, PI_HERMIS_NE_ID=> p_ne_id, PI_HERMIS_OPERATION=> 'CREATE END_DATED MEMBS', PI_HERMIS_SUCCESS=> 'Y',PI_HERMIS_TEXT=>'Loop completed');

    FORALL i IN 1 .. l_iit_ne_id.COUNT
       INSERT INTO NM_MEMBERS_ALL
                   (nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type,
                    nm_begin_mp, nm_start_date, nm_end_date, nm_end_mp,
                    nm_slk, nm_cardinality, nm_admin_unit, nm_seq_no, nm_true
                   )
            VALUES (l_iit_ne_id (i), l_nm_ne_id (i), 'I', l_nm_inv_type (i),
                    l_nm_start (i), l_nm_date (i), l_nm_end_date(i), l_nm_end (i),
                    NULL, 1, l_nm_au (i), l_nm_seq_no(i), NULL );

  --
  EXCEPTION
    WHEN OTHERS THEN
      add_log(p_batch_no, p_ne_id,'CREATE END-DATED MEMBS','N','ERROR  - '||SQLERRM);
	  ROLLBACK TO start_of_procedure;
      RETURN;
  END;
  add_log(p_batch_no, p_ne_id,'CREATE END-DATED MEMBS','Y','FINISH');
--

  UPDATE HERMIS_REVERSAL
     SET hr_success_flag = 'Y'
   WHERE hr_ne_id = p_ne_id
   AND   hr_batch_no = p_batch_no;
--
  COMMIT;

--ROLLBACK;


/*
EXCEPTION
  WHEN OTHERS THEN
    add_log( p_batch_no, p_ne_id, 'failed', 'N', 'ERROR  - '||SQLERRM);
	ROLLBACK TO start_of_procedure;
    RAISE;
*/
END;
-------------------------------------------------------------------------------
--
END Reverse_Hermis_Section;
/
