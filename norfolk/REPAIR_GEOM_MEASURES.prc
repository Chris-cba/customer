CREATE OR REPLACE PROCEDURE NORFOLK.repair_geom_measures (pi_inv_type IN VARCHAR2)
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/REPAIR_GEOM_MEASURES.prc-arc   1.2   Nov 26 2013 16:11:04   Rob.Coupe  $
--       Module Name      : $Workfile:   REPAIR_GEOM_MEASURES.prc  $
--       Date into PVCS   : $Date:   Nov 26 2013 16:11:04  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:10:36  $
--       Version          : $Revision:   1.2  $
-------------------------------------------------------------------------

   CURSOR c1
   IS
      SELECT nth_theme_id,
             nth_feature_table,
             nith_nit_id,
             nth_xsp_column,
             nth_sequence_name,
             nit_pnt_or_cont,
             'I' nm_type,
             'NM_INV_ITEMS_ALL' business_table,
             'IIT_NE_ID' PK_COL
        FROM nm_inv_themes, nm_themes_all, nm_inv_types
       WHERE     nith_nth_theme_id = nth_theme_id
             AND nth_base_table_theme IS NULL
             AND NVL (pi_inv_type, nith_nit_id) = nith_nit_id
             AND nit_inv_type = nith_nit_id
             AND nth_dependency = 'D'
             AND not exists (select 1 from nm_nw_ad_types where nith_nit_id = nad_inv_type )
    union all
      SELECT nth_theme_id,
             nth_feature_table,
             nat_gty_group_type,
             nth_xsp_column,
             nth_sequence_name,
             'C',
             'G',
             'NM_ELEMENTS_ALL',
             'NE_ID '
        FROM nm_area_themes, nm_themes_all, nm_area_types
       WHERE     nath_nth_theme_id = nth_theme_id
             AND nth_base_table_theme IS NULL
             and nath_nat_id = nat_id
             AND NVL (pi_inv_type, nat_gty_group_type ) = nat_gty_group_type 
             AND nth_dependency = 'D';
   --
   c2str             VARCHAR2 (4000);

   TYPE c2curtype IS REF CURSOR;
   
   NULL_GEOM exception;
   pragma exception_init(NULL_GEOM, -01400);

   c2cur             c2curtype;
   --
   l_nm_ne_id_in     NM3TYPE.TAB_NUMBER;
   l_nm_ne_id_of     NM3TYPE.TAB_NUMBER;
   l_nm_begin_mp     NM3TYPE.TAB_NUMBER;
   l_nm_end_mp       NM3TYPE.TAB_NUMBER;
   l_nm_start_date   NM3TYPE.TAB_DATE;
   l_nm_end_date     NM3TYPE.TAB_DATE;
   l_iit_x_sect      NM3TYPE.TAB_VARCHAR4;
--
   l_offset_3d      VARCHAR2(2000) := '    SDO_LRS.OFFSET_GEOM_SEGMENT (shape, nm_begin_mp, nm_end_mp, hxo_offset, 0.005) ';
   l_offset_2d      VARCHAR2(2000) := '    SDO_LRS.convert_to_std_geom(SDO_LRS.OFFSET_GEOM_SEGMENT (shape, nm_begin_mp, nm_end_mp, hxo_offset, 0.005)) ';

   l_geom_3d        VARCHAR2(2000) := '    SDO_LRS.CLIP_GEOM_SEGMENT(shape, nm_begin_mp, nm_end_mp, 0.005) ';
   l_geom_2d        VARCHAR2(2000) := '    SDO_LRS.convert_to_std_geom(SDO_LRS.CLIP_GEOM_SEGMENT(shape, nm_begin_mp, nm_end_mp, 0.005)) ';
   
   l_geom           VARCHAR2(2000);
   l_geom2          VARCHAR2(2000);
   
--
BEGIN
--
   FOR irec IN c1
   LOOP
      --
      EXECUTE IMMEDIATE
            'delete from '|| irec.nth_feature_table|| '  s '
         || 'where not exists ( select 1 from nm_members_all m '
         || 'where m.nm_type = '|| ''''||irec.nm_type|| ''''
         || ' and m.nm_obj_type = '|| ''''|| irec.nith_nit_id|| ''''
         || ' and m.nm_ne_id_in = s.ne_id '
         || ' and m.nm_ne_id_of = s.ne_id_of '
         || ' and m.nm_begin_mp = s.nm_begin_mp '
         || ' and m.nm_end_mp   = s.nm_end_mp '
         || ' and m.nm_start_date = s.start_date '
         || ' and nvl(m.nm_end_date, to_date('||''''||'31-DEC-2090'||''''||'))  = nvl(s.end_date, to_date('||''''||'31-DEC-2090'||''''||' ))) '; 

      --
      IF irec.nth_xsp_column IS NOT NULL
      THEN
      
         if irec.nit_pnt_or_cont = 'C' and irec.nm_type = 'I' then
           l_geom := l_offset_3d;
         else
           l_geom := l_offset_2d;
         end if;

