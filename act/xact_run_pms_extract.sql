CREATE OR REPLACE PROCEDURE xact_run_pms_extract IS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_run_pms_extract.sql	1.1 03/14/05
--       Module Name      : xact_run_pms_extract.sql
--       Date into SCCS   : 05/03/14 23:10:59
--       Date fetched Out : 07/06/06 14:33:49
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   PMS extract procedure
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
   l_rec_nmq        nm_mrg_query%ROWTYPE;
   l_tab_xsp        nm3type.tab_varchar4;
   l_results        nm_mrg_query_results.nqr_mrg_job_id%TYPE;
   l_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE;
   l_tab_ne_id      nm3type.tab_number;
--   l_tab_nte_job_id nm3type.tab_number;
   l_tab_ne_unique  nm3type.tab_varchar30;
   c_table_name CONSTANT VARCHAR2(30) := 'xact_pms_extract';
   l_tab_fixed_cols_source      nm3type.tab_varchar30;
--
   l_tab_variable_cols        nm3type.tab_varchar30;
   l_tab_variable_cols_type   nm3type.tab_varchar30;
   l_tab_variable_is_ft       nm3type.tab_varchar4;
   l_tab_variable_xsect_allow nm3type.tab_varchar4;
   l_tab_all_cols_dest        nm3type.tab_varchar30;
   l_tab_all_cols_source      nm3type.tab_varchar2000;
   l_view_name VARCHAR2(30);
   l_sql nm3type.max_varchar2;
--
   l_tab_functions            nm3type.tab_varchar30;
   l_tab_func_abbrev          nm3type.tab_varchar30;
--
   l_tab_func_inv_type        nm3type.tab_varchar4;
   l_tab_func_view_col        nm3type.tab_varchar30;
   l_tab_func_output_col      nm3type.tab_varchar30;
   l_tab_func_xsp_reqd        nm3type.tab_varchar4;
--
--   l_count NUMBER;
--
   PROCEDURE add_func_type (p_inv_type VARCHAR2, p_view_col VARCHAR2, p_output_col VARCHAR2 DEFAULT NULL) IS
      c PLS_INTEGER;
   BEGIN
      c := l_tab_func_inv_type.COUNT+1;
      l_tab_func_inv_type(c)   := p_inv_type;
      l_tab_func_view_col(c)   := p_view_col;
      l_tab_func_output_col(c) := NVL(p_output_col,p_view_col);
      l_tab_func_xsp_reqd(c)   := nm3get.get_nit(pi_nit_inv_type=>p_inv_type).nit_x_sect_allow_flag;
   END add_func_type;
--
   PROCEDURE add_col (p_dest VARCHAR2, p_source VARCHAR2) IS
      c PLS_INTEGER;
   BEGIN
      c := l_tab_all_cols_dest.COUNT+1;
      l_tab_all_cols_dest(c)   := p_dest;
      l_tab_all_cols_source(c) := p_source||nm3flx.i_t_e (p_source=p_dest
                                                         ,null
                                                         ,' '||p_dest
                                                         );
   END add_col;
--
BEGIN
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.set_level(1);
   l_rec_nmq   := nm3get.get_nmq (pi_nmq_unique => 'PMS_EXTRACT');
   l_view_name := nm3mrg_view.get_mrg_view_name_by_qry_id (pi_qry_id => l_rec_nmq.nmq_id)||'_SVL';
--
   SELECT xsr_x_sect_value
    BULK  COLLECT
    INTO  l_tab_xsp
    FROM  xsp_restraints
   WHERE  xsr_ity_inv_code = 'SEG'
--    AND ROWNUM<5
   ORDER BY xsr_x_sect_value;
--
   SELECT ne_id
         ,ne_unique
    BULK  COLLECT
    INTO  l_tab_ne_id
         ,l_tab_ne_unique
    FROM  nm_elements_all
   WHERE  ne_nt_type = 'ROAD'
--    AND   ne_unique  IN ('PARKES WY.')
--                        ,'MONARO HWY.'
--                        ,'TUGGERANONG PWY.'
--                        )
   ORDER BY ne_unique;
