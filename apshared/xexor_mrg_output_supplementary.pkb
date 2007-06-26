CREATE OR REPLACE PACKAGE BODY xexor_mrg_output_supplementary AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_mrg_output_supplementary.pkb	1.1 03/15/05
--       Module Name      : xexor_mrg_output_supplementary.pkb
--       Date into SCCS   : 05/03/15 22:46:52
--       Date fetched Out : 07/06/06 14:36:40
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Supplementary Merge Output package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xexor_mrg_output_supplementary.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xexor_mrg_output_supplementary';
--
   c_app_owner       CONSTANT  VARCHAR2(30)                            := hig.get_application_owner;
   c_disco_ba        CONSTANT  hig_disco_business_areas.hdba_name%TYPE := hig.get_sysopt('MRGOUTBA');
   c_create_in_disco CONSTANT  BOOLEAN                                 := c_disco_ba IS NOT NULL;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_descr RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_copy_job (p_block      VARCHAR2
                          ,p_nmq_unique VARCHAR2
                          ,p_table_name VARCHAR2
                          ,p_nqr_job_id NUMBER
                          ,p_is_copy    BOOLEAN
                          );
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
FUNCTION get_output_table_name (p_nmf_id IN nm_mrg_output_file.nmf_id%TYPE
                               ) RETURN user_tables.table_name%TYPE IS
   l_retval  user_tables.table_name%TYPE;
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
BEGIN
   l_rec_nmf := nm3get.get_nmf (pi_nmf_id => p_nmf_id);
   l_retval  := SUBSTR('MRG_'||nm3get.get_nmq(pi_nmq_id=>l_rec_nmf.nmf_nmq_id).nmq_unique||'_'||p_nmf_id,1,30);
   RETURN l_retval;
END get_output_table_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_table_from_nmf (p_nmf_id         IN nm_mrg_output_file.nmf_id%TYPE
                                ,p_nqr_mrg_job_id IN nm_mrg_query_results.nqr_mrg_job_id%TYPE DEFAULT NULL
                                ,p_table_name     IN user_tables.table_name%TYPE DEFAULT NULL
                                ,p_source_id      IN NUMBER    DEFAULT NULL
                                ,p_source         IN VARCHAR2  DEFAULT NULL
                                ,p_nmq_id         IN NUMBER    DEFAULT NULL
                                ) IS
--
   l_rec_nqr nm_mrg_query_results%ROWTYPE;
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
--
   l_table_name user_tables.table_name%TYPE := p_table_name;
   l_view_name  user_views.view_name%TYPE;
   l_sql        nm3type.max_varchar2;
   l_rec_hdba   hig_disco_business_areas%ROWTYPE;
   l_hdt_id     NUMBER;
--
   l_rec_atc_table nm3ddl.tab_atc;
   l_rec_atc_view  nm3ddl.tab_atc;
   l_view_and_table_match BOOLEAN;
--
   PROCEDURE create_the_table IS
   BEGIN
      l_sql :=            'CREATE TABLE '||c_app_owner||'.'||l_table_name||' UNRECOVERABLE AS'
               ||CHR(10)||'SELECT *'
               ||CHR(10)||' FROM  '||c_app_owner||'.'||l_view_name
               ||CHR(10)||'WHERE  ROWNUM = 0';
      nm3ddl.create_object_and_syns (p_object_name => l_table_name
                                    ,p_ddl_text    => l_sql
                                    );
      l_sql :=            'CREATE INDEX '||c_app_owner||'.'||SUBSTR(l_table_name,1,27)||'_IX ON '
               ||CHR(10)||' '||c_app_owner||'.'||l_table_name||' (NMS_MRG_JOB_ID)';
      EXECUTE IMMEDIATE l_sql;
      l_sql :=            'ALTER TABLE '||c_app_owner||'.'||l_table_name
               ||CHR(10)||' ADD CONSTRAINT '||SUBSTR(l_table_name,1,27)||'_FK'
               ||CHR(10)||' FOREIGN KEY (NMS_MRG_JOB_ID)'
               ||CHR(10)||'REFERENCES NM_MRG_QUERY_RESULTS_ALL (NQR_MRG_JOB_ID)'
               ||CHR(10)||'ON DELETE CASCADE';
      EXECUTE IMMEDIATE l_sql;
      --
      -- Suck it through into discoverer
      --
      IF c_create_in_disco
       THEN
         higdisco.create_hdba_records_from_disco;
         l_rec_hdba := higdisco.get_hdba (p_hdba_name       => c_disco_ba
                                         ,p_raise_not_found => FALSE
                                         );
         higdisco.suck_table_into_disco_tables
                       (p_table_name                   => l_table_name
                       ,p_hdba_id                      => l_rec_hdba.hdba_id
                       ,p_hide_who_cols                => FALSE
                       ,p_create_fk_parents_if_reqd    => FALSE
                       );
         l_hdt_id := higdisco.curr_hdt_id_seq;
         --
         UPDATE hig_disco_tables
          SET   hdt_description = SUBSTR(l_rec_nmf.nmf_description,1,240)
         WHERE  hdt_id = l_hdt_id;
         --
         UPDATE hig_disco_tab_columns
          SET   hdtc_description = (SELECT SUBSTR(nmc_description,1,240)
                                     FROM  nm_mrg_output_cols
                                    WHERE  nmc_nmf_id        = p_nmf_id
                                     AND   nmc_view_col_name = hdtc_column_name
                                   )
         WHERE  hdtc_hdt_id = l_hdt_id;
         --
         higdisco.create_table_in_eul
                       (p_table_name               => l_table_name
                       ,p_recreate                 => TRUE
                       ,p_create_fk                => FALSE
                       ,p_create_fk_parents_in_eul => FALSE
                       );
      END IF;
   END create_the_table;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_table_from_nmf');
