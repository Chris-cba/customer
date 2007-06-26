CREATE OR REPLACE PACKAGE BODY xtnz_lar_create_inv IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_lar_create_inv.pkb	1.2 03/16/05
--       Module Name      : xtnz_lar_create_inv.pkb
--       Date into SCCS   : 05/03/16 01:19:36
--       Date fetched Out : 07/06/06 14:40:25
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   template package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xtnz_lar_create_inv.pkb	1.2 03/16/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30) := 'xtnz_lar_create_inv';
--
   c_this_module     CONSTANT  hig_modules.hmo_module%TYPE   := 'XTNZWEB0510';
   c_module_title    CONSTANT  hig_modules.hmo_title%TYPE    := hig.get_module_title(c_this_module);
   c_la_this_module  CONSTANT  hig_modules.hmo_module%TYPE   := 'XTNZWEB0511';
   c_la_module_title CONSTANT  hig_modules.hmo_title%TYPE    := hig.get_module_title(c_la_this_module);
   c_cp_this_module  CONSTANT  hig_modules.hmo_module%TYPE   := 'XTNZWEB0512';
   c_cp_module_title CONSTANT  hig_modules.hmo_title%TYPE    := hig.get_module_title(c_cp_this_module);
   c_continue        CONSTANT  nm_errors.ner_descr%TYPE      := hig.get_ner(nm3type.c_hig,165).ner_descr;
   c_tnz_product     CONSTANT  hig_products.hpr_product%TYPE := 'XTNZ';
--
------------------------------------------------------------------------------
--
FUNCTION harsh_date_check (p_char_date VARCHAR2) RETURN DATE;
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
----------------------------------------------------------------------------------------
--
PROCEDURE sccs_tags IS
BEGIN
   htp.comment('--   SCCS Identifiers :-');
   htp.comment('--');
   htp.comment('--       sccsid           : @(#)xtnz_lar_create_inv.pkb	1.2 03/16/05');
   htp.comment('--       Module Name      : xtnz_lar_create_inv.pkb');
   htp.comment('--       Date into SCCS   : 05/03/16 01:19:36');
   htp.comment('--       Date fetched Out : 07/06/06 14:40:25');
   htp.comment('--       SCCS Version     : 1.2');
   htp.comment('--');
   htp.comment('--');
   htp.comment('--   Author : Jonathan Mills');
   htp.comment('--');
   htp.comment('-----------------------------------------------------------------------------');
   htp.comment('--	Copyright (c) exor corporation ltd, 2003');
   htp.comment('-----------------------------------------------------------------------------');
   htp.comment(Null);
END sccs_Tags;
--
----------------------------------------------------------------------------------------
--
PROCEDURE inv_types IS
BEGIN
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
   htp.formopen(g_package_name||'.enter_data'
               );
   htp.formhidden ('p_module',c_this_module);
   htp.formhidden ('p_module_title',c_module_title);
   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader (htf.small('Select Asset Type'));
   htp.p('<TD>');
   htp.formselectopen('p_inv_type');
   FOR cs_rec IN (SELECT nit_inv_type,nit_descr
                   FROM  nm_inv_types
                  WHERE  nit_table_name IS NULL
                   AND   nit_update_allowed = 'Y'
                   AND   nm3inv.get_inv_mode_by_role (nit_inv_type,USER) = nm3type.c_normal
                  ORDER BY 1
                 )
    LOOP
      htp.p('   <OPTION VALUE="'||cs_rec.nit_inv_type||'">'||cs_rec.nit_inv_type||' - '||cs_rec.nit_descr||'</OPTION>');
   END LOOP;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.bodyclose;
   htp.htmlclose;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END inv_types;
--
----------------------------------------------------------------------------------------
--
PROCEDURE enter_data (p_inv_type        IN VARCHAR2
                     ,p_module          IN VARCHAR2 DEFAULT NULL
                     ,p_module_title    IN VARCHAR2 DEFAULT NULL
                     ,p_iit_foreign_key IN VARCHAR2 DEFAULT NULL
                     ) IS
--
   l_rec_nit nm_inv_types%ROWTYPE;
--
   l_mandatory VARCHAR2(30);
   c_mand CONSTANT VARCHAR2(30) := '<SUP>*</SUP>';
--
   g_fixed_cols nm3type.tab_varchar30;
--
   l_owner CONSTANT VARCHAR2(30) := nm3context.get_context(pi_attribute=>'APPLICATION_OWNER');
   l_this_is_a_trid_item BOOLEAN;
--
   CURSOR cs_mand (c_col_name VARCHAR2) IS
   SELECT *
    FROM  all_tab_columns
   WHERE  owner = l_owner
    AND   table_name = 'NM_INV_ITEMS'
    AND   column_name = c_col_name;
   l_dummy cs_mand%ROWTYPE;
--
   CURSOR cs_ita (c_inv_type VARCHAR2) IS
   SELECT *
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type = c_inv_type
   ORDER BY ita_disp_seq_no;
--
   xsp_allow BOOLEAN := FALSE;
--
   l_mandatory_fields nm3type.tab_varchar30;
   l_mand_fields_disp nm3type.tab_varchar30;
   l_tab_scl          nm3type.tab_varchar4;
   l_tab_scl_descr    nm3type.tab_varchar80;
   l_start_prefix     VARCHAR2(30);
--
BEGIN
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => p_module_title
               );
   l_rec_nit := nm3inv.get_inv_type(p_inv_type);
--
   l_this_is_a_trid_item := xtnz_trid.this_is_a_trid_item(l_rec_nit.nit_elec_drain_carr);
--
   IF nm3inv.get_inv_mode_by_role (pi_inv_type => l_rec_nit.nit_inv_type
                                  ,pi_username => USER
                                  ) != nm3type.c_normal
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => 'Create '||l_rec_nit.nit_descr
                    );
   END IF;
   IF l_this_is_a_trid_item
    THEN
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_START_DATE';
   END IF;
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_ADMIN_UNIT';
   IF l_this_is_a_trid_item
    THEN
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_DESCR';
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_NOTE';
   END IF;
   IF  l_this_is_a_trid_item
    OR xtnz_trid.user_has_normal_module_access (p_module)
    THEN
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_END_DATE';
   END IF;
   IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
    THEN
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_X_SECT';
   END IF;
