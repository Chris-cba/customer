create or replace view bike_ped_ROAD_SEG_RTE
as
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/Bike_Ped/admin/views/bike_ped_road_seg_rte.vw-arc   3.0   Sep 21 2010 14:28:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   bike_ped_road_seg_rte.vw  $
--       Date into PVCS   : $Date:   Sep 21 2010 14:28:36  $
--       Date fetched Out : $Modtime:   Sep 21 2010 14:24:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
    NQR_MRG_JOB_ID
  , NMS_MRG_SECTION_ID
  , rte_type_IS
  , RTE_TYPE_US_1
  , case when RTE_TYPE_US_2 != RTE_TYPE_US_1
    then
        RTE_TYPE_US_2 
    end RTE_TYPE_US_2
  ,  RTE_TYPE_OR_1
  , case when RTE_TYPE_OR_2 != RTE_TYPE_OR_1
    then
        RTE_TYPE_OR_2 
    end RTE_TYPE_OR_2
    from
        (
          select 
          NQR_MRG_JOB_ID
          , NMS_MRG_SECTION_ID
          , max(IS_route_id ) rte_type_IS
          , max(us_route_id ) RTE_TYPE_US_1 
          , min(us_route_id ) RTE_TYPE_US_2
          , max(or_route_id ) RTE_TYPE_OR_1 
          , min(or_route_id ) RTE_TYPE_OR_2 
          from 
         (
           Select NQR_MRG_JOB_ID, NMS_MRG_SECTION_ID, 
           NE_ID,
           NE_UNIQUE,
           NE_LENGTH,
           NE_DESCR,
           NE_START_DATE,
           NE_ADMIN_UNIT,
           ADMIN_UNIT_CODE,
           NE_GTY_GROUP_TYPE,
           ROUTE_SUFFIX,
           case when route_type = 'OR'
                then ROUTE_ID
           end OR_ROUTE_ID,
            case when route_type = 'I-'
                then ROUTE_ID
           end IS_ROUTE_ID,
            case when route_type = 'US'
                then ROUTE_ID
           end US_ROUTE_ID,
           ROUTE_TYPE
            from
            V_MRG_BIKE_PED_MRG
            , nm_members 
            , v_nm_rte_rte_nt
            where NMS_NE_ID_first = nm_ne_id_of 
            and nm_obj_type = 'RTE'
            and nE_id = nm_ne_id_in
          )
            group by NQR_MRG_JOB_ID
          , NMS_MRG_SECTION_ID
        );