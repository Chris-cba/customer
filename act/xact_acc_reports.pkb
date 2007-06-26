CREATE OR REPLACE PACKAGE BODY xact_acc_reports AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_acc_reports.pkb	1.2 11/22/05
--       Module Name      : xact_acc_reports.pkb
--       Date into SCCS   : 05/11/22 09:07:28
--       Date fetched Out : 07/06/06 14:33:36
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   ACT Accident Reporting package body
--
-- 2005-06-06 - JC - Amended to use accident date as the effective date
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
   g_body_sccsid     CONSTANT varchar2(2000) := '"@(#)xact_acc_reports.pkb	1.2 11/22/05"';

   g_package_name    CONSTANT  varchar2(30)   := 'xact_acc_reports';
--
   c_date_mask                 CONSTANT VARCHAR2(11) := 'DD-MON-YYYY';
   c_short_date_mask           CONSTANT VARCHAR2(11) := 'DD/MM/YYYY';
   c_date_time_mask            CONSTANT VARCHAR2(20) := c_short_date_mask||' HH24:MI';
   c_ranking_module            CONSTANT VARCHAR2(30) := 'XACT010';
   c_intx_hist_module          CONSTANT VARCHAR2(30) := 'XACT020';
   c_midblock_hist_module      CONSTANT VARCHAR2(30) := 'XACT021';
   c_route_hist_module         CONSTANT VARCHAR2(30) := 'XACT022';
   c_user                      CONSTANT VARCHAR2(30) := USER;
   g_location_col VARCHAR2(30);
   g_header_rowid ROWID;
   g_start_time   NUMBER;
   g_tab_report_text nm3type.tab_varchar32767;
   g_mail_title      nm3type.max_varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_hist_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_old_data (p_grr_job_id NUMBER
                          ,p_module     VARCHAR2
                          );
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_the_data (pi_intx_accidents BOOLEAN
                            ,pi_start_date     DATE
                            ,pi_end_date       DATE
                            ,pi_location_id    NUMBER  DEFAULT NULL
                            ,pi_array_reqd     BOOLEAN DEFAULT FALSE
                            );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_site_details (pi_intersection IN     BOOLEAN
                           ,pi_site_id      IN     NUMBER
                           ,pi_group_only   IN     BOOLEAN DEFAULT FALSE
                           ,po_site_name       OUT VARCHAR2
                           ,po_site_descr      OUT VARCHAR2
                           );
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_the_details (pi_location_id   NUMBER
                               ,pi_location_type VARCHAR2
                               ,pi_seq_no        NUMBER
                               ,pi_gri_job_id    NUMBER
                               ,pi_start_date    DATE
                               ,pi_end_date      DATE
                               );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_intx_and_midblock (pi_ne_id    IN     NUMBER
                                ,po_tab_id      OUT nm3type.tab_number
                                ,po_tab_type    OUT nm3type.tab_varchar4
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE  create_header (pi_gri_job_id NUMBER
                         ,pi_site_descr VARCHAR2
                         ,pi_start_date DATE
                         ,pi_end_date   DATE
                         ,pi_module     VARCHAR2
                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE update_header;
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
PROCEDURE prepopulate_acc_ranking (pi_start_date     DATE
                                  ,pi_end_date       DATE
                                  ,pi_run_type       VARCHAR2
                                  ,pi_records        PLS_INTEGER DEFAULT NULL
                                  ,pi_fatal_score    PLS_INTEGER DEFAULT 16
                                  ,pi_injury_score   PLS_INTEGER DEFAULT 4
                                  ,pi_property_score PLS_INTEGER DEFAULT 1
                                  ,pi_fatal_set      VARCHAR2    DEFAULT NULL
                                  ,pi_serious_set    VARCHAR2    DEFAULT NULL
                                  ,pi_minor_set      VARCHAR2    DEFAULT NULL
                                  ,pi_property_set   VARCHAR2    DEFAULT NULL
                                  ) IS
   TYPE tab_rec_xair IS TABLE OF xact_acc_intx_ranking%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_xair tab_rec_xair;
   l_rec          xact_acc_intx_ranking%ROWTYPE;
   l_rec_empty    xact_acc_intx_ranking%ROWTYPE;
--
   l_tab_fatal_count   nm3type.tab_number;
   l_tab_prop_count    nm3type.tab_number;
   l_tab_serious_count nm3type.tab_number;
   l_tab_minor_count   nm3type.tab_number;
--
   l_tab_rowid         nm3type.tab_rowid;
   l_tab_rank          nm3type.tab_number;
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
   l_sql   nm3type.max_varchar2;
--
   c_intx_run CONSTANT BOOLEAN := pi_run_type = 'I';
   l_count             PLS_INTEGER;
--
   c_grr_job_id CONSTANT NUMBER := NVL(higgri.last_grr_job_id,1);
--
   l_tab_fatal_set    nm3type.tab_varchar2000;
   l_tab_serious_set  nm3type.tab_varchar2000;
   l_tab_minor_set    nm3type.tab_varchar2000;
   l_tab_property_set nm3type.tab_varchar2000;
--
   CURSOR cs_is_serious (c_acc_id NUMBER) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  acc_items_all
                  WHERE  acc_ait_id = 'CAS'
                   AND   acc_top_id = c_acc_id
                   AND   accdisc.get_attr_number_value(acc_id,'CINJ',acc_ait_id) = 2
                 );
--
   PROCEDURE add_one (p_tab IN OUT nm3type.tab_number, p_index NUMBER) IS
   BEGIN
      IF p_index IS NOT NULL
       THEN
         IF NOT p_tab.EXISTS(p_index)
          THEN
            p_tab(p_index) := 0;
         END IF;
         p_tab(p_index) := p_tab(p_index) + 1;
      END IF;
   END add_one;
--
   PROCEDURE add_text (p_counts nm3type.tab_number, p_text OUT VARCHAR2) IS
      i PLS_INTEGER;
   BEGIN
      i := p_counts.FIRST;
      WHILE i IS NOT NULL
       LOOP
         IF p_text IS NOT NULL
          THEN
            p_text := p_text||' ';
         END IF;
         p_text := p_text||p_counts(i)||'x'||i;
         i := p_counts.NEXT(i);
      END LOOP;
      IF p_text IS NULL
       THEN
         p_text := 'None';
      END IF;
   END add_text;
--
   PROCEDURE populate_set (pi_code    IN     VARCHAR2
                          ,pi_domain  IN     VARCHAR2
                          ,po_set_tab    OUT nm3type.tab_varchar2000
                          ) IS
      l_rec_hco hig_codes%ROWTYPE;
      l_val     nm3type.max_varchar2;
   BEGIN
      po_set_tab.DELETE;
      IF pi_code IS NOT NULL
       THEN
         l_rec_hco := nm3get.get_hco (pi_hco_domain      => pi_domain
                                     ,pi_hco_code        => pi_code
                                     ,pi_raise_not_found => FALSE
                                     );
         IF l_rec_hco.hco_code IS NOT NULL
          THEN
            nm3load.g_single_line := l_rec_hco.hco_meaning;
            FOR i IN 1..LENGTH(l_rec_hco.hco_meaning)
             LOOP
               l_val := nm3load.get_csv_value_from_line (i, ',');
               EXIT WHEN l_val IS NULL;
               po_set_tab(po_set_tab.COUNT+1) := l_val;
            END LOOP;
         END IF;
      END IF;
   END populate_set;
--
   FUNCTION this_is_in_set (p_tab_set  nm3type.tab_varchar2000
                           ,p_acc_type VARCHAR2
                           ) RETURN BOOLEAN IS
      l_retval BOOLEAN := (p_tab_set.COUNT = 0); -- set it to TRUE initially if set empty (i.e. all)
   BEGIN
      FOR i IN 1..p_tab_set.COUNT
       LOOP
         IF p_tab_set(i) = p_acc_type
          THEN
            l_retval := TRUE;
            EXIT;
         END IF;
      END LOOP;
      RETURN l_retval;
   END this_is_in_set;
--
BEGIN
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--
   nm_debug.proc_start(g_package_name,'prepopulate_acc_ranking');
--
   delete_old_data (p_grr_job_id => c_grr_job_id
                   ,p_module     => c_ranking_module
                   );
--
   populate_the_data (pi_intx_accidents => c_intx_run
                     ,pi_start_date     => pi_start_date
                     ,pi_end_date       => pi_end_date
                     ,pi_array_reqd     => TRUE
                     );
--
   l_rec_empty.gri_job_id := c_grr_job_id;
--
   l_sql :=            'BEGIN'
            ||CHR(10)||'   SELECT acc_id'
            ||CHR(10)||'         ,accdisc.get_attr_number_value(acc_id,'||nm3flx.string('ASEV')||','||g_package_name||'.c_ait_id_acc) severity'
            ||CHR(10)||'         ,accdisc.get_attr_number_value(acc_id,'||nm3flx.string('ATPE')||','||g_package_name||'.c_ait_id_acc) acc_type'
            ||CHR(10)||'   BULK  COLLECT'
            ||CHR(10)||'    INTO  '||g_package_name||'.g_tab_acc_id'
            ||CHR(10)||'         ,'||g_package_name||'.g_tab_acc_sev'
            ||CHR(10)||'         ,'||g_package_name||'.g_tab_acc_type'
            ||CHR(10)||'    FROM  xact_acc_intx_ranking_temp'
            ||CHR(10)||'   WHERE  '||g_location_col||' = :location_id;'
            ||CHR(10)||'END;';
--
   populate_set (pi_fatal_set,'XACC_FATAL_SET',l_tab_fatal_set);
   populate_set (pi_serious_set,'XACC_SERIOUS_SET',l_tab_serious_set);
   populate_set (pi_minor_set,'XACC_MINOR_SET',l_tab_minor_set);
   populate_set (pi_property_set,'XACC_PROPERTY_SET',l_tab_property_set);
--
   FOR i IN 1..g_tab_location_id.COUNT
    LOOP
--
      l_tab_fatal_count.DELETE;
      l_tab_prop_count.DELETE;
      l_tab_serious_count.DELETE;
      l_tab_minor_count.DELETE;
--
      l_rec            := l_rec_empty;
      l_rec.score      := 0;
      l_rec.site_id    := g_tab_location_id(i);
--
      get_site_details (pi_intersection => c_intx_run
                       ,pi_site_id      => l_rec.site_id
                       ,po_site_name    => l_rec.site_name
                       ,po_site_descr   => l_rec.site_descr
                       );
--
      EXECUTE IMMEDIATE l_sql USING l_rec.site_id;
--
      FOR j IN 1..g_tab_acc_id.COUNT
       LOOP
--         nm_debug.debug(g_tab_acc_sev(j));
         IF g_tab_acc_sev(j) = 16 -- Fatal
          THEN
            IF this_is_in_set (l_tab_fatal_set,g_tab_acc_type(j))
             THEN
               l_rec.score := l_rec.score  + pi_fatal_score;
               add_one (l_tab_fatal_count,g_tab_acc_type(j));
            END IF;
         ELSIF g_tab_acc_sev(j) = 1 -- Property
          THEN
            IF this_is_in_set (l_tab_property_set,g_tab_acc_type(j))
             THEN
               l_rec.score := l_rec.score  + pi_property_score;
               add_one (l_tab_prop_count,g_tab_acc_type(j));
            END IF;
         ELSE
            -- This is a "injury" one. look to see if it is a serious one or not
            OPEN  cs_is_serious (g_tab_acc_id(j));
            FETCH cs_is_serious INTO l_dummy;
            l_found := cs_is_serious%FOUND;
            CLOSE cs_is_serious;
            IF l_found
             THEN
               IF this_is_in_set (l_tab_serious_set,g_tab_acc_type(j))
                THEN
                  add_one (l_tab_serious_count,g_tab_acc_type(j));
                  l_rec.score := l_rec.score  + pi_injury_score;
               END IF;
            ELSE
               IF this_is_in_set (l_tab_minor_set,g_tab_acc_type(j))
                THEN
                  add_one (l_tab_minor_count,g_tab_acc_type(j));
                  l_rec.score := l_rec.score  + pi_injury_score;
               END IF;
            END IF;
         END IF;
      END LOOP;
--
      add_text (l_tab_fatal_count,l_rec.fatal_dets);
      add_text (l_tab_serious_count,l_rec.serious_dets);
      add_text (l_tab_minor_count,l_rec.minor_dets);
      add_text (l_tab_prop_count,l_rec.property_dets);
--
      l_tab_rec_xair(i) := l_rec;
--
   END LOOP;
--
   DECLARE
--
      l_tab_gri_job_id    nm3type.tab_number;
      l_tab_ranking       nm3type.tab_number;
      l_tab_site_id       nm3type.tab_number;
      l_tab_site_name     nm3type.tab_varchar30;
      l_tab_site_descr    nm3type.tab_varchar80;
      l_tab_score         nm3type.tab_number;
      l_tab_fatal_dets    nm3type.tab_varchar2000;
      l_tab_serious_dets  nm3type.tab_varchar2000;
      l_tab_minor_dets    nm3type.tab_varchar2000;
      l_tab_property_dets nm3type.tab_varchar2000;
--
   BEGIN
--
      FOR i IN 1..l_tab_rec_xair.COUNT
       LOOP
         l_tab_gri_job_id(i)    := l_tab_rec_xair(i).gri_job_id;
         l_tab_ranking(i)       := l_tab_rec_xair(i).ranking;
         l_tab_site_id(i)       := l_tab_rec_xair(i).site_id;
         l_tab_site_name(i)     := l_tab_rec_xair(i).site_name;
         l_tab_site_descr(i)    := l_tab_rec_xair(i).site_descr;
         l_tab_score(i)         := l_tab_rec_xair(i).score;
         l_tab_fatal_dets(i)    := l_tab_rec_xair(i).fatal_dets;
         l_tab_serious_dets(i)  := l_tab_rec_xair(i).serious_dets;
         l_tab_minor_dets(i)    := l_tab_rec_xair(i).minor_dets;
         l_tab_property_dets(i) := l_tab_rec_xair(i).property_dets;
      END LOOP;
--
      FORALL i IN 1..l_tab_rec_xair.COUNT
         INSERT INTO xact_acc_intx_ranking
                (gri_job_id
                ,ranking
                ,site_id
                ,site_name
                ,site_descr
                ,score
                ,fatal_dets
                ,serious_dets
                ,minor_dets
                ,property_dets
                )
         VALUES (l_tab_gri_job_id(i)
                ,l_tab_ranking(i)
                ,l_tab_site_id(i)
                ,l_tab_site_name(i)
                ,l_tab_site_descr(i)
                ,l_tab_score(i)
                ,l_tab_fatal_dets(i)
                ,l_tab_serious_dets(i)
                ,l_tab_minor_dets(i)
                ,l_tab_property_dets(i)
                );
--
   END;
--
   SELECT ROWID, 0
    BULK  COLLECT
    INTO  l_tab_rowid
         ,l_tab_rank
    FROM  xact_acc_intx_ranking
   WHERE  gri_job_id = c_grr_job_id
   ORDER BY score DESC;
--
   l_count := nm3flx.i_t_e (pi_records IS NOT NULL
                           ,LEAST(pi_records,l_tab_rowid.COUNT)
                           ,l_tab_rowid.COUNT
                           );
--
   FOR i IN 1..l_count
    LOOP
      l_tab_rank(i) := i;
   END LOOP;
--
   FORALL i IN 1..l_count
      UPDATE xact_acc_intx_ranking
       SET   ranking = l_tab_rank(i)
      WHERE  rowid   = l_tab_rowid(i);
--
   IF l_count < l_tab_rowid.COUNT
    THEN
      FORALL i IN (l_count+1)..l_tab_rowid.COUNT
         DELETE xact_acc_intx_ranking
         WHERE  rowid   = l_tab_rowid(i);
   END IF;
--
--nm_debug.debug_off;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'prepopulate_acc_ranking');
--
END prepopulate_acc_ranking;
--
-----------------------------------------------------------------------------
--
PROCEDURE prepopulate_site_hist_inj_type (pi_start_date     DATE
                                         ,pi_end_date       DATE
                                         ,pi_run_type       VARCHAR2
                                         ,pi_node_id        NUMBER
                                         ,pi_element_id     NUMBER
                                         ) IS