--
   FOR l_count IN 1..g_fixed_cols.COUNT
    LOOP
      OPEN  cs_mand(g_fixed_cols(l_count));
      FETCH cs_mand INTO l_dummy;
      CLOSE cs_mand;
      IF l_dummy.nullable != 'Y'
       THEN
         l_mandatory_fields(l_mandatory_fields.COUNT+1) := g_fixed_cols(l_count);
         l_mand_fields_disp(l_mand_fields_disp.COUNT+1) := INITCAP(SUBSTR(REPLACE(g_fixed_cols(l_count),'_',' '),5));
      END IF;
   END LOOP;
   FOR cs_rec IN cs_ita(p_inv_type)
    LOOP
      IF cs_rec.ita_mandatory_yn = 'Y'
       THEN
         l_mandatory_fields(l_mandatory_fields.COUNT+1) := cs_rec.ita_attrib_name;
         l_mand_fields_disp(l_mand_fields_disp.COUNT+1) := cs_rec.ita_scrn_text;
      END IF;
   END LOOP;
--
   htp.p('</HEAD>');
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => p_module);
   htp.header(2,p_inv_type||' - '||l_rec_nit.nit_descr);
   htp.nl;
   htp.tableopen;
   htp.formopen(g_package_name||'.insert_data'
               ,CATTRIBUTES => 'name="inventory_data"'
               );
   htp.formhidden('IIT_INV_TYPE',p_inv_type);
   htp.formhidden('p_module',p_module);
   htp.formhidden('p_module_title',p_module_title);
--   htp.formhidden('IIT_END_DATE',Null);
--
   htp.tablerowopen;
   htp.tabledata(htf.hr,CCOLSPAN=>3);
   htp.tablerowclose;
--
   SELECT nsc_sub_class
         ,nsc_descr
    BULK  COLLECT
    INTO  l_tab_scl
         ,l_tab_scl_descr
    FROM  nm_type_subclass
   WHERE  nsc_nw_type = 'RSLD'
   ORDER BY nsc_seq_no;
--
   l_start_prefix := nm3flx.i_t_e (l_rec_nit.nit_pnt_or_cont = 'C'
                                  ,'Start '
                                  ,Null
                                  );
--
   DECLARE
      c_mand_local CONSTANT VARCHAR2(9) := nm3flx.i_t_e (nm3inv.inv_location_is_mandatory (l_rec_nit.nit_inv_type)
                                                        ,c_mand
                                                        ,nm3web.c_nbsp
                                                        );
   BEGIN
      htp.tablerowopen;
      htp.tableheader(htf.small(l_start_prefix||'Route Station'));
      htp.tabledata(c_mand_local);
      htp.tabledata(htf.formtext(cname      => 'START_ELEMENT'
                                ,CMAXLENGTH => 30
                                ,CSIZE      => 30
                                )
                   );
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader(htf.small(l_start_prefix||'Route Position'));
      htp.tabledata(c_mand_local);
      htp.tabledata(htf.formtext(cname=>'START_ELEMENT_MP'));
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader(htf.small(l_start_prefix||'Route Carriageway'));
      htp.tabledata(c_mand_local);
      htp.p('<TD>');
      htp.formselectopen(cname=>'START_ELEMENT_SUBCLASS');
      FOR i IN 1..l_tab_scl.COUNT
       LOOP
         htp.p('   <OPTION VALUE="'||l_tab_scl(i)||'">'||l_tab_scl(i)||' - '||l_tab_scl_descr(i)||'</OPTION>');
      END LOOP;
      htp.formselectclose;
      htp.p('</TD>');
      htp.tablerowclose;
      IF l_rec_nit.nit_pnt_or_cont = 'C'
       THEN
         htp.tablerowopen;
         htp.tableheader(htf.small('End Route Station'));
         htp.tabledata(c_mand_local);
         htp.tabledata(htf.formtext(cname      => 'END_ELEMENT'
                                   ,CMAXLENGTH => 30
                                   ,CSIZE      => 30
                                   )
                      );
         htp.tablerowclose;
         htp.tablerowopen;
         htp.tableheader(htf.small('End Route Position'));
         htp.tabledata(c_mand_local);
         htp.tabledata(htf.formtext(cname=>'END_ELEMENT_MP'));
         htp.tablerowclose;
         htp.tablerowopen;
         htp.tableheader(htf.small('End Route Carriageway'));
         htp.tabledata(c_mand_local);
         htp.p('<TD>');
         htp.formselectopen(cname=>'END_ELEMENT_SUBCLASS');
         FOR i IN 1..l_tab_scl.COUNT
          LOOP
            htp.p('   <OPTION VALUE="'||l_tab_scl(i)||'">'||l_tab_scl(i)||' - '||l_tab_scl_descr(i)||'</OPTION>');
         END LOOP;
         htp.formselectclose;
         htp.p('</TD>');
         htp.tablerowclose;
      ELSE
         htp.formhidden ('END_ELEMENT',Null);
         htp.formhidden ('END_ELEMENT_MP',Null);
         htp.formhidden ('END_ELEMENT_SUBCLASS',Null);
      END IF;
   END;
--
   htp.tablerowopen;
   htp.tabledata(htf.hr,CCOLSPAN=>3);
   htp.tablerowclose;
--
   FOR l_count IN 1..g_fixed_cols.COUNT
    LOOP
--
      htp.tablerowopen;
      htp.tableheader(htf.small(translate_some_screen_text(INITCAP(SUBSTR(REPLACE(g_fixed_cols(l_count),'_',' '),5)))));
      OPEN  cs_mand(g_fixed_cols(l_count));
      FETCH cs_mand INTO l_dummy;
      CLOSE cs_mand;
      IF l_dummy.nullable = 'Y'
       THEN
         l_mandatory := nm3web.c_nbsp;
      ELSE
         l_mandatory := c_mand;
      END IF;
      htp.tabledata(l_mandatory);
      htp.p('<TD>');
      IF g_fixed_cols(l_count) = 'IIT_START_DATE'
       THEN
         l_dummy.data_default := TO_CHAR(nm3user.get_effective_date,nm3user.get_user_date_mask);
      END IF;
      IF g_fixed_cols(l_count) = 'IIT_X_SECT'
       THEN
         IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
          THEN
            htp.formselectopen(cname      => g_fixed_cols(l_count));
            FOR cs_xsp IN (SELECT xsr_x_sect_value, xsr_descr
                            FROM  xsp_restraints
                           WHERE  xsr_ity_inv_code = p_inv_type
                           GROUP BY xsr_x_sect_value, xsr_descr
                          )
             LOOP
               htp.p('   <OPTION VALUE="'||cs_xsp.xsr_x_sect_value||'">'||NVL(cs_xsp.xsr_descr,cs_xsp.xsr_x_sect_value)||'</OPTION>');
            END LOOP;
            htp.formselectclose;
            xsp_allow := TRUE;
         ELSE
           htp.formhidden(g_fixed_cols(l_count),Null);
           htp.p('XSP Not Allowed');
         END IF;
      ELSIF g_fixed_cols(l_count) = 'IIT_DET_XSP'
       AND  NOT xsp_allow
       THEN
         Null;
