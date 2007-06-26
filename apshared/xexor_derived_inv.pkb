CREATE OR REPLACE PACKAGE BODY xexor_derived_inv AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_derived_inv.pkb	1.1 03/15/05
--       Module Name      : xexor_derived_inv.pkb
--       Date into SCCS   : 05/03/15 22:46:49
--       Date fetched Out : 07/06/06 14:36:37
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Derived Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xexor_derived_inv.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xexor_derived_inv';
--
   g_tab_rec_iit_old nm3type.tab_rec_iit;
   g_tab_rec_iit_new nm3type.tab_rec_iit;
--
   c_old_rec_dot  CONSTANT VARCHAR2(62) := g_package_name||'.g_rec_iit_old.';
   c_new_rec_dot  CONSTANT VARCHAR2(62) := g_package_name||'.g_rec_iit_new.';
--
   c_nm_inv_items CONSTANT VARCHAR2(30) := 'NM_INV_ITEMS';
--
   g_tab_ita                nm3inv.tab_nita;
   g_tab_ita_child          nm3inv.tab_nita;
   g_last_inv_type          nm_inv_types.nit_inv_type%TYPE := nm3type.c_nvl;
   g_last_parent_inv_type   nm_inv_types.nit_inv_type%TYPE := nm3type.c_nvl;
   g_last_child_inv_type    nm_inv_types.nit_inv_type%TYPE := nm3type.c_nvl;
   g_comparison_sql         nm3type.tab_varchar32767;
   g_update_sql             nm3type.tab_varchar32767;
   g_formula_sql            nm3type.tab_varchar32767;
   g_tab_child_types        nm3type.tab_varchar4;
--
-----------------------------------------------------------------------------
--
FUNCTION is_a_parent (p_inv_type_parent nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
FUNCTION attributes_have_changed (p_rec_iit_old nm_inv_items%ROWTYPE
                                 ,p_rec_iit_new nm_inv_items%ROWTYPE
                                 ) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_each_child_item (p_child_type nm_inv_types.nit_inv_type%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_inv_type_pair (p_nit_inv_type_parent nm_inv_types.nit_inv_type%TYPE
                                    ,p_nit_inv_type_child  nm_inv_types.nit_inv_type%TYPE
                                    );
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_for_inv_type (p_nit_inv_type nm_inv_types.nit_inv_type%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE update_flex_attr_from_rowtype (p_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                                        ,p_rec_iit   nm_inv_items%ROWTYPE
                                        );
--
-----------------------------------------------------------------------------
--
PROCEDURE is_column_in_table (p_table_name  VARCHAR2
                             ,p_column_name VARCHAR2
                             ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                             );
--
-----------------------------------------------------------------------------
--
FUNCTION is_column_in_table (p_table_name  VARCHAR2
                            ,p_column_name VARCHAR2
                            ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                            ) RETURN BOOLEAN;
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
PROCEDURE add_pair_to_arrays (p_rec_iit_old nm_inv_items%ROWTYPE
                             ,p_rec_iit_new nm_inv_items%ROWTYPE
                             ) IS
--
   c_count CONSTANT PLS_INTEGER := g_tab_rec_iit_old.COUNT+1;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'add_pair_to_arrays');
--
--      nm_Debug.delete_debug(TRUE);
--      nm_debug.debug_on;
--
   IF   is_a_parent (p_rec_iit_new.iit_inv_type)
    AND attributes_have_changed (p_rec_iit_old, p_rec_iit_new)
    THEN
      g_tab_rec_iit_old(c_count) := p_rec_iit_old;
      g_tab_rec_iit_new(c_count) := p_rec_iit_new;
   END IF;
--
   nm_debug.proc_end (g_package_name,'add_pair_to_arrays');
--
END add_pair_to_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_arrays IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'clear_arrays');
--
   g_tab_rec_iit_old.DELETE;
   g_tab_rec_iit_new.DELETE;
--
   nm_debug.proc_end (g_package_name,'clear_arrays');
--
END clear_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_arrays IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'process_arrays');
--
   FOR i IN 1..g_tab_rec_iit_old.COUNT
    LOOP
--      nm_debug.debug('Process iit_pair ('||i||')');
      process_iit_pair (p_rec_iit_old => g_tab_rec_iit_old(i)
                       ,p_rec_iit_new => g_tab_rec_iit_new(i)
                       );
   END LOOP;
--
   clear_arrays;