--
   c_intx_run CONSTANT BOOLEAN                     := pi_run_type = 'I';
   c_module   CONSTANT hig_modules.hmo_module%TYPE := nm3flx.i_t_e (c_intx_run,c_intx_hist_module,c_midblock_hist_module);
--
   l_location_id       NUMBER;
--
   c_grr_job_id CONSTANT NUMBER := NVL(higgri.last_grr_job_id,1);
--
   l_site_name  nm_elements.ne_unique%TYPE;
   l_site_descr nm_elements.ne_descr%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'prepopulate_site_hist_inj_type');
--
   delete_old_data (p_grr_job_id => c_grr_job_id
                   ,p_module     => c_module
                   );
--
   l_location_id := nm3flx.i_t_e(c_intx_run
                                ,pi_node_id
                                ,pi_element_id
                                );
--
   get_site_details (pi_intersection => c_intx_run
                    ,pi_site_id      => l_location_id
                    ,po_site_name    => l_site_name
                    ,po_site_descr   => l_site_descr
                    );
--
   create_header (pi_gri_job_id => c_grr_job_id
                 ,pi_site_descr => l_site_descr
                 ,pi_start_date => pi_start_date
                 ,pi_end_date   => pi_end_date
                 ,pi_module     => c_module
                 );
--
   populate_the_details (pi_location_id   => l_location_id
                        ,pi_location_type => pi_run_type
                        ,pi_seq_no        => 1
                        ,pi_gri_job_id    => c_grr_job_id
                        ,pi_start_date    => pi_start_date
                        ,pi_end_date      => pi_end_date
                        );