--         htp.formhidden(g_fixed_cols(l_count),Null);
      ELSIF g_fixed_cols(l_count) = 'IIT_ADMIN_UNIT'
       THEN
--         FOR cs_au IN (SELECT nau_admin_unit
--                             ,nau_unit_code
--                             ,nau_name
--                             ,REPLACE(RPAD(' ',((nau_level-1)*3),' '),' ',nm3web.c_nbsp) level_indent
--                        FROM  nm_admin_units
--                       WHERE  nau_admin_type = l_rec_nit.nit_admin_type
--                       ORDER BY nau_level, nau_unit_code
--                       )
         DECLARE
            l_tab_depth nm3type.tab_number;
            l_tab_label nm3type.tab_varchar2000;
            l_tab_au    nm3type.tab_number;
         BEGIN
            SELECT 1 DEPTH
                  ,nau_unit_code||' - '||nau_name label
                  ,nau_admin_unit
            BULK   COLLECT
            INTO   l_tab_depth
                  ,l_tab_label
                  ,l_tab_au
            FROM   nm_admin_units
            WHERE  nau_admin_unit IN (SELECT nau_admin_unit
                                       FROM  nm_admin_units
                                      WHERE  nau_admin_type = l_rec_nit.nit_admin_type
                                       AND   nau_level = 1
                                      )
            UNION ALL
            SELECT l_level+1 DEPTH
                  ,nau_unit_code||' - '||nau_name label
                  ,nau_admin_unit
            FROM   nm_admin_units
                 ,(SELECT nag_child_admin_unit, LEVEL l_level
                    FROM (SELECT *
                           FROM  NM_ADMIN_GROUPS
                          WHERE  nag_direct_link = 'Y'
                         )
                   CONNECT BY PRIOR nag_child_admin_unit = nag_parent_admin_unit
                   START WITH nag_parent_admin_unit IN (SELECT nau_admin_unit
                                                         FROM  nm_admin_units
                                                        WHERE  nau_admin_type = l_rec_nit.nit_admin_type
                                                         AND   nau_level = 1
                                                       )
                   )
            WHERE nau_admin_unit = nag_child_admin_unit;
            IF l_tab_depth.COUNT = 1
             THEN
               htp.formhidden (g_fixed_cols(l_count),l_tab_au(1));
               htp.p(htf.small(l_tab_label(1)));
            ELSE
               htp.formselectopen(cname      => g_fixed_cols(l_count));
               FOR i IN 1..l_tab_depth.COUNT
                LOOP
                  htp.p('   <OPTION VALUE="'||l_tab_au(i)||'">'||REPLACE(RPAD(' ',((l_tab_depth(i)-1)*5),' '),' ',nm3web.c_nbsp)||l_tab_label(i)||'</OPTION>');
               END LOOP;
               htp.formselectclose;
            END IF;
         END;
      ELSE
         IF l_dummy.data_type = 'DATE'
          THEN
            l_dummy.data_length := 11;
         END IF;
         htp.formtext(cname      => g_fixed_cols(l_count)
                     ,CMAXLENGTH => l_dummy.data_length
                     ,CSIZE      => l_dummy.data_length
                     ,CVALUE     => l_dummy.data_default
                     );
      END IF;
      htp.p('</TD>');
      htp.tablerowclose;
--
   END LOOP;
--
   htp.tablerowopen;
   htp.tabledata(htf.hr,CCOLSPAN=>3);
   htp.tablerowclose;
--
   FOR cs_rec IN cs_ita(p_inv_type)
    LOOP
      htp.tablerowopen;
      htp.tableheader(htf.small(cs_rec.ita_scrn_text));
      IF cs_rec.ita_mandatory_yn = 'N'
       THEN
         l_mandatory := nm3web.c_nbsp;
      ELSE
         l_mandatory := c_mand;
      END IF;
      htp.tabledata(l_mandatory);
      htp.p('<TD>');
      OPEN  cs_mand(cs_rec.ita_attrib_name);
      FETCH cs_mand INTO l_dummy;
      CLOSE cs_mand;
      IF cs_rec.ita_attrib_name = 'IIT_FOREIGN_KEY'
       AND nm3invval.inv_type_is_child_type (p_inv_type)
       THEN
         htp.formselectopen(cname      => cs_rec.ita_attrib_name);
         FOR cs_par IN (SELECT /*+ INDEX (itg itg_nit_fk_ind) */
                               iit_primary_key
                              ,iit_inv_type
                         FROM  nm_inv_items
                              ,nm_inv_type_groupings
                        WHERE  itg_inv_type        = p_inv_type
                         AND   itg_parent_inv_type = iit_inv_type
                         AND   iit_primary_key     = NVL(p_iit_foreign_key,iit_primary_key)
                       )
          LOOP
            htp.p('   <OPTION VALUE="'||cs_par.iit_primary_key||'">'||cs_par.iit_inv_type||' - '||cs_par.iit_primary_key||'</OPTION>');
         END LOOP;
         htp.formselectclose;
      ELSIF cs_rec.ita_id_domain IS NULL
       THEN
         IF l_dummy.data_type = 'DATE'
          THEN
            cs_rec.ita_fld_length := 11;
         END IF;
         IF cs_rec.ita_fld_length >= 100
          THEN
            htp.formtextarea
               (cname      => cs_rec.ita_attrib_name
               ,nrows      => TRUNC((cs_rec.ita_fld_length/50)+.5)
               ,ncolumns   => 50
               );
         ELSE
            htp.formtext(cname      => cs_rec.ita_attrib_name
                        ,CMAXLENGTH => cs_rec.ita_fld_length
                        ,CSIZE      => cs_rec.ita_fld_length
                        );
         END IF;
      ELSE
--
         htp.formselectopen(cname      => cs_rec.ita_attrib_name);
         IF cs_rec.ita_mandatory_yn = 'N'
          THEN
            htp.formselectoption(Null);
         END IF;
         FOR cs_dom IN (SELECT ial_meaning,ial_value
                         FROM  nm_inv_attri_lookup
                        WHERE  ial_domain = cs_rec.ita_id_domain
                        ORDER BY ial_seq
                       )
          LOOP
            htp.p('   <OPTION VALUE="'||cs_dom.ial_value||'">'||cs_dom.ial_meaning||'</OPTION>');
         END LOOP;
         htp.formselectclose;
      END IF;
      htp.p('</TD>');
      htp.tablerowclose;
   END LOOP;
