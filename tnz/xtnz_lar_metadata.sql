--
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_lar_metadata.sql	1.1 03/16/05
--       Module Name      : xtnz_lar_metadata.sql
--       Date into SCCS   : 05/03/16 01:19:39
--       Date fetched Out : 07/06/06 14:40:29
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TNZ LAR metadata
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
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
   l_current_type := 'XTNZ';
   add_ner(1,'Click on <b><u>');
   add_ner(2,'</b></u> and <b><i>save</b></i> the file to C:\LAR.  If you want to display or print the merge data then click on the link and <b><i>open</b></i> the file');
   add_ner(3,'Then click on <b><u>');
   add_ner(4,'</b></u>. Word will open so you can edit the template if you wish. When you'||CHR(39)||'re ready use Word'||CHR(39)||'s <i>Mail Merge</i> function.');
   add_ner(5,'Word will create your documents and you can edit individual pages if you want to');
   add_ner(6,'End point must exist further down a defined linear group than the start point');
   add_ner(7,'Start and End points exist on more than one linear group together');
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
   l_rec_hmo.hmo_module           := 'DOCWEB0010';
   l_rec_hmo.hmo_title            := 'Run Query';
   l_rec_hmo.hmo_filename         := 'dm3query.list_queries';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'DOC';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0010';
   l_rec_hmo.hmo_title            := 'LAR Produce Letters';
   l_rec_hmo.hmo_filename         := 'xtnz_lar_mail_merge.main';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0010A';
   l_rec_hmo.hmo_title            := 'LAR Produce Letters (admin)';
   l_rec_hmo.hmo_filename         := 'xtnz_lar_mail_merge.main';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('LAR_ADMIN',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0570';
   l_rec_hmo.hmo_title            := 'Find Inventory';
   l_rec_hmo.hmo_filename         := 'xtnz_find_inventory.main';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0030';
   l_rec_hmo.hmo_title            := 'Find Crossing Places';
   l_rec_hmo.hmo_filename         := 'xtnz_find_inventory.find_cp';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0040';
   l_rec_hmo.hmo_title            := 'Find LAR Sections';
   l_rec_hmo.hmo_filename         := 'xtnz_find_inventory.find_la';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER',nm3type.c_normal);
   l_rec_hmo.hmo_module           := 'XTNZWEB0510';
   l_rec_hmo.hmo_title            := 'Create Inventory';
   l_rec_hmo.hmo_filename         := 'xtnz_lar_create_inv.inv_types';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   FOR cs_rec IN (SELECT hmr_role FROM hig_module_roles WHERE hmr_module = 'NM0510')
    LOOP
      add_hmr (cs_rec.hmr_role,nm3type.c_normal);
   END LOOP;
   l_rec_hmo.hmo_module           := 'XTNZWEB0511';
   l_rec_hmo.hmo_title            := 'Create LA Section';
   l_rec_hmo.hmo_filename         := 'xtnz_lar_create_inv.create_la';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   FOR cs_rec IN (SELECT hmr_role FROM hig_module_roles WHERE hmr_module = 'NM0510')
    LOOP
      add_hmr (cs_rec.hmr_role,nm3type.c_normal);
   END LOOP;
   l_rec_hmo.hmo_module           := 'XTNZWEB0512';
   l_rec_hmo.hmo_title            := 'Create LA Crossing Place';
   l_rec_hmo.hmo_filename         := 'xtnz_lar_create_inv.create_cp';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'ENQ';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   FOR cs_rec IN (SELECT hmr_role FROM hig_module_roles WHERE hmr_module = 'NM0510')
    LOOP
      add_hmr (cs_rec.hmr_role,nm3type.c_normal);
   END LOOP;
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

INSERT INTO DOC_QUERY ( DQ_ID, DQ_TITLE, DQ_DESCR, DQ_SQL )
SELECT
nm3seq.next_dq_id_seq, 'Road Closures', 'Road Closures in last 24 hours', 'SELECT iit_primary_key
      ,iit_descr
      ,IIT_CHR_ATTRIB26 INFORMATION_SOURCE
      ,IIT_CHR_ATTRIB27 IMPACT
      ,IIT_CHR_ATTRIB28 PUBLIC_CONTACT
      ,DECODE(iit_inv_type
	         ,''AW'',IIT_CHR_ATTRIB36
	         ,''PW'',IIT_CHR_ATTRIB30
			 ,''N/A''
			 )  PLANNED_EVENT
      ,DECODE(iit_inv_type
	         ,''RH'',IIT_CHR_ATTRIB31
	         ,''AW'',IIT_CHR_ATTRIB34
			 ,''N/A''
			 ) INFORMATION_STATUS
      ,DECODE(iit_inv_type
	         ,''RH'',IIT_CHR_ATTRIB36
             ,''N/A''
			 ) HAZARD_TYPE
      ,DECODE(iit_inv_type
	         ,''RH'',IIT_CHR_ATTRIB36
	         ,''AW'',IIT_CHR_ATTRIB55
	         ,''PW'',IIT_CHR_ATTRIB55
			 ,''N/A''
			 ) NMC_NOTIFIED
      ,DECODE(iit_inv_type
	         ,''RW'',IIT_CHR_ATTRIB66
             ,''N/A''
			 )  WORKS_DESCRIPTION
      ,IIT_CHR_ATTRIB67 ALTERNATIVE_ROUTE
      ,IIT_CHR_ATTRIB68 COMMENTS
      ,DECODE(iit_inv_type
	         ,''AW'',TO_CHAR(IIT_DATE_ATTRIB86,''DD-MON-YYYY HH24:MI'')
	         ,''RW'',TO_CHAR(IIT_DATE_ATTRIB86,''DD-MON-YYYY HH24:MI'')
	         ,''PW'',TO_CHAR(IIT_DATE_ATTRIB86,''DD-MON-YYYY HH24:MI'')
			 ,''N/A''
			 ) EVENT_START_DATE
      ,DECODE(iit_inv_type
	         ,''AW'',TO_CHAR(IIT_DATE_ATTRIB87,''DD-MON-YYYY HH24:MI'')
	         ,''RW'',TO_CHAR(IIT_DATE_ATTRIB87,''DD-MON-YYYY HH24:MI'')
	         ,''PW'',TO_CHAR(IIT_DATE_ATTRIB87,''DD-MON-YYYY HH24:MI'')
			 ,''N/A''
			 ) EXPECTED_COMPLETION_DATE
      ,DECODE(iit_inv_type
	         ,''RH'',TO_CHAR(IIT_DATE_ATTRIB87,''DD-MON-YYYY HH24:MI'')
			 ,''N/A''
			 )  EXPECTED_RESOLUTION_DATE
      ,to_char(IIT_DATE_ATTRIB88,''DD-MON-YYYY HH24:MI'') DATE_NEXT_UPDATE_DUE
 FROM  nm_inv_items_all
WHERE  iit_inv_type IN (''RW'',''AW'',''PW'',''RH'')
 AND   iit_date_created > (sysdate-1)
 AND   iit_chr_attrib27 = ''CLOSED'''
 FROM DUAL
WHERE NOT EXISTS (SELECT 1
                   FROM  doc_query
                  WHERE  dq_title = 'Road Closures'
                 );


commit
/