--
   update_header;
--
   send_hist_mail;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'prepopulate_site_hist_inj_type');
--
END prepopulate_site_hist_inj_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE prepopulate_street_hist (pi_start_date     DATE
                                  ,pi_end_date       DATE
                                  ,pi_element_id     NUMBER
                                  ) IS
--
   l_tab_id     nm3type.tab_number;
   l_tab_type   nm3type.tab_varchar4;
--
   l_site_name  nm_elements.ne_unique%TYPE;
   l_site_descr nm_elements.ne_descr%TYPE;
   c_grr_job_id CONSTANT NUMBER := NVL(higgri.last_grr_job_id,1);
--
   l_seq_no     PLS_INTEGER := 1;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'prepopulate_street_hist');
--
   delete_old_data (p_grr_job_id => c_grr_job_id
                   ,p_module     => c_route_hist_module
                   );
--
   get_site_details (pi_intersection => FALSE
                    ,pi_site_id      => pi_element_id
                    ,pi_group_only   => TRUE
                    ,po_site_name    => l_site_name
                    ,po_site_descr   => l_site_descr
                    );
--
   create_header (pi_gri_job_id => c_grr_job_id
                 ,pi_site_descr => l_site_descr
                 ,pi_start_date => pi_start_date
                 ,pi_end_date   => pi_end_date
                 ,pi_module     => c_route_hist_module
                 );
--
   get_intx_and_midblock (pi_ne_id    => pi_element_id
                         ,po_tab_id   => l_tab_id
                         ,po_tab_type => l_tab_type
                         );
--
   FOR i IN 1..l_tab_id.COUNT
    LOOP
      populate_the_details (pi_location_id   => l_tab_id(i)
                           ,pi_location_type => l_tab_type(i)
                           ,pi_seq_no        => l_seq_no
                           ,pi_gri_job_id    => c_grr_job_id
                           ,pi_start_date    => pi_start_date
                           ,pi_end_date      => pi_end_date
                           );
      IF g_acc_count > 0
       THEN
         l_seq_no := l_seq_no + 1;
      END IF;
   END LOOP;