--
   htp.tablerowopen;
   htp.tabledata(htf.hr,CCOLSPAN=>3);
   htp.tablerowclose;
--
--
   htp.comment('Mandatory Fields - ');
   FOR l_count IN 1..l_mandatory_fields.COUNT
    LOOP
      htp.comment(l_mandatory_fields(l_count));
   END LOOP;
--
   htp.tablerowopen;
   htp.tabledata(cvalue      => htf.formsubmit(cvalue=>'Create '||l_rec_nit.nit_descr)
                ,cattributes => 'COLSPAN=3 ALIGN=CENTER'
                );
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.tabledata(htf.hr,CCOLSPAN=>3);
   htp.tablerowclose;
--
   htp.formclose;
   htp.tableclose;
   htp.bodyclose;
   htp.htmlclose;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END enter_data;
--
------------------------------------------------------------------------------
--
PROCEDURE insert_data
      (IIT_INV_TYPE                   IN VARCHAR2 DEFAULT Null
      ,IIT_PRIMARY_KEY                IN VARCHAR2 DEFAULT Null
      ,IIT_START_DATE                 IN VARCHAR2 DEFAULT TO_CHAR(nm3user.get_effective_date,'DD-MON-YYYY')
      ,IIT_DATE_CREATED               IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_MODIFIED              IN VARCHAR2 DEFAULT Null
      ,IIT_CREATED_BY                 IN VARCHAR2 DEFAULT Null
      ,IIT_MODIFIED_BY                IN VARCHAR2 DEFAULT Null
      ,IIT_ADMIN_UNIT                 IN VARCHAR2 DEFAULT Null
      ,IIT_DESCR                      IN VARCHAR2 DEFAULT Null
      ,IIT_END_DATE                   IN VARCHAR2 DEFAULT Null
      ,IIT_FOREIGN_KEY                IN VARCHAR2 DEFAULT Null
      ,IIT_LOCATED_BY                 IN NUMBER   DEFAULT Null
      ,IIT_POSITION                   IN NUMBER   DEFAULT Null
      ,IIT_X_COORD                    IN NUMBER   DEFAULT Null
      ,IIT_Y_COORD                    IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB16               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB17               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB18               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB19               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB20               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB21               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB22               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB23               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB24               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB25               IN NUMBER   DEFAULT Null
      ,IIT_CHR_ATTRIB26               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB27               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB28               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB29               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB30               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB31               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB32               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB33               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB34               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB35               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB36               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB37               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB38               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB39               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB40               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB41               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB42               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB43               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB44               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB45               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB46               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB47               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB48               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB49               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB50               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB51               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB52               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB53               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB54               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB55               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB56               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB57               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB58               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB59               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB60               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB61               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB62               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB63               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB64               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB65               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB66               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB67               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB68               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB69               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB70               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB71               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB72               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB73               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB74               IN VARCHAR2 DEFAULT Null
      ,IIT_CHR_ATTRIB75               IN VARCHAR2 DEFAULT Null
      ,IIT_NUM_ATTRIB76               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB77               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB78               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB79               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB80               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB81               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB82               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB83               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB84               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB85               IN NUMBER   DEFAULT Null
      ,IIT_DATE_ATTRIB86              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB87              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB88              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB89              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB90              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB91              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB92              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB93              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB94              IN VARCHAR2 DEFAULT Null
      ,IIT_DATE_ATTRIB95              IN VARCHAR2 DEFAULT Null
      ,IIT_ANGLE                      IN NUMBER   DEFAULT Null
      ,IIT_ANGLE_TXT                  IN VARCHAR2 DEFAULT Null
      ,IIT_CLASS                      IN VARCHAR2 DEFAULT Null
      ,IIT_CLASS_TXT                  IN VARCHAR2 DEFAULT Null
      ,IIT_COLOUR                     IN VARCHAR2 DEFAULT Null
      ,IIT_COLOUR_TXT                 IN VARCHAR2 DEFAULT Null
      ,IIT_COORD_FLAG                 IN VARCHAR2 DEFAULT Null
      ,IIT_DESCRIPTION                IN VARCHAR2 DEFAULT Null
      ,IIT_DIAGRAM                    IN VARCHAR2 DEFAULT Null
      ,IIT_DISTANCE                   IN NUMBER   DEFAULT Null
      ,IIT_END_CHAIN                  IN NUMBER   DEFAULT Null
      ,IIT_GAP                        IN NUMBER   DEFAULT Null
      ,IIT_HEIGHT                     IN NUMBER   DEFAULT Null
      ,IIT_HEIGHT_2                   IN NUMBER   DEFAULT Null
      ,IIT_ID_CODE                    IN VARCHAR2 DEFAULT Null
      ,IIT_INSTAL_DATE                IN VARCHAR2 DEFAULT Null
      ,IIT_INVENT_DATE                IN VARCHAR2 DEFAULT Null
      ,IIT_INV_OWNERSHIP              IN VARCHAR2 DEFAULT Null
      ,IIT_ITEMCODE                   IN VARCHAR2 DEFAULT Null
      ,IIT_LCO_LAMP_CONFIG_ID         IN NUMBER   DEFAULT Null
      ,IIT_LENGTH                     IN NUMBER   DEFAULT Null
      ,IIT_MATERIAL                   IN VARCHAR2 DEFAULT Null
      ,IIT_MATERIAL_TXT               IN VARCHAR2 DEFAULT Null
      ,IIT_METHOD                     IN VARCHAR2 DEFAULT Null
      ,IIT_METHOD_TXT                 IN VARCHAR2 DEFAULT Null
      ,IIT_NOTE                       IN VARCHAR2 DEFAULT Null
      ,IIT_NO_OF_UNITS                IN NUMBER   DEFAULT Null
      ,IIT_OPTIONS                    IN VARCHAR2 DEFAULT Null
      ,IIT_OPTIONS_TXT                IN VARCHAR2 DEFAULT Null
      ,IIT_OUN_ORG_ID_ELEC_BOARD      IN NUMBER   DEFAULT Null
      ,IIT_OWNER                      IN VARCHAR2 DEFAULT Null
      ,IIT_OWNER_TXT                  IN VARCHAR2 DEFAULT Null
      ,IIT_PEO_INVENT_BY_ID           IN NUMBER   DEFAULT Null
      ,IIT_PHOTO                      IN VARCHAR2 DEFAULT Null
      ,IIT_POWER                      IN NUMBER   DEFAULT Null
      ,IIT_PROV_FLAG                  IN VARCHAR2 DEFAULT Null
      ,IIT_REV_BY                     IN VARCHAR2 DEFAULT Null
      ,IIT_REV_DATE                   IN VARCHAR2 DEFAULT Null
      ,IIT_TYPE                       IN VARCHAR2 DEFAULT Null
      ,IIT_TYPE_TXT                   IN VARCHAR2 DEFAULT Null
      ,IIT_WIDTH                      IN NUMBER   DEFAULT Null
      ,IIT_XTRA_CHAR_1                IN VARCHAR2 DEFAULT Null
      ,IIT_XTRA_DATE_1                IN VARCHAR2 DEFAULT Null
      ,IIT_XTRA_DOMAIN_1              IN VARCHAR2 DEFAULT Null
      ,IIT_XTRA_DOMAIN_TXT_1          IN VARCHAR2 DEFAULT Null
      ,IIT_XTRA_NUMBER_1              IN NUMBER   DEFAULT Null
      ,IIT_X_SECT                     IN VARCHAR2 DEFAULT Null
      ,IIT_DET_XSP                    IN VARCHAR2 DEFAULT Null
      ,IIT_OFFSET                     IN NUMBER   DEFAULT Null
      ,IIT_X                          IN NUMBER   DEFAULT Null
      ,IIT_Y                          IN NUMBER   DEFAULT Null
      ,IIT_Z                          IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB96               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB97               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB98               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB99               IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB100              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB101              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB102              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB103              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB104              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB105              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB106              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB107              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB108              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB109              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB110              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB111              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB112              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB113              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB114              IN NUMBER   DEFAULT Null
      ,IIT_NUM_ATTRIB115              IN NUMBER   DEFAULT Null
      ,START_ELEMENT                  IN VARCHAR2
      ,START_ELEMENT_MP               IN NUMBER
      ,START_ELEMENT_SUBCLASS         IN VARCHAR2
      ,END_ELEMENT                    IN VARCHAR2
      ,END_ELEMENT_MP                 IN NUMBER
      ,END_ELEMENT_SUBCLASS           IN VARCHAR2
      ,p_module                       IN VARCHAR2 DEFAULT NULL
      ,p_module_title                 IN VARCHAR2 DEFAULT NULL
--
      ) IS
