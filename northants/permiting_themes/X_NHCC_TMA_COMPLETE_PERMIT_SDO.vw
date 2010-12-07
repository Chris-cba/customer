CREATE OR REPLACE  VIEW X_NHCC_TMA_COMPLETE_PERMIT_SDO AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/permiting_themes/X_NHCC_TMA_COMPLETE_PERMIT_SDO.vw-arc   1.0   Dec 07 2010 08:41:44   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_NHCC_TMA_COMPLETE_PERMIT_SDO.vw  $
--       Date into PVCS   : $Date:   Dec 07 2010 08:41:44  $
--       Date fetched Out : $Modtime:   Dec 07 2010 08:40:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- View created for Northants as part of BRS 3384 for Northants (NHSWM)
-- this views contains all the completed phases that are permited
--
-----------------------------------------------------------------------------
          twor_works_id,
          twor_works_ref,
          twor_org_ref,
          twor_dist_ref,
          twor_no_of_phases,
          twor_str_ne_id,
          twor_actual_works_id,
          twor_licence_id,
          twor_external_ref,
          org_name,
          org_prefix,
          dist_name,
          dist_prefix,
          str_usrn,
          str_descr,
          str_locality,
          str_town,
          str_county,
          str_provisional_street_flag,
          tphs_active_flag,
          tphs_phase_no,
          tphs_description,
          tphs_phase_status,
          tphs_works_category,
          twca_description,
          tphs_phase_type,
          hig_codes1.hco_meaning phase_type_meaning,
          tphs_proposed_start_date,
          tphs_est_end_date,
          tphs_latest_start_date,
          tphs_latest_end_date,
          tphs_act_start_date,
          tphs_act_end_date,
          tphs_start_date,
          tphs_end_date,
          hig_codes2.hco_meaning phase_status_meaning,
          tphs_reinst_cat,
          tphs_phase_id,
          tphs_loc_description,
          tphs_challenged,
          tphs_cway_restrict_type,
          hig_codes3.hco_meaning cway_restrict_meaning,
          B.TPPS_TPHS_GEOMETRY
     FROM v_tma_works_active_phase_ah,
          nsg_organisations,
          nsg_districts,
          v_tma_streets, 
          tma_works_categories,
          hig_codes hig_codes1,
          hig_codes hig_codes2,
          hig_codes hig_codes3,
          TMA_PHASES_POINT_SDO b
    WHERE     twor_org_ref = org_ref
          AND twor_dist_ref = dist_ref
          AND org_ref = dist_org_ref
          AND twor_str_ne_id = str_ne_id
          AND tphs_works_category = twca_works_category
          AND tphs_phase_type = hig_codes1.hco_code
          AND hig_codes1.hco_domain = 'PHASE_TYPE'
          AND tphs_phase_status = hig_codes2.hco_code
          AND hig_codes2.hco_domain = 'PHASE_STATUS'
          AND hig_codes3.hco_domain = 'PHASE_CWAY_RESTRICT'
          AND tphs_cway_restrict_type = hig_codes3.hco_code
          AND tphs_phase_status IN
                 ('WORKS_COMPLETE',
                  'WORKS_COMPLETE_EX',
                  'WORKS_COMPLETE_NOEX')
          AND tphs_phase_id = b.TPPS_TPHS_ID
          AND  x_nhswm_phase_permited(twor_works_id,tphs_phase_no ) = 1; 
          
delete from user_sdo_geom_metadata 
   where table_name = 'X_NHCC_TMA_COMPLETE_PERMIT_SDO';
   
insert into user_sdo_geom_metadata
   select 'X_NHCC_TMA_COMPLETE_PERMIT_SDO', column_name, diminfo, SRID
    from user_sdo_geom_metadata 
  where table_name = 'TMA_PHASES_POINT_SDO';          

commit;          
