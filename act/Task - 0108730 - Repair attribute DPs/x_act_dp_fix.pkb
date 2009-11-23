CREATE OR REPLACE PACKAGE BODY x_act_dp_fix
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/act/Task - 0108730 - Repair attribute DPs/x_act_dp_fix.pkb-arc   3.0   Nov 23 2009 10:25:02   aedwards  $
--       Module Name      : $Workfile:   x_act_dp_fix.pkb  $
--       Date into PVCS   : $Date:   Nov 23 2009 10:25:02  $
--       Date fetched Out : $Modtime:   Nov 23 2009 10:22:02  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
AS
  g_body_id CONSTANT VARCHAR2(30) :='"$Revision:   3.0  $"';
--
-------------------------------------------------------------------------------
--
  TYPE rec_attribs IS RECORD ( asset_type  nm_inv_type_attribs.ita_inv_type%TYPE
                             , attrib_name nm_inv_type_attribs.ita_attrib_name%TYPE 
                             , dec_places  nm_inv_type_attribs.ita_dec_places%TYPE);
--
  TYPE tab_attribs IS TABLE OF rec_attribs INDEX BY BINARY_INTEGER;
--
-------------------------------------------------------------------------------
--
  FUNCTION get_sccs_version RETURN NUMBER IS
  BEGIN
  --
    RETURN g_pvcs_id;
  --
  END get_sccs_version;
--
-------------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN NUMBER IS
  BEGIN
  --
    RETURN g_body_id;
  --
  END get_body_version;
--
-------------------------------------------------------------------------------
--
  PROCEDURE raise_error ( pi_error IN VARCHAR2 ) IS
  BEGIN
  --
    raise_application_error(-20001,pi_error);
  --
  END raise_error;
--
-------------------------------------------------------------------------------
--
  PROCEDURE do_asset_type_internal
               ( pi_asset_type        IN nm_inv_types.nit_inv_type%TYPE 
               , pi_asset_attrib_name IN nm_inv_type_attribs.ita_attrib_name%TYPE
               , pi_dec_places        IN nm_inv_type_attribs.ita_dec_places%TYPE)
  IS
  BEGIN
  --
    EXECUTE IMMEDIATE
      'UPDATE nm_inv_items_all '||
         'SET '||pi_asset_attrib_name||' = ROUND('||pi_asset_attrib_name||','
                                                  ||pi_dec_places||')'||
      ' WHERE iit_inv_type = '||nm3flx.string(pi_asset_type);
  --
  END do_asset_type_internal;
--
-------------------------------------------------------------------------------
--
  PROCEDURE do_asset_type 
               ( pi_asset_type IN nm_inv_types.nit_inv_type%TYPE )
  IS
    l_tab_attribs tab_attribs;
  BEGIN
  --
    SELECT ita_inv_type, ita_attrib_name, ita_dec_places 
      BULK COLLECT INTO l_tab_attribs
      FROM nm_inv_type_attribs
     WHERE ita_dec_places IS NOT NULL
       AND ita_format = nm3type.c_number
       AND ita_inv_type = pi_asset_type;
  --
    IF l_tab_attribs.COUNT > 0
    THEN
    --
      FOR i IN 1..l_tab_attribs.COUNT
      LOOP
      --
        do_asset_type_internal
                      ( pi_asset_type        => l_tab_attribs(i).asset_type
                      , pi_asset_attrib_name => l_tab_attribs(i).attrib_name 
                      , pi_dec_places        => l_tab_attribs(i).dec_places);
      --
      END LOOP;
    --
    END IF;
  --
  END do_asset_type;