--
   update_header;
--
   send_hist_mail;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'prepopulate_street_hist');
--
END prepopulate_street_hist;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_old_data (p_grr_job_id NUMBER
                          ,p_module     VARCHAR2
                          ) IS
   l_tab_old_grr_job_id nm3type.tab_number;
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_old_data');
--
   DELETE FROM xact_acc_intx_ranking
   WHERE  gri_job_id = p_grr_job_id;
--
   DELETE FROM xact_acc_history_header
   WHERE  gri_job_id = p_grr_job_id;
--
   SELECT grr_job_id
    BULK  COLLECT
    INTO  l_tab_old_grr_job_id
    FROM  gri_report_runs
   WHERE  grr_module      = p_module
    AND   grr_username    = c_user
    AND   grr_submit_date < (SYSDATE-1)
    AND   grr_job_id     != p_grr_job_id
   FOR UPDATE NOWAIT;
--
   FORALL i IN 1..l_tab_old_grr_job_id.COUNT
      DELETE FROM xact_acc_intx_ranking
      WHERE gri_job_id = l_tab_old_grr_job_id(i);
--
   FORALL i IN 1..l_tab_old_grr_job_id.COUNT
      DELETE FROM xact_acc_history_header
      WHERE gri_job_id = l_tab_old_grr_job_id(i);
--
   FORALL i IN 1..l_tab_old_grr_job_id.COUNT
      DELETE FROM gri_report_runs
      WHERE grr_job_id = l_tab_old_grr_job_id(i);
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'delete_old_data');
--
END delete_old_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_the_data (pi_intx_accidents BOOLEAN
                            ,pi_start_date     DATE
                            ,pi_end_date       DATE
                            ,pi_location_id    NUMBER  DEFAULT NULL
                            ,pi_array_reqd     BOOLEAN DEFAULT FALSE
                            ) IS
--
   l_sql   nm3type.max_varchar2;
--
   l_not       VARCHAR2(4);
   l_ne_id_col VARCHAR2(30);
--
   c_date_mask CONSTANT VARCHAR2(30) := nm3type.c_full_date_time_format;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'populate_the_data');
--
   IF pi_intx_accidents
    THEN
      l_not          := 'NOT ';
      g_location_col := 'acc_intersection';
      l_ne_id_col    := 'Null';
   ELSE
      l_not          := Null;
      g_location_col := 'alo_ne_id';
      l_ne_id_col    := 'alo_ne_id';
   END IF;
--
   DELETE xact_acc_intx_ranking_temp;
--
   l_sql :=            'BEGIN'
            ||CHR(10)||'   INSERT INTO xact_acc_intx_ranking_temp'
            ||CHR(10)||'          (acc_id'
            ||CHR(10)||'          ,acc_intersection'
            ||CHR(10)||'          ,alo_ne_id'
            ||CHR(10)||'          )'
            ||CHR(10)||'   SELECT acc_id'
            ||CHR(10)||'         ,acc_intersection'
            ||CHR(10)||'         ,'||l_ne_id_col
            ||CHR(10)||'   FROM  acc_items_all_all acc';
   IF NOT pi_intx_accidents
    THEN
      l_sql := l_sql
            ||CHR(10)||'         ,acc_locations     alo';
   END IF;
   l_sql := l_sql
            ||CHR(10)||'   WHERE  acc_intersection IS '||l_not||'NULL';
   --
   g_start_date := pi_start_date;
   g_end_date   := pi_end_date;
   --
   IF   pi_start_date IS NULL
    AND pi_end_date   IS NULL
    THEN
      Null;
   ELSIF pi_start_date IS NOT NULL
    AND  pi_end_date   IS     NULL
    THEN
      l_sql := l_sql
            ||CHR(10)||'    AND   acc.acc_start_date >= '||g_package_name||'.g_start_date';
   ELSIF pi_start_date IS     NULL
    AND  pi_end_date   IS NOT NULL
    THEN
      l_sql := l_sql
            ||CHR(10)||'    AND   acc.acc_start_date <= '||g_package_name||'.g_end_date';
   ELSE -- both passed
      DECLARE
         c_st_date  CONSTANT DATE := LEAST(pi_start_date,pi_end_date);
         c_end_date CONSTANT DATE := GREATEST(pi_start_date,pi_end_date);
      BEGIN
         g_start_date := c_st_date;
         g_end_date   := c_end_date;
         IF c_st_date = c_end_date
          THEN
            l_sql := l_sql
            ||CHR(10)||'    AND   acc.acc_start_date = '||g_package_name||'.g_start_date';
         ELSE
            l_sql := l_sql
            ||CHR(10)||'    AND   acc.acc_start_date BETWEEN '||g_package_name||'.g_start_date AND '||g_package_name||'.g_end_date';
         END IF;
      END;
   END IF;
--
   IF NOT pi_intx_accidents
    THEN
      l_sql := l_sql
            ||CHR(10)||'    AND   acc.acc_id      = alo.alo_acc_id'
            ||CHR(10)||'    AND   alo.alo_primary = '||nm3flx.string('Y');
   END IF;
   g_location_id := pi_location_id;
   IF pi_location_id IS NOT NULL
    THEN
      l_sql := l_sql
            ||CHR(10)||'    AND   '||g_location_col||' = '||g_package_name||'.g_location_id';
   END IF;
   l_sql := l_sql||';'
            ||CHR(10)||'   '||g_package_name||'.g_acc_count := SQL%ROWCOUNT;'
            ||CHR(10)||'END;';
--   nm_debug.debug(l_sql);
   EXECUTE IMMEDIATE l_sql;
--
   g_tab_location_id.DELETE;
   IF pi_array_reqd
    THEN
      l_sql :=            'BEGIN'
               ||CHR(10)||'   SELECT '||g_location_col
               ||CHR(10)||'    BULK COLLECT'
               ||CHR(10)||'    INTO  '||g_package_name||'.g_tab_location_id'
               ||CHR(10)||'    FROM  xact_acc_intx_ranking_temp'
               ||CHR(10)||'   GROUP BY '||g_location_col||';'
               ||CHR(10)||'END;';
   --   nm_debug.debug(l_sql);
      EXECUTE IMMEDIATE l_sql;
   END IF;
--
   nm_debug.proc_end(g_package_name,'populate_the_data');
