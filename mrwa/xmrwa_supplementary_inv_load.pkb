CREATE OR REPLACE PACKAGE BODY xmrwa_supplementary_inv_load AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_supplementary_inv_load.pkb	1.1 03/15/05
--       Module Name      : xmrwa_supplementary_inv_load.pkb
--       Date into SCCS   : 05/03/15 00:46:06
--       Date fetched Out : 07/06/06 14:38:31
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA supplementary inventory loader package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_supplementary_inv_load.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xmrwa_supplementary_inv_load';
--
   c_eff_date DATE;
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
PROCEDURE startup (p_eff_date DATE) IS
BEGIN
   c_eff_date := nm3user.get_effective_date;
   nm3user.set_effective_date (p_eff_date);
END startup;
--
-----------------------------------------------------------------------------
--
PROCEDURE shutdown IS
BEGIN
   nm3user.set_effective_date (c_eff_date);
END shutdown;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_item (p_iit_ne_id          nm_inv_items.iit_ne_id%TYPE
                    ,p_iit_primary_key    nm_inv_items.iit_primary_key%TYPE
                    ,p_iit_inv_type       nm_inv_items.iit_inv_type%TYPE
                    ) IS
BEGIN
--
   IF p_iit_inv_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 22
                    ,pi_supplementary_info => 'IIT_INV_TYPE'
                    );
   END IF;
--
   IF    p_iit_ne_id       IS NOT NULL
    AND  p_iit_primary_key IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'specify IIT_NE_ID OR IIT_PRIMARY_KEY - not both'
                    );
   ELSIF p_iit_ne_id IS NOT NULL
    THEN
      g_rec_iit := nm3get.get_iit (pi_iit_ne_id => p_iit_ne_id);
   ELSIF p_iit_primary_key IS NOT NULL
    THEN
      g_rec_iit := nm3get.get_iit (pi_iit_primary_key => p_iit_primary_key
                                  ,pi_iit_inv_type    => p_iit_inv_type
                                  );
   ELSE
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 22
                    ,pi_supplementary_info => 'IIT_NE_ID or IIT_PRIMARY_KEY'
                    );
   END IF;
--
   IF g_rec_iit.iit_inv_type != p_iit_inv_type
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'passed iit_inv_type('||p_iit_inv_type||' is different to inv type of item ('||g_rec_iit.iit_inv_type||')'
                    );
   END IF;
--
END find_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_item (p_rec xmrwa_end_date_inv_item%ROWTYPE) IS
   l_warning_code nm3type.max_varchar2;
   l_warning_msg  nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_item');
--
   startup (p_rec.iit_end_date);
--
   find_item (p_iit_ne_id       => p_rec.iit_ne_id
             ,p_iit_primary_key => p_rec.iit_primary_key
             ,p_iit_inv_type    => p_rec.iit_inv_type
             );
--
   IF p_rec.iit_note IS NOT NULL
    THEN
      g_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => g_rec_iit.iit_ne_id);
      UPDATE nm_inv_items
       SET   iit_note = p_rec.iit_note
      WHERE  ROWID    = g_rowid;
   END IF;
--
   nm3homo.end_inv_location (pi_iit_ne_id            => g_rec_iit.iit_ne_id
                            ,pi_effective_date       => nm3user.get_effective_date
                            ,pi_check_for_parent     => TRUE
                            ,pi_ignore_item_loc_mand => TRUE
                            ,po_warning_code         => l_warning_code
                            ,po_warning_msg          => l_warning_msg
                            );
--
   shutdown;
--
   nm_debug.proc_end(g_package_name,'end_date_item');
--
EXCEPTION
   WHEN others
    THEN
      shutdown;
      RAISE;
END end_date_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_item_validate (p_rec xmrwa_end_date_inv_item%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_item_validate');
--
   startup (p_rec.iit_end_date);
--
   find_item (p_iit_ne_id       => p_rec.iit_ne_id
             ,p_iit_primary_key => p_rec.iit_primary_key
             ,p_iit_inv_type    => p_rec.iit_inv_type
             );
--
   shutdown;
--
   nm_debug.proc_end(g_package_name,'end_date_item_validate');
--
EXCEPTION
   WHEN others
    THEN
      shutdown;
      RAISE;
END end_date_item_validate;
--
-----------------------------------------------------------------------------
--
PROCEDURE relocate_item (p_rec xmrwa_modify_inv_item_location%ROWTYPE) IS
   l_rec_loc mrwa_load_inv_loc%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'relocate_item');
--
   startup (p_rec.nm_start_date);
--
   find_item (p_iit_ne_id       => p_rec.iit_ne_id
             ,p_iit_primary_key => p_rec.iit_primary_key
             ,p_iit_inv_type    => p_rec.iit_inv_type
             );
--
   l_rec_loc.ne_group       := p_rec.ne_group;
   l_rec_loc.start_slk      := p_rec.start_slk;
   l_rec_loc.end_slk        := p_rec.end_slk;
   l_rec_loc.ne_sub_class   := p_rec.ne_sub_class;
   l_rec_loc.iit_inv_type   := g_rec_iit.iit_inv_type;
   l_rec_loc.iit_ne_id      := g_rec_iit.iit_ne_id;
   l_rec_loc.nm_start_date  := p_rec.nm_start_date;
   mrwa_inv_load.load (l_rec_loc);