--
   l_rec_nmf := nm3get.get_nmf  (pi_nmf_id         => p_nmf_id);
   IF p_nqr_mrg_job_id IS NOT NULL
    THEN
      l_rec_nqr := nm3get.get_nmqr (pi_nqr_mrg_job_id => p_nqr_mrg_job_id);
   --
      IF l_rec_nqr.nqr_nmq_id != l_rec_nmf.nmf_nmq_id
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 190
                       ,pi_supplementary_info => nm3get.get_nmq(pi_nmq_id=>l_rec_nqr.nqr_nmq_id).nmq_unique
                                               ||' != '
                                               ||nm3get.get_nmq(pi_nmq_id=>l_rec_nmf.nmf_nmq_id).nmq_unique
                       );
      END IF;
   END IF;
--
   IF l_table_name IS NULL
    THEN
      l_table_name := get_output_table_name (p_nmf_id => p_nmf_id);
   END IF;
   l_view_name := nm3mrg_output.get_view_name (p_nmf_id => p_nmf_id);
--
   IF NOT nm3ddl.does_object_exist (p_object_name => l_table_name
                                   ,p_object_type => 'TABLE'
                                   )
    THEN
      create_the_table;
   ELSE -- check the columns match the view
--
      l_rec_atc_table := nm3ddl.get_all_columns_for_table (p_table_name => l_table_name);
      l_rec_atc_view  := nm3ddl.get_all_columns_for_table (p_table_name => l_view_name);
      l_view_and_table_match := TRUE;
      IF l_rec_atc_table.COUNT != l_rec_atc_view.COUNT
       THEN
         l_view_and_table_match := FALSE;
      ELSE
         FOR i IN 1..l_rec_atc_table.COUNT
          LOOP
            IF  l_rec_atc_table(i).column_name                  != l_rec_atc_view(i).column_name
             OR l_rec_atc_table(i).data_length                  != l_rec_atc_view(i).data_length
             OR NVL(l_rec_atc_table(i).data_type,nm3type.c_nvl) != NVL(l_rec_atc_view(i).data_type,nm3type.c_nvl)
             OR NVL(l_rec_atc_table(i).data_precision,-1)       != NVL(l_rec_atc_view(i).data_precision,-1)
             OR NVL(l_rec_atc_table(i).data_scale,-1)           != NVL(l_rec_atc_view(i).data_scale,-1)
             THEN
               l_view_and_table_match := FALSE;
               EXIT;
            END IF;
         END LOOP;
         IF NOT l_view_and_table_match
          THEN
            l_sql := 'DROP TABLE '||c_app_owner||'.'||l_table_name||' CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE l_sql;
            IF c_create_in_disco
             THEN
               higdisco.delete_object_from_eul (l_table_name);
            END IF;
            create_the_table;
         ELSE
            IF p_nqr_mrg_job_id IS NOT NULL
             THEN
               l_sql :=            'DELETE FROM '||c_app_owner||'.'||l_table_name
                        ||CHR(10)||'WHERE  NMS_MRG_JOB_ID = :a';
               EXECUTE IMMEDIATE l_sql USING p_nqr_mrg_job_id;
            END IF;
         END IF;
      END IF;
--
--
   END IF;
