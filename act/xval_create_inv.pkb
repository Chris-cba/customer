CREATE OR REPLACE PACKAGE BODY xval_create_inv IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_create_inv.pkb	1.1 03/14/05
--       Module Name      : xval_create_inv.pkb
--       Date into SCCS   : 05/03/14 23:11:26
--       Date fetched Out : 07/06/06 14:33:55
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   valuations asset creation package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xval_create_inv.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30) := 'xval_create_inv';
--
   c_this_module     CONSTANT  hig_modules.hmo_module%TYPE   := 'XVALWEB0510';
   c_module_title    CONSTANT  hig_modules.hmo_title%TYPE    := hig.get_module_title(c_this_module);
--
   c_continue     CONSTANT nm_errors.ner_descr%TYPE    := hig.get_ner(nm3type.c_hig,165).ner_descr;
   c_equals       CONSTANT VARCHAR2(5) := CHR(38)||'#61;';
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
   htp.comment('--       sccsid           : @(#)xval_create_inv.pkb	1.1 03/14/05');
   htp.comment('--       Module Name      : xval_create_inv.pkb');
   htp.comment('--       Date into SCCS   : 05/03/14 23:11:26');
   htp.comment('--       Date fetched Out : 07/06/06 14:33:55');
   htp.comment('--       SCCS Version     : 1.1');
   htp.comment('--');
   htp.comment('--');
   htp.comment('--   Author : Jonathan Mills');
   htp.comment('--');
   htp.comment('-----------------------------------------------------------------------------');
   htp.comment('--	Copyright (c) exor corporation ltd, 2004');
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
   htp.tableheader (/*htf.small*/('Select Asset Type'));
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
PROCEDURE enter_data (p_inv_type           IN VARCHAR2
                     ,p_module             IN VARCHAR2 DEFAULT NULL
                     ,p_module_title       IN VARCHAR2 DEFAULT NULL
                     ,p_iit_foreign_key    IN VARCHAR2 DEFAULT NULL
                     ,p_parent_ngqi_job_id IN NUMBER   DEFAULT NULL
                     ) IS
--
   l_rec_nit nm_inv_types%ROWTYPE;
--
   l_mandatory VARCHAR2(30);
   c_mand CONSTANT VARCHAR2(30) := '<SUP>*</SUP>';
--
   g_fixed_cols nm3type.tab_varchar32767;
--
   l_owner CONSTANT VARCHAR2(30) := nm3context.get_context(pi_attribute=>'APPLICATION_OWNER');
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
   l_mandatory_fields nm3type.tab_varchar32767;
   l_mand_fields_disp nm3type.tab_varchar32767;
   l_tab_scl          nm3type.tab_varchar4;
   l_tab_scl_descr    nm3type.tab_varchar80;
   l_start_prefix     VARCHAR2(30);
--
   l_iit_fk_is_ita    BOOLEAN := FALSE;
--
BEGIN
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
--
   sccs_tags;
--
   htp.bodyopen;
   l_rec_nit := nm3inv.get_inv_type(p_inv_type);
