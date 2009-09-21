CREATE OR REPLACE FORCE VIEW v_wag_tpc_claimant (
   doc_id,
   hct_title,
   hct_first_name,
   hct_surname,
   had_postcode,
   had_building_no,
   had_building_name,
   had_sub_building_name_no,
   had_thoroughfare,
   had_dependent_thoroughfare,
   had_dependent_locality_name,
   had_post_town,
   had_county,
   hus_initials,
   hus_name
   )
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/view/v_wag_tpc_claimant.vw-arc   3.0   Sep 21 2009 16:13:12   smarshall  $
--       Module Name      : $Workfile:   v_wag_tpc_claimant.vw  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:13:12  $
--       Date fetched Out : $Modtime:   Sep 21 2009 14:51:16  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
   SELECT doc_id,
         hct_title,
         hct_first_name,
         hct_surname,
         had_postcode,
         had_building_no,
         had_building_name,
         had_sub_building_name_no,
         had_thoroughfare,
         had_dependent_thoroughfare,
         had_dependent_locality_name,
         had_post_town,
         had_county,
         hus_initials,
         hus_name
   FROM hig_contacts,
        docs,
        doc_enquiry_contacts,
        hig_contact_address,
        hig_address,
        hig_users
   WHERE     doc_id = dec_doc_id
         AND dec_hct_id = hct_id
         AND hct_id = hca_hct_id
         AND hca_had_id = had_id
         AND doc_user_id = hus_user_id
         AND dec_contact = 'Y'
/