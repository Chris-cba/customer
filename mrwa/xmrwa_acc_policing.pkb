CREATE OR REPLACE PACKAGE BODY xmrwa_acc_policing AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_acc_policing.pkb	1.1 03/15/05
--       Module Name      : xmrwa_acc_policing.pkb
--       Date into SCCS   : 05/03/15 00:45:22
--       Date fetched Out : 07/06/06 14:38:09
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA Accident Policing package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_acc_policing.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xmrwa_acc_policing';
--
   c_acc             CONSTANT  acc_item_types.ait_id%TYPE    := 'ACC';
   c_evt             CONSTANT  acc_item_types.ait_id%TYPE    := 'EVT';
   c_xmrwa           CONSTANT  hig_products.hpr_product%TYPE := 'XMRWA';
--
   g_tab_acc_id        nm3type.tab_number;
   g_tab_acc_parent_id nm3type.tab_number;
   g_tab_acc_top_id    nm3type.tab_number;
   g_tab_acc_ait_id    nm3type.tab_varchar4;
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
PROCEDURE clear_globals IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'clear_globals');
--
   g_tab_acc_id.DELETE;
   g_tab_acc_parent_id.DELETE;
   g_tab_acc_top_id.DELETE;
   g_tab_acc_ait_id.DELETE;
--
   nm_debug.proc_end (g_package_name,'clear_globals');
--
END clear_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_to_globals (p_acc_id         acc_items_all.acc_id%TYPE
                            ,p_acc_parent_id  acc_items_all.acc_parent_id%TYPE
                            ,p_acc_top_id     acc_items_all.acc_top_id%TYPE
                            ,p_acc_ait_id     acc_items_all.acc_ait_id%TYPE
                            ) IS
--
   c_count CONSTANT PLS_INTEGER := g_tab_acc_id.COUNT + 1;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'append_to_globals');
--
   g_tab_acc_id(c_count)        := p_acc_id;
   g_tab_acc_parent_id(c_count) := p_acc_parent_id;
   g_tab_acc_top_id(c_count)    := p_acc_top_id;
   g_tab_acc_ait_id(c_count)    := p_acc_ait_id;
--
   nm_debug.proc_end (g_package_name,'append_to_globals');
--
END append_to_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_globals IS
--
   l_evt_count PLS_INTEGER;
--
   FUNCTION get_evt_count (p_acc_parent_id acc_items_all.acc_parent_id%TYPE) RETURN PLS_INTEGER IS
      l_retval PLS_INTEGER;
   BEGIN
      SELECT  /*+ INDEX (acc acc_ind_parent) */ COUNT(1)
       INTO  l_retval
       FROM  acc_items_all  acc
      WHERE  acc_parent_id = p_acc_parent_id
       AND   acc_ait_id    = c_evt;
      RETURN l_retval;
   END get_evt_count;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'process_globals');
--
   FOR i IN 1..g_tab_acc_id.COUNT
    LOOP
--
      IF    g_tab_acc_ait_id(i) = c_evt
       THEN
         l_evt_count := get_evt_count (g_tab_acc_parent_id(i));
      ELSIF g_tab_acc_ait_id(i) = c_acc
       THEN
         l_evt_count := get_evt_count (g_tab_acc_id(i));
      ELSE
         l_evt_count := get_evt_count (g_tab_acc_top_id(i));
      END IF;
--
      IF l_evt_count > 1
       THEN
         hig.raise_ner (pi_appl => c_xmrwa
                       ,pi_id   => 1
                       );
      END IF;
--
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
END xmrwa_acc_policing;
/