--
   shutdown;
--
   nm_debug.proc_end(g_package_name,'relocate_item');
--
EXCEPTION
   WHEN others
    THEN
      shutdown;
      RAISE;
END relocate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE relocate_item_validate (p_rec xmrwa_modify_inv_item_location%ROWTYPE) IS
   l_rec_loc mrwa_load_inv_loc%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'relocate_item_validate');
--
   startup (p_rec.nm_start_date);
--
   find_item (p_iit_ne_id       => p_rec.iit_ne_id
             ,p_iit_primary_key => p_rec.iit_primary_key
             ,p_iit_inv_type    => p_rec.iit_inv_type
             );
--
   l_rec_loc.ne_group       := p_rec.ne_group;
   l_rec_loc.start_slk      := p_rec.start_slk;
   l_rec_loc.end_slk        := p_rec.end_slk;
   l_rec_loc.ne_sub_class   := p_rec.ne_sub_class;
   l_rec_loc.iit_inv_type   := g_rec_iit.iit_inv_type;
   l_rec_loc.iit_ne_id      := g_rec_iit.iit_ne_id;
   l_rec_loc.nm_start_date  := p_rec.nm_start_date;
   mrwa_inv_load.validate (l_rec_loc);
--
   shutdown;
--
   nm_debug.proc_end(g_package_name,'relocate_item_validate');
--
EXCEPTION
   WHEN others
    THEN
      shutdown;
      RAISE;
END relocate_item_validate;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_item_attr_internal (p_rec           xmrwa_modify_item_attr%ROWTYPE
                                    ,p_validate_only BOOLEAN
                                    ) IS
   l_rec_ita    nm_inv_type_attribs%ROWTYPE;
   l_block      nm3type.max_varchar2;
   l_value_str  nm3type.max_varchar2;
   l_date_value DATE;
BEGIN
--
   startup (p_rec.iit_start_date);
--
   find_item (p_iit_ne_id       => p_rec.iit_ne_id
             ,p_iit_primary_key => p_rec.iit_primary_key
             ,p_iit_inv_type    => p_rec.iit_inv_type
             );
--
   l_rec_ita := nm3get.get_ita (pi_ita_inv_type      => p_rec.iit_inv_type
                               ,pi_ita_view_col_name => p_rec.ita_view_col_name
                               );
--
   IF p_rec.iit_new_value IS NULL
    THEN
      l_value_str := 'Null';
   ELSE
      IF l_rec_ita.ita_format = nm3type.c_date
       THEN
         l_date_value := hig.date_convert(p_rec.iit_new_value);
         IF l_date_value IS NULL
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 148
                          ,pi_supplementary_info => p_rec.iit_new_value
                          );
         END IF;
         l_value_str  := 'TO_DATE('||nm3flx.string(to_char(l_date_value,nm3type.c_full_date_time_format))||',nm3type.c_full_date_time_format)';
      ELSIF l_rec_ita.ita_format = nm3type.c_number
       THEN
         IF NOT nm3flx.is_numeric (p_rec.iit_new_value)
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 111
                          ,pi_supplementary_info => p_rec.iit_new_value
                          );
         END IF;
         l_value_str  := p_rec.iit_new_value;
      ELSE
         l_value_str  := nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(UPPER(p_rec.iit_new_value)));
      END IF;
   END IF;
   l_block :=            'DECLARE'
              ||CHR(10)||'   l_value nm_inv_items.'||l_rec_ita.ita_attrib_name||'%TYPE;'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   l_value := '||l_value_str||';'
              ||CHR(10)||'   '||g_package_name||'.g_rec_iit.'||l_rec_ita.ita_attrib_name||' := l_value;'
              ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_block;
--
   IF p_validate_only
    THEN
      nm3inv.validate_rec_iit (g_rec_iit);
   ELSE
      g_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => g_rec_iit.iit_ne_id);
      l_block :=            'BEGIN'
                 ||CHR(10)||'   UPDATE nm_inv_items'
                 ||CHR(10)||'    SET   '||l_rec_ita.ita_attrib_name||' = '||g_package_name||'.g_rec_iit.'||l_rec_ita.ita_attrib_name
                 ||CHR(10)||'   WHERE  ROWID = '||g_package_name||'.g_rowid;'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block;
   END IF;
--
   shutdown;
--
EXCEPTION
   WHEN others
    THEN
      shutdown;
      RAISE;
END update_item_attr_internal;
-- 
-----------------------------------------------------------------------------
--
PROCEDURE update_item_attr (p_rec xmrwa_modify_item_attr%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'update_item_attr');
--
   update_item_attr_internal (p_rec, FALSE);
--
   nm_debug.proc_end(g_package_name,'update_item_attr');
--
END update_item_attr;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_item_attr_validate (p_rec xmrwa_modify_item_attr%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'update_item_attr_validate');
--
   update_item_attr_internal (p_rec, TRUE);
--
   nm_debug.proc_end(g_package_name,'update_item_attr_validate');
--
END update_item_attr_validate;
--
-----------------------------------------------------------------------------
--
END xmrwa_supplementary_inv_load;
/
