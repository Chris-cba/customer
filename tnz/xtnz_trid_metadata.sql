
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_metadata.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_metadata.sql
--       Date into SCCS   : 05/03/15 03:46:18
--       Date fetched Out : 07/06/06 14:40:38
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------

--INSERT INTO nm_inv_categories
--      (nic_category, nic_descr)
--SELECT '~'
--      ,'TRID Inventory'
-- FROM  dual
--WHERE  NOT EXISTS (SELECT 1
--                    FROM  nm_inv_categories
--                   WHERE  nic_category = '~'
--                  )
--/
--
--
--INSERT INTO nm_inv_category_modules
--      (icm_nic_category, icm_hmo_module, icm_updatable)
--SELECT '~', hmo_module, 'Y'
-- FROM  hig_modules
--WHERE  hmo_module IN ('NM0510','NM0560','NM0570')
-- AND   NOT EXISTS (SELECT 1
--                    FROM  nm_inv_category_modules
--                   WHERE  icm_nic_category = '~'
--                    AND   icm_hmo_module   = hmo_module
--                  )
--/

INSERT INTO hig_codes
      (hco_domain
      ,hco_code
      ,hco_meaning
      ,hco_system
      ,hco_seq
      )
SELECT 'MODULE_TYPE'
      ,'URL'
      ,'Universal Resource Locater'
      ,'Y'
      ,8
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_codes
                   WHERE  hco_domain = 'MODULE_TYPE'
                    AND   hco_code   = 'URL'
                  )
/


DECLARE
--
--  HIG_MODULES and HIG_MODULE_ROLES
--
   TYPE tab_rec_module IS TABLE OF hig_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_hmo     hig_modules%ROWTYPE;
   l_tab_rec_hmo tab_rec_module;
--
   l_tab_hmr_module nm3type.tab_varchar30;
   l_tab_hmr_role   nm3type.tab_varchar30;
   l_tab_hmr_mode   nm3type.tab_varchar30;
--
   l_hmo_count      PLS_INTEGER := 0;
   l_hmr_count      PLS_INTEGER := 0;
--
   PROCEDURE add_hmo IS
   BEGIN
      l_hmo_count := l_hmo_count + 1;
      l_tab_rec_hmo(l_hmo_count) := l_rec_hmo;
   END add_hmo;
--
   PROCEDURE add_hmr (p_role   VARCHAR2
                     ,p_mode   VARCHAR2
                     ,p_module VARCHAR2 DEFAULT l_rec_hmo.hmo_module
                     ) IS
   BEGIN
      l_hmr_count := l_hmr_count + 1;
      l_tab_hmr_module(l_hmr_count) := UPPER(p_module);
      l_tab_hmr_role(l_hmr_count)   := UPPER(p_role);
      l_tab_hmr_mode(l_hmr_count)   := UPPER(p_mode);
   END add_hmr;
--
BEGIN
   l_rec_hmo.hmo_module           := 'XTNZWEB0020';
   l_rec_hmo.hmo_title            := 'TRID Find Items';
   l_rec_hmo.hmo_filename         := 'xtnz_trid_aor_reporting.main';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0021';
   l_rec_hmo.hmo_title            := 'TRID Find Items (search route)';
   l_rec_hmo.hmo_filename         := 'xtnz_trid_aor_reporting.nt_qry';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0022';
   l_rec_hmo.hmo_title            := 'Search TRID Route';
   l_rec_hmo.hmo_filename         := 'xtnz_trid_aor_reporting.trid';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0004';
   l_rec_hmo.hmo_title            := 'TNZ Favourites';
   l_rec_hmo.hmo_filename         := 'xtnzweb_fav.show_favourites';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZURL0001';
   l_rec_hmo.hmo_title            := 'Transit Homepage';
   l_rec_hmo.hmo_filename         := 'http://www.transit.govt.nz';
   l_rec_hmo.hmo_module_type      := 'URL';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
--
   FOR i IN 1..l_hmo_count
    LOOP
      l_rec_hmo := l_tab_rec_hmo(i);
      INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
      SELECT l_rec_hmo.hmo_module
            ,l_rec_hmo.hmo_title
            ,l_rec_hmo.hmo_filename
            ,l_rec_hmo.hmo_module_type
            ,l_rec_hmo.hmo_fastpath_opts
            ,l_rec_hmo.hmo_fastpath_invalid
            ,l_rec_hmo.hmo_use_gri
            ,l_rec_hmo.hmo_application
            ,l_rec_hmo.hmo_menu
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_rec_hmo.hmo_module
                       );
   END LOOP;