--if we use XSP it has to be an asset
                    
         c2str :=
               'select m.nm_ne_id_in, m.nm_ne_id_of, m.nm_begin_mp, m.nm_end_mp, m.nm_start_date, m.nm_end_date, i.iit_x_sect '
            || ' from nm_members_all m, '||irec.business_table||' i '
            || ' where m.nm_type = '|| ''''||irec.nm_type|| ''''
            || ' and m.nm_obj_type = i.iit_inv_type '
            || ' and i.iit_ne_id = m.nm_ne_id_in '
            || ' and m.nm_obj_type = '|| ''''||irec.nith_nit_id|| ''''
            || ' and not exists ( select 1 from '|| irec.nth_feature_table|| ' s '
            || '                  where  m.nm_ne_id_in = s.ne_id  '
            || '                  and m.nm_ne_id_of = s.ne_id_of '
            || '                  and m.nm_begin_mp = s.nm_begin_mp '
            || '                  and m.nm_end_mp = s.nm_end_mp '
            || '                  and m.nm_start_date = s.start_date '
            || '                  and nvl(m.nm_end_date, to_date('||''''||'31-DEC-2090'||''''||'))   = nvl(s.end_date, to_date('||''''||'31-DEC-2090'||''''||' ))) ';

         --
         OPEN c2cur FOR c2str;

         FETCH c2cur
            BULK COLLECT INTO l_nm_ne_id_in,
                 l_nm_ne_id_of,
                 l_nm_begin_mp,
                 l_nm_end_mp,
                 l_nm_start_date,
                 l_nm_end_date,
                 l_iit_x_sect;


         --
         FOR j IN 1 .. l_nm_ne_id_in.COUNT
         LOOP
            BEGIN

               EXECUTE IMMEDIATE
                     ' insert into '
                  || irec.nth_feature_table
                  || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, end_date, geoloc ) '
                  || '  select '
                  || irec.nth_sequence_name
                  || '.nextval, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, '
                  || l_geom
--                  || '    SDO_LRS.OFFSET_GEOM_SEGMENT (shape, nm_begin_mp, nm_end_mp, hxo_offset, 0.005) '
                  || '  from '
                  || '   ( select nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, hxo_offset '
                  || '  FROM herm_xsp h, '
                  || '      nm_members_all m '
                  || '  WHERE hxo_ne_id_of = nm_ne_id_of '
                  || '    and m.nm_ne_id_in = :l_nm_ne_id_in '
                  || '    and m.nm_begin_mp = :l_nm_begin_mp '
                  || '    and m.nm_start_date = :l_nm_start_date '
                  || '    AND nm_ne_id_of = :l_nm_ne_id_of '
                  || '    AND hxo_nwx_x_sect = :l_iit_x_sect '
                  || '    and nm_start_date between hxo_start_date and nvl(hxo_end_date, to_date('
                  || ''''
                  || '31-DEC-2099'
                  || ''''
                  || ')) '
                  || '    group by nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, hxo_offset ) '
                  || '  , nm_nsg_esu_shapes_table '
                  || '    where ne_id = nm_ne_id_of '
                  USING l_nm_ne_id_in (j),
                        l_nm_begin_mp (j),
                        l_nm_start_date (j),
                        l_nm_ne_id_of (j),
                        l_iit_x_sect (j);
            EXCEPTION
               WHEN NULL_GEOM then
                  if irec.nit_pnt_or_cont = 'C' then
                    l_geom2 := l_geom_3d;
                  else
                    l_geom2 := l_geom_2d;
                  end if;

                  BEGIN
                  EXECUTE IMMEDIATE
                     ' insert into '
                  || irec.nth_feature_table
                  || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, end_date, geoloc ) '
                  || '  select '
                  || irec.nth_sequence_name
                  || '.nextval, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, '
                  || l_geom2