--
   l_sql :=              'DECLARE'
              ||CHR(10)||'   l_nte_job_id NUMBER;'
              ||CHR(10)||'   l_mrg_job_id NUMBER;'
              ||CHR(10)||'BEGIN';
   IF p_nqr_mrg_job_id IS NOT NULL
    THEN
      l_sql := l_sql
              ||CHR(10)||'   l_mrg_job_id := '||p_nqr_mrg_job_id||';';
   ELSE
      l_sql := l_sql
              ||CHR(10)||'   nm3extent.create_temp_ne'
              ||CHR(10)||'        (pi_source_id => '||p_source_id
              ||CHR(10)||'        ,pi_source    => '||nm3flx.string(p_source)
              ||CHR(10)||'        ,po_job_id    => l_nte_job_id'
              ||CHR(10)||'        );'
              ||CHR(10)||'   nm3mrg.execute_mrg_query'
              ||CHR(10)||'        (pi_query_id      => '||NVL(p_nmq_id,l_rec_nmf.nmf_nmq_id)
              ||CHR(10)||'        ,pi_nte_job_id    => l_nte_job_id'
              ||CHR(10)||'        ,pi_description   => '||nm3flx.string(get_default_descr)
              ||CHR(10)||'        ,po_result_job_id => l_mrg_job_id'
              ||CHR(10)||'        );'
              ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Extent          : ')||'||nm3extent.get_unique_from_source(nm3extent.g_last_temp_extent_source_id, nm3extent.g_last_temp_extent_source,'||nm3flx.string('Y')||'));'
              ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Result ID is    : ')||'||l_mrg_job_id);';
   END IF;
   l_sql := l_sql
              ||CHR(10)||'   INSERT INTO '||c_app_owner||'.'||l_table_name
              ||CHR(10)||'   SELECT *'
              ||CHR(10)||'    FROM  '||c_app_owner||'.'||l_view_name
              ||CHR(10)||'   WHERE  nms_mrg_job_id = l_mrg_job_id;'
              ||CHR(10)||'   COMMIT;'
              ||CHR(10)||'END;';
--
   submit_copy_job (p_block      => l_sql
                   ,p_nmq_unique => nm3get.get_nmq(pi_nmq_id=>l_rec_nmf.nmf_nmq_id).nmq_unique
                   ,p_table_name => l_table_name
                   ,p_nqr_job_id => p_nqr_mrg_job_id
                   ,p_is_copy    => TRUE
                   );
--
   COMMIT;
--
   nm_debug.proc_end (g_package_name,'create_table_from_nmf');
--
END create_table_from_nmf;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_mail_line (p_line VARCHAR2) IS
BEGIN
   g_mail_text(g_mail_text.COUNT+1) := p_line||nm3mail.c_crlf;
END add_mail_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_copy_job (p_block      VARCHAR2
                          ,p_nmq_unique VARCHAR2
                          ,p_table_name VARCHAR2
                          ,p_nqr_job_id NUMBER
                          ,p_is_copy    BOOLEAN
                          ) IS
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   c_nmu_id CONSTANT NUMBER := nm3mail.get_current_nmu_id;
   l_block           nm3type.max_varchar2;
   l_id NUMBER;
   --
   l_title VARCHAR2(80);
   --