--
   nm_debug.proc_end (g_package_name,'process_arrays');
--
END process_arrays;
--
-----------------------------------------------------------------------------
--
FUNCTION is_a_parent (p_inv_type_parent nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN IS
   CURSOR cs_check (c_inv_type_parent nm_inv_types.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  xexor_derived_attributes
                  WHERE  xda_nit_inv_type_parent = c_inv_type_parent
                 );
   l_found BOOLEAN;
   l_dummy PLS_INTEGER;
BEGIN
--
   nm_debug.proc_start (g_package_name,'clear_arrays');
--
   OPEN  cs_check (p_inv_type_parent);
   FETCH cs_check INTO l_dummy;
   l_found := cs_check%FOUND;
   CLOSE cs_check;
--
   nm_debug.proc_end (g_package_name,'clear_arrays');
--
--nm_debug.debug ('is_a_parent ('||p_inv_type_parent||') = '||nm3flx.boolean_to_char (l_found));
   RETURN l_found;
--
END is_a_parent;
--
-----------------------------------------------------------------------------
--
FUNCTION attributes_have_changed (p_rec_iit_old nm_inv_items%ROWTYPE
                                 ,p_rec_iit_new nm_inv_items%ROWTYPE
                                 ) RETURN BOOLEAN IS
--
   c_rec_iit_old CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_old;
   c_rec_iit_new CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_new;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'attributes_have_changed');
--
   instantiate_for_inv_type (p_nit_inv_type => p_rec_iit_new.iit_inv_type);
--
--   nm_debug.debug('------------------------------------------------------------------------------');
--   nm3debug.debug_iit (p_rec_iit_old);
--   nm_debug.debug('------------------------------------------------------------------------------');
--   nm3debug.debug_iit (p_rec_iit_new);
--   nm_debug.debug('------------------------------------------------------------------------------');
--
   g_rec_iit_old  := p_rec_iit_old;
   g_rec_iit_new  := p_rec_iit_new;
   g_vals_changed := FALSE;
   nm3ddl.execute_tab_varchar (g_comparison_sql);
   g_rec_iit_old  := c_rec_iit_old;
   g_rec_iit_new  := c_rec_iit_new;
--
   nm_debug.proc_end (g_package_name,'attributes_have_changed');
--
--nm_debug.debug ('attributes_have_changed  = '||nm3flx.boolean_to_char (g_vals_changed));
   RETURN g_vals_changed;
--
END attributes_have_changed;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_iit_pair   (p_rec_iit_old nm_inv_items%ROWTYPE
                             ,p_rec_iit_new nm_inv_items%ROWTYPE
                             ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'process_iit_pair');
--
   g_rec_iit_old := p_rec_iit_old;
   g_rec_iit_new := p_rec_iit_new;
--
   instantiate_for_inv_type (p_rec_iit_new.iit_inv_type);
--
   FOR i IN 1..g_tab_child_types.COUNT
    LOOP
      create_each_child_item (g_tab_child_types(i));
   END LOOP;
--
   nm_debug.proc_end (g_package_name,'process_iit_pair');
--
END process_iit_pair;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_each_child_item (p_child_type nm_inv_types.nit_inv_type%TYPE) IS
--
   l_update_record       BOOLEAN := FALSE;
   l_insert_record       BOOLEAN := FALSE;
   l_rec_iit_child_old   nm_inv_items%ROWTYPE;
   l_rec_iit_child_empty nm_inv_items%ROWTYPE;
   c_rec_iit_parent CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_parent;
   c_rec_iit_child  CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_child;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_each_child_item');
--
   l_rec_iit_child_old := get_child_record (p_iit_ne_id_parent => g_rec_iit_new.iit_ne_id
                                           ,p_child_asset_type => p_child_type
                                           ,p_raise_not_found  => FALSE
                                           );
--
   g_rec_iit_child := l_rec_iit_child_empty;
--
   g_rec_iit_child.iit_inv_type    := p_child_type;
   g_rec_iit_child.iit_start_date  := g_rec_iit_new.iit_start_date;
   g_rec_iit_child.iit_admin_unit  := g_rec_iit_new.iit_admin_unit;
   g_rec_iit_child.iit_foreign_key := g_rec_iit_new.iit_primary_key;
--
   --
   -- move all the stuff into the global
   --
   instantiate_inv_type_pair (p_nit_inv_type_parent => g_rec_iit_new.iit_inv_type
                             ,p_nit_inv_type_child  => p_child_type
                             );
