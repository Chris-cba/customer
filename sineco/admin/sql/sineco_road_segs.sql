CREATE OR REPLACE FORCE VIEW ROAD_SEGS
(
   RSE_HE_ID,
   RSE_UNIQUE,
   RSE_ADMIN_UNIT,
   RSE_TYPE,
   RSE_GTY_GROUP_TYPE,
   RSE_GROUP,
   RSE_SYS_FLAG,
   RSE_AGENCY,
   RSE_LINKCODE,
   RSE_SECT_NO,
   RSE_ROAD_NUMBER,
   RSE_START_DATE,
   RSE_END_DATE,
   RSE_DESCR,
   RSE_ADOPTION_STATUS,
   RSE_ALIAS,
   RSE_BH_HIER_CODE,
   RSE_CARRIAGEWAY_TYPE,
   RSE_CLASS_INDEX,
   RSE_COORD_FLAG,
   RSE_DATE_ADOPTED,
   RSE_DATE_OPENED,
   RSE_ENGINEERING_DIFFICULTY,
   RSE_FOOTWAY_CATEGORY,
   RSE_GIS_MAPID,
   RSE_GIS_MSLINK,
   RSE_GRADIENT,
   RSE_HGV_PERCENT,
   RSE_INT_CODE,
   RSE_LAST_INSPECTED,
   RSE_LAST_SURVEYED,
   RSE_LENGTH,
   RSE_MAINT_CATEGORY,
   RSE_MAX_CHAIN,
   RSE_NETWORK_DIRECTION,
   RSE_NLA_TYPE,
   RSE_NUMBER_OF_LANES,
   RSE_PUS_NODE_ID_END,
   RSE_PUS_NODE_ID_ST,
   RSE_RECORD_INVENT_REV,
   RSE_REF_COAT_FLAG,
   RSE_REINSTATEMENT_CATEGORY,
   RSE_ROAD_CATEGORY,
   RSE_ROAD_ENVIRONMENT,
   RSE_ROAD_TYPE,
   RSE_SCL_SECT_CLASS,
   RSE_SEARCH_GROUP_NO,
   RSE_SEQ_SIGNIF,
   RSE_SHARED_ITEMS,
   RSE_SKID_RES,
   RSE_SPEED_LIMIT,
   RSE_STATUS,
   RSE_TRAFFIC_SENSITIVITY,
   RSE_VEH_PER_DAY,
   RSE_BEGIN_MP,
   RSE_CNT_CODE,
   RSE_COUPLET_ID,
   RSE_END_MP,
   RSE_GOV_LEVEL,
   RSE_MAX_MP,
   RSE_PREFIX,
   RSE_ROUTE,
   RSE_SUFFIX,
   RSE_LENGTH_STATUS,
   RSE_TRAFFIC_LEVEL,
   RSE_NET_SEL_CRT,
   RSE_USRN_NO,
   ROAD_HIERARCHY
)
AS
   SELECT 
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/sineco/admin/sql/sineco_road_segs.sql-arc   3.0   Nov 16 2010 14:51:22   Mike.Alexander  $
--       Module Name      : $Workfile:   sineco_road_segs.sql  $
--       Date into PVCS   : $Date:   Nov 16 2010 14:51:22  $
--       Date fetched Out : $Modtime:   Nov 16 2010 14:50:48  $
--       PVCS Version     : $Revision:   3.0  $
 -----------------------------------------------------------------------------