--
END populate_the_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_site_details (pi_intersection IN     BOOLEAN
                           ,pi_site_id      IN     NUMBER
                           ,pi_group_only   IN     BOOLEAN DEFAULT FALSE
                           ,po_site_name       OUT VARCHAR2
                           ,po_site_descr      OUT VARCHAR2
                           ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_site_details');
--
   IF pi_intersection
    THEN
      DECLARE
         l_rec_no nm_nodes%ROWTYPE;
      BEGIN
         l_rec_no      := nm3get.get_no_all (pi_no_node_id => pi_site_id);
         po_site_name  := l_rec_no.no_node_name;
         po_site_descr := l_rec_no.no_descr;
      END;
   ELSE
      DECLARE
         l_rec_ne nm_elements%ROWTYPE;
      BEGIN
         l_rec_ne      := nm3get.get_ne_all (pi_ne_id => pi_site_id);
         IF pi_group_only
          THEN
            IF l_rec_ne.ne_gty_group_type IS NULL
             THEN
               -- cannot operate on datums
               hig.raise_ner (pi_appl => nm3type.c_net
                             ,pi_id   => 311
                             );
            ELSIF nm3get.get_ngt (pi_ngt_group_type => l_rec_ne.ne_gty_group_type).ngt_sub_group_allowed = 'Y'
             THEN
               -- cannot operate on a group of groups
               hig.raise_ner (pi_appl => nm3type.c_net
                             ,pi_id   => 51
                             );
            END IF;
         ELSE
            IF l_rec_ne.ne_gty_group_type IS NOT NULL
             THEN
               -- can only operate on datums
               hig.raise_ner (pi_appl => nm3type.c_net
                             ,pi_id   => 169
                             );
            END IF;
         END IF;
         po_site_name  := l_rec_ne.ne_unique;
         po_site_descr := l_rec_ne.ne_descr;
      END;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_site_details');
--
END get_site_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_the_details (pi_location_id   NUMBER
                               ,pi_location_type VARCHAR2
                               ,pi_seq_no        NUMBER
                               ,pi_gri_job_id    NUMBER
                               ,pi_start_date    DATE
                               ,pi_end_date      DATE
                               ) IS
--
   l_site_name   nm_elements.ne_unique%TYPE;
   l_site_descr  nm_elements.ne_descr%TYPE;
   c_intx_run CONSTANT BOOLEAN := pi_location_type = 'I';
   l_acc_count   NUMBER;
   l_hco_meaning hig_codes.hco_meaning%TYPE;
   l_tab_acc_id  nm3type.tab_number;
--
   l_tab_rowid   nm3type.tab_rowid;
   l_tab_num_cas nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'populate_the_details');
--
   populate_the_data (pi_intx_accidents => c_intx_run
                     ,pi_start_date     => pi_start_date
                     ,pi_end_date       => pi_end_date
                     ,pi_location_id    => pi_location_id
                     );
--
   get_site_details (pi_intersection => c_intx_run
                    ,pi_site_id      => pi_location_id
                    ,po_site_name    => l_site_name
                    ,po_site_descr   => l_site_descr
                    );
--
   hig.valid_fk_hco (pi_hco_domain  => 'XACT_ACCIDENT_TYPE'
                    ,pi_hco_code    => pi_location_type
                    ,po_hco_meaning => l_hco_meaning
                    );
--
   IF g_acc_count > 0
    THEN
   --
      INSERT INTO xact_acc_history_locations
             (gri_job_id
             ,seq_no
             ,location_type
             ,location_id
             ,location_descr
             ,accident_count
             )
      VALUES (pi_gri_job_id
             ,pi_seq_no
             ,l_hco_meaning
             ,pi_location_id
             ,l_site_descr
             ,g_acc_count
             );
   --
      INSERT INTO xact_acc_history_accidents
            (gri_job_id
            ,xahl_seq_no
            ,acc_id
            ,police_reference
            ,acc_date_time
            ,acc_severity
            ,acc_type
            ,num_cas
            ,num_veh
            ,road_surface
            ,weather
            ,rum_code
            )
      SELECT /*+ INDEX (aia acc_pk) */
             pi_gri_job_id
            ,pi_seq_no
            ,aia.acc_id
            ,aia.acc_name
            ,TO_DATE(TO_CHAR(aia.acc_start_date,c_short_date_mask)||' '||accdisc.get_attr_value(aia.acc_id,'ATIM',aia.acc_ait_id),c_date_time_mask)
            ,accdisc.get_acc_attr_list_value(aia.acc_id,'ASEV',aia.acc_ait_id)
            ,accdisc.get_attr_value(aia.acc_id,'ATPE',aia.acc_ait_id)
            ,accdisc.get_attr_number_value(aia.acc_id,'ACAS',aia.acc_ait_id)
            ,accdisc.get_attr_number_value(aia.acc_id,'AVEH',aia.acc_ait_id)
            ,accdisc.get_acc_attr_list_value(aia.acc_id,'ARDC',aia.acc_ait_id)
            ,accdisc.get_acc_attr_list_value(aia.acc_id,'AWEA',aia.acc_ait_id)
            ,accdisc.get_attr_value(aia.acc_id,'ARUM',aia.acc_ait_id)
        FROM xact_acc_intx_ranking_temp xairt
            ,acc_items_all aia
      WHERE  xairt.acc_id = aia.acc_id;
   --
      UPDATE xact_acc_history_accidents xaha
       SET   acc_injury_type = get_list_value((SELECT /*+ INDEX (AIA AIA_PK) */
                                                      MAX(aia.aia_value)
                                                FROM  acc_items_all acc
                                                     ,acc_item_attr aia
                                               WHERE  acc.acc_ait_id = c_ait_id_cas
                                                AND   acc.acc_top_id = xaha.acc_id
                                                AND   aia.aia_acc_id = acc.acc_id
                                                AND   aia.aia_ait_id = acc.acc_ait_id
                                                AND   aia.aia_aat_id = 'CINJ'
                                              )
                                             ,'CINJ'
                                             )
      WHERE  gri_job_id = pi_gri_job_id
       AND   num_cas    > 0;
   --
      UPDATE xact_acc_history_accidents
       SET   primary_street = (SELECT ne_group
                                FROM  nm_elements_all, acc_locations
                               WHERE  ne_id       = alo_ne_id
                                AND   alo_acc_id  = acc_id
                                AND   alo_primary = 'Y'
                                AND   rownum      = 1
                              )
      WHERE  gri_job_id = pi_gri_job_id;
   --
      SELECT acc_id
       BULK  COLLECT
       INTO  l_tab_acc_id
       FROM  xact_acc_intx_ranking_temp;
   --
      FORALL i IN 1..l_tab_acc_id.COUNT
         INSERT INTO xact_acc_history_vehicles
               (gri_job_id
               ,acc_id_veh
               ,acc_id_acc
               ,vehicle_num
               ,direction
               ,lane
               ,position
               ,movement
               ,visibility_restriction
               )
         SELECT /*+ INDEX (acc acc_ind_parent) */
                pi_gri_job_id
               ,acc.acc_id
               ,acc.acc_top_id
               ,acc.acc_seq
               ,accdisc.get_acc_attr_list_value(acc.acc_id,'VDIR',acc.acc_ait_id)
               ,accdisc.get_acc_attr_list_value(acc.acc_id,'VLNC',acc.acc_ait_id)
               ,accdisc.get_acc_attr_list_value(acc.acc_id,'VPOS',acc.acc_ait_id)
               ,accdisc.get_acc_attr_list_value(acc.acc_id,'VMOV',acc.acc_ait_id)
               ,accdisc.get_acc_attr_list_value(acc.acc_id,'VVIS',acc.acc_ait_id)
          FROM  acc_items_all acc
         WHERE  acc.acc_ait_id    = c_ait_id_veh
          AND   acc.acc_parent_id = l_tab_acc_id(i);
   END IF;
