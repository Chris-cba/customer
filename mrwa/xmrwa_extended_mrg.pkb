CREATE OR REPLACE PACKAGE BODY xmrwa_extended_mrg AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_extended_mrg.pkb	1.1 03/15/05
--       Module Name      : xmrwa_extended_mrg.pkb
--       Date into SCCS   : 05/03/15 00:45:33
--       Date fetched Out : 07/06/06 14:38:19
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA Extended Merge package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_extended_mrg.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xmrwa_extended_mrg';
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
PROCEDURE get_sula_sush_specified_year IS
--
   c_grr_job_id         CONSTANT gri_report_runs.grr_job_id%TYPE := higgri.get_last_grr_job_id;
   c_nmq_unique         CONSTANT nm_mrg_query.nmq_unique%TYPE    := 'JONS_SULA_SUSH';
   c_final_table        CONSTANT VARCHAR2(30)                    := 'JONS_SULA_SUSH_TAB';
   c_grp_param_year     CONSTANT gri_params.gp_param%TYPE        := 'YEAR';
   c_grp_param_element  CONSTANT gri_params.gp_param%TYPE        := 'GAZ_NW';
   c_grp_param_extent   CONSTANT gri_params.gp_param%TYPE        := 'GAZ_EX';
   c_nmq_unique_temp    CONSTANT nm_mrg_query.nmq_unique%TYPE    := 'TMP_GRR'||c_grr_job_id;
--
   l_rec_nmq                     nm_mrg_query%ROWTYPE;
   l_nmq_id                      nm_mrg_query.nmq_id%TYPE;
   l_tab_years                   nm3type.tab_varchar2000;
   l_tab_inv_types               nm3type.tab_varchar4;
   l_nqr_job_id                  nm_mrg_query_results.nqr_mrg_job_id%TYPE;
   l_nte_job_id                  nm_nw_temp_extents.nte_job_id%TYPE;
   l_condition                   nm_mrg_query_attribs.nqa_condition%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_sula_sush_specified_year');
--
   -- Get the existing query (make sure it exists)
   l_rec_nmq := nm3get.get_nmq (pi_nmq_unique => c_nmq_unique);
--
   -- Create the Temp NE from the GRI_RUN_PARAMETERS
   l_nte_job_id := create_temp_ne_from_grp (pi_grr_job_id         => c_grr_job_id
                                           ,pi_element_param_name => c_grp_param_element
                                           ,pi_extent_param_name  => c_grp_param_extent
                                           );
--
   -- Shouldn't be there, but delete just in case
   nm3del.del_nmq (pi_nmq_unique      => c_nmq_unique_temp
                  ,pi_raise_not_found => FALSE
                  );
--
   -- Take a copy of the "standard" query
   l_nmq_id  := nm3mrg_toolkit.copy_mrg_query (pi_nmq_id_old     => l_rec_nmq.nmq_id
                                              ,pi_nmq_unique_new => c_nmq_unique_temp
                                              ,pi_nmq_descr_new  => NULL
                                              ,pi_create_views   => TRUE
                                              );
--
   -- Lock the query. We don't want anyone else messing with it!
   nm3lock_gen.lock_nmq (pi_nmq_id => l_nmq_id);
--
-- Get the list of the years specified in the run parameters
   l_tab_years := nm3mrg_toolkit.get_tab_grp_for_mrg_conditions (pi_grp_job_id => c_grr_job_id
                                                                ,pi_grp_param  => c_grp_param_year
                                                                );
--
   IF l_tab_years.COUNT > 0
    THEN -- Only add the conditions if there have been some values specified
      --
      -- the condition is dependent on whether there is 1 (=) or >1 (IN) values specified
      l_condition        := nm3mrg_toolkit.get_condition_from_array_count(l_tab_years.COUNT);
      --
      -- Do this in a simple loop as SULA and SUSH are the same
      l_tab_inv_types(1) := 'SULA';
      l_tab_inv_types(2) := 'SUSH';
      FOR i IN 1..l_tab_inv_types.COUNT
       LOOP
         nm3mrg_toolkit.add_condition_to_query (pi_nmq_id            => l_nmq_id
                                               ,pi_nit_inv_type      => l_tab_inv_types(i)
                                               ,pi_ita_view_col_name => 'IIT_YEAR'
                                               ,pi_nqa_condition     => l_condition
                                               ,pi_tab_values        => l_tab_years
                                               );
      END LOOP;
   END IF;