--
   IF NVL(nm3inv.get_inv_mode_by_role (pi_inv_type => l_rec_nit.nit_inv_type
                                      ,pi_username => USER
                                      )
         ,nm3type.c_readonly
         ) != nm3type.c_normal
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => 'Create '||l_rec_nit.nit_descr
                    );
   END IF;
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_PRIMARY_KEY';
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_START_DATE';
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_ADMIN_UNIT';
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_DESCR';
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_NOTE';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_LOCATED_BY';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_POSITION';
   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_END_DATE';
   IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
    THEN
      g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_X_SECT';
   END IF;
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_DET_XSP';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_OFFSET';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_X';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_Y';
--   g_fixed_cols(g_fixed_cols.COUNT+1) := 'IIT_Z';
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
   nm3web.module_startup(pi_module => p_module);
   htp.header(2,l_rec_nit.nit_descr);
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
--
--   htp.tablerowopen;
--   htp.tableheader(/*htf.small*/('Route'));
--   htp.tabledata(c_mand);
--   htp.p('<TD>');
--   htp.formselectopen(cname=>'ROUTE_NE_ID');
--   htp.p('   <OPTION VALUE="-1">Unlocated</OPTION>');
--   htp.formselectclose;
--   htp.p('</TD>');
--   htp.tablerowclose;
--   IF l_rec_nit.nit_pnt_or_cont = 'C'
--    THEN
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/('SLK From'));
--      htp.tabledata(c_mand);
--      htp.tabledata(htf.formtext(cname=>'SLK_FROM'));
--      htp.tablerowclose;
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/('SLK To'));
--      htp.tabledata(c_mand);
--      htp.tabledata(htf.formtext(cname=>'SLK_TO'));
--      htp.tablerowclose;
--   ELSE
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/('SLK'));
--      htp.tabledata(c_mand);
--      htp.tabledata(htf.formtext(cname=>'SLK_FROM'));
--      htp.tablerowclose;
--      htp.formhidden (cname  => 'SLK_TO'
--                     ,cvalue => Null
--                     );
--   END IF;
--
--   SELECT nsc_sub_class
--         ,nsc_descr
--    BULK  COLLECT
--    INTO  l_tab_scl
--         ,l_tab_scl_descr
--    FROM  nm_type_subclass
--   WHERE  nsc_nw_type = 'RSLD'
--   ORDER BY nsc_seq_no;
--
--   l_start_prefix := nm3flx.i_t_e (l_rec_nit.nit_pnt_or_cont = 'C'
--                                  ,'Start '
--                                  ,Null
--                                  );
----
--   DECLARE
--      c_mand_local CONSTANT VARCHAR2(9) := nm3flx.i_t_e (nm3inv.inv_location_is_mandatory (l_rec_nit.nit_inv_type)
--                                                        ,c_mand
--                                                        ,nm3web.c_nbsp
--                                                        );
--   BEGIN
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/(l_start_prefix||'Element'));
--      htp.tabledata(c_mand_local);
--      htp.tabledata(htf.formtext(cname      => 'START_ELEMENT'
--                                ,CMAXLENGTH => 30
--                                ,CSIZE      => 30
--                                )
--                   );
--      htp.tablerowclose;
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/(l_start_prefix||'Element MP'));
--      htp.tabledata(c_mand_local);
--      htp.tabledata(htf.formtext(cname=>'START_ELEMENT_MP'));
--      htp.tablerowclose;
--      htp.tablerowopen;
--      htp.tableheader(/*htf.small*/(l_start_prefix||'Element Carriageway'));
--      htp.tabledata(c_mand_local);
--      htp.p('<TD>');
--      htp.formselectopen(cname=>'START_ELEMENT_SUBCLASS');
--      FOR i IN 1..l_tab_scl.COUNT
--       LOOP
--         htp.p('   <OPTION VALUE="'||l_tab_scl(i)||'">'||l_tab_scl(i)||' - '||l_tab_scl_descr(i)||'</OPTION>');
--      END LOOP;
--      htp.formselectclose;
--      htp.p('</TD>');
--      htp.tablerowclose;
--      IF l_rec_nit.nit_pnt_or_cont = 'C'
--       THEN
--         htp.tablerowopen;
--         htp.tableheader(/*htf.small*/('End Element'));
--         htp.tabledata(c_mand_local);
--         htp.tabledata(htf.formtext(cname      => 'END_ELEMENT'
--                                   ,CMAXLENGTH => 30
--                                   ,CSIZE      => 30
--                                   )
--                      );
--         htp.tablerowclose;
--         htp.tablerowopen;
--         htp.tableheader(/*htf.small*/('End Element MP'));
--         htp.tabledata(c_mand_local);
--         htp.tabledata(htf.formtext(cname=>'END_ELEMENT_MP'));
--         htp.tablerowclose;
--         htp.tablerowopen;
--         htp.tableheader(/*htf.small*/('End Element Carriageway'));
--         htp.tabledata(c_mand_local);
--         htp.p('<TD>');
--         htp.formselectopen(cname=>'END_ELEMENT_SUBCLASS');
--         FOR i IN 1..l_tab_scl.COUNT
--          LOOP
--            htp.p('   <OPTION VALUE="'||l_tab_scl(i)||'">'||l_tab_scl(i)||' - '||l_tab_scl_descr(i)||'</OPTION>');
--         END LOOP;
--         htp.formselectclose;
--         htp.p('</TD>');
--         htp.tablerowclose;
--      ELSE
--         htp.formhidden ('START_ELEMENT',Null);
--         htp.formhidden ('START_ELEMENT_MP',Null);
--         htp.formhidden ('START_ELEMENT_SUBCLASS',Null);
--         htp.formhidden ('END_ELEMENT',Null);
--         htp.formhidden ('END_ELEMENT_MP',Null);
--         htp.formhidden ('END_ELEMENT_SUBCLASS',Null);
--      END IF;
--   END;
--
--   htp.tablerowopen;
--   htp.tabledata(htf.hr,CCOLSPAN=>3);
--   htp.tablerowclose;
----
   FOR l_count IN 1..g_fixed_cols.COUNT
    LOOP