--
   l_rec_iit nm_inv_items%ROWTYPE;
   l_rec_nit nm_inv_types%ROWTYPE;
   c_init_eff_date CONSTANT DATE := nm3user.get_effective_date;
--
   l_start_ne_id NUMBER;
   l_start_mp    NUMBER;
   l_end_ne_id   NUMBER;
   l_end_mp      NUMBER;
   l_nte_job_id  NUMBER;
--
   l_locate_it   BOOLEAN := TRUE;
--
   PROCEDURE get_datum_lref (p_ne_unique    IN     VARCHAR2
                            ,p_mp           IN     NUMBER
                            ,p_subclass     IN     VARCHAR2
                            ,p_datum_ne_id     OUT NUMBER
                            ,p_datum_offset    OUT NUMBER
                            ) IS
      l_ne_id NUMBER;
   BEGIN
      l_ne_id := nm3net.get_ne_id (p_ne_unique);
      DECLARE
         l_ambig EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_ambig, -20002);
         l_lref  nm_lref;
         l_lref_table nm3lrs.lref_table;
      BEGIN
         l_lref         := nm3lrs.get_datum_offset( p_parent_lr => nm_lref (l_ne_id, p_mp));
         p_datum_ne_id  := l_lref.lr_ne_id;
         p_datum_offset := l_lref.lr_offset;
      EXCEPTION
         WHEN l_ambig
          THEN
            nm3lrs.get_ambiguous_lrefs
                                (p_parent_id    => l_ne_id
                                ,p_parent_units => 2
                                ,p_datum_units  => 1
                                ,p_offset       => p_mp
                                ,p_lrefs        => l_lref_table
                                ,p_sub_class    => p_subclass
                                );
--            IF l_lref_table.COUNT > 1
--             THEN
--               hig.raise_ner (pi_appl => nm3type.c_net
--                             ,pi_id   => 312
--                             ,pi_supplementary_info => l_lref_table.COUNT
--                             );
--            END IF;
            p_datum_ne_id  := l_lref_table(1).r_ne_id;
            p_datum_offset := l_lref_table(1).r_offset;
      END;
   END get_datum_lref;
--
   FUNCTION check_char (p_char_in VARCHAR2) RETURN VARCHAR2 IS
      l_retval nm3type.max_varchar2 := p_char_in;
   BEGIN
      IF l_retval != UPPER(l_retval)
       THEN
         l_retval          := UPPER(l_retval);
      END IF;
      l_retval             := REPLACE (l_retval,CHR(10),' ');
      l_retval             := REPLACE (l_retval,CHR(13),Null);
      l_retval             := RTRIM(l_retval,' ');
      RETURN l_retval;
   END check_char;
--
BEGIN
   SAVEPOINT top_of_insert;
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => p_module);
   l_rec_iit.iit_start_date := harsh_date_check(iit_start_date);
   nm3user.set_effective_date (l_rec_iit.iit_start_date);
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => iit_inv_type);
--
   IF  start_element          IS NULL
    OR start_element_mp       IS NULL
    OR start_element_subclass IS NULL
    OR (l_rec_nit.nit_pnt_or_cont = 'C'
        AND (end_element          IS NULL
          OR end_element_mp       IS NULL
          OR end_element_subclass IS NULL
            )
       )
    THEN
      IF nm3inv.inv_location_is_mandatory (l_rec_nit.nit_inv_type)
       THEN
         hig.raise_ner (pi_appl => nm3type.c_net
                       ,pi_id   => 50
                       );
      ELSE
         l_locate_it := FALSE;
      END IF;
   END IF;