--
   -- Run the query
   nm3mrg.execute_mrg_query
             (pi_query_id      => l_nmq_id
             ,pi_nte_job_id    => l_nte_job_id
             ,pi_description   => c_grr_job_id||' '||c_nmq_unique
             ,po_result_job_id => l_nqr_job_id
             );
--
   -- Take a copy of the results of the query and put them into the table
--   nm3mrg_toolkit.insert_mrg_results_into_table (pi_nqr_job_id          => l_nqr_job_id
--                                                ,pi_view_name           => nm3mrg_view.get_mrg_view_name_by_qry_id(l_nmq_id)
--                                                ,pi_table_name          => c_final_table
--                                                ,pi_view_mrg_job_id_col => 'NMS_MRG_JOB_ID'
--                                                ,pi_grr_job_id          => c_grr_job_id
--                                                ,pi_grr_job_id_col      => 'GRR_JOB_ID'
--                                                );
--
   --
   --   Call nik's code here to shuffle the data in the merge tables.
   --
   --
--
   -- Delete the query behind us - we're finished with it
   nm3del.del_nmq (pi_nmq_id          => l_nmq_id
                  ,pi_raise_not_found => FALSE
                  );
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'get_sula_sush_specified_year');
--
END get_sula_sush_specified_year;
--
-----------------------------------------------------------------------------
--
FUNCTION create_temp_ne_from_grp (pi_grr_job_id         IN gri_report_runs.grr_job_id%TYPE
                                 ,pi_element_param_name IN gri_params.gp_param%TYPE DEFAULT NULL
                                 ,pi_extent_param_name  IN gri_params.gp_param%TYPE DEFAULT NULL
                                 ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
--
   CURSOR cs_grp (c_grp_job_id  gri_run_parameters.grp_job_id%TYPE
                 ,c_grp_param_year   gri_run_parameters.grp_param%TYPE
                 ,c_source_type VARCHAR2
                 ) IS
   SELECT grp_value
         ,c_source_type
    FROM  gri_run_parameters
   WHERE  grp_job_id = c_grp_job_id
    AND   grp_param  = c_grp_param_year
    AND   grp_value  IS NOT NULL;
--
   l_nte_job_id  nm_nw_temp_extents.nte_job_id%TYPE;
   l_found       BOOLEAN := FALSE;
--
   l_source_id   NUMBER;
   l_source_type VARCHAR2(30);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_temp_ne_from_grp');
--
   IF pi_element_param_name IS NOT NULL
    THEN
      OPEN  cs_grp (pi_grr_job_id,pi_element_param_name,nm3extent.c_route);
      FETCH cs_grp
       INTO l_source_id
           ,l_source_type;
      l_found := cs_grp%FOUND;
      CLOSE cs_grp;
   END IF;
--
   IF pi_extent_param_name IS NOT NULL
    AND NOT l_found
    THEN
      OPEN  cs_grp (pi_grr_job_id,pi_extent_param_name,nm3extent.c_saved);
      FETCH cs_grp
       INTO l_source_id
           ,l_source_type;
      l_found := cs_grp%FOUND;
      CLOSE cs_grp;
   END IF;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'GRI_RUN_PARAMETERS'
                    );
   END IF;
--
   nm3extent.create_temp_ne (pi_source_id => l_source_id
                            ,pi_source    => l_source_type
                            ,po_job_id    => l_nte_job_id
                            );
--
   nm_debug.proc_end(g_package_name,'create_temp_ne_from_grp');
--
   RETURN l_nte_job_id;
--
END create_temp_ne_from_grp;
--
-----------------------------------------------------------------------------
--
END xmrwa_extended_mrg;
/
