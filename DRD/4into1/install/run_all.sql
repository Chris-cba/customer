-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/DRD/4into1/install/run_all.sql-arc   1.0   Jan 17 2013 10:38:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   run_all.sql  $
--       Date into PVCS   : $Date:   Jan 17 2013 10:38:36  $
--       Date fetched Out : $Modtime:   Jan 17 2013 10:32:02  $
--       Version          : $Revision:   1.0  $
--
--   Copyright (c) exor corporation ltd, 2010
--
-----------------------------------------------------------------------------
BEGIN

  drd4into1.init;
  drd4into1.do_admin_units;
  drd4into1.do_hig_users;
  drd4into1.do_doc_types;
  drd4into1.do_docs;
  drd4into1.do_contact_address;

  drd4into1.inv_metadata;  
  drd4into1.do_inv_items;  
   do_inv_items;
  
   do_points;
   do_nodes;
   do_elements;
  --  do_nm_node_usages_all;
   DO_NM_MEMBERS_ALL;
   do_nm_nw_ad_link_all;
  
   DO_ACTIVITIES;
   DO_ACTIVITIES_REPORT;
   DO_ACT_FREQS;
   DO_ACT_REPORT_LINES;
   DO_STANDARD_ITEMS;
   DO_CONTRACTS;
   DO_CONTRACT_ITEMS;
   DO_CONTRACT_PAYMENTS;
   DO_COST_CENTRES;
   DO_DEFECT_PRIORITIES;
   DO_DEF_TREATS;
   DO_DEF_MOVEMENTS;
   DO_DEFECTS;
   DO_NM_AUDIT_ACTIONS;
   DO_NM_AUDIT_CHANGES;
   DO_NM_ELEMENT_HISTORY;
   DO_NOTICES;
   DO_NOTICE_DEFECTS;
   DO_REPAIRS;
   DO_SCHEDULES;
   DO_SCHEDULE_ITEMS;
   DO_SCHEDULE_ROADS;
   DO_SECTION_FREQS;
   DO_WORK_ORDERS;
   DO_WORK_ORDER_LINES;
   DO_BOQ_ITEMS;  
   DO_BUDGETS;
   DO_CLAIM_PAYMENTS;
   DO_CLAIM_PAYMENTS_AUDIT;
   DO_DOC_ACTIONS;
   DO_DOC_ACTION_HISTORY;
   DO_DOC_ASSOCS;
   DO_roles;


END;
/

  