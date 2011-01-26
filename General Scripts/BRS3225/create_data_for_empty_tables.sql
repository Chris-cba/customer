-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/create_data_for_empty_tables.sql-arc   1.0   Jan 26 2011 07:58:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_data_for_empty_tables.sql  $
--       Date into PVCS   : $Date:   Jan 26 2011 07:58:12  $
--       Date fetched Out : $Modtime:   Jan 25 2011 17:11:22  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : AIleen Heal
--
--    %YourObjectname%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
DECLARE
--
CURSOR missing
  IS
    SELECT nth_theme_id, nth_theme_name, nth_feature_table, nth_feature_shape_column, ntg_gtype
      FROM nm_themes_all, nm_theme_gtypes
     WHERE nth_theme_type = 'SDO'
       AND nth_theme_id = ntg_theme_id
       AND nth_theme_id = nth_theme_id
       AND NOT EXISTS
         (SELECT 1 FROM user_sdo_geom_metadata
           WHERE table_name = nth_feature_table
             AND column_name = nth_feature_shape_column)
     ORDER BY nth_base_table_theme NULLS FIRST, nth_theme_id;
--
  l_diminfo      mdsys.sdo_dim_array := nm3sdo.coalesce_nw_diminfo;
  l_real_diminfo mdsys.sdo_dim_array;
  l_srid         NUMBER;
  l_count        NUMBER;
--
  CURSOR get_srid
  IS
    SELECT srid FROM user_sdo_geom_metadata
     WHERE srid IS NOT NULL
       AND rownum=1;
--
BEGIN
--
  OPEN get_srid; FETCH get_srid INTO l_srid; CLOSE get_srid;
--
  nm_debug.debug_on;
  FOR i IN missing
  LOOP
  --
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||i.nth_feature_table INTO l_count;
  --
    IF l_count = 0
    THEN 
  --
      --
      BEGIN
        IF i.ntg_gtype LIKE '2%'
        THEN
          l_real_diminfo := sdo_lrs.convert_to_std_dim_array(l_diminfo);
        ELSE
          l_real_diminfo := l_diminfo;
        END IF;
     --
     -- Insert USGM for the Highways Owner
     --
        INSERT INTO user_sdo_geom_metadata
        VALUES 
          (i.nth_feature_table,
           i.nth_feature_shape_column,
           l_real_diminfo,
           l_srid);
      --
      -- Insert USGM for the subordinate users based on the row above
      --
        INSERT INTO MDSYS.sdo_geom_metadata_table
           SELECT hus_username, nth_feature_table, nth_feature_shape_column,sdo_diminfo, sdo_srid
             FROM MDSYS.sdo_geom_metadata_table u,
                  (SELECT   hus_username, nth_feature_table, nth_feature_shape_column
                       FROM (SELECT hus_username, a.nth_feature_table, a.nth_feature_shape_column
                               FROM nm_themes_all a,
                                    nm_theme_roles,
                                    hig_user_roles,
                                    hig_users,
                                    all_users
                              WHERE nthr_theme_id = a.nth_theme_id
                                AND nthr_role = hur_role
                                AND hur_username = hus_username
                                AND hus_username = username
                                AND hus_username != hig.get_application_owner
                                AND a.nth_feature_table = i.nth_feature_table
                                AND a.nth_feature_shape_column = i.nth_feature_shape_column
                                AND NOT EXISTS (
                                       SELECT 1
                                         FROM MDSYS.sdo_geom_metadata_table g1
                                        WHERE g1.sdo_owner = hus_username
                                          AND g1.sdo_table_name = nth_feature_table
                                          AND g1.sdo_column_name = nth_feature_shape_column)
                             UNION ALL
                             SELECT hus_username, b.nth_feature_table, b.nth_feature_shape_column
                               FROM nm_themes_all a,
                                    hig_users,
                                    all_users,
                                    nm_themes_all b
                              WHERE b.nth_theme_id = a.nth_base_table_theme
                                AND hus_username = username
                                AND hus_username != hig.get_application_owner
                                AND a.nth_feature_table = i.nth_feature_table
                                AND a.nth_feature_shape_column = i.nth_feature_shape_column
                                AND NOT EXISTS (
                                       SELECT 1
                                         FROM MDSYS.sdo_geom_metadata_table g1
                                        WHERE g1.sdo_owner = hus_username
                                          AND g1.sdo_table_name = b.nth_feature_table
                                          AND g1.sdo_column_name = b.nth_feature_shape_column))
                   GROUP BY hus_username, nth_feature_table, nth_feature_shape_column)
            WHERE u.sdo_table_name = nth_feature_table
              AND u.sdo_column_name = nth_feature_shape_column
              AND u.sdo_owner = hig.get_application_owner;
      --
      EXCEPTION
        WHEN OTHERS
        THEN
          nm_debug.debug(i.nth_theme_name||' - '||SQLERRM);
      END;
    --
    END IF;
    --
  END LOOP;

  -- added by Aileen to recreate any spatial idexes which would have failed due to sdo_geom_metadata entry
  -- having been delete when refreshing metadata for empty tables.
  For csrec in (select index_name, table_name, STATUS, domidx_status, domidx_opstatus from user_indexes
     where ityp_name = 'SPATIAL_INDEX' and domidx_opstatus = 'FAILED') loop
        execute immediate ('drop index '||csrec.index_name);
        nm3sdo.create_spatial_idx(csrec.table_name,nm3sdo.get_spatial_column_name(csrec.table_name));
  end loop;


  nm_debug.debug_off;
--
END;
/