--
      htp.tablerowopen;
      htp.tableheader(/*htf.small*/(INITCAP(SUBSTR(REPLACE(g_fixed_cols(l_count),'_',' '),5))));
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
      ELSIF g_fixed_cols(l_count) = 'IIT_ADMIN_UNIT'
       THEN
         xval_find_inv.do_au_listbox (pi_admin_type       => l_rec_nit.nit_admin_type
                                     ,pi_parameter_name   => g_fixed_cols(l_count)
                                     ,pi_normal_mode_only => TRUE
                                     );
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
      htp.tableheader(/*htf.small*/(cs_rec.ita_scrn_text));
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
         l_iit_fk_is_ita := TRUE;
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
         IF l_dummy.data_type = nm3type.c_date
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
   IF   p_iit_foreign_key IS NOT NULL
    AND NOT l_iit_fk_is_ita
    THEN
      htp.formhidden ('IIT_FOREIGN_KEY',p_iit_foreign_key);
   END IF;
--
   IF p_parent_ngqi_job_id IS NOT NULL
    THEN
      htp.formhidden ('p_parent_ngqi_job_id',p_parent_ngqi_job_id);
   END IF;
--
   htp.comment('Mandatory Fields - ');
   FOR l_count IN 1..l_mandatory_fields.COUNT
    LOOP
      htp.comment(l_mandatory_fields(l_count));
   END LOOP;
--
   htp.tablerowopen;