--
   FORALL i IN 1..l_hmr_count
      INSERT INTO hig_module_roles
            (hmr_module
            ,hmr_role
            ,hmr_mode
            )
      SELECT l_tab_hmr_module(i)
            ,l_tab_hmr_role(i)
            ,l_tab_hmr_mode(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_module_roles
                        WHERE  hmr_module = l_tab_hmr_module(i)
                         AND   hmr_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_roles
                        WHERE  hro_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_tab_hmr_module(i)
                       );
--
END;
/



EXEC nm3ddl.REBUILD_SEQUENCE ('DQ_ID_SEQ');
DELETE FROM doc_query
WHERE dq_title = 'TRID_ROUTE_SEARCH'
/

INSERT INTO doc_query
       (dq_id
       ,dq_title
       ,dq_descr
       ,dq_sql
       )
VALUES ( dq_id_seq.NEXTVAL
       ,'TRID_ROUTE_SEARCH'
       ,Null
       ,           'SELECT xtnz_lar_mail_merge.get_detail_url(iit_ne_id) detail'
        ||CHR(10)||'      ,xtnz_trid.get_map_item_url(iit_ne_id,iit_inv_type) map'
        ||CHR(10)||'      ,v.*'
        ||CHR(10)||' FROM  v_all_events v'
        ||CHR(10)||'WHERE  iit_ne_id IN (SELECT ngqi_item_id'
        ||CHR(10)||'                      FROM  nm_gaz_query_item_list'
        ||CHR(10)||'                     WHERE  ngqi_job_id         = (SELECT xtnz_trid_aor_reporting.get_ngqi_job_id FROM DUAL WHERE ROWNUM=1)'
        ||CHR(10)||'                      AND   ngqi_item_type_type = '||nm3flx.string('I')
        ||CHR(10)||'                      AND   ngqi_item_type      = v.iit_inv_type'
        ||CHR(10)||'                    )'
       );

INSERT INTO hig_options
      (hop_id
      ,hop_product
      ,hop_name
      ,hop_value
      ,hop_remarks
      ,hop_domain
      ,hop_datatype
      ,hop_mixed_case
      )
SELECT 'X_INSTANCE'
      ,'XTNZ'
      ,'Instance Name'
      ,instance_name
      ,'The name of the DB instance. The Application server must have a value for this in TNSNAMES.ORA'
      ,Null
      ,'VARCHAR2'
      ,'Y'
 FROM  v$instance
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options
                   WHERE  hop_id = 'X_INSTANCE'
                  )
/


INSERT INTO hig_options
      (hop_id
      ,hop_product
      ,hop_name
      ,hop_value
      ,hop_remarks
      ,hop_domain
      ,hop_datatype
      ,hop_mixed_case
      )
SELECT 'XFORMS_URL'
      ,'XTNZ'
      ,'Forms URL'
      ,'http://trid:81/servlet/f60servlet?config=exor'
      ,'The value of the URL for launching forms'
      ,Null
      ,'VARCHAR2'
      ,'Y'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options
                   WHERE  hop_id = 'XFORMS_URL'
                  )
/



INSERT INTO hig_options
      (hop_id
      ,hop_product
      ,hop_name
      ,hop_value
      ,hop_remarks
      ,hop_domain
      ,hop_datatype
      ,hop_mixed_case
      )
SELECT 'XFAVSTPAGE'
      ,'XTNZ'
      ,'Starting page for Web Favs'
      ,'http://www.transit.govt.nz/'
      ,'Starting page for the web favourites'
      ,Null
      ,'VARCHAR2'
      ,'Y'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options
                   WHERE  hop_id = 'XFAVSTPAGE'
                  )
/


INSERT INTO hig_options
      (hop_id
      ,hop_product
      ,hop_name
      ,hop_value
      ,hop_remarks
      ,hop_domain
      ,hop_datatype
      ,hop_mixed_case
      )
SELECT 'X_TIMEOUT'
      ,'XTNZ'
      ,'Timeout in seconds'
      ,'90'
      ,'Timeout in Seconds for launching modules from the TNZ web favourites'
      ,Null
      ,'NUMBER'
      ,'N'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_options
                   WHERE  hop_id = 'X_TIMEOUT'
                  )
/


COMMIT
/