--
   g_rec_iit_parent := g_rec_iit_new;
   nm3ddl.execute_tab_varchar (g_formula_sql);
   g_rec_iit_parent := c_rec_iit_parent;
--
   IF l_rec_iit_child_old.iit_ne_id IS NOT NULL
    THEN -- i.e. there is one there already, so see if we need to change it
      l_update_record := attributes_have_changed (p_rec_iit_old => l_rec_iit_child_old
                                                 ,p_rec_iit_new => g_rec_iit_child
                                                 );
   ELSE
      l_insert_record := TRUE;
   END IF;
--
   IF l_insert_record
    THEN
      g_rec_iit_child.iit_ne_id    := nm3seq.next_ne_id_seq;
      nm3ins.ins_iit (g_rec_iit_child);
   ELSIF l_update_record
    THEN
      update_flex_attr_from_rowtype (p_iit_ne_id => l_rec_iit_child_old.iit_ne_id
                                    ,p_rec_iit   => g_rec_iit_child
                                    );
   END IF;
   g_rec_iit_child  := c_rec_iit_child;
--
   nm_debug.proc_end (g_package_name,'create_each_child_item');
--
END create_each_child_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_child_record (p_iit_ne_id_parent nm_inv_items.iit_ne_id%TYPE
                          ,p_child_asset_type nm_inv_types.nit_inv_type%TYPE
                          ,p_raise_not_found  BOOLEAN DEFAULT TRUE
                          ) RETURN nm_inv_items%ROWTYPE IS
   CURSOR cs_val (c_iit_ne_id_parent nm_inv_items.iit_ne_id%TYPE
                 ,c_child_asset_type nm_inv_types.nit_inv_type%TYPE
                 ) IS
   SELECT iit.*
    FROM  nm_inv_items          iit
         ,nm_inv_item_groupings iig
   WHERE  iig.iig_parent_id = c_iit_ne_id_parent
    AND   iig.iig_item_id   = iit.iit_ne_id
    AND   iit.iit_inv_type  = c_child_asset_type;
--
   l_retval nm_inv_items%ROWTYPE;
   l_found  BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_child_record');
--
   OPEN  cs_val (p_iit_ne_id_parent, p_child_asset_type);
   FETCH cs_val INTO l_retval;
   l_found := cs_val%FOUND;
   CLOSE cs_val;
--
   IF NOT l_found
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => nm3inv.get_nit_descr(p_child_asset_type)||' record for asset'
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'get_child_record');
--
   RETURN l_retval;
--
END get_child_record;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_inv_type_pair (p_nit_inv_type_parent nm_inv_types.nit_inv_type%TYPE
                                    ,p_nit_inv_type_child  nm_inv_types.nit_inv_type%TYPE
                                    ) IS
--
   CURSOR cs_formulae (c_nit_inv_type_parent xexor_derived_attributes.xda_nit_inv_type_parent%TYPE
                      ,c_nit_inv_type_child  xexor_derived_attributes.xda_nit_inv_type_child%TYPE
                      ) IS
   SELECT translate_formula_string(translate_formula_string(xda.xda_formula,c_nit_inv_type_child),c_nit_inv_type_parent,'Y') translated_formula
         ,xda.xda_formula
         ,NVL(ita_val.ita_attrib_name, xda.xda_ita_view_col_name) ita_attrib_name
         ,xda.xda_ita_view_col_name ita_view_col_name
    FROM  xexor_derived_attributes xda
         ,nm_inv_type_attribs      ita_val
   WHERE  xda.xda_nit_inv_type_parent   = c_nit_inv_type_parent
    AND   xda.xda_nit_inv_type_child    = c_nit_inv_type_child
    AND   ita_val.ita_inv_type      (+) = c_nit_inv_type_child
    AND   ita_val.ita_view_col_name (+) = xda.xda_ita_view_col_name
   ORDER BY xda_process_seq_no;
--
   l_tab_translated_formula nm3type.tab_varchar32767;
   l_tab_formula            nm3type.tab_varchar32767;
   l_tab_attrib_name        nm3type.tab_varchar30;
   l_tab_view_col_name      nm3type.tab_varchar30;
--
   c_g_rec_iit_child         CONSTANT VARCHAR2(30) := 'g_rec_iit_child';
   c_dot_g_rec_iit_child_dot CONSTANT VARCHAR2(32) := '.'||c_g_rec_iit_child||'.';
   c_rpad_len                CONSTANT PLS_INTEGER  := LENGTH(g_package_name||c_dot_g_rec_iit_child_dot)+30;