--
-------------------------------------------------------------------------------
--
  PROCEDURE do_asset_type 
               ( pi_asset_type     IN nm_inv_types.nit_inv_type%TYPE 
               , pi_asset_view_col IN nm_inv_type_attribs.ita_view_col_name%TYPE)
  IS
    l_rec_ita nm_inv_type_attribs%ROWTYPE;
  BEGIN
  --
    l_rec_ita := nm3get.get_ita
                   ( pi_ita_inv_type      => pi_asset_type
                   , pi_ita_view_col_name => pi_asset_view_col);
  --
    IF l_rec_ita.ita_dec_places IS NOT NULL
    AND l_rec_ita.ita_format = nm3type.c_number
    THEN
  --
      do_asset_type_internal
          ( pi_asset_type        => pi_asset_type
          , pi_asset_attrib_name => l_rec_ita.ita_attrib_name
          , pi_dec_places        => l_rec_ita.ita_dec_places);
  --
    ELSE
      raise_error ('Not a numerical asset attribute ['||l_rec_ita.ita_format
                 ||'] - or no decimal places set ['||l_rec_ita.ita_dec_places||']');
    END IF;
  --
  END do_asset_type;
--
-------------------------------------------------------------------------------
--
  PROCEDURE do_asset_type 
               ( pi_asset_type        IN nm_inv_types.nit_inv_type%TYPE 
               , pi_asset_attrib_name IN nm_inv_type_attribs.ita_attrib_name%TYPE)
  IS
    l_rec_ita nm_inv_type_attribs%ROWTYPE;
  BEGIN
  --
    l_rec_ita := nm3get.get_ita
                   ( pi_ita_inv_type    => pi_asset_type
                   , pi_ita_attrib_name => pi_asset_attrib_name);
  --
    IF l_rec_ita.ita_dec_places IS NOT NULL
    AND l_rec_ita.ita_format = nm3type.c_number
    THEN
  --
      do_asset_type_internal
          ( pi_asset_type        => pi_asset_type
          , pi_asset_attrib_name => l_rec_ita.ita_attrib_name
          , pi_dec_places        => l_rec_ita.ita_dec_places);
  --
    ELSE
      raise_error ('Not a numerical asset attribute ['||l_rec_ita.ita_format
                 ||'] - or no decimal places set ['||l_rec_ita.ita_dec_places||']');
    END IF;
  END do_asset_type;
--
-------------------------------------------------------------------------------
--
  PROCEDURE run_checker
  IS
  BEGIN
    run_checker( pi_asset_type => NULL );
  END run_checker;
