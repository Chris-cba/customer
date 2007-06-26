--

--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_valuations_metadata.sql	1.1 03/14/05
--       Module Name      : xact_valuations_metadata.sql
--       Date into SCCS   : 05/03/14 23:11:01
--       Date fetched Out : 07/06/06 14:33:50
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/
--
DELETE FROM HIG_MODULE_ROLES
WHERE hmr_module LIKE 'XVAL%';
DELETE FROM HIG_MODULES
WHERE hmo_module LIKE 'XVAL%';

--
DECLARE
   --
   -- NM_ERRORS
   --
   l_tab_ner_id    nm3type.tab_number;
   l_tab_ner_descr nm3type.tab_varchar2000;
   l_tab_appl      nm3type.tab_varchar30;
   --
   l_tab_dodgy_ner_id    nm3type.tab_number;
   l_tab_dodgy_ner_appl  nm3type.tab_varchar30;
   l_tab_dodgy_descr_old nm3type.tab_varchar2000;
   l_tab_dodgy_descr_new nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS
      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;
   BEGIN
      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_appl(c_count)      := p_app;
   END add_ner;
   --
   PROCEDURE add_dodgy (p_ner_id        number
                       ,p_ner_descr_old varchar2
                       ,p_ner_descr_new varchar2
                       ,p_app           varchar2 DEFAULT l_current_type
                       ) IS
      c_count CONSTANT pls_integer := l_tab_dodgy_ner_id.COUNT+1;
   BEGIN
      l_tab_dodgy_ner_id(c_count)    := p_ner_id;
      l_tab_dodgy_descr_old(c_count) := p_ner_descr_old;
      l_tab_dodgy_descr_new(c_count) := NVL(p_ner_descr_new,p_ner_descr_old);
      l_tab_dodgy_ner_appl(c_count)  := p_app;
   END add_dodgy;
   --
BEGIN
   --
   l_current_type := nm3type.c_hig;
   DELETE FROM nm_errors
   WHERE ner_appl = 'HIG'
   AND ner_id=223;
   add_ner(231, 'Detail');
   add_ner(216, 'Close');
   add_ner(217, 'Select All');
   add_ner(218, 'Inverse Selection');
   add_ner(219, 'Refresh');

--
   l_current_type := 'XVAL';
   add_ner(1,'Column cannot be updated by valuation product');
   add_ner(2,'ITA_VIEW_COL_NAME cannot be the same as an allowable NM_INV_ITEMS column for update by valuation product');
   add_ner(3,'Dry Run');
   add_ner(4,'Revaluation');
   add_ner(5,'Depreciation');
   add_ner(6,'Record Created');
   add_ner(7,'Records Created');
   add_ner(8,'Only numeric attributes may be summed for reporting');
   add_ner(9,'Run');
   add_ner(10,'Select report');
   --
   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;
   --
   FORALL i IN 1..l_tab_dodgy_ner_id.COUNT
      UPDATE nm_errors
       SET   ner_descr = l_tab_dodgy_descr_new (i)
      WHERE  ner_id    = l_tab_dodgy_ner_id(i)
       AND   ner_appl  = l_tab_dodgy_ner_appl(i)
       AND   ner_descr = l_tab_dodgy_descr_old(i);
   --
END;
/
--
INSERT INTO hig_products
      (hpr_product
      ,hpr_product_name
      ,hpr_version
      ,hpr_key
      ,hpr_sequence
      )
SELECT 'XVAL'
      ,'Asset Valuations'
      ,'3.1.0.0'
      ,ASCII('X')
      ,9
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_products
                   WHERE  hpr_product = 'XVAL'
                  )
/
--
INSERT INTO hig_roles
      (hro_role
      ,hro_product
      ,hro_descr
      )
SELECT 'XVAL_USER'
      ,'XVAL'
      ,'Valuation User'
 FROM  DUAL
WHERE  NOT EXISTS (SELECT 1
                    FROM  hig_roles
                   WHERE  hro_role = 'XVAL_USER'
                  )
/
--
DECLARE
   l_dummy NUMBER;
   c_role VARCHAR2(30) := 'XVAL_USER';
BEGIN
   SELECT 1
    INTO  l_dummy
    FROM  dba_roles
   WHERE  role = c_role;
