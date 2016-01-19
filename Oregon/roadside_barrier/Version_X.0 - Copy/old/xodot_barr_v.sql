CREATE OR REPLACE FORCE VIEW XODOT_BARR_V

AS
   SELECT ne_unique HWY,
          BEG_MP_no,
          END_MP_no,
          HIGHWAY_NUMBER,
          SUFFIX,
          ROADWAY_ID,
          MILEAGE_TYPE,
          OVERLAP_MILEAGE_CODE,
          general_road_direction ROAD_DIRECTION,
          ROAD_TYPE,
          iit_primary_key PRIMARY_KEY,
          highway_ea_number SECTION_EA,
          g.maint_section_crew_id SECTION_CREW,
          g.maint_dist_id DISTRICT,
          g.maint_reg_id REGION,
          BARR_TYP,
          CONC_CNSTRC_TYP,
          CONC_CON_DESC,
          RAIL_POST_SPACING_TYP,
          RAIL_POST_TYP,
          BARR_HT_CD,
          BARR_COND_CD,
          BEG_TRMNL_TYP,
          BEG_TRMNL_HT_CD,
          BEG_TRMNL_COND_CD,
          SHR_BEG_TRMNL_FLG,
          END_TRMNL_TYP,
          END_TRMNL_HT_CD,
          END_TRMNL_COND_CD,
          SHR_END_TRMNL_FLG,
          BARR_DESC,
          INV_COMNT,
          NOTE note,
          LAST_INV_Yr BARR_LAST_INV_DT
     FROM v_nm_BARR a,
          v_nm_hwy_hwy_nt hwy,
          (SELECT aloc_nm_ne_id_in IIT_NE_ID,
                  mem_nm_ne_id_in,
                  begin_MP_NO beg_mp_no,
                  end end_mp_no,
                  highway_ea_number
             FROM (SELECT aloc_nm_ne_id_in,
                          mem_nm_ne_id_in,
                          p_end,
                          begin_MP_NO,
                          end_mp_no,
                          next_b -- need an NVL here in case we are all on one datum!
                                ,
                          NVL (
                             LEAD ( end_MP_NO) OVER ( PARTITION BY aloc_nm_ne_id_in, mem_nm_ne_id_in  ORDER BY begin_MP_NO), end_mp_no)
                             end,
                          highway_ea_number
                     FROM (  SELECT aloc_nm_ne_id_in,
                                    mem_nm_ne_id_in,
                                    p_end,
                                    begin_MP_NO,
                                    end_mp_no,
                                    next_b,
                                    highway_ea_number
                               FROM (SELECT aloc_nm_ne_id_in,
                                            mem_nm_ne_id_in,
                                            begin_MP_NO,
                                            end_mp_no,
                                            LEAD (begin_MP_NO) OVER (   PARTITION BY aloc_nm_ne_id_in, mem_nm_ne_id_in ORDER BY begin_MP_NO) next_b,
                                            LAG (end_mp_NO) OVER (PARTITION BY aloc_nm_ne_id_in, mem_nm_ne_id_in ORDER BY end_MP_NO) P_end,
                                            highway_ea_number
                                       FROM (SELECT mem.nm_ne_id_in
                                                       mem_nm_ne_id_in,
                                                    aloc.nm_ne_id_in
                                                       aloc_nm_ne_id_in,
                                                    DECODE (
                                                       MEM.NM_CARDINALITY,
                                                       1,   mem.nm_slk
                                                          + aloc.nm_begin_mp,
                                                       -1,   mem.nm_end_slk
                                                           - aloc.nm_begin_mp)
                                                       begin_MP_NO,
                                                    DECODE (
                                                       MEM.NM_CARDINALITY,
                                                       1,   mem.nm_slk
                                                          + aloc.nm_end_mp,
                                                       -1,   mem.nm_end_slk
                                                           - aloc.nm_begin_mp)
                                                       END_MP_NO,
                                                    highway_ea_number
                                               FROM nm_members aloc,
                                                    nm_members mem,
                                                    (SELECT *  FROM v_nm_seea_nt, nm_members WHERE     ne_id = nm_ne_id_in  AND nm_obj_type = 'SEEA') s
                                              WHERE     mem.nm_obj_type = 'HWY'
                                                    AND aloc.nm_type = 'I'
                                                    -- set asset type here - massive speed differance
                                                    AND aloc.nm_obj_type =
                                                           'BARR'
                                                    AND aloc.nm_ne_id_of =
                                                           s.nm_ne_id_of
                                                    AND (    aloc.nm_begin_mp <
                                                                s.nm_end_mp
                                                         AND aloc.nm_end_mp >
                                                                s.nm_begin_mp)
                                                    --
                                                    AND mem.nm_ne_id_of = aloc.nm_ne_id_of --  and aloc.nm_ne_id_in in (           -- for testing
                                          --                          1166653,
                                           --                          1166650
                                                 --                          )
                                            ))
                              WHERE    (begin_mp_no != p_end OR p_end IS NULL)
                                    OR end_mp_no != next_b
                                    OR next_b IS NULL
                           ORDER BY begin_mp_no))
            WHERE p_end != begin_mp_no OR p_end IS NULL) loc,
          XODOT_EA_CW_DIST_REG_LOOKUP g
    WHERE     a.iit_ne_id = loc.iit_ne_id
          AND mem_nm_ne_id_in = hwy.ne_id
          AND HIGHWAY_EA_NUMBER = g.ea_number;


