CREATE OR REPLACE  VIEW X_NHCC_FWDPLAN_PERM_SHP_SDO AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS5006_permitting_themes/X_NHCC_FWDPLAN_PERM_SHP_SDO.vw-arc   1.0   May 10 2011 09:08:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_NHCC_FWDPLAN_PERM_SHP_SDO.vw  $
--       Date into PVCS   : $Date:   May 10 2011 09:08:48  $
--       Date fetched Out : $Modtime:   Apr 26 2011 10:38:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- View created for Northants as part of BRS 5006 for Northants (NHSWM)
-- this views contains all the FORWARD PLAN phases that are permited
-- the geometry is the shape of the phase
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
          B.TPHS_GEOMETRY
     FROM v_tma_works_active_phase_ah,
          nsg_organisations,
          nsg_districts,
          v_tma_streets, 
          tma_works_categories,
          hig_codes hig_codes1,
          hig_codes hig_codes2,
          hig_codes hig_codes3,
          TMA_PHASES_SDO b 
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
          AND tphs_phase_status IN ('FWD_PLAN')
          AND tphs_phase_id = b.TPHS_ID
          AND  tphs_proposed_start_date > to_date('01102011', 'MMDDYY')
          AND x_nhswm_permited_street(twor_str_ne_id) = 1;
          
delete from user_sdo_geom_metadata 
   where table_name = 'X_NHCC_FWDPLAN_PERM_SHP_SDO';
   
insert into user_sdo_geom_metadata
   select 'X_NHCC_FWDPLAN_PERM_SHP_SDO', column_name, diminfo, SRID
    from user_sdo_geom_metadata 
  where table_name = 'TMA_PHASES_SDO';          

commit;
          