EXCEPTION
   WHEN no_data_found
    THEN
      EXECUTE IMMEDIATE 'CREATE ROLE '||c_role;
END;
/
--
EXEC grant_role_to_user(USER,'XVAL_USER',TRUE);
--
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
   c_xval CONSTANT VARCHAR2(4) := 'XVAL';
   c_web  CONSTANT VARCHAR2(3) := 'WEB';
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
   l_rec_hmo.hmo_module           := 'DOCWEB0010';
   l_rec_hmo.hmo_title            := 'Run Query';
   l_rec_hmo.hmo_filename         := 'dm3query.list_queries';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'DOC';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XEXORWEB0570';
   l_rec_hmo.hmo_title            := 'Find Asset';
   l_rec_hmo.hmo_filename         := 'xval_find_inv.find_anything';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('NET_ADMIN',nm3type.c_normal);
   add_hmr ('NET_USER',nm3type.c_normal);
   add_hmr ('NET_READONLY',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0570';
   l_rec_hmo.hmo_title            := 'Find Asset (valuations)';
   l_rec_hmo.hmo_filename         := 'xval_find_inv.main';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0510';
   l_rec_hmo.hmo_title            := 'Create Asset';
   l_rec_hmo.hmo_filename         := 'xval_create_inv.inv_types';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   l_rec_hmo.hmo_module           := 'XVALWEB0010';
   l_rec_hmo.hmo_title            := 'Create Valuation Record (single item)';
   l_rec_hmo.hmo_filename         := 'xval_find_inv.find_val_rec_cr8';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_find_inv.create_val';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'S';
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0011';
   l_rec_hmo.hmo_title            := 'Create Valuation Record (multiple)';
   l_rec_hmo.hmo_filename         := 'xval_find_inv.val_rec_cr8_mult';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_find_inv.create_val_multi';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'M';
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0012';
   l_rec_hmo.hmo_title            := 'Valuation Record Error Correction';
   l_rec_hmo.hmo_filename         := 'xval_find_inv.val_rec_err_fix';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0020';
   l_rec_hmo.hmo_title            := 'Perform Ad-hoc revaluation'; -- (single item)';
   l_rec_hmo.hmo_filename         := 'xval_reval.find_adhoc_single';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_reval.prompt_adhoc_single';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'S';
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0030';
   l_rec_hmo.hmo_title            := 'Perform Ad-hoc revaluation (multiple)';
   l_rec_hmo.hmo_filename         := 'xval_reval.find_adhoc_many';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_reval.prompt_adhoc_many';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'M';
--   add_hmo;
--   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0040';
   l_rec_hmo.hmo_title            := 'Perform year end depreciation';
   l_rec_hmo.hmo_filename         := 'xval_reval.find_year_end_dep';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_reval.prompt_year_end_dep';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'M';
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0050';
   l_rec_hmo.hmo_title            := 'Perform revaluation (Rawlinson Factor)';
   l_rec_hmo.hmo_filename         := 'xval_reval.find_year_end_reval';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := 'xval_reval.prompt_year_end_rev';
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := 'M';
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XVALWEB0060';
   l_rec_hmo.hmo_title            := 'Valuations Reports';
   l_rec_hmo.hmo_filename         := 'xval_reporting.main';
   l_rec_hmo.hmo_module_type      := c_web;
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := c_xval;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('XVAL_USER',nm3type.c_normal);
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


DECLARE
--
-- HIG_OPTION_LIST and HIG_OPTION_VALUES
--
   l_tab_hol_id         nm3type.tab_varchar30;
   l_tab_hol_product    nm3type.tab_varchar30;
   l_tab_hol_name       nm3type.tab_varchar30;
   l_tab_hol_remarks    nm3type.tab_varchar2000;
   l_tab_hol_domain     nm3type.tab_varchar30;
   l_tab_hol_datatype   nm3type.tab_varchar30;
   l_tab_hol_mixed_case nm3type.tab_varchar30;
   l_tab_hov_value      nm3type.tab_varchar2000;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add (p_hol_id         VARCHAR2
                 ,p_hol_product    VARCHAR2
                 ,p_hol_name       VARCHAR2
                 ,p_hol_remarks    VARCHAR2
                 ,p_hol_domain     VARCHAR2 DEFAULT Null
                 ,p_hol_datatype   VARCHAR2 DEFAULT nm3type.c_varchar
                 ,p_hol_mixed_case VARCHAR2 DEFAULT 'N'
                 ,p_hov_value      VARCHAR2 DEFAULT NULL
                 ) IS
      c_count PLS_INTEGER := l_tab_hol_id.COUNT+1;
   BEGIN
      l_tab_hol_id(c_count)         := p_hol_id;
      l_tab_hol_product(c_count)    := p_hol_product;
      l_tab_hol_name(c_count)       := p_hol_name;
      l_tab_hol_remarks(c_count)    := p_hol_remarks;
      l_tab_hol_domain(c_count)     := p_hol_domain;
      l_tab_hol_datatype(c_count)   := p_hol_datatype;
      l_tab_hol_mixed_case(c_count) := p_hol_mixed_case;
      l_tab_hov_value(c_count)      := p_hov_value;
   END add;
BEGIN
--
   add (p_hol_id         => 'XVALINVTYP'
       ,p_hol_product    => 'XVAL'
       ,p_hol_name       => 'Valuation asset type'
       ,p_hol_remarks    => 'The asset type for the valuation recordsd'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'VAL'
       );
--
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_list
            (hol_id
            ,hol_product
            ,hol_name
            ,hol_remarks
            ,hol_domain
            ,hol_datatype
            ,hol_mixed_case
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hol_product(i)
            ,l_tab_hol_name(i)
            ,l_tab_hol_remarks(i)
            ,l_tab_hol_domain(i)
            ,l_tab_hol_datatype(i)
            ,l_tab_hol_mixed_case(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_option_list
                         WHERE  hol_id = l_tab_hol_id(i)
                        );
--
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_values
            (hov_id
            ,hov_value
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hov_value(i)
        FROM dual
      WHERE  l_tab_hov_value(i) IS NOT NULL
       AND   NOT EXISTS (SELECT 1
                          FROM  hig_option_values
                         WHERE  hov_id = l_tab_hol_id(i)
                        );
--
END;
/
--
DECLARE
   l_tab_HSTF_PARENT nm3type.tab_varchar30;
   l_tab_HSTF_CHILD  nm3type.tab_varchar30;
   l_tab_HSTF_DESCR  nm3type.tab_varchar80;
   l_tab_HSTF_TYPE   nm3type.tab_varchar4;
   l_tab_HSTF_ORDER  nm3type.tab_number;
--
   c_xval CONSTANT VARCHAR2(4) := 'XVAL';
--
   PROCEDURE add_it (p_HSTF_PARENT VARCHAR2
                    ,p_HSTF_CHILD  VARCHAR2
                    ,p_HSTF_DESCR  VARCHAR2
                    ,p_HSTF_TYPE   VARCHAR2
                    ,p_HSTF_ORDER  NUMBER
                    ) IS
      c_count CONSTANT PLS_INTEGER := l_tab_HSTF_PARENT.COUNT+1;
   BEGIN
      l_tab_HSTF_PARENT(c_count) := p_HSTF_PARENT;
      l_tab_HSTF_CHILD(c_count)  := p_HSTF_CHILD;
      l_tab_HSTF_DESCR(c_count)  := p_HSTF_DESCR;
      l_tab_HSTF_TYPE(c_count)   := p_HSTF_TYPE;
      l_tab_HSTF_ORDER(c_count)  := p_HSTF_ORDER;
   END add_it;
BEGIN
--
   add_it ('FAVOURITES',c_xval,'Asset Valuations','F',9);
--
   FOR cs_rec IN (SELECT *
                   FROM  hig_modules
                  WHERE  hmo_application = c_xval
                 )
    LOOP
      add_it (c_xval,cs_rec.hmo_module,cs_rec.hmo_title,'M',l_tab_hstf_parent.COUNT);
   END LOOP;
--
   FORALL i IN 1..l_tab_HSTF_PARENT.COUNT
      INSERT INTO hig_standard_favourites
            (hstf_parent
            ,hstf_child
            ,hstf_descr
            ,hstf_type
            ,hstf_order
            )
      SELECT l_tab_hstf_parent(i)
            ,l_tab_hstf_child(i)
            ,l_tab_hstf_descr(i)
            ,l_tab_hstf_type(i)
            ,l_tab_hstf_order(i)
       FROM  DUAL
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_standard_favourites
                         WHERE  hstf_parent = l_tab_hstf_parent(i)
                          AND   hstf_child  = l_tab_hstf_child(i)
                        );
--
END;
/

DECLARE
--
-- HIG_DOMAINS and HIG_CODES
--
   l_tab_hdo_domain     nm3type.tab_varchar30;
   l_tab_hdo_product    nm3type.tab_varchar30;
   l_tab_hdo_title      nm3type.tab_varchar2000;
   l_tab_hdo_code_len   nm3type.tab_number;
--
   l_tab_hco_domain     nm3type.tab_varchar30;
   l_tab_hco_code       nm3type.tab_varchar30;
   l_tab_hco_meaning    nm3type.tab_varchar2000;
   l_tab_hco_system     nm3type.tab_varchar4;
   l_tab_hco_seq        nm3type.tab_number;
   l_tab_hco_start_date nm3type.tab_date;
   l_tab_hco_end_date   nm3type.tab_date;
--
   l_hdo_count        PLS_INTEGER := 0;
   l_hco_count        PLS_INTEGER := 0;
--
   PROCEDURE add_hdo (p_domain   VARCHAR2
                     ,p_product  VARCHAR2
                     ,p_title    VARCHAR2
                     ,p_code_len NUMBER
                     ) IS
   BEGIN
      l_hdo_count := l_hdo_count + 1;
      l_tab_hdo_domain(l_hdo_count)   := UPPER(p_domain);
      l_tab_hdo_product(l_hdo_count)  := UPPER(p_product);
      l_tab_hdo_title(l_hdo_count)    := p_title;
      l_tab_hdo_code_len(l_hdo_count) := p_code_len;
   END add_hdo;
--
   PROCEDURE add_hco (p_domain     VARCHAR2
                     ,p_code       VARCHAR2
                     ,p_meaning    VARCHAR2
                     ,p_system     VARCHAR2 DEFAULT 'Y'
                     ,p_seq        NUMBER   DEFAULT NULL
                     ,p_start_date DATE     DEFAULT NULL
                     ,p_end_date   DATE     DEFAULT NULL
                     ) IS
   BEGIN
      l_hco_count := l_hco_count + 1;
      l_tab_hco_domain(l_hco_count)     := UPPER(p_domain);
      l_tab_hco_code(l_hco_count)       := p_code;
      l_tab_hco_meaning(l_hco_count)    := p_meaning;
      l_tab_hco_system(l_hco_count)     := p_system;
      l_tab_hco_seq(l_hco_count)        := p_seq;
      l_tab_hco_start_date(l_hco_count) := p_start_date;
      l_tab_hco_end_date(l_hco_count)   := p_end_date;
   END add_hco;
--
BEGIN
--
   add_hco('GAZ_QRY_FIXED_COLS_I','IIT_DESCR','Description','Y', 1005);
   add_hco('GAZ_QRY_FIXED_COLS_I','IIT_NOTE','Note','Y', 1006);
   add_hco('GAZ_QRY_FIXED_COLS_I','IIT_PEO_INVENT_BY_ID','Inspected By','Y', 1007);
--
   FORALL i IN 1..l_hdo_count
      INSERT INTO hig_domains
            (hdo_domain
            ,hdo_product
            ,hdo_title
            ,hdo_code_length
            )
      SELECT l_tab_hdo_domain(i)
            ,l_tab_hdo_product(i)
            ,l_tab_hdo_title(i)
            ,l_tab_hdo_code_len(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hdo_domain(i)
                       );
   FORALL i IN 1..l_hco_count
      INSERT INTO hig_codes
            (hco_domain
            ,hco_code
            ,hco_meaning
            ,hco_system
            ,hco_seq
            ,hco_start_date
            ,hco_end_date
            )
      SELECT l_tab_hco_domain(i)
            ,l_tab_hco_code(i)
            ,l_tab_hco_meaning(i)
            ,l_tab_hco_system(i)
            ,l_tab_hco_seq(i)
            ,l_tab_hco_start_date(i)
            ,l_tab_hco_end_date(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_codes
                        WHERE  hco_domain = l_tab_hco_domain(i)
                         AND   hco_code   = l_tab_hco_code(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hco_domain(i)
                       );
--
END;
/


commit
/