--
   l_attrib      nm_inv_type_attribs.ita_attrib_name%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'instantiate_inv_type_pair');
--
   IF  g_last_parent_inv_type != p_nit_inv_type_parent
    OR g_last_child_inv_type  != p_nit_inv_type_child
    THEN
--
      g_last_parent_inv_type := p_nit_inv_type_parent;
      g_last_child_inv_type  := p_nit_inv_type_child;
--
      OPEN  cs_formulae (c_nit_inv_type_parent => p_nit_inv_type_parent
                        ,c_nit_inv_type_child  => p_nit_inv_type_child
                        );
      FETCH cs_formulae
       BULK COLLECT
       INTO l_tab_translated_formula
           ,l_tab_formula
           ,l_tab_attrib_name
           ,l_tab_view_col_name;
      CLOSE cs_formulae;
--
      g_formula_sql.DELETE;
      nm3tab_varchar.append (g_formula_sql,'BEGIN',FALSE);
      IF l_tab_translated_formula.COUNT = 0
       THEN
         nm3tab_varchar.append (g_formula_sql,'   Null;');
      ELSE
         FOR i IN 1..l_tab_translated_formula.COUNT
          LOOP
            is_column_in_table (c_nm_inv_items,l_tab_attrib_name(i));
            nm3tab_varchar.append (g_formula_sql,'   -- '||l_tab_view_col_name(i)||' = '||l_tab_formula(i));
            nm3tab_varchar.append (g_formula_sql,'   '||RPAD(g_package_name||c_dot_g_rec_iit_child_dot||LOWER(l_tab_attrib_name(i)),c_rpad_len)||' := '||l_tab_translated_formula(i)||';');
            nm3tab_varchar.append (g_formula_sql,'   --');
         END LOOP;
      END IF;
      nm3tab_varchar.append (g_formula_sql,'END;');
   --
      g_tab_ita_child  := nm3inv.get_tab_ita (p_inv_type => p_nit_inv_type_child);
      g_update_sql.DELETE;
      nm3tab_varchar.append (g_update_sql,'DECLARE',FALSE);
      nm3tab_varchar.append (g_update_sql,'   l_rowid ROWID;');
      nm3tab_varchar.append (g_update_sql,'BEGIN');
      nm3tab_varchar.append (g_update_sql,'   l_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => '||c_old_rec_dot||'iit_ne_id);');
      nm3tab_varchar.append (g_update_sql,'   UPDATE nm_inv_items_all');
      nm3tab_varchar.append (g_update_sql,'    SET   iit_date_modified = iit_date_modified');
      FOR i IN 1..g_tab_ita_child.COUNT
       LOOP
         l_attrib := g_tab_ita_child(i).ita_attrib_name;
         nm3tab_varchar.append (g_update_sql,'         ,'||l_attrib||' = '||c_new_rec_dot||l_attrib);
      END LOOP;
      nm3tab_varchar.append (g_update_sql,'   WHERE  rowid = l_rowid;');
      nm3tab_varchar.append (g_update_sql,'END;');
   --
--      nm_debug.debug('*******************************************************************');
--      nm3tab_varchar.debug_tab_varchar (g_formula_sql);
--      nm_debug.debug('*******************************************************************');
--      nm3tab_varchar.debug_tab_varchar (g_update_sql);
--      nm_debug.debug('*******************************************************************');
--      nm_debug.debug_off;
   --
   END IF;
--
   nm_debug.proc_start (g_package_name,'instantiate_inv_type_pair');
--
END instantiate_inv_type_pair;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_for_inv_type (p_nit_inv_type nm_inv_types.nit_inv_type%TYPE) IS
--
   l_attrib      nm_inv_type_attribs.ita_attrib_name%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'instantiate_for_inv_type');