--                  || '    SDO_LRS.OFFSET_GEOM_SEGMENT (shape, nm_begin_mp, nm_end_mp, hxo_offset, 0.005) '
                  || '  from '
                  || '   ( select nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, hxo_offset '
                  || '  FROM herm_xsp h, '
                  || '      nm_members_all m '
                  || '  WHERE hxo_ne_id_of = nm_ne_id_of '
                  || '    and m.nm_ne_id_in = :l_nm_ne_id_in '
                  || '    and m.nm_begin_mp = :l_nm_begin_mp '
                  || '    and m.nm_start_date = :l_nm_start_date '
                  || '    AND nm_ne_id_of = :l_nm_ne_id_of '
                  || '    AND hxo_nwx_x_sect = :l_iit_x_sect '
                  || '    and nm_start_date between hxo_start_date and nvl(hxo_end_date, to_date('
                  || ''''
                  || '31-DEC-2099'
                  || ''''
                  || ')) '
                  || '    group by nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, hxo_offset ) '
                  || '  , nm_nsg_esu_shapes_table '
                  || '    where ne_id = nm_ne_id_of '
                  USING l_nm_ne_id_in (j),
                        l_nm_begin_mp (j),
                        l_nm_start_date (j),
                        l_nm_ne_id_of (j),
                        l_iit_x_sect (j);
                  EXCEPTION
                    WHEN OTHERS
                    THEN
                      nm_debug.debug_on;
                      nm_debug.debug(sqlerrm);
                      nm_debug.debug_off;
                   END;
                   
               WHEN OTHERS
               THEN
                  nm_debug.debug_on;
                  nm_debug.debug(sqlerrm);
                  nm_debug.debug_off;
            END;
         END LOOP;
      --
      ELSE
         --     theme does not use lateral offset
      
         if irec.nit_pnt_or_cont = 'C' and irec.nm_type = 'I' then
           l_geom := l_geom_3d;
         else
           l_geom := l_geom_2d;
         end if;

         c2str :=
               'select m.nm_ne_id_in, m.nm_ne_id_of, m.nm_begin_mp, m.nm_end_mp, m.nm_start_date, m.nm_end_date '
            || ' from nm_members_all m, '||irec.business_table||' i '
            || ' where m.nm_type = '||''''|| irec.nm_type|| ''''
            || ' and i.'||irec.pk_col||' = m.nm_ne_id_in '
            || ' and m.nm_obj_type = '||''''|| irec.nith_nit_id|| ''''
            || ' and not exists ( select 1 from '
            || irec.nth_feature_table|| ' s '
            || '                  where  m.nm_ne_id_in = s.ne_id  '
            || '                  and m.nm_ne_id_of = s.ne_id_of '
            || '                  and m.nm_begin_mp = s.nm_begin_mp '
            || '                  and m.nm_end_mp = s.nm_end_mp '
            || '                  and m.nm_start_date = s.start_date '
            || '                  and nvl(m.nm_end_date, to_date('||''''||'31-DEC-2090'||''''||'))   = nvl(s.end_date, to_date('||''''||'31-DEC-2090'||''''||' ))) ';

         --
         OPEN c2cur FOR c2str;

         FETCH c2cur
            BULK COLLECT INTO l_nm_ne_id_in,
                 l_nm_ne_id_of,
                 l_nm_begin_mp,
                 l_nm_end_mp,
                 l_nm_start_date,
                 l_nm_end_date;

         --

         FOR j IN 1 .. l_nm_ne_id_in.COUNT
         LOOP
            BEGIN

               EXECUTE IMMEDIATE
                     ' insert into '
                  || irec.nth_feature_table
                  || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, start_date, end_date, geoloc ) '
                  || '  select '
                  || irec.nth_sequence_name
                  || '.nextval, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date, '
                  || l_geom
--                  || '    SDO_LRS.CLIP_GEOM_SEGMENT(shape, nm_begin_mp, nm_end_mp, 0.005) '
                  || '  from '
                  || '   ( select nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date '
                  || '  FROM  nm_members_all m '
                  || '  WHERE m.nm_ne_id_in = :l_nm_ne_id_in '
                  || '    and m.nm_begin_mp = :l_nm_begin_mp '
                  || '    and m.nm_start_date = :l_nm_start_date '
                  || '    AND nm_ne_id_of = :l_nm_ne_id_of '
                  || '    group by nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp, nm_start_date, nm_end_date ) '
                  || '  , nm_nsg_esu_shapes_table '
                  || '    where ne_id = nm_ne_id_of '
                  USING l_nm_ne_id_in (j),
                        l_nm_begin_mp (j),
                        l_nm_start_date (j),
                        l_nm_ne_id_of (j);
            EXCEPTION
               WHEN OTHERS
               THEN
                  nm_debug.debug_on;
                  nm_debug.debug(sqlerrm);
                  nm_debug.debug_off;
            END;
         END LOOP;
      END IF;
   END LOOP;
END;
/