-- Created bespoke version for Sineco to hard-code sys flag to L as their
-- network model does not support RMMS style sys flags.  Ridiculous
-- decode is to force the column datatype to varchar2(4) otherwise
-- package signature errors throughout MAI and UKP.
-- SW 16 NOV 2010 in relation to calls 728183 and 726912.
 -----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2010
 -----------------------------------------------------------------------------
          ne.ne_id                                      rse_he_id,
          ne.ne_unique                                  rse_unique,
          ne.ne_admin_unit                              rse_admin_unit,
          DECODE (ne.ne_gty_group_type, NULL, 'S', 'G') rse_type,
          DECODE (ne.ne_gty_group_type,
                 'LLNK', 'LINK',
                 'DLNK', 'LINK',
                 ne.ne_gty_group_type)                  rse_gty_group_type,
          DECODE (ne.ne_gty_group_type,
                  NULL,
                  SUBSTR (ne.ne_unique, 1, INSTR (ne.ne_unique, '/') - 1),
                  ne.ne_unique)                         rse_group,
      --  ne.ne_prefix rse_sys_flag,
      --  ne.NE_SUB_CLASS rse_sys_flag,
          DECODE (ne.ne_nt_type, 
                  ne.ne_nt_type, 'L', 
                  NULL, 'L', 'L   ')                    rse_sys_flag,  --16112010
          DECODE (
            DECODE (ne.ne_gty_group_type,
                   'LLNK', 'Y',
                   'DLNK', 'Y',
                    NULL, 'Y',
                   'N'),
                 'Y', ne.ne_owner,
                  NULL)                                 rse_agency,
          DECODE (
            DECODE (ne.ne_gty_group_type,
                   'LLNK', 'Y',
                   'DLNK', 'Y',
                    NULL, 'Y',
                   'N'),
                 'Y', ne.ne_sub_type || ne.ne_name_1,
                  NULL)                                 rse_linkcode,
          DECODE (ne.ne_gty_group_type, 
                  NULL, ne.ne_number, NULL)             rse_sect_no,
          DECODE (ne.ne_nt_type,
                 'L', linkcode.ne_group,
                 'D', linkcode.ne_group,
                  ne.ne_group)                          rse_road_number,
          ne.ne_start_date                              rse_start_date,
          ne.ne_end_date                                rse_end_date,
          ne.ne_descr                                   rse_descr,
          SUBSTR (iit_chr_attrib26, 1, 1)               rse_adoption_status,
          iit_num_attrib16                              rse_alias,
          DECODE (ne.ne_gty_group_type,
                 'LLNK', ne.ne_name_2,
                 'DLNK', ne.ne_name_2)                  rse_bh_hier_code,
          SUBSTR (iit_chr_attrib28, 1, 1)               rse_carriageway_type,
          DECODE (ne.ne_nt_type,
                 'L',SUBSTR (iit_chr_attrib28, 1, 6)    --rse_carriageway_type
                 || iit_num_attrib22                    --rse_number_of_lanes
                 || ne.ne_sub_class                     --rse_scl_sect_class
                 || SUBSTR (iit_chr_attrib41, 1, 1)     --rse_road_environment
                 || SUBSTR (iit_chr_attrib44, 1, 1)     --rse_shared_items
                ,'D',SUBSTR (iit_chr_attrib28, 1, 6)    --rse_carriageway_type
                 || iit_num_attrib22                    --rse_number_of_lanes
                 || ne.ne_sub_class                     --rse_scl_sect_class
                 || SUBSTR (iit_chr_attrib41, 1, 1)     --rse_road_environment
                 || SUBSTR (iit_chr_attrib44, 1, 1)     --rse_shared_items
                 )                                      rse_class_index,
          SUBSTR (iit_chr_attrib29, 1, 1)               rse_coord_flag,
          iit_date_attrib86                             rse_date_adopted,
          iit_date_attrib87                             rse_date_opened,
          SUBSTR (iit_chr_attrib31, 1, 2)               rse_engineering_difficulty,
          SUBSTR (iit_chr_attrib32, 1, 1)               rse_footway_category,
          TO_NUMBER (NULL)                              rse_gis_mapid,
          TO_NUMBER (NULL)                              rse_gis_mslink,
          TO_NUMBER (NULL)                              rse_gradient,
          iit_num_attrib20                              rse_hgv_percent,
          SUBSTR (iit_chr_attrib33, 1, 4)               rse_int_code,
          iit_date_attrib88                             rse_last_inspected,
          iit_date_attrib89                             rse_last_surveyed,
          DECODE (ne.ne_gty_group_type,
                  NULL, get_ne_length (ne.ne_id),
                  NULL)                                 rse_length,
          SUBSTR (iit_chr_attrib34, 1, 2)               rse_maint_category,
          TO_NUMBER (NULL)                              rse_max_chain,
          SUBSTR (iit_chr_attrib35, 1, 2)               rse_network_direction,
          SUBSTR (iit_chr_attrib36, 1, 1)               rse_nla_type,
          iit_num_attrib22                              rse_number_of_lanes,
          get_node_name (ne.ne_no_end)                  rse_pus_node_id_end,
          get_node_name (ne.ne_no_start)                rse_pus_node_id_st,
          SUBSTR (iit_chr_attrib37, 1, 1)               rse_record_invent_rev,
          SUBSTR (iit_chr_attrib38, 1, 1)               rse_ref_coat_flag,
          SUBSTR (iit_chr_attrib39, 1, 2)               rse_reinstatement_category,
          SUBSTR (iit_chr_attrib40, 1, 1)               rse_road_category,
          SUBSTR (iit_chr_attrib41, 1, 1)               rse_road_environment,
          SUBSTR (iit_chr_attrib42, 1, 2)               rse_road_type,
          ne.ne_sub_class                               rse_scl_sect_class,
          iit_num_attrib23                              rse_search_group_no,
          SUBSTR (iit_chr_attrib43, 1, 1)               rse_seq_signif,
          SUBSTR (iit_chr_attrib44, 1, 1)               rse_shared_items,
          iit_num_attrib24                              rse_skid_res,
          iit_num_attrib25                              rse_speed_limit,
          SUBSTR (iit_chr_attrib45, 1, 1)               rse_status,
          SUBSTR (iit_chr_attrib46, 1, 2)               rse_traffic_sensitivity,
          iit_num_attrib76                              rse_veh_per_day,
          iit_num_attrib77                              rse_begin_mp,
          iit_num_attrib78                              rse_cnt_code,
          iit_num_attrib79                              rse_couplet_id,
          iit_num_attrib80                              rse_end_mp,
          SUBSTR (iit_chr_attrib47, 1, 2)               rse_gov_level,
          iit_num_attrib81                              rse_max_mp,
          SUBSTR (iit_chr_attrib48, 1, 2)               rse_prefix,
          iit_num_attrib82                              rse_route,
          SUBSTR (iit_chr_attrib49, 1, 2)               rse_suffix,
          SUBSTR (iit_chr_attrib50, 1, 1)               rse_length_status,
          SUBSTR (iit_chr_attrib51, 1, 1)               rse_traffic_level,
          DECODE (ne.ne_nt_type,
                 'LGT', ne.ne_version_no,
                 'NLGT', ne.ne_version_no,
                 'N')                                   rse_net_sel_crt,
          iit_num_attrib83                              rse_usrn_no,
          iit_chr_attrib60                              road_hierarchy
     FROM nm_elements_all                               ne,
          nm_nw_ad_link_all                             nad,
          nm_inv_items_all                              iit,
          nm_elements_all                               linkcode
    WHERE ne.ne_id = nad.nad_ne_id(+)
      AND nad.nad_iit_ne_id = iit.iit_ne_id(+)
      AND nad.nad_primary_ad(+) = 'Y'
      AND ne.ne_name_2 = linkcode.ne_unique(+)
/