--
   IF g_last_inv_type != p_nit_inv_type
    THEN
   --
      g_last_inv_type := p_nit_inv_type;
      g_tab_ita       := nm3inv.get_tab_ita (p_inv_type => g_last_inv_type);
   --
      g_comparison_sql.DELETE;
      nm3tab_varchar.append (g_comparison_sql,'DECLARE',FALSE);
      nm3tab_varchar.append (g_comparison_sql,'   l_flex_identical BOOLEAN;');
      nm3tab_varchar.append (g_comparison_sql,'BEGIN');
      nm3tab_varchar.append (g_comparison_sql,'   l_flex_identical := (NVL('||c_old_rec_dot||'iit_ne_id,-1) = NVL('||c_new_rec_dot||'iit_ne_id,-1))');
      FOR i IN 1..g_tab_ita.COUNT
       LOOP
         l_attrib := g_tab_ita(i).ita_attrib_name;
         nm3tab_varchar.append (g_comparison_sql,'                 -- '||g_tab_ita(i).ita_view_col_name);
         nm3tab_varchar.append (g_comparison_sql,'                 AND ('||c_old_rec_dot||l_attrib||' = '||c_new_rec_dot||l_attrib);
         nm3tab_varchar.append (g_comparison_sql,'                    OR ('||c_old_rec_dot||l_attrib||' IS NULL AND '||c_new_rec_dot||l_attrib||' IS NULL)');
         nm3tab_varchar.append (g_comparison_sql,'                     )');
      END LOOP;
      nm3tab_varchar.append (g_comparison_sql,';',FALSE);
      nm3tab_varchar.append (g_comparison_sql,'    '||g_package_name||'.g_vals_changed := NOT (l_flex_identical);');
      nm3tab_varchar.append (g_comparison_sql,'END;');
   --
--      nm3tab_varchar.debug_tab_varchar (g_comparison_sql);
--
      SELECT xda_nit_inv_type_child
       BULK  COLLECT
       INTO  g_tab_child_types
       FROM  xexor_derived_attributes
      WHERE  xda_nit_inv_type_parent = p_nit_inv_type
      GROUP BY xda_nit_inv_type_child;
   --
   END IF;
--
   nm_debug.proc_end (g_package_name,'instantiate_for_inv_type');
--
END instantiate_for_inv_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_flex_attr_from_rowtype (p_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                                        ,p_rec_iit   nm_inv_items%ROWTYPE
                                        ) IS
--
   l_attrib      nm_inv_type_attribs.ita_attrib_name%TYPE;
--
   c_rec_iit_old CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_old;
   c_rec_iit_new CONSTANT nm_inv_items%ROWTYPE := g_rec_iit_new;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'update_flex_attr_from_rowtype');
--
   instantiate_for_inv_type (p_nit_inv_type => p_rec_iit.iit_inv_type);
--
   g_rec_iit_old.iit_ne_id := p_iit_ne_id;
   g_rec_iit_new           := p_rec_iit;
   nm3ddl.execute_tab_varchar (g_update_sql);
   g_rec_iit_old           := c_rec_iit_old;
   g_rec_iit_new           := c_rec_iit_new;
--
   nm_debug.proc_end (g_package_name,'update_flex_attr_from_rowtype');
--
END update_flex_attr_from_rowtype;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_formula_string (p_formula    VARCHAR2
                                  ,p_inv_type   nm_inv_types.nit_inv_type%TYPE
                                  ,p_is_parent  VARCHAR2 DEFAULT 'N'
                                  ) RETURN VARCHAR2 IS
--
   l_retval           nm3type.max_varchar2;
--
   l_sanity           PLS_INTEGER := 0;
   i                  PLS_INTEGER := 1;
   j                  PLS_INTEGER;
   l_ascii            PLS_INTEGER;
   l_view_col_name    nm3type.max_varchar2;
   l_attrib_name      nm3type.max_varchar2;
--
   c_formula_length   CONSTANT PLS_INTEGER  := LENGTH(p_formula);
   c_inv_type_dot     CONSTANT VARCHAR2(31) := p_inv_type||'.';
   c_inv_type_dot_len CONSTANT PLS_INTEGER  := LENGTH(c_inv_type_dot);
   c_record_name      CONSTANT VARCHAR2(30) := nm3flx.i_t_e (p_is_parent = 'N'
                                                            ,'g_rec_iit_child'
                                                            ,'g_rec_iit_parent'
                                                            );
--
BEGIN
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--nm_debug.debug('p_formula='||p_formula);
--nm_debug.debug('c_inv_type_dot_len='||c_inv_type_dot_len);
--nm_debug.debug('c_inv_type_dot='||c_inv_type_dot);
   WHILE i <= LENGTH(p_formula)
    LOOP
--
      l_sanity := l_sanity + 1;
      IF l_sanity > 4000
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 28
                       ,pi_supplementary_info => 'loop sanity check exceeded in '||g_package_name||'.translate_formula_string'
                       );
      END IF;