--
   nm_debug.proc_end(g_package_name,'populate_the_details');
--
END populate_the_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_intx_and_midblock (pi_ne_id    IN     NUMBER
                                ,po_tab_id      OUT nm3type.tab_number
                                ,po_tab_type    OUT nm3type.tab_varchar4
                                ) IS
--
   l_pl_arr nm_placement_array;
   l_pl     nm_placement;
   l_rec_ne nm_elements_all%ROWTYPE;
--
   l_arr_ne nm3type.tab_boolean;
   l_arr_no nm3type.tab_boolean;
--
   c_node CONSTANT VARCHAR2(1) := 'I'; -- intersection
   c_ele  CONSTANT VARCHAR2(1) := 'M'; -- midblock
--
   PROCEDURE add_it (p_id NUMBER, p_type VARCHAR2) IS
      c CONSTANT PLS_INTEGER := po_tab_id.COUNT+1;
      l_already_there BOOLEAN := FALSE;
   BEGIN
      IF p_type = c_node
       THEN
         l_already_there := l_arr_no.EXISTS(p_id);
      ELSE
         l_already_there := l_arr_ne.EXISTS(p_id);
      END IF;
      IF NOT l_already_there
       THEN
         po_tab_id(c)   := p_id;
         po_tab_type(c) := p_type;
         IF p_type = c_node
          THEN
            l_arr_no(p_id) := TRUE;
         ELSE
            l_arr_ne(p_id) := TRUE;
         END IF;
      END IF;
   END add_it;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_intx_and_midblock');
--
   l_pl_arr := nm3pla.get_placement_from_ne (pi_ne_id);
--
   FOR i IN 1..l_pl_arr.placement_count
    LOOP
      l_pl     := l_pl_arr.get_entry(i);
      l_rec_ne := nm3get.get_ne_all (pi_ne_id => l_pl.pl_ne_id);
      IF l_pl.pl_start = 0
       THEN
         add_it (l_rec_ne.ne_no_start,c_node);
      END IF;
      add_it (l_rec_ne.ne_id,c_ele);
      IF l_pl.pl_end = l_rec_ne.ne_length
       THEN
         add_it (l_rec_ne.ne_no_end,c_node);
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_intx_and_midblock');
--
END get_intx_and_midblock;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_header (pi_gri_job_id NUMBER
                        ,pi_site_descr VARCHAR2
                        ,pi_start_date DATE
                        ,pi_end_date   DATE
                        ,pi_module     VARCHAR2
                        ) IS
--
   l_module_title hig_modules.hmo_title%TYPE;
   l_user_name    hig_users.hus_name%TYPE;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'create_header');
--
   g_start_time   := dbms_utility.get_time;
   l_module_title := nm3get.get_hmo(pi_hmo_module=>pi_module).hmo_title;
   l_user_name    := nm3get.get_hus(pi_hus_user_id=>nm3user.get_user_id).hus_name;
--
   INSERT INTO xact_acc_history_header
          (gri_job_id
          ,module_title
          ,location_descr
          ,start_date
          ,end_date
          ,run_time
          ,run_for
          ,run_date
          )
   VALUES (pi_gri_job_id
          ,l_module_title
          ,pi_site_descr
          ,pi_start_date
          ,pi_end_date
          ,0
          ,l_user_name
          ,SYSDATE
          )
   RETURNING ROWID INTO g_header_rowid;
--
   nm_debug.proc_end(g_package_name,'create_header');
--
END create_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_header IS
   l_run_time NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'update_header');
--
   l_run_time := (dbms_utility.get_time-g_start_time)/100;
--
   UPDATE xact_acc_history_header
    SET   run_time = l_run_time
   WHERE  ROWID    = g_header_rowid;
--
   nm_debug.proc_end(g_package_name,'update_header');
--
END update_header;
--
-----------------------------------------------------------------------------
--
FUNCTION get_list_value (pi_value VARCHAR2, pi_aat_id VARCHAR2) RETURN VARCHAR2 IS
--
   CURSOR cs_val IS
   SELECT aal_meaning
    FROM  acc_attr_lookup
         ,acc_attr_types
   WHERE  aat_id     = pi_aat_id
    AND   aal_aad_id = aat_aad_id
    AND   aal_value  = pi_value;
--
   l_retval acc_attr_lookup.aal_meaning%TYPE;
--
BEGIN
--
   IF pi_value IS NOT NULL
    THEN
      OPEN  cs_val;
      FETCH cs_val INTO l_retval;
      CLOSE cs_val;
   END IF;
--
   RETURN l_retval;
--
END get_list_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_the_report_html (p_grr_job_id NUMBER) IS
--
   c_mask CONSTANT VARCHAR2(80) := nm3user.get_user_date_mask;
--
   TYPE tab_xahh IS TABLE OF xact_acc_history_header%ROWTYPE    INDEX BY BINARY_INTEGER;
   TYPE tab_xahl IS TABLE OF xact_acc_history_locations%ROWTYPE INDEX BY BINARY_INTEGER;
   TYPE tab_xaha IS TABLE OF xact_acc_history_accidents%ROWTYPE INDEX BY BINARY_INTEGER;
   TYPE tab_xahv IS TABLE OF xact_acc_history_vehicles%ROWTYPE  INDEX BY BINARY_INTEGER;
--
   l_tab_xahh tab_xahh;
   l_tab_xahl tab_xahl;
   l_tab_xaha tab_xaha;
   l_tab_xahv tab_xahv;
--
   l_rec_xahh xact_acc_history_header%ROWTYPE;
   l_throw    BOOLEAN;
   l_route_hist_module BOOLEAN;
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      g_tab_report_text(g_tab_report_text.COUNT+1) := p_text;
   END append;