BEGIN
   --
   IF p_is_copy
    THEN
      l_title := p_nmq_unique||' output to table';
   ELSE
      l_title := p_nmq_unique||' submission in batch';
   END IF;
   --
   -- Create the job as a dummy one first (so we can get the job_id)
   --
   dbms_job.submit (job       => l_id
                   ,what      => 'BEGIN Null; END;'
                   ,next_date => TO_DATE('31129999','DDMMYYYY')
                   );
   l_block :=           'DECLARE'
             ||CHR(10)||'   l_to nm3mail.tab_recipient;'
             ||CHR(10)||'   l_cc nm3mail.tab_recipient;'
             ||CHR(10)||'   c_st NUMBER := dbms_utility.get_time;'
             ||CHR(10)||'BEGIN'
             ||CHR(10)||'   l_to(1).rcpt_id := '||c_nmu_id||';'
             ||CHR(10)||'   l_to(1).rcpt_type := nm3mail.c_user;'
             ||CHR(10)||'   '||g_package_name||'.g_mail_text.DELETE;'
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Merge Query     : '||p_nmq_unique)||');';
   IF p_is_copy
    THEN
      l_block := l_block
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Output Table    : '||p_table_name)||');';
      IF p_nqr_job_id IS NOT NULL
       THEN
         l_block := l_block
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Result Set ID   : '||p_nqr_job_id)||');';
      END IF;
   END IF;
   l_block := l_block
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Submission time : '||TO_CHAR(sysdate,nm3type.c_full_date_time_format))||');'
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Start time      : ')||'||TO_CHAR(sysdate,nm3type.c_full_date_time_format));'
             ||CHR(10)||'   BEGIN'
             ||CHR(10)||NVL(p_block,'Null;')
             ||CHR(10)||'      '||g_package_name||'.add_mail_line('||nm3flx.string('Finish time     : ')||'||TO_CHAR(sysdate,nm3type.c_full_date_time_format));'
             ||CHR(10)||'      '||g_package_name||'.add_mail_line('||nm3flx.string('Completed Successfully')||');'
             ||CHR(10)||'   EXCEPTION'
             ||CHR(10)||'      WHEN others'
             ||CHR(10)||'       THEN'
             ||CHR(10)||'         '||g_package_name||'.add_mail_line('||nm3flx.string('***** ERROR *****')||');'
             ||CHR(10)||'         '||g_package_name||'.add_mail_line(SQLERRM);'
             ||CHR(10)||'   END;'
             ||CHR(10)||'   '||g_package_name||'.add_mail_line(nm3mail.c_crlf||nm3mail.c_crlf);'
             ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Run Time : ')||'||((dbms_utility.get_time-c_st)/100));'
             ||CHR(10)||'   nm3mail.write_mail_complete(l_to(1).rcpt_id,'||nm3flx.string(l_title)||',FALSE,l_to,l_cc,l_cc,'||g_package_name||'.g_mail_text);'
             ||CHR(10)||'END;';
   --
   dbms_job.change (job       => l_id
                   ,what      => l_block
                   ,next_date => SYSDATE
                   ,interval  => Null
                   );
   --
   COMMIT;
   --
END submit_copy_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_descr RETURN VARCHAR2 IS
BEGIN
   RETURN 'Submitted '||to_char(sysdate,nm3type.c_full_date_time_format);
END get_default_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_merge_in_batch (p_source_id  NUMBER
                                ,p_source     VARCHAR2
                                ,p_nmq_id     NUMBER
                                ,p_nmq_descr  VARCHAR2
                                ) IS
   l_block           nm3type.max_varchar2;
   l_rec_nmq         nm_mrg_query%ROWTYPE;
   l_descr           nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start (g_package_name,'submit_merge_in_batch');
--
   l_rec_nmq := nm3get.get_nmq (pi_nmq_id => p_nmq_id);
--
   l_descr := nm3flx.repl_quotes_amps_for_dyn_sql(NVL(p_nmq_descr,get_default_descr));
--
   l_block :=            'DECLARE'
              ||CHR(10)||'   l_nte_job_id NUMBER;'
              ||CHR(10)||'   l_mrg_job_id NUMBER;'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   nm3extent.create_temp_ne'
              ||CHR(10)||'        (pi_source_id => '||p_source_id
              ||CHR(10)||'        ,pi_source    => '||nm3flx.string(p_source)
              ||CHR(10)||'        ,po_job_id    => l_nte_job_id'
              ||CHR(10)||'        );'
              ||CHR(10)||'   nm3mrg.execute_mrg_query'
              ||CHR(10)||'        (pi_query_id      => '||l_rec_nmq.nmq_id
              ||CHR(10)||'        ,pi_nte_job_id    => l_nte_job_id'
              ||CHR(10)||'        ,pi_description   => '||nm3flx.string(l_descr)
              ||CHR(10)||'        ,po_result_job_id => l_mrg_job_id'
              ||CHR(10)||'        );'
              ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Extent          : ')||'||nm3extent.get_unique_from_source(nm3extent.g_last_temp_extent_source_id, nm3extent.g_last_temp_extent_source,'||nm3flx.string('Y')||'));'
              ||CHR(10)||'   '||g_package_name||'.add_mail_line('||nm3flx.string('Result ID is    : ')||'||l_mrg_job_id);'
              ||CHR(10)||'   COMMIT;'
              ||CHR(10)||'END;';
--
   submit_copy_job (p_block      => l_block
                   ,p_nmq_unique => l_rec_nmq.nmq_unique
                   ,p_table_name => Null
                   ,p_nqr_job_id => Null
                   ,p_is_copy    => FALSE
                   );
--
   nm_debug.proc_end (g_package_name,'submit_merge_in_batch');
--
END submit_merge_in_batch;
--
-----------------------------------------------------------------------------
--
END xexor_mrg_output_supplementary;
/