--
--   nm_debug.debug (l_tab_ne_id.COUNT||' routes to process (for each XSP)',1);
--   nm_debug.debug (l_tab_xsp.COUNT  ||' XSP to process',1);
--
   EXECUTE IMMEDIATE 'TRUNCATE TABLE '||c_table_name;
--
   SELECT nqt_inv_type
         ,ita_view_col_name
         ,DECODE(nit_table_name
                ,Null,'N'
                ,'Y'
                )
         ,nit_x_sect_allow_flag
    BULK  COLLECT
    INTO  l_tab_variable_cols_type
         ,l_tab_variable_cols
         ,l_tab_variable_is_ft
         ,l_tab_variable_xsect_allow
    FROM  nm_mrg_query_types
         ,nm_mrg_query_attribs
         ,nm_inv_type_attribs
         ,nm_inv_types
   WHERE  nqt_nmq_id         = l_rec_nmq.nmq_id
    AND   nqt_nmq_id         = nqa_nmq_id
    AND   nqt_seq_no         = nqa_nqt_seq_no
    AND   nqt_inv_type       = nit_inv_type
    AND   nqt_inv_type       = ita_inv_type
    AND   nqa_attrib_name    = ita_attrib_name
    AND   ita_view_col_name != 'SEGT_X_SECT';
--
   l_tab_functions(1)   := 'get_length_weighted_ave';
   l_tab_func_abbrev(1) := 'AVE';
   l_tab_functions(2)   := 'get_maximum_value';
   l_tab_func_abbrev(2) := 'MAX';
   l_tab_functions(3)   := 'get_minimum_value';
   l_tab_func_abbrev(3) := 'MIN';
   l_tab_functions(4)   := 'get_standard_deviation';
   l_tab_func_abbrev(4) := 'SD';
--
   add_func_type ('LASR','LASR_D_RUT','DRIVER_RUT_DEPTH');
   add_func_type ('LASR','LASR_P_RUT','PASSENGER_RUT_DEPTH');
   add_func_type ('FWD','FWD_LOAD');
   add_func_type ('FWD','FWD_M_000');
   add_func_type ('FWD','FWD_M_200');
--   add_func_type ('FWD','FWD_M_300');
--   add_func_type ('FWD','FWD_M_600');
--   add_func_type ('FWD','FWD_M_750');
--   add_func_type ('FWD','FWD_M_900');
--   add_func_type ('FWD','FWD_M_1500');
--
   FOR i IN 1..l_tab_xsp.COUNT
    LOOP
--
      nm_debug.debug (i||'.'||l_tab_xsp(i),1);
--
      l_tab_all_cols_dest.DELETE;
      l_tab_all_cols_source.DELETE;
--
      add_col ('ROUTE_UNIQUE','NQR_DESCRIPTION');
      add_col ('ROUTE_NE_ID','NMS_OFFSET_NE_ID');
      add_col ('BEGIN_MP','NMS_BEGIN_OFFSET');
      add_col ('END_MP','NMS_END_OFFSET');
      add_col ('XSP',nm3flx.string(l_tab_xsp(i)));
--
      FOR q IN 1..l_tab_variable_cols.COUNT
       LOOP
         IF l_tab_variable_is_ft(q) = 'Y'
          OR l_tab_variable_xsect_allow(q) != 'Y'
          THEN
            add_col (l_tab_variable_cols(q),l_tab_variable_cols_type(q)||'_'||l_tab_variable_cols(q));
         ELSE
            add_col (l_tab_variable_cols(q),l_tab_variable_cols_type(q)||'_'||l_tab_xsp(i)||'_'||l_tab_variable_cols(q));
         END IF;
      END LOOP;