--
   PROCEDURE write_seperator IS
   BEGIN
      append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
         append ('<TR>');
            append ('<TH>');
               append ('<HR WIDTH=95%>');
            append ('</TH>');
         append ('</TR>');
      append ('</TABLE>');
   END write_seperator;
--
   PROCEDURE write_acc_dets (p_police_reference VARCHAR2
                            ,p_acc_date_time    VARCHAR2
                            ,p_acc_severity     VARCHAR2
                            ,p_acc_injury_type  VARCHAR2
                            ,p_acc_type         VARCHAR2
                            ,p_num_cas          VARCHAR2
                            ,p_num_veh          VARCHAR2
--                            ,p_primary_street   VARCHAR2
                            ,p_road_surface     VARCHAR2
                            ,p_weather          VARCHAR2
                            ,p_rum_code         VARCHAR2
                            ) IS
   BEGIN
      append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
         append ('<TR>');
            append ('<TD WIDTH=8%>');
               append ('<FONT SIZE=-1><B>'||p_police_reference||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=8%>');
               append ('<FONT SIZE=-1><B>'||p_acc_date_time||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=16%>');
               append ('<FONT SIZE=-1><B>'||p_acc_severity||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=16%>');
               append ('<FONT SIZE=-1><B>'||p_acc_injury_type||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=3%>');
               append ('<FONT SIZE=-1><B>'||p_acc_type||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=3%>');
               append ('<FONT SIZE=-1><B>'||p_num_cas||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=3%>');
               append ('<FONT SIZE=-1><B>'||p_num_veh||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=20%>');
               append ('<FONT SIZE=-1><B>'||p_road_surface||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=18%>');
               append ('<FONT SIZE=-1><B>'||p_weather||'</B></FONT>');
            append ('</TD>');
            append ('<TD WIDTH=5%>');
               append ('<FONT SIZE=-1><B>'||p_rum_code||'</B></FONT>');
            append ('</TD>');
         append ('</TR>');
      append ('</TABLE>');
   END write_acc_dets;
--
   PROCEDURE write_veh_dets (p_vehicle_num            VARCHAR2
                            ,p_direction              VARCHAR2
                            ,p_lane                   VARCHAR2
                            ,p_position               VARCHAR2
                            ,p_movement               VARCHAR2
                            ,p_visibility_restriction VARCHAR2
                            ) IS
   BEGIN
      append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
      append ('<TR>');
      append ('<TD WIDTH=37%>'||nm3web.c_nbsp||'</TD>');
      append ('<TD WIDTH=8%><FONT SIZE=-2>'||p_vehicle_num||'</FONT></TD>');
      append ('<TD WIDTH=10%><FONT SIZE=-2>'||p_direction||'</FONT></TD>');
      append ('<TD WIDTH=10%><FONT SIZE=-2>'||p_lane||'</FONT></TD>');
      append ('<TD WIDTH=15%><FONT SIZE=-2>'||p_position||'</FONT></TD>');
      append ('<TD WIDTH=10%><FONT SIZE=-2>'||p_movement||'</FONT></TD>');
      append ('<TD WIDTH=10%><FONT SIZE=-2>'||p_visibility_restriction||'</FONT></TD>');
      append ('</TR></TABLE>');
   END write_veh_dets;
--
   PROCEDURE close_table_and_break (p_break BOOLEAN DEFAULT TRUE) IS
   BEGIN
      append ('</TD></TR></TABLE>');
      IF p_break
       THEN
         append ('<P style="page-break-before: always">');
      END IF;
   END close_table_and_break;
--
   PROCEDURE write_header (p_headings BOOLEAN DEFAULT TRUE, p_title BOOLEAN DEFAULT TRUE) IS
   BEGIN
      append ('<TABLE BORDER=1 WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
      IF p_title
       THEN
         append ('<TR>');
            append ('<TH COLSPAN=3>');
               append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
                  append ('<TR>');
                     append ('<TD WIDTH=142>');
                        append ('<IMG SRC="'||hig.get_sysopt('XFAQBASE')||'urbanservices.jpg">');
                     append ('</TH>');
                     append ('<TH WIDTH=100%>');
                        append ('<FONT SIZE=+2><B>'||l_rec_xahh.module_title||'</B></FONT></TH>');
                     append ('</TH>');
                  append ('</TR>');
               append ('</TABLE>');
            append ('</TH>');
         append ('</TR>');
         append ('<TR>');
            append ('<TD ALIGN=RIGHT>Run For'||nm3web.c_nbsp||'</TD>');
            append ('<TD><B>'||nm3web.c_nbsp||l_rec_xahh.run_for||'</B></TD>');
            append ('<TD><B>'||nm3web.c_nbsp||to_char(l_rec_xahh.run_date,c_mask)||'</B></TD>');
         append ('</TR>');
         append ('<TR>');
            append ('<TD ALIGN=RIGHT>History For'||nm3web.c_nbsp||'</TD>');
            append ('<TD COLSPAN=2><B>'||nm3web.c_nbsp||l_rec_xahh.location_descr||'</B></TD>');
         append ('</TR>');
         append ('<TR>');
            append ('<TD ALIGN=RIGHT>Accident Date Between'||nm3web.c_nbsp||'</TD>');
            append ('<TD COLSPAN=2><B>'||nm3web.c_nbsp||to_char(l_rec_xahh.start_date,c_mask)||' and '||to_char(l_rec_xahh.end_date,c_mask)||'</B></TD>');
         append ('</TR>');
      END IF;
         append ('<TR>');
            append ('<TD COLSPAN=3>');
      IF p_headings
       THEN
         write_seperator;
         write_acc_dets (p_police_reference => '<B><DIV ALIGN=CENTER>Police Reference</DIV></B>'
                        ,p_acc_date_time    => '<B><DIV ALIGN=CENTER>Date/Time</DIV></B>'
                        ,p_acc_severity     => '<B><DIV ALIGN=CENTER>Severity</DIV></B>'
                        ,p_acc_injury_type  => '<B><DIV ALIGN=CENTER>Injury Type</DIV></B>'
                        ,p_acc_type         => '<B><DIV ALIGN=CENTER>Acc<BR>Type</DIV></B>'
                        ,p_num_cas          => '<B><DIV ALIGN=CENTER>Num<BR>Cas</DIV></B>'
                        ,p_num_veh          => '<B><DIV ALIGN=CENTER>Num<BR>Veh</DIV></B>'
                        --,p_primary_street   => null
                        ,p_road_surface     => '<B><DIV ALIGN=LEFT>Road Surface</DIV></B>'
                        ,p_weather          => '<B><DIV ALIGN=LEFT>Weather</DIV></B>'
                        ,p_rum_code         => '<B><DIV ALIGN=CENTER>RUM Code</DIV></B>'
                        );
         write_seperator;
         write_veh_dets (p_vehicle_num            => 'Veh Num'
                        ,p_direction              => 'Direction'
                        ,p_lane                   => 'Lane'
                        ,p_position               => 'Position'
                        ,p_movement               => 'Movement'
                        ,p_visibility_restriction => 'Visibility'
                        );
      END IF;
   END write_header;
--
BEGIN
--
   g_tab_report_text.DELETE;
--
   append (htf.htmlopen);
   append (htf.bodyopen);
--
   SELECT *
    BULK  COLLECT
    INTO  l_tab_xahh
    FROM  xact_acc_history_header
   WHERE  gri_job_id = p_grr_job_id;
--
   IF l_tab_xahh.COUNT = 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => p_grr_job_id
                    );
   ELSIF l_tab_xahh.COUNT = 1
    THEN
      l_rec_xahh := l_tab_xahh(1);
   ELSE
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 105
                    ,pi_supplementary_info => p_grr_job_id
                    );
   END IF;
--
   l_route_hist_module := nm3get.get_grr (pi_grr_job_id => p_grr_job_id).grr_module = c_route_hist_module;
--
   g_mail_title := l_rec_xahh.module_title||' - '||l_rec_xahh.location_descr;
--
   SELECT *
    BULK  COLLECT
    INTO  l_tab_xahl
    FROM  xact_acc_history_locations
   WHERE  gri_job_id = l_rec_xahh.gri_job_id
   ORDER  BY seq_no;
--
   IF l_tab_xahl.COUNT = 0
    THEN
      write_header (FALSE);
      append ('<DIV ALIGN=CENTER><FONT SIZE=+1><B><I>'
            ||hig.raise_and_catch_ner(nm3type.c_net,326)
            ||'</I></B></FONT></DIV>'
             );
      close_table_and_break (FALSE);
   END IF;
--
   FOR i IN 1..l_tab_xahl.COUNT
    LOOP
      write_header (TRUE,i=1);
      --
      IF l_route_hist_module
       THEN
         append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
            append ('<TR>');
               append ('<TH WIDTH=15% ALIGN=LEFT><FONT SIZE=+1>'||l_tab_xahl(i).location_type||'</FONT></TH>');
               append ('<TH WIDTH=10% ALIGN=CENTER><FONT SIZE=+1>'||l_tab_xahl(i).location_id||'</FONT></TH>');
               append ('<TH WIDTH=75% ALIGN=CENTER><FONT SIZE=+1>'||l_tab_xahl(i).location_descr||'</FONT></TH>');
            append ('</TR>');
         append ('</TABLE>');
      END IF;
      --
      SELECT *
       BULK  COLLECT
       INTO  l_tab_xaha
       FROM  xact_acc_history_accidents
      WHERE  gri_job_id  = l_tab_xahl(i).gri_job_id
       AND   xahl_seq_no = l_tab_xahl(i).seq_no
      ORDER BY acc_date_time;
      --
      FOR j IN 1..l_tab_xaha.COUNT
       LOOP
         --
         write_acc_dets (p_police_reference => l_tab_xaha(j).police_reference
                        ,p_acc_date_time    => TO_CHAR(l_tab_xaha(j).acc_date_time,'DD/MM/YY HH24:MI')
                        ,p_acc_severity     => l_tab_xaha(j).acc_severity
                        ,p_acc_injury_type  => l_tab_xaha(j).acc_injury_type
                        ,p_acc_type         => l_tab_xaha(j).acc_type
                        ,p_num_cas          => l_tab_xaha(j).num_cas
                        ,p_num_veh          => l_tab_xaha(j).num_veh
                        --,p_primary_street   => null
                        ,p_road_surface     => l_tab_xaha(j).road_surface
                        ,p_weather          => l_tab_xaha(j).weather
                        ,p_rum_code         => l_tab_xaha(j).rum_code
                        );
         --
         SELECT *
          BULK  COLLECT
          INTO  l_tab_xahv
          FROM  xact_acc_history_vehicles
         WHERE  gri_job_id  = l_tab_xaha(j).gri_job_id
          AND   acc_id_acc  = l_tab_xaha(j).acc_id
         ORDER BY vehicle_num;
         --
         FOR k IN 1..l_tab_xahv.COUNT
          LOOP
            write_veh_dets (p_vehicle_num            => l_tab_xahv(k).vehicle_num
                           ,p_direction              => l_tab_xahv(k).direction
                           ,p_lane                   => l_tab_xahv(k).lane
                           ,p_position               => l_tab_xahv(k).position
                           ,p_movement               => l_tab_xahv(k).movement
                           ,p_visibility_restriction => l_tab_xahv(k).visibility_restriction
                           );
         END LOOP;
         --
      END LOOP;
--
--      IF l_route_hist_module
--       THEN
         append ('<TABLE WIDTH=100% CELLPADDING=0 CELLSPACING=0>');
            append ('<TR>');
               append ('<TH WIDTH=100% ALIGN=RIGHT><FONT SIZE=+1>Total Accidents: '||l_tab_xahl(i).accident_count||'</FONT></TH>');
            append ('</TR>');
         append ('</TABLE>');
--      END IF;
      --
--            write_seperator;
      l_throw := (i = l_tab_xahl.COUNT);
      close_table_and_break (l_throw);
   END LOOP;
--
   append (htf.bodyclose);
   append (htf.htmlclose);
--
END write_the_report_html;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_hist_mail IS
--
   c_grr_job_id CONSTANT NUMBER := NVL(higgri.last_grr_job_id,1);
--
   l_nmu_id nm_mail_users.nmu_id%TYPE;
   l_found  BOOLEAN;
--
   l_tab_to   nm3mail.tab_recipient;
   l_tab_cc   nm3mail.tab_recipient;
   l_tab_bcc  nm3mail.tab_recipient;
--
   l_nmm_id   NUMBER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'send_hist_mail');
--
   l_nmu_id := nm3mail.get_current_nmu_id;
--
   l_tab_to(1).rcpt_id           := l_nmu_id;
   l_tab_to(1).rcpt_type         := nm3mail.c_user;
--
   write_the_report_html (c_grr_job_id);
--
   nm3mail.write_mail_complete (p_from_user        => l_nmu_id
                               ,p_subject          => g_mail_title
                               ,p_html_mail        => TRUE
                               ,p_tab_to           => l_tab_to
                               ,p_tab_cc           => l_tab_cc
                               ,p_tab_bcc          => l_tab_bcc
                               ,p_tab_message_text => g_tab_report_text
                               );
--
   nm_debug.proc_end(g_package_name,'send_hist_mail');
--
END send_hist_mail;
--
-----------------------------------------------------------------------------
--
END xact_acc_reports;
/