--   htp.p('<TD><INPUT TYPE="Button" VALUE="Validate" onClick="validateForm(document.inventory_data)"></TD>');
--   htp.p('<TD><INPUT TYPE="Button" VALUE="Validate2" onClick="alert('||nm3flx.string('Validate!')||')"></TD>');
--   htp.p('<TD><INPUT TYPE="Button" VALUE="Validate2" onClick="alert(this.form.name)"></TD>');
--   htp.tabledata(Null);
--   htp.tabledata(Null);
   htp.tabledata(cvalue      => htf.formsubmit(cvalue=>xval_find_inv.c_continue)
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
      (iit_inv_type                   IN VARCHAR2 DEFAULT Null
      ,iit_primary_key                IN VARCHAR2 DEFAULT Null
      ,iit_start_date                 IN VARCHAR2 DEFAULT Null
      ,iit_admin_unit                 IN VARCHAR2 DEFAULT Null
      ,iit_descr                      IN VARCHAR2 DEFAULT Null
      ,iit_end_date                   IN VARCHAR2 DEFAULT Null
      ,iit_foreign_key                IN VARCHAR2 DEFAULT Null
      ,iit_located_by                 IN VARCHAR2 DEFAULT Null
      ,iit_position                   IN VARCHAR2 DEFAULT Null
      ,iit_x_coord                    IN VARCHAR2 DEFAULT Null
      ,iit_y_coord                    IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib16               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib17               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib18               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib19               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib20               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib21               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib22               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib23               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib24               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib25               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib26               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib27               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib28               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib29               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib30               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib31               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib32               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib33               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib34               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib35               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib36               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib37               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib38               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib39               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib40               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib41               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib42               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib43               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib44               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib45               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib46               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib47               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib48               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib49               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib50               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib51               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib52               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib53               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib54               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib55               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib56               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib57               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib58               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib59               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib60               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib61               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib62               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib63               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib64               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib65               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib66               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib67               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib68               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib69               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib70               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib71               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib72               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib73               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib74               IN VARCHAR2 DEFAULT Null
      ,iit_chr_attrib75               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib76               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib77               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib78               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib79               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib80               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib81               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib82               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib83               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib84               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib85               IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib86              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib87              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib88              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib89              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib90              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib91              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib92              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib93              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib94              IN VARCHAR2 DEFAULT Null
      ,iit_date_attrib95              IN VARCHAR2 DEFAULT Null
      ,iit_angle                      IN VARCHAR2 DEFAULT Null
      ,iit_angle_txt                  IN VARCHAR2 DEFAULT Null
      ,iit_class                      IN VARCHAR2 DEFAULT Null
      ,iit_class_txt                  IN VARCHAR2 DEFAULT Null
      ,iit_colour                     IN VARCHAR2 DEFAULT Null
      ,iit_colour_txt                 IN VARCHAR2 DEFAULT Null
      ,iit_coord_flag                 IN VARCHAR2 DEFAULT Null
      ,iit_description                IN VARCHAR2 DEFAULT Null
      ,iit_diagram                    IN VARCHAR2 DEFAULT Null
      ,iit_distance                   IN VARCHAR2 DEFAULT Null
      ,iit_end_chain                  IN VARCHAR2 DEFAULT Null
      ,iit_gap                        IN VARCHAR2 DEFAULT Null
      ,iit_height                     IN VARCHAR2 DEFAULT Null
      ,iit_height_2                   IN VARCHAR2 DEFAULT Null
      ,iit_id_code                    IN VARCHAR2 DEFAULT Null
      ,iit_instal_date                IN VARCHAR2 DEFAULT Null
      ,iit_invent_date                IN VARCHAR2 DEFAULT Null
      ,iit_inv_ownership              IN VARCHAR2 DEFAULT Null
      ,iit_itemcode                   IN VARCHAR2 DEFAULT Null
      ,iit_lco_lamp_config_id         IN VARCHAR2 DEFAULT Null
      ,iit_length                     IN VARCHAR2 DEFAULT Null
      ,iit_material                   IN VARCHAR2 DEFAULT Null
      ,iit_material_txt               IN VARCHAR2 DEFAULT Null
      ,iit_method                     IN VARCHAR2 DEFAULT Null
      ,iit_method_txt                 IN VARCHAR2 DEFAULT Null
      ,iit_note                       IN VARCHAR2 DEFAULT Null
      ,iit_no_of_units                IN VARCHAR2 DEFAULT Null
      ,iit_options                    IN VARCHAR2 DEFAULT Null
      ,iit_options_txt                IN VARCHAR2 DEFAULT Null
      ,iit_oun_org_id_elec_board      IN VARCHAR2 DEFAULT Null
      ,iit_owner                      IN VARCHAR2 DEFAULT Null
      ,iit_owner_txt                  IN VARCHAR2 DEFAULT Null
      ,iit_peo_invent_by_id           IN VARCHAR2 DEFAULT Null
      ,iit_photo                      IN VARCHAR2 DEFAULT Null
      ,iit_power                      IN VARCHAR2 DEFAULT Null
      ,iit_prov_flag                  IN VARCHAR2 DEFAULT Null
      ,iit_rev_by                     IN VARCHAR2 DEFAULT Null
      ,iit_rev_date                   IN VARCHAR2 DEFAULT Null
      ,iit_type                       IN VARCHAR2 DEFAULT Null
      ,iit_type_txt                   IN VARCHAR2 DEFAULT Null
      ,iit_width                      IN VARCHAR2 DEFAULT Null
      ,iit_xtra_char_1                IN VARCHAR2 DEFAULT Null
      ,iit_xtra_date_1                IN VARCHAR2 DEFAULT Null
      ,iit_xtra_domain_1              IN VARCHAR2 DEFAULT Null
      ,iit_xtra_domain_txt_1          IN VARCHAR2 DEFAULT Null
      ,iit_xtra_number_1              IN VARCHAR2 DEFAULT Null
      ,iit_x_sect                     IN VARCHAR2 DEFAULT Null
      ,iit_det_xsp                    IN VARCHAR2 DEFAULT Null
      ,iit_offset                     IN VARCHAR2 DEFAULT Null
      ,iit_x                          IN VARCHAR2 DEFAULT Null
      ,iit_y                          IN VARCHAR2 DEFAULT Null
      ,iit_z                          IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib96               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib97               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib98               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib99               IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib100              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib101              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib102              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib103              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib104              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib105              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib106              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib107              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib108              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib109              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib110              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib111              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib112              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib113              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib114              IN VARCHAR2 DEFAULT Null
      ,iit_num_attrib115              IN VARCHAR2 DEFAULT Null
      ,p_module                       IN VARCHAR2 DEFAULT NULL
      ,p_module_title                 IN VARCHAR2 DEFAULT NULL
      ,p_parent_ngqi_job_id           IN nm_gaz_query_item_list.ngqi_job_id%TYPE DEFAULT NULL
--
      ) IS
--
   l_rec_iit                nm_inv_items%ROWTYPE;
   c_empty_rec_iit CONSTANT nm_inv_items%ROWTYPE := l_rec_iit;
   l_rec_nit                nm_inv_types%ROWTYPE;
   c_init_eff_date CONSTANT DATE := nm3user.get_effective_date;
--
   l_tab_iit_ne_id   nm3type.tab_varchar30;
   l_tab_parent_pk   nm3type.tab_varchar80;
   l_tab_parent_id   nm3type.tab_varchar30;
   l_tab_parent_nit  nm3type.tab_varchar4;
   l_parent_inv_type nm_inv_types.nit_inv_type%TYPE;
--
   PROCEDURE local_move_and_insert (p_iit_foreign_key nm_inv_items.iit_foreign_key%TYPE) IS
   BEGIN
--
      l_rec_iit.iit_inv_type              := iit_inv_type;
      l_rec_iit.iit_primary_key           := iit_primary_key;
      l_rec_iit.iit_start_date            := harsh_date_check(iit_start_date);
      l_rec_iit.iit_admin_unit            := iit_admin_unit;
      l_rec_iit.iit_descr                 := iit_descr;
      l_rec_iit.iit_end_date              := harsh_date_check(iit_end_date);
      l_rec_iit.iit_foreign_key           := p_iit_foreign_key;
      l_rec_iit.iit_located_by            := iit_located_by;
      l_rec_iit.iit_position              := harsh_number_check(iit_position);
      l_rec_iit.iit_x_coord               := harsh_number_check(iit_x_coord);
      l_rec_iit.iit_y_coord               := harsh_number_check(iit_y_coord);
      l_rec_iit.iit_num_attrib16          := harsh_number_check(iit_num_attrib16);
      l_rec_iit.iit_num_attrib17          := harsh_number_check(iit_num_attrib17);
      l_rec_iit.iit_num_attrib18          := harsh_number_check(iit_num_attrib18);
      l_rec_iit.iit_num_attrib19          := harsh_number_check(iit_num_attrib19);
      l_rec_iit.iit_num_attrib20          := harsh_number_check(iit_num_attrib20);
      l_rec_iit.iit_num_attrib21          := harsh_number_check(iit_num_attrib21);
      l_rec_iit.iit_num_attrib22          := harsh_number_check(iit_num_attrib22);
      l_rec_iit.iit_num_attrib23          := harsh_number_check(iit_num_attrib23);
      l_rec_iit.iit_num_attrib24          := harsh_number_check(iit_num_attrib24);
      l_rec_iit.iit_num_attrib25          := harsh_number_check(iit_num_attrib25);
      l_rec_iit.iit_chr_attrib26          := UPPER(iit_chr_attrib26);
      l_rec_iit.iit_chr_attrib27          := UPPER(iit_chr_attrib27);
      l_rec_iit.iit_chr_attrib28          := UPPER(iit_chr_attrib28);
      l_rec_iit.iit_chr_attrib29          := UPPER(iit_chr_attrib29);
      l_rec_iit.iit_chr_attrib30          := UPPER(iit_chr_attrib30);
      l_rec_iit.iit_chr_attrib31          := UPPER(iit_chr_attrib31);
      l_rec_iit.iit_chr_attrib32          := UPPER(iit_chr_attrib32);
      l_rec_iit.iit_chr_attrib33          := UPPER(iit_chr_attrib33);
      l_rec_iit.iit_chr_attrib34          := UPPER(iit_chr_attrib34);
      l_rec_iit.iit_chr_attrib35          := UPPER(iit_chr_attrib35);
      l_rec_iit.iit_chr_attrib36          := UPPER(iit_chr_attrib36);
      l_rec_iit.iit_chr_attrib37          := UPPER(iit_chr_attrib37);
      l_rec_iit.iit_chr_attrib38          := UPPER(iit_chr_attrib38);
      l_rec_iit.iit_chr_attrib39          := UPPER(iit_chr_attrib39);
      l_rec_iit.iit_chr_attrib40          := UPPER(iit_chr_attrib40);
      l_rec_iit.iit_chr_attrib41          := UPPER(iit_chr_attrib41);
      l_rec_iit.iit_chr_attrib42          := UPPER(iit_chr_attrib42);
      l_rec_iit.iit_chr_attrib43          := UPPER(iit_chr_attrib43);
      l_rec_iit.iit_chr_attrib44          := UPPER(iit_chr_attrib44);
      l_rec_iit.iit_chr_attrib45          := UPPER(iit_chr_attrib45);
      l_rec_iit.iit_chr_attrib46          := UPPER(iit_chr_attrib46);
      l_rec_iit.iit_chr_attrib47          := UPPER(iit_chr_attrib47);
      l_rec_iit.iit_chr_attrib48          := UPPER(iit_chr_attrib48);
      l_rec_iit.iit_chr_attrib49          := UPPER(iit_chr_attrib49);
      l_rec_iit.iit_chr_attrib50          := UPPER(iit_chr_attrib50);
      l_rec_iit.iit_chr_attrib51          := UPPER(iit_chr_attrib51);
      l_rec_iit.iit_chr_attrib52          := UPPER(iit_chr_attrib52);
      l_rec_iit.iit_chr_attrib53          := UPPER(iit_chr_attrib53);
      l_rec_iit.iit_chr_attrib54          := UPPER(iit_chr_attrib54);
      l_rec_iit.iit_chr_attrib55          := UPPER(iit_chr_attrib55);
      l_rec_iit.iit_chr_attrib56          := UPPER(iit_chr_attrib56);
      l_rec_iit.iit_chr_attrib57          := UPPER(iit_chr_attrib57);
      l_rec_iit.iit_chr_attrib58          := UPPER(iit_chr_attrib58);
      l_rec_iit.iit_chr_attrib59          := UPPER(iit_chr_attrib59);
      l_rec_iit.iit_chr_attrib60          := UPPER(iit_chr_attrib60);
      l_rec_iit.iit_chr_attrib61          := UPPER(iit_chr_attrib61);
      l_rec_iit.iit_chr_attrib62          := UPPER(iit_chr_attrib62);
      l_rec_iit.iit_chr_attrib63          := UPPER(iit_chr_attrib63);
      l_rec_iit.iit_chr_attrib64          := UPPER(iit_chr_attrib64);
      l_rec_iit.iit_chr_attrib65          := UPPER(iit_chr_attrib65);
      l_rec_iit.iit_chr_attrib66          := UPPER(iit_chr_attrib66);
      l_rec_iit.iit_chr_attrib67          := UPPER(iit_chr_attrib67);
      l_rec_iit.iit_chr_attrib68          := UPPER(iit_chr_attrib68);
      l_rec_iit.iit_chr_attrib69          := UPPER(iit_chr_attrib69);
      l_rec_iit.iit_chr_attrib70          := UPPER(iit_chr_attrib70);
      l_rec_iit.iit_chr_attrib71          := UPPER(iit_chr_attrib71);
      l_rec_iit.iit_chr_attrib72          := UPPER(iit_chr_attrib72);
      l_rec_iit.iit_chr_attrib73          := UPPER(iit_chr_attrib73);
      l_rec_iit.iit_chr_attrib74          := UPPER(iit_chr_attrib74);
      l_rec_iit.iit_chr_attrib75          := UPPER(iit_chr_attrib75);
      l_rec_iit.iit_num_attrib76          := harsh_number_check(iit_num_attrib76);
      l_rec_iit.iit_num_attrib77          := harsh_number_check(iit_num_attrib77);
      l_rec_iit.iit_num_attrib78          := harsh_number_check(iit_num_attrib78);
      l_rec_iit.iit_num_attrib79          := harsh_number_check(iit_num_attrib79);
      l_rec_iit.iit_num_attrib80          := harsh_number_check(iit_num_attrib80);
      l_rec_iit.iit_num_attrib81          := harsh_number_check(iit_num_attrib81);
      l_rec_iit.iit_num_attrib82          := harsh_number_check(iit_num_attrib82);
      l_rec_iit.iit_num_attrib83          := harsh_number_check(iit_num_attrib83);
      l_rec_iit.iit_num_attrib84          := harsh_number_check(iit_num_attrib84);
      l_rec_iit.iit_num_attrib85          := harsh_number_check(iit_num_attrib85);
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
      l_rec_iit.iit_angle                 := harsh_number_check(iit_angle);
      l_rec_iit.iit_angle_txt             := UPPER(iit_angle_txt);
      l_rec_iit.iit_class                 := UPPER(iit_class);
      l_rec_iit.iit_class_txt             := UPPER(iit_class_txt);
      l_rec_iit.iit_colour                := UPPER(iit_colour);
      l_rec_iit.iit_colour_txt            := UPPER(iit_colour_txt);
      l_rec_iit.iit_coord_flag            := UPPER(iit_coord_flag);
      l_rec_iit.iit_description           := UPPER(iit_description);
      l_rec_iit.iit_diagram               := UPPER(iit_diagram);
      l_rec_iit.iit_distance              := harsh_number_check(iit_distance);
      l_rec_iit.iit_end_chain             := harsh_number_check(iit_end_chain);
      l_rec_iit.iit_gap                   := harsh_number_check(iit_gap);
      l_rec_iit.iit_height                := harsh_number_check(iit_height);
      l_rec_iit.iit_height_2              := harsh_number_check(iit_height_2);
      l_rec_iit.iit_id_code               := UPPER(iit_id_code);
      l_rec_iit.iit_instal_date           := harsh_date_check(iit_instal_date);
      l_rec_iit.iit_invent_date           := harsh_date_check(iit_invent_date);
      l_rec_iit.iit_inv_ownership         := UPPER(iit_inv_ownership);
      l_rec_iit.iit_itemcode              := UPPER(iit_itemcode);
      l_rec_iit.iit_lco_lamp_config_id    := harsh_number_check(iit_lco_lamp_config_id);
      l_rec_iit.iit_length                := harsh_number_check(iit_length);
      l_rec_iit.iit_material              := UPPER(iit_material);
      l_rec_iit.iit_material_txt          := UPPER(iit_material_txt);
      l_rec_iit.iit_method                := UPPER(iit_method);
      l_rec_iit.iit_method_txt            := UPPER(iit_method_txt);
      l_rec_iit.iit_note                  := iit_note;
      l_rec_iit.iit_no_of_units           := harsh_number_check(iit_no_of_units);
      l_rec_iit.iit_options               := UPPER(iit_options);
      l_rec_iit.iit_options_txt           := UPPER(iit_options_txt);
      l_rec_iit.iit_oun_org_id_elec_board := harsh_number_check(iit_oun_org_id_elec_board);
      l_rec_iit.iit_owner                 := UPPER(iit_owner);
      l_rec_iit.iit_owner_txt             := UPPER(iit_owner_txt);
      l_rec_iit.iit_peo_invent_by_id      := harsh_number_check(iit_peo_invent_by_id);
      l_rec_iit.iit_photo                 := UPPER(iit_photo);
      l_rec_iit.iit_power                 := harsh_number_check(iit_power);
      l_rec_iit.iit_prov_flag             := UPPER(iit_prov_flag);
      l_rec_iit.iit_rev_by                := UPPER(iit_rev_by);
      l_rec_iit.iit_rev_date              := harsh_date_check(iit_rev_date);
      l_rec_iit.iit_type                  := UPPER(iit_type);
      l_rec_iit.iit_type_txt              := UPPER(iit_type_txt);
      l_rec_iit.iit_width                 := harsh_number_check(iit_width);
      l_rec_iit.iit_xtra_char_1           := UPPER(iit_xtra_char_1);
      l_rec_iit.iit_xtra_date_1           := harsh_date_check(iit_xtra_date_1);
      l_rec_iit.iit_xtra_domain_1         := UPPER(iit_xtra_domain_1);
      l_rec_iit.iit_xtra_domain_txt_1     := UPPER(iit_xtra_domain_txt_1);
      l_rec_iit.iit_xtra_number_1         := harsh_number_check(iit_xtra_number_1);
      l_rec_iit.iit_x_sect                := UPPER(iit_x_sect);
      l_rec_iit.iit_det_xsp               := UPPER(iit_det_xsp);
      l_rec_iit.iit_offset                := harsh_number_check(iit_offset);
      l_rec_iit.iit_x                     := harsh_number_check(iit_x);
      l_rec_iit.iit_y                     := harsh_number_check(iit_y);
      l_rec_iit.iit_z                     := harsh_number_check(iit_z);
      l_rec_iit.iit_num_attrib96          := harsh_number_check(iit_num_attrib96);
      l_rec_iit.iit_num_attrib97          := harsh_number_check(iit_num_attrib97);
      l_rec_iit.iit_num_attrib98          := harsh_number_check(iit_num_attrib98);
      l_rec_iit.iit_num_attrib99          := harsh_number_check(iit_num_attrib99);
      l_rec_iit.iit_num_attrib100         := harsh_number_check(iit_num_attrib100);
      l_rec_iit.iit_num_attrib101         := harsh_number_check(iit_num_attrib101);
      l_rec_iit.iit_num_attrib102         := harsh_number_check(iit_num_attrib102);
      l_rec_iit.iit_num_attrib103         := harsh_number_check(iit_num_attrib103);
      l_rec_iit.iit_num_attrib104         := harsh_number_check(iit_num_attrib104);
      l_rec_iit.iit_num_attrib105         := harsh_number_check(iit_num_attrib105);
      l_rec_iit.iit_num_attrib106         := harsh_number_check(iit_num_attrib106);
      l_rec_iit.iit_num_attrib107         := harsh_number_check(iit_num_attrib107);
      l_rec_iit.iit_num_attrib108         := harsh_number_check(iit_num_attrib108);
      l_rec_iit.iit_num_attrib109         := harsh_number_check(iit_num_attrib109);
      l_rec_iit.iit_num_attrib110         := harsh_number_check(iit_num_attrib110);
      l_rec_iit.iit_num_attrib111         := harsh_number_check(iit_num_attrib111);
      l_rec_iit.iit_num_attrib112         := harsh_number_check(iit_num_attrib112);
      l_rec_iit.iit_num_attrib113         := harsh_number_check(iit_num_attrib113);
      l_rec_iit.iit_num_attrib114         := harsh_number_check(iit_num_attrib114);
      l_rec_iit.iit_num_attrib115         := harsh_number_check(iit_num_attrib115);
   --
      l_rec_iit.iit_ne_id                 := nm3seq.next_ne_id_seq;
   --
      nm3ins.ins_iit (l_rec_iit);
      l_tab_iit_ne_id (l_tab_iit_ne_id.COUNT+1) := l_rec_iit.iit_ne_id;
   --
      xval_audit.create_nat_pair_for_val (p_rec_iit_old => c_empty_rec_iit
                                         ,p_rec_iit_new => l_rec_iit
                                         ,p_audit_type  => xval_audit.c_insert
                                         );
   --
--      nm_debug.debug(l_tab_iit_ne_id.COUNT||'. inserted '||l_rec_iit.iit_ne_id);
   --
   END local_move_and_insert;
--
BEGIN
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--nm_debug.set_level(3);
   SAVEPOINT top_of_insert;
   nm3web.head (p_close_head => FALSE
               ,p_title      => p_module_title
               );
   xval_find_inv.create_js_funcs;
   htp.headclose;
--
   sccs_tags;
   htp.headclose;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => p_module);
   l_rec_iit.iit_start_date := harsh_date_check(iit_start_date);
   nm3user.set_effective_date (l_rec_iit.iit_start_date);
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => iit_inv_type);
--
   IF p_parent_ngqi_job_id IS NOT NULL
    THEN
      SELECT iit_primary_key
            ,iit_ne_id
            ,iit_inv_type
       BULK  COLLECT
       INTO  l_tab_parent_pk
            ,l_tab_parent_id
            ,l_tab_parent_nit
       FROM  nm_inv_items
            ,nm_gaz_query_item_list
      WHERE  ngqi_job_id         = p_parent_ngqi_job_id
       AND   iit_ne_id           = ngqi_item_id
       AND   ngqi_item_type_type = nm3gaz_qry.c_ngqt_item_type_type_inv
       AND   ngqi_item_type      = iit_inv_type;
      FOR i IN 1..l_tab_parent_pk.COUNT
       LOOP
         local_move_and_insert (l_tab_parent_pk(i));
         l_parent_inv_type := l_tab_parent_nit(i);
      END LOOP;
   ELSE
      local_move_and_insert (iit_foreign_key);
   END IF;