--
   IF l_locate_it
    THEN
      get_datum_lref (p_ne_unique    => start_element
                     ,p_mp           => start_element_mp
                     ,p_subclass     => start_element_subclass
                     ,p_datum_ne_id  => l_start_ne_id
                     ,p_datum_offset => l_start_mp
                     );
   --
      IF l_rec_nit.nit_pnt_or_cont = 'C'
       THEN
         get_datum_lref (p_ne_unique    => end_element
                        ,p_mp           => end_element_mp
                        ,p_subclass     => end_element_subclass
                        ,p_datum_ne_id  => l_end_ne_id
                        ,p_datum_offset => l_end_mp
                        );
         -- Now work out if we can find these 2 on the same linear route!
         DECLARE
            CURSOR cs_mem IS
            SELECT st.nm_ne_id_in
             FROM  nm_members st
                  ,nm_group_types
            WHERE  st.nm_ne_id_of  = l_start_ne_id
             AND   l_start_mp BETWEEN st.nm_begin_mp AND st.nm_end_mp
             AND   ngt_group_type  = st.nm_obj_type
             AND   ngt_linear_flag = 'Y'
             AND   st.nm_type      = 'G'
             AND   EXISTS (SELECT 1
                            FROM  nm_members en
                           WHERE  en.nm_ne_id_in = st.nm_ne_id_in
                            AND   en.nm_ne_id_of = l_end_ne_id
                            AND   l_end_mp BETWEEN en.nm_begin_mp AND en.nm_end_mp
                            AND   en.nm_seq_no   > st.nm_seq_no
                          )
            GROUP BY st.nm_ne_id_in;
            l_tab_groups nm3type.tab_number;
         BEGIN
            IF l_start_ne_id = l_end_ne_id
             THEN -- Same datum
               IF l_start_mp > l_end_mp
                THEN
                  hig.raise_ner(c_tnz_product,6);
               END IF;
               nm3extent.create_temp_ne (pi_source_id => l_start_ne_id
                                        ,pi_source    => nm3extent.c_route
                                        ,pi_begin_mp  => l_start_mp
                                        ,pi_end_mp    => l_end_mp
                                        ,po_job_id    => l_nte_job_id
                                        );
            ELSE
               OPEN  cs_mem;
               FETCH cs_mem
                BULK COLLECT
                INTO l_tab_groups;
               CLOSE cs_mem;
               IF l_tab_groups.COUNT = 0
                THEN
                  hig.raise_ner(c_tnz_product,6);
               ELSIF l_tab_groups.COUNT > 1
                THEN
                  hig.raise_ner(c_tnz_product,7);
               END IF;
               nm3wrap.create_temp_ne_from_route (pi_route                   => l_tab_groups(1)
                                                 ,pi_start_ne_id             => l_start_ne_id
                                                 ,pi_start_offset            => l_start_mp
                                                 ,pi_end_ne_id               => l_end_ne_id
                                                 ,pi_end_offset              => l_end_mp
                                                 ,pi_sub_class               => nm3flx.i_t_e (start_element_subclass = 'S'
                                                                                             ,'I'
                                                                                             ,start_element_subclass
                                                                                             )
                                                 ,pi_restrict_excl_sub_class => nm3flx.i_t_e (start_element_subclass = 'D'
                                                                                             ,'Y'
                                                                                             ,'N'
                                                                                             )
                                                 ,pi_homo_check              => TRUE
                                                 ,po_job_id                  => l_nte_job_id
                                                 );
            END IF;
         END;
      ELSE
         l_nte_job_id := nm3seq.next_nte_id_seq;
         DECLARE
            l_rec_nte nm_nw_temp_extents%ROWTYPE;
         BEGIN
            l_rec_nte.nte_job_id      := l_nte_job_id;
            l_rec_nte.nte_ne_id_of    := l_start_ne_id;
            l_rec_nte.nte_begin_mp    := l_start_mp;
            l_rec_nte.nte_end_mp      := l_start_mp;
            l_rec_nte.nte_cardinality := 1;
            l_rec_nte.nte_seq_no      := 1;
            l_rec_nte.nte_route_ne_id := -1;
            nm3extent.ins_nte (l_rec_nte);
         END;
      END IF;
   END IF;
