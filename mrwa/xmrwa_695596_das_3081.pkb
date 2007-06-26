CREATE OR REPLACE PACKAGE BODY xmrwa_695596_das_3081 AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_695596_das_3081.pkb	1.1 03/15/05
--       Module Name      : xmrwa_695596_das_3081.pkb
--       Date into SCCS   : 05/03/15 00:45:20
--       Date fetched Out : 07/06/06 14:38:08
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA DOCUMENT_GATEWAYS v3.0.x.x workaround package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_695596_das_3081.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xmrwa_695596_das_3081';
--
   TYPE tab_das IS TABLE OF doc_assocs%ROWTYPE INDEX BY BINARY_INTEGER;
   g_tab_das    tab_das;
   g_tab_insert nm3type.tab_boolean;
   g_tab_delete nm3type.tab_boolean;
--
   c_net_hpr_version CONSTANT hig_products.hpr_version%TYPE := nm3get.get_hpr (pi_hpr_product => nm3type.c_net).hpr_version;
   c_app_owner       CONSTANT VARCHAR2(30)                  := hig.get_application_owner;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_globals (p_das_table_name doc_assocs.das_table_name%TYPE
                         ,p_das_rec_id     doc_assocs.das_rec_id%TYPE
                         ,p_das_doc_id     doc_assocs.das_doc_id%TYPE
                         ,p_inserting      BOOLEAN
                         ,p_deleting       BOOLEAN
                         ) IS
--
   l_not_firing              EXCEPTION;
--
   c_das_table_name CONSTANT doc_assocs.das_table_name%TYPE := p_das_table_name;
   c_das_rec_id     CONSTANT doc_assocs.das_rec_id%TYPE     := p_das_rec_id;
   c_das_doc_id     CONSTANT doc_assocs.das_doc_id%TYPE     := p_das_doc_id;
--
   l_rec_iit                 nm_inv_items%ROWTYPE;
   l_rec_das                 doc_assocs%ROWTYPE;
--
   c_count CONSTANT PLS_INTEGER := g_tab_das.COUNT+1;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'add_to_globals');
--
   IF c_das_table_name != 'NM_INV_ITEMS'
    OR c_net_hpr_version NOT LIKE '3.0%'
    THEN
      RAISE l_not_firing;
   END IF;
--
   l_rec_iit := nm3get.get_iit (pi_iit_ne_id => c_das_rec_id);
--
   l_rec_das.das_table_name := c_app_owner||'.'||nm3inv_view.derive_nw_inv_type_view_name(l_rec_iit.iit_inv_type);
   l_rec_das.das_rec_id     := c_das_rec_id;
   l_rec_das.das_doc_id     := c_das_doc_id;
--
   IF nm3get.get_dgt (pi_dgt_table_name  => l_rec_das.das_table_name
                     ,pi_raise_not_found => FALSE
                     ).dgt_table_name IS NULL
    THEN
      RAISE l_not_firing;
   END IF;
--
   g_tab_das(c_count)       := l_rec_das;
   g_tab_insert(c_count)    := p_inserting;
   g_tab_delete(c_count)    := p_deleting;
--
   nm_debug.proc_end (g_package_name,'add_to_globals');
--
EXCEPTION
   WHEN l_not_firing
    THEN
      Null;
END add_to_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_globals IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'clear_globals');
--
   g_tab_das.DELETE;
   g_tab_insert.DELETE;
   g_tab_delete.DELETE;
--
   nm_debug.proc_end (g_package_name,'clear_globals');
--
END clear_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_globals IS
   l_rec_das                 doc_assocs%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'process_globals');
--
   FOR i IN 1..g_tab_das.COUNT
    LOOP
      l_rec_das := g_tab_das(i);
      IF g_tab_insert(i)
       THEN
         nm3ins.ins_das (l_rec_das);
      ELSIF g_tab_delete(i)
       THEN
         nm3del.del_das (pi_das_table_name  => l_rec_das.das_table_name
                        ,pi_das_rec_id      => l_rec_das.das_rec_id
                        ,pi_das_doc_id      => l_rec_das.das_doc_id
                        ,pi_raise_not_found => FALSE
                        );
      END IF;
   END LOOP;
--
   clear_globals;
--
   nm_debug.proc_end (g_package_name,'process_globals');
--
END process_globals;
--
-----------------------------------------------------------------------------
--
END xmrwa_695596_das_3081;
/