--
   nm3user.set_effective_date (c_init_eff_date);
   commit;
--
   IF l_tab_iit_ne_id.COUNT = 1
    THEN
      xval_find_inv.show_detail (pi_iit_ne_id    => l_tab_iit_ne_id(1)
                                ,pi_close_button => FALSE
                                );
      xval_find_inv.js_ner (pi_appl               => nm3type.c_hig
                           ,pi_id                 => 95
                           ,pi_supplementary_info => xval_reval.c_record_created
                           );
   ELSE
      xval_find_inv.instantiate_for_inv_type (l_parent_inv_type);
      xval_find_inv.show_results (p_module      => Null
                                 ,p_ngqi_job_id => xval_reval.put_tab_iit_ne_id_into_ngqi (p_tab_iit_ne_id => l_tab_parent_id)
                                 );
      xval_find_inv.js_ner (pi_appl               => nm3type.c_hig
                           ,pi_id                 => 95
                           ,pi_supplementary_info => xval_reval.c_records_created
                           );
   END IF;
--
--nm_debug.debug_off;
   htp.bodyclose;
   htp.htmlclose;
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
------------------------------------------------------------------------------
--
FUNCTION harsh_number_check (p_char_number VARCHAR2) RETURN NUMBER IS
   l_retval NUMBER;
BEGIN
   IF p_char_number IS NOT NULL
    THEN
      IF NOT nm3flx.is_numeric (p_char_number)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 111
                       ,pi_supplementary_info => p_char_number
                       );
      ELSE
         l_retval := TO_NUMBER(p_char_number);
      END IF;
   END IF;
   RETURN l_retval;
END harsh_number_check;
--
------------------------------------------------------------------------------
--
END xval_create_inv;
/