--
--nm_debug.debug('.....');
--nm_debug.debug('i='||i);
--nm_debug.debug(UPPER(SUBSTR(p_formula,i,c_inv_type_dot_len)));
      IF UPPER(SUBSTR(p_formula,i,c_inv_type_dot_len)) = c_inv_type_dot
       THEN
         l_retval := l_retval||g_package_name||'.'||c_record_name||'.';
         l_view_col_name := Null;
--         nm_debug.debug('FOR k IN ('||to_char(i+c_inv_type_dot_len)||')..'||to_char(LENGTH(p_formula)));
         FOR k IN (i+c_inv_type_dot_len)..c_formula_length
          LOOP
            l_ascii := ASCII(SUBSTR(p_formula,k,1));
            IF   l_ascii NOT BETWEEN 65 AND 90  -- A-Z
             AND l_ascii NOT BETWEEN 97 AND 122 -- a-z
             AND l_ascii != 95 -- _
             THEN
--               nm_debug.debug('getting out- l_ascii='||l_ascii||'...k='||k);
               j := k;
               EXIT;
            ELSE
               l_view_col_name := l_view_col_name||SUBSTR(p_formula,k,1);
            END IF;
            IF k = c_formula_length
             THEN
               j := k+1;
            END IF;
         END LOOP;
         IF l_view_col_name IS NOT NULL
          THEN
--            nm_debug.debug(l_view_col_name);
            IF LENGTH(l_view_col_name) > 30
             THEN
               hig.raise_ner (pi_appl               => nm3type.c_net
                             ,pi_id                 => 28
                             ,pi_supplementary_info => l_view_col_name||' is too long to be a valid ITA_VIEW_COL_NAME'
                             );
            END IF;
            l_view_col_name := UPPER(l_view_col_name);
            l_attrib_name   := nm3get.get_ita (pi_ita_inv_type      => p_inv_type
                                              ,pi_ita_view_col_name => l_view_col_name
                                              ,pi_raise_not_found   => FALSE
                                              ).ita_attrib_name;
            IF l_attrib_name IS NULL
             THEN
               IF is_column_in_table (c_nm_inv_items,l_view_col_name)
                THEN
                  l_attrib_name := l_view_col_name;
               ELSE
                  hig.raise_ner (pi_appl               => nm3type.c_hig
                                ,pi_id                 => 67
                                ,pi_supplementary_info =>            'NM_INV_TYPE_ATTRIBS:'
                                                          ||CHR(10)||'ITA_INV_TYPE='||p_inv_type
                                                          ||CHR(10)||'ITA_VIEW_COL_NAME='||l_view_col_name
                                );
               END IF;
            END IF;
            l_retval := l_retval||LOWER(l_attrib_name);
            i := j;
         ELSIF j = c_formula_length
          THEN
            i := j;
         END IF;
      ELSE
         l_retval := l_retval||SUBSTR(p_formula,i,1);
         i := i + 1;
      END IF;
--
   END LOOP;
--nm_debug.debug_off;
--
   RETURN l_retval;
--
END translate_formula_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE is_column_in_table (p_table_name  VARCHAR2
                             ,p_column_name VARCHAR2
                             ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                             ) IS
BEGIN
   IF NOT is_column_in_table (p_table_name  => p_table_name
                             ,p_column_name => p_column_name
                             ,p_table_owner => p_table_owner
                             )
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 147
                    ,pi_supplementary_info => p_table_owner||'.'||p_table_name||'.'||p_column_name
                    );
   END IF;
END is_column_in_table;
--
-----------------------------------------------------------------------------
--
FUNCTION is_column_in_table (p_table_name  VARCHAR2
                            ,p_column_name VARCHAR2
                            ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                            ) RETURN BOOLEAN IS
   CURSOR cs_atc IS
   SELECT 1
    FROM  all_tab_columns
   WHERE  owner       = p_table_owner
    AND   table_name  = p_table_name
    AND   column_name = p_column_name;
   l_dummy  PLS_INTEGER;
   l_retval BOOLEAN;
BEGIN
--
   OPEN  cs_atc;
   FETCH cs_atc INTO l_dummy;
   l_retval := cs_atc%FOUND;
   CLOSE cs_atc;
--
   RETURN l_retval;
--
END is_column_in_table;
--
-----------------------------------------------------------------------------
--
END xexor_derived_inv;
/