--
   l_rec_iit.iit_ne_id                 := nm3seq.next_ne_id_seq;
   l_rec_iit.iit_inv_type              := iit_inv_type;
   l_rec_iit.iit_primary_key           := iit_primary_key;
   l_rec_iit.iit_start_date            := harsh_date_check(iit_start_date);
   l_rec_iit.iit_admin_unit            := (iit_admin_unit);
   l_rec_iit.iit_descr                 := (iit_descr);
   l_rec_iit.iit_end_date              := harsh_date_check(iit_end_date);
   l_rec_iit.iit_foreign_key           := (iit_foreign_key);
   l_rec_iit.iit_located_by            := (iit_located_by);
   l_rec_iit.iit_position              := (iit_position);
   l_rec_iit.iit_x_coord               := (iit_x_coord);
   l_rec_iit.iit_y_coord               := (iit_y_coord);
   l_rec_iit.iit_num_attrib16          := (iit_num_attrib16);
   l_rec_iit.iit_num_attrib17          := (iit_num_attrib17);
   l_rec_iit.iit_num_attrib18          := (iit_num_attrib18);
   l_rec_iit.iit_num_attrib19          := (iit_num_attrib19);
   l_rec_iit.iit_num_attrib20          := (iit_num_attrib20);
   l_rec_iit.iit_num_attrib21          := (iit_num_attrib21);
   l_rec_iit.iit_num_attrib22          := (iit_num_attrib22);
   l_rec_iit.iit_num_attrib23          := (iit_num_attrib23);
   l_rec_iit.iit_num_attrib24          := (iit_num_attrib24);
   l_rec_iit.iit_num_attrib25          := (iit_num_attrib25);
   l_rec_iit.iit_chr_attrib26          := check_char(iit_chr_attrib26);
   l_rec_iit.iit_chr_attrib27          := check_char(iit_chr_attrib27);
   l_rec_iit.iit_chr_attrib28          := check_char(iit_chr_attrib28);
   l_rec_iit.iit_chr_attrib29          := check_char(iit_chr_attrib29);
   l_rec_iit.iit_chr_attrib30          := check_char(iit_chr_attrib30);
   l_rec_iit.iit_chr_attrib31          := check_char(iit_chr_attrib31);
   l_rec_iit.iit_chr_attrib32          := check_char(iit_chr_attrib32);
   l_rec_iit.iit_chr_attrib33          := check_char(iit_chr_attrib33);
   l_rec_iit.iit_chr_attrib34          := check_char(iit_chr_attrib34);
   l_rec_iit.iit_chr_attrib35          := check_char(iit_chr_attrib35);
   l_rec_iit.iit_chr_attrib36          := check_char(iit_chr_attrib36);
   l_rec_iit.iit_chr_attrib37          := check_char(iit_chr_attrib37);
   l_rec_iit.iit_chr_attrib38          := check_char(iit_chr_attrib38);
   l_rec_iit.iit_chr_attrib39          := check_char(iit_chr_attrib39);
   l_rec_iit.iit_chr_attrib40          := check_char(iit_chr_attrib40);
   l_rec_iit.iit_chr_attrib41          := check_char(iit_chr_attrib41);
   l_rec_iit.iit_chr_attrib42          := check_char(iit_chr_attrib42);
   l_rec_iit.iit_chr_attrib43          := check_char(iit_chr_attrib43);
   l_rec_iit.iit_chr_attrib44          := check_char(iit_chr_attrib44);
   l_rec_iit.iit_chr_attrib45          := check_char(iit_chr_attrib45);
   l_rec_iit.iit_chr_attrib46          := check_char(iit_chr_attrib46);
   l_rec_iit.iit_chr_attrib47          := check_char(iit_chr_attrib47);
   l_rec_iit.iit_chr_attrib48          := check_char(iit_chr_attrib48);
   l_rec_iit.iit_chr_attrib49          := check_char(iit_chr_attrib49);
   l_rec_iit.iit_chr_attrib50          := check_char(iit_chr_attrib50);
   l_rec_iit.iit_chr_attrib51          := check_char(iit_chr_attrib51);
   l_rec_iit.iit_chr_attrib52          := check_char(iit_chr_attrib52);
   l_rec_iit.iit_chr_attrib53          := check_char(iit_chr_attrib53);
   l_rec_iit.iit_chr_attrib54          := check_char(iit_chr_attrib54);
   l_rec_iit.iit_chr_attrib55          := check_char(iit_chr_attrib55);
   l_rec_iit.iit_chr_attrib56          := check_char(iit_chr_attrib56);
   l_rec_iit.iit_chr_attrib57          := check_char(iit_chr_attrib57);
   l_rec_iit.iit_chr_attrib58          := check_char(iit_chr_attrib58);
   l_rec_iit.iit_chr_attrib59          := check_char(iit_chr_attrib59);
   l_rec_iit.iit_chr_attrib60          := check_char(iit_chr_attrib60);
   l_rec_iit.iit_chr_attrib61          := check_char(iit_chr_attrib61);
   l_rec_iit.iit_chr_attrib62          := check_char(iit_chr_attrib62);
   l_rec_iit.iit_chr_attrib63          := check_char(iit_chr_attrib63);
   l_rec_iit.iit_chr_attrib64          := check_char(iit_chr_attrib64);
   l_rec_iit.iit_chr_attrib65          := check_char(iit_chr_attrib65);
   l_rec_iit.iit_chr_attrib66          := check_char(iit_chr_attrib66);
   l_rec_iit.iit_chr_attrib67          := check_char(iit_chr_attrib67);
   l_rec_iit.iit_chr_attrib68          := check_char(iit_chr_attrib68);
   l_rec_iit.iit_chr_attrib69          := check_char(iit_chr_attrib69);
   l_rec_iit.iit_chr_attrib70          := check_char(iit_chr_attrib70);
   l_rec_iit.iit_chr_attrib71          := check_char(iit_chr_attrib71);
   l_rec_iit.iit_chr_attrib72          := check_char(iit_chr_attrib72);
   l_rec_iit.iit_chr_attrib73          := check_char(iit_chr_attrib73);
   l_rec_iit.iit_chr_attrib74          := check_char(iit_chr_attrib74);
   l_rec_iit.iit_chr_attrib75          := check_char(iit_chr_attrib75);
   l_rec_iit.iit_num_attrib76          := (iit_num_attrib76);
   l_rec_iit.iit_num_attrib77          := (iit_num_attrib77);
   l_rec_iit.iit_num_attrib78          := (iit_num_attrib78);
   l_rec_iit.iit_num_attrib79          := (iit_num_attrib79);
   l_rec_iit.iit_num_attrib80          := (iit_num_attrib80);
   l_rec_iit.iit_num_attrib81          := (iit_num_attrib81);
   l_rec_iit.iit_num_attrib82          := (iit_num_attrib82);
   l_rec_iit.iit_num_attrib83          := (iit_num_attrib83);
   l_rec_iit.iit_num_attrib84          := (iit_num_attrib84);
   l_rec_iit.iit_num_attrib85          := (iit_num_attrib85);
   l_rec_iit.iit_date_attrib86         := harsh_date_check(iit_date_attrib86);
   l_rec_iit.iit_date_attrib87         := harsh_date_check(iit_date_attrib87);
   l_rec_iit.iit_date_attrib88         := harsh_date_check(iit_date_attrib88);
   l_rec_iit.iit_date_attrib89         := harsh_date_check(iit_date_attrib89);
   l_rec_iit.iit_date_attrib90         := harsh_date_check(iit_date_attrib90);
   l_rec_iit.iit_date_attrib91         := harsh_date_check(iit_date_attrib91);
   l_rec_iit.iit_date_attrib92         := harsh_date_check(iit_date_attrib92);
   l_rec_iit.iit_date_attrib93         := harsh_date_check(iit_date_attrib93);
   l_rec_iit.iit_date_attrib94         := harsh_date_check(iit_date_attrib94);
   l_rec_iit.iit_date_attrib95         := harsh_date_check(iit_date_attrib95);
   l_rec_iit.iit_angle                 := (iit_angle);
   l_rec_iit.iit_angle_txt             := check_char(iit_angle_txt);
   l_rec_iit.iit_class                 := check_char(iit_class);
   l_rec_iit.iit_class_txt             := check_char(iit_class_txt);
   l_rec_iit.iit_colour                := check_char(iit_colour);
   l_rec_iit.iit_colour_txt            := check_char(iit_colour_txt);
   l_rec_iit.iit_coord_flag            := check_char(iit_coord_flag);
   l_rec_iit.iit_description           := check_char(iit_description);
   l_rec_iit.iit_diagram               := check_char(iit_diagram);
   l_rec_iit.iit_distance              := (iit_distance);
   l_rec_iit.iit_end_chain             := (iit_end_chain);
   l_rec_iit.iit_gap                   := (iit_gap);
   l_rec_iit.iit_height                := (iit_height);
   l_rec_iit.iit_height_2              := (iit_height_2);
   l_rec_iit.iit_id_code               := check_char(iit_id_code);
   l_rec_iit.iit_instal_date           := harsh_date_check(iit_instal_date);
   l_rec_iit.iit_invent_date           := harsh_date_check(iit_invent_date);
   l_rec_iit.iit_inv_ownership         := check_char(iit_inv_ownership);
   l_rec_iit.iit_itemcode              := check_char(iit_itemcode);
   l_rec_iit.iit_lco_lamp_config_id    := (iit_lco_lamp_config_id);
   l_rec_iit.iit_length                := (iit_length);
   l_rec_iit.iit_material              := check_char(iit_material);
   l_rec_iit.iit_material_txt          := check_char(iit_material_txt);
   l_rec_iit.iit_method                := check_char(iit_method);
   l_rec_iit.iit_method_txt            := check_char(iit_method_txt);
   l_rec_iit.iit_note                  := (iit_note);
   l_rec_iit.iit_no_of_units           := (iit_no_of_units);
   l_rec_iit.iit_options               := check_char(iit_options);
   l_rec_iit.iit_options_txt           := check_char(iit_options_txt);
   l_rec_iit.iit_oun_org_id_elec_board := (iit_oun_org_id_elec_board);
   l_rec_iit.iit_owner                 := check_char(iit_owner);
   l_rec_iit.iit_owner_txt             := check_char(iit_owner_txt);
   l_rec_iit.iit_peo_invent_by_id      := (iit_peo_invent_by_id);
   l_rec_iit.iit_photo                 := check_char(iit_photo);
   l_rec_iit.iit_power                 := (iit_power);
   l_rec_iit.iit_prov_flag             := check_char(iit_prov_flag);
   l_rec_iit.iit_rev_by                := check_char(iit_rev_by);
   l_rec_iit.iit_rev_date              := harsh_date_check(iit_rev_date);
   l_rec_iit.iit_type                  := check_char(iit_type);
   l_rec_iit.iit_type_txt              := check_char(iit_type_txt);
   l_rec_iit.iit_width                 := (iit_width);
   l_rec_iit.iit_xtra_char_1           := check_char(iit_xtra_char_1);
   l_rec_iit.iit_xtra_date_1           := harsh_date_check(iit_xtra_date_1);
   l_rec_iit.iit_xtra_domain_1         := check_char(iit_xtra_domain_1);
   l_rec_iit.iit_xtra_domain_txt_1     := check_char(iit_xtra_domain_txt_1);
   l_rec_iit.iit_xtra_number_1         := (iit_xtra_number_1);
   l_rec_iit.iit_x_sect                := check_char(iit_x_sect);
   l_rec_iit.iit_det_xsp               := check_char(iit_det_xsp);
   l_rec_iit.iit_offset                := (iit_offset);
   l_rec_iit.iit_x                     := (iit_x);
   l_rec_iit.iit_y                     := (iit_y);
   l_rec_iit.iit_z                     := (iit_z);
   l_rec_iit.iit_num_attrib96          := (iit_num_attrib96);
   l_rec_iit.iit_num_attrib97          := (iit_num_attrib97);
   l_rec_iit.iit_num_attrib98          := (iit_num_attrib98);
   l_rec_iit.iit_num_attrib99          := (iit_num_attrib99);
   l_rec_iit.iit_num_attrib100         := (iit_num_attrib100);
   l_rec_iit.iit_num_attrib101         := (iit_num_attrib101);
   l_rec_iit.iit_num_attrib102         := (iit_num_attrib102);
   l_rec_iit.iit_num_attrib103         := (iit_num_attrib103);
   l_rec_iit.iit_num_attrib104         := (iit_num_attrib104);
   l_rec_iit.iit_num_attrib105         := (iit_num_attrib105);
   l_rec_iit.iit_num_attrib106         := (iit_num_attrib106);
   l_rec_iit.iit_num_attrib107         := (iit_num_attrib107);
   l_rec_iit.iit_num_attrib108         := (iit_num_attrib108);
   l_rec_iit.iit_num_attrib109         := (iit_num_attrib109);
   l_rec_iit.iit_num_attrib110         := (iit_num_attrib110);
   l_rec_iit.iit_num_attrib111         := (iit_num_attrib111);
   l_rec_iit.iit_num_attrib112         := (iit_num_attrib112);
   l_rec_iit.iit_num_attrib113         := (iit_num_attrib113);
   l_rec_iit.iit_num_attrib114         := (iit_num_attrib114);
   l_rec_iit.iit_num_attrib115         := (iit_num_attrib115);