--
-------------------------------------------------------------------------------
--
  PROCEDURE run_checker
              ( pi_asset_type IN nm_inv_types.nit_inv_type%TYPE )
  IS
    l_retval                  NUMBER;
    l_result                  VARCHAR2(10);
    b_report_passes           BOOLEAN := FALSE;
    b_check_end_dated         BOOLEAN := TRUE;
  --
    PROCEDURE put_out ( pi_retval IN NUMBER
                      , pi_message IN nm3type.max_varchar2 )
    IS
    BEGIN
      IF pi_retval > 0
        THEN
        l_result := 'FAIL - ';
        dbms_output.put_line (l_result||pi_message);
      ELSE
        l_result := 'PASS - ';
        IF b_report_passes
        THEN
          dbms_output.put_line (l_result||pi_message);
        END IF;
      END IF;
    END put_out; 
  --
  BEGIN
  --
    dbms_output.enable;
  --
    FOR z IN (SELECT * FROM nm_inv_types
               WHERE nit_table_name IS NULL
                 AND nit_inv_type = NVL(pi_asset_type,nit_inv_type)
                 AND EXISTS
                   (SELECT 1 FROM nm_inv_type_attribs
                     WHERE nit_inv_type = ita_inv_type
                       AND ita_format = 'NUMBER'
                       AND (ita_dec_places IS NOT NULL OR ita_max IS NOT NULL)))
    LOOP
  --
      dbms_output.put_line ('--');
      dbms_output.put_line ('======================================================');
      dbms_output.put_line (' Checking '||z.nit_inv_type||' - '||z.nit_descr);
      dbms_output.put_line ('======================================================');
  --
      FOR i IN
      --
      (WITH all_num_attribs AS
        (SELECT * 
           FROM nm_inv_type_attribs
          WHERE ita_inv_type = z.nit_inv_type
            AND ita_format = 'NUMBER'
            AND (ita_dec_places IS NOT NULL OR ita_max IS NOT NULL)
        )
       SELECT 'SELECT COUNT(*) FROM nm_inv_items_all '||
               'WHERE iit_inv_type = '||nm3flx.string(ita_inv_type)||
               '  AND LENGTH(REPLACE('||ita_attrib_name||',''.'','''')) > '||ita_fld_length l_length_sql,
             --
               CASE
                 WHEN ita_dec_places IS NOT NULL
                 THEN
                   'SELECT COUNT(*) FROM nm_inv_items_all'||
                   ' WHERE iit_inv_type = '||nm3flx.string(ita_inv_type)||
                   '   AND '||ita_attrib_name||' IS NOT NULL'||
                   '   AND '||ita_attrib_name||' != '||'ROUND('||ita_attrib_name||','||ita_dec_places||')'
               END AS l_dp_sql,
             --
               CASE
                 WHEN ita_max IS NOT NULL
                 THEN
                   'SELECT COUNT(*) FROM nm_inv_items_all '||
                    'WHERE iit_inv_type = '||nm3flx.string(ita_inv_type)||
                     ' AND '||ita_attrib_name||' IS NOT NULL'||
                    '  AND '||ita_attrib_name||' > '||ita_max 
               END AS l_max_sql,
             --
               CASE
                 WHEN ita_min IS NOT NULL
                 THEN
                   'SELECT COUNT(*) FROM nm_inv_items_all '||
                    'WHERE iit_inv_type = '||nm3flx.string(ita_inv_type)||
                     ' AND '||ita_attrib_name||' IS NOT NULL'||
                     ' AND '||ita_attrib_name||' < '||ita_min 
               END AS l_min_sql
             --
             , ita_inv_type
             , ita_attrib_name
         FROM all_num_attribs
        ORDER BY 1)
      --
      LOOP
      --
        l_retval := 0;
        l_result := 'PASS - ';
      --
  --      dbms_output.put_line ('--');
      ---------------------------------------------------------------------------
      --  LENGTH CHECK VALIDATION
      ---------------------------------------------------------------------------
        EXECUTE IMMEDIATE i.l_length_sql INTO l_retval;
      --
        put_out ( pi_retval  => l_retval
                , pi_message => 'Asset '||i.ita_inv_type||' : ['||i.ita_attrib_name
                                        ||'] - LENGTH Check - has '||l_retval||' invalid records');
      ---------------------------------------------------------------------------
      --  DP CHECK VALIDATION
      ---------------------------------------------------------------------------
        IF i.l_dp_sql IS NOT NULL
        THEN
          EXECUTE IMMEDIATE i.l_dp_sql INTO l_retval;
        --
          put_out ( pi_retval  => l_retval
                  , pi_message => 'Asset '||i.ita_inv_type||' : ['||i.ita_attrib_name
                                          ||'] - DP Check - has '||l_retval||' invalid records');
        --
        END IF;
      ---------------------------------------------------------------------------
      --  MAX VALUE CHECK VALIDATION
      ---------------------------------------------------------------------------
        IF i.l_max_sql IS NOT NULL
        THEN
          EXECUTE IMMEDIATE i.l_max_sql INTO l_retval;
        --
          put_out ( pi_retval  => l_retval
                  , pi_message => 'Asset '||i.ita_inv_type||' : ['||i.ita_attrib_name
                                          ||'] - MAX Value Check - has '||l_retval||' invalid records');
        --
        END IF;
      ---------------------------------------------------------------------------
      --  MIN VALUE CHECK VALIDATION
      ---------------------------------------------------------------------------
        IF i.l_min_sql IS NOT NULL
        THEN
        --
          EXECUTE IMMEDIATE i.l_min_sql INTO l_retval;
        --
          put_out ( pi_retval  => l_retval
                  , pi_message => 'Asset '||i.ita_inv_type||' : ['||i.ita_attrib_name
                                          ||'] - MIN Value Check - has '||l_retval||' invalid records');
        --
        END IF;
      --
      END LOOP;
    --
      dbms_output.put_line ('--');
      dbms_output.put_line (' Finished checking '||z.nit_inv_type||' - '||z.nit_descr);
    END LOOP;
  --
  END run_checker;
--
-------------------------------------------------------------------------------
--
END x_act_dp_fix;