--
      FOR r IN 1..l_tab_functions.COUNT
       LOOP
         FOR q IN 1..l_tab_func_inv_type.COUNT
          LOOP
            add_col (l_tab_func_abbrev(r)||'_'||l_tab_func_output_col(q)
                    ,'nm3eng_dynseg.'||l_tab_functions(r)
                     ||'(NMS_MRG_JOB_ID, NMS_MRG_SECTION_ID'
                     ||','||nm3flx.string(l_tab_func_inv_type(q))
                     ||nm3flx.i_t_e (l_tab_func_xsp_reqd(q) = 'Y'
                                    ,','||nm3flx.string(l_tab_xsp(i))
                                    ,Null
                                    )
                     ||','||nm3flx.string(l_tab_func_view_col(q))
                     ||')'
                    );
         END LOOP;
      END LOOP;
--
      DELETE FROM nm_mrg_query_results
      WHERE  nqr_nmq_id = l_rec_nmq.nmq_id;
--
      UPDATE nm_mrg_query_types
       SET   nqt_x_sect = l_tab_xsp (i)
      WHERE  nqt_nmq_id = l_rec_nmq.nmq_id
       AND   EXISTS (SELECT 1
                      FROM  nm_inv_types
                     WHERE  nit_inv_type = nqt_inv_type
                      AND   nit_table_name IS NULL
                      AND   nit_x_sect_allow_flag = 'Y'
                    );
--
--      UPDATE nm_mrg_query_values
--       SET   nqv_value       = l_tab_xsp (i)
--      WHERE  nqv_nmq_id      = l_rec_nmq.nmq_id
--       AND   nqv_attrib_name = 'IIT_X_SECT';
--
      nm3mrg_view.build_view (l_rec_nmq.nmq_id);
--
      FOR j IN 1..l_tab_ne_id.COUNT
       LOOP
         nm3extent.create_temp_ne (pi_source_id => l_tab_ne_id(j)
                                  ,pi_source    => nm3extent.c_route
                                  ,po_job_id    => l_nte_job_id
                                  );
         l_results := Null;
         nm3mrg.execute_mrg_query
             (pi_query_id      => l_rec_nmq.nmq_id
             ,pi_nte_job_id    => l_nte_job_id
             ,pi_description   => l_tab_ne_unique(j)
             ,po_result_job_id => l_results
             );
         DELETE FROM nm_nw_temp_extents
         WHERE nte_job_id = l_nte_job_id;
--         IF mod(j,1000) = 0
--          THEN
--            nm_debug.debug('----'||j||' processed for XSP '||l_tab_xsp(i),1);
--         END IF;
      END LOOP;
--      nm_debug.debug('----'||l_tab_ne_id.COUNT||' processed for XSP '||l_tab_xsp(i),1);
--
      l_sql := 'INSERT INTO '||c_table_name;
      FOR q IN 1..l_tab_all_cols_dest.COUNT
       LOOP
         l_sql := l_sql||CHR(10);
         IF q = 1
          THEN
            l_sql := l_sql||'(';
         ELSE
            l_sql := l_sql||',';
         END IF;
         l_sql := l_sql||l_tab_all_cols_dest(q);
      END LOOP;
      l_sql := l_sql||CHR(10)||')';
      l_sql := l_sql||CHR(10)||'SELECT ';
      FOR q IN 1..l_tab_all_cols_dest.COUNT
       LOOP
         l_sql := l_sql||CHR(10);
         IF q = 1
          THEN
            l_sql := l_sql||' ';
         ELSE
            l_sql := l_sql||',';
         END IF;
         l_sql := l_sql||l_tab_all_cols_source(q);
      END LOOP;
      l_sql := l_sql||CHR(10)||' FROM '||l_view_name;
      l_sql := l_sql||CHR(10)||' WHERE SEG_'||l_tab_xsp(i)||'_NAASRA_CLASS IS NOT NULL';
--      IF i = 1
--       THEN
--         nm_debug.debug(l_sql,1);
--      END IF;
      EXECUTE IMMEDIATE l_sql;
--      nm_debug.debug('--'||SQL%ROWCOUNT||' records created for XSP '||l_tab_xsp(i),1);
--
      COMMIT;
--
   END LOOP;
--   nm_debug.set_level(3);
--   nm_debug.debug_off;
--
END;
/