--
   nm3ins.ins_iit (l_rec_iit);
--
   IF l_locate_it
    THEN
      nm3homo.homo_update (l_nte_job_id
                          ,l_rec_iit.iit_ne_id
                          ,l_rec_iit.iit_start_date
                          );
   END IF;
   nm3user.set_effective_date (c_init_eff_date);
--
   htp.bodyclose;
   htp.htmlclose;
   commit;
   xtnz_lar_mail_merge.show_single_inv_item_details (pi_iit_ne_id => l_rec_iit.iit_ne_id);
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here
   THEN
     nm3user.set_effective_date (c_init_eff_date);
  WHEN OTHERS
   THEN
     DECLARE
        c_sqlerrm CONSTANT nm3type.max_varchar2 := SQLERRM;
     BEGIN
        ROLLBACK TO top_of_insert;
        nm3user.set_effective_date (c_init_eff_date);
        nm3web.failure(c_SQLERRM);
     END;
END insert_data;
--
------------------------------------------------------------------------------
--
FUNCTION harsh_date_check (p_char_date VARCHAR2) RETURN DATE IS
   l_date DATE;
BEGIN
   IF p_char_date IS NOT NULL
    THEN
      l_date := hig.date_convert (p_char_date);
      IF l_date IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 148
                       ,pi_supplementary_info => p_char_date
                       );
      END IF;
   END IF;
   RETURN l_date;
END harsh_date_check;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_la IS
BEGIN
   enter_data (p_inv_type     => 'LA'
              ,p_module       => c_la_this_module
              ,p_module_title => c_la_module_title
              );
END create_la;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_cp IS
BEGIN
   enter_data (p_inv_type     => 'CP'
              ,p_module       => c_cp_this_module
              ,p_module_title => c_cp_module_title
              );
END create_cp;
--
------------------------------------------------------------------------------
--
PROCEDURE translate_some_screen_text (p_ita_scrn_text IN OUT VARCHAR2) IS
BEGIN
   IF p_ita_scrn_text = 'Admin Unit'
    THEN
      p_ita_scrn_text := 'Regional Office';
   END IF;
END translate_some_screen_text;
--
------------------------------------------------------------------------------
--
FUNCTION  translate_some_screen_text (p_ita_scrn_text IN VARCHAR2) RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2 := p_ita_scrn_text;
BEGIN
   translate_some_screen_text (l_retval);
   RETURN l_retval;
END translate_some_screen_text;
--
------------------------------------------------------------------------------
--
END xtnz_lar_create_inv;
/
