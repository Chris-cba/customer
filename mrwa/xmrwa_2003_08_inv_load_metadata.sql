--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_2003_08_inv_load_metadata.sql	1.1 03/15/05
--       Module Name      : xmrwa_2003_08_inv_load_metadata.sql
--       Date into SCCS   : 05/03/15 00:45:16
--       Date fetched Out : 07/06/06 14:38:05
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
INSERT INTO nm_load_destinations
      (nld_id
      ,nld_table_name
      ,nld_table_short_name
      ,nld_insert_proc
      ,nld_validation_proc
      )
SELECT nm3seq.next_nld_id_seq
      ,a.table_name
      ,a.short_name
      ,a.insert_proc
      ,a.valid_proc
 FROM (SELECT 'XMRWA_END_DATE_INV_ITEM' table_name
             ,'XEIL' short_name
             ,'xmrwa_supplementary_inv_load.end_date_item' insert_proc
             ,'xmrwa_supplementary_inv_load.end_date_item_validate' valid_proc
        FROM  DUAL
       UNION ALL
       SELECT 'XMRWA_MODIFY_INV_ITEM_LOCATION' table_name
             ,'XMIL' short_name
             ,'xmrwa_supplementary_inv_load.relocate_item' insert_proc
             ,'xmrwa_supplementary_inv_load.relocate_item_validate' valid_proc
        FROM  DUAL
       UNION ALL
       SELECT 'XMRWA_MODIFY_ITEM_ATTR' table_name
             ,'XMIA' short_name
             ,'xmrwa_supplementary_inv_load.update_item_attr' insert_proc
             ,'xmrwa_supplementary_inv_load.update_item_attr_validate' valid_proc
        FROM  DUAL
      ) a
WHERE NOT EXISTS (SELECT 1
                   FROM  nm_load_destinations b
                  WHERE  a.table_name = b.nld_table_name
                 )
/


DECLARE
   --
   c_nlf_unique CONSTANT nm_load_files.nlf_unique%TYPE := 'END_ITEM_LOC';
   --
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
   --
   PROCEDURE add_nlfc (p_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                      ,p_nlfc_datatype     nm_load_file_cols.nlfc_datatype%TYPE
                      ,p_nlfc_varchar_size nm_load_file_cols.nlfc_varchar_size%TYPE
                      ,p_nlfc_mandatory    nm_load_file_cols.nlfc_mandatory%TYPE
                      ) IS
   BEGIN
      l_rec_nlfc.nlfc_seq_no        := l_rec_nlfc.nlfc_seq_no + 1;
      l_rec_nlfc.nlfc_holding_col   := p_nlfc_holding_col;
      l_rec_nlfc.nlfc_datatype      := p_nlfc_datatype;
      l_rec_nlfc.nlfc_varchar_size  := p_nlfc_varchar_size;
      l_rec_nlfc.nlfc_mandatory     := p_nlfc_mandatory;
      nm3ins.ins_nlfc (l_rec_nlfc);
   END add_nlfc;
   --
   PROCEDURE upd_nlcd (p_nlcd_dest_col   VARCHAR2
                      ,p_nlcd_source_col VARCHAR2
                      ) IS
   BEGIN
      UPDATE nm_load_file_col_destinations
       SET   nlcd_source_col = p_nlcd_source_col
      WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id
       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id
       AND   nlcd_dest_col   = p_nlcd_dest_col;
   END upd_nlcd;
   --
BEGIN
   --
   nm3del.del_nlf (pi_nlf_unique      => c_nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
   --
   l_rec_nlf.nlf_id        := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_unique    := c_nlf_unique;
   l_rec_nlf.nlf_descr     := 'End Inv Item Location';
   l_rec_nlf.nlf_path      := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter := ',';
   nm3ins.ins_nlf (l_rec_nlf);
   --
   l_rec_nlfc.nlfc_nlf_id        := l_rec_nlf.nlf_id;
   l_rec_nlfc.nlfc_seq_no        := 0;
   --
   add_nlfc('IIT_NE_ID',nm3type.c_number,Null,'N');
   add_nlfc('IIT_PRIMARY_KEY',nm3type.c_varchar,50,'N');
   add_nlfc('IIT_INV_TYPE',nm3type.c_varchar,4,'Y');
   add_nlfc('IIT_END_DATE',nm3type.c_varchar,11,'Y');
   add_nlfc('IIT_NOTE',nm3type.c_varchar,40,'N');
   --
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'XMRWA_END_DATE_INV_ITEM').nld_id;
   l_rec_nlfd.nlfd_seq    := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('IIT_NE_ID',l_rec_nlf.nlf_unique||'.IIT_NE_ID');
   upd_nlcd ('IIT_PRIMARY_KEY',l_rec_nlf.nlf_unique||'.IIT_PRIMARY_KEY');
   upd_nlcd ('IIT_INV_TYPE',l_rec_nlf.nlf_unique||'.IIT_INV_TYPE');
   upd_nlcd ('IIT_NOTE',l_rec_nlf.nlf_unique||'.IIT_NOTE');
   upd_nlcd ('IIT_END_DATE','TO_DATE('||l_rec_nlf.nlf_unique||'.IIT_END_DATE,'||nm3flx.string('DD/MM/YYYY')||')');
   --
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
   --
END;
/


DECLARE
   --
   c_nlf_unique CONSTANT nm_load_files.nlf_unique%TYPE := 'RELOCATE_ITEM';
   --
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
   --
   PROCEDURE add_nlfc (p_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                      ,p_nlfc_datatype     nm_load_file_cols.nlfc_datatype%TYPE
                      ,p_nlfc_varchar_size nm_load_file_cols.nlfc_varchar_size%TYPE
                      ,p_nlfc_mandatory    nm_load_file_cols.nlfc_mandatory%TYPE
                      ) IS
   BEGIN
      l_rec_nlfc.nlfc_seq_no        := l_rec_nlfc.nlfc_seq_no + 1;
      l_rec_nlfc.nlfc_holding_col   := p_nlfc_holding_col;
      l_rec_nlfc.nlfc_datatype      := p_nlfc_datatype;
      l_rec_nlfc.nlfc_varchar_size  := p_nlfc_varchar_size;
      l_rec_nlfc.nlfc_mandatory     := p_nlfc_mandatory;
      nm3ins.ins_nlfc (l_rec_nlfc);
   END add_nlfc;
   --
   PROCEDURE upd_nlcd (p_nlcd_dest_col   VARCHAR2
                      ,p_nlcd_source_col VARCHAR2
                      ) IS
   BEGIN
      UPDATE nm_load_file_col_destinations
       SET   nlcd_source_col = p_nlcd_source_col
      WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id
       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id
       AND   nlcd_dest_col   = p_nlcd_dest_col;
   END upd_nlcd;
   --
BEGIN
   --
   nm3del.del_nlf (pi_nlf_unique      => c_nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
   --
   l_rec_nlf.nlf_id        := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_unique    := c_nlf_unique;
   l_rec_nlf.nlf_descr     := 'Relocate Inv Item';
   l_rec_nlf.nlf_path      := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter := ',';
   nm3ins.ins_nlf (l_rec_nlf);
   --
   l_rec_nlfc.nlfc_nlf_id        := l_rec_nlf.nlf_id;
   l_rec_nlfc.nlfc_seq_no        := 0;
   --
   add_nlfc('IIT_NE_ID',nm3type.c_number,Null,'N');
   add_nlfc('IIT_PRIMARY_KEY',nm3type.c_varchar,50,'N');
   add_nlfc('IIT_INV_TYPE',nm3type.c_varchar,4,'Y');
   add_nlfc('NM_START_DATE',nm3type.c_varchar,11,'Y');
   add_nlfc('NE_GROUP',nm3type.c_varchar,30,'Y');
   add_nlfc('START_SLK',nm3type.c_number,Null,'Y');
   add_nlfc('END_SLK',nm3type.c_number,Null,'Y');
   add_nlfc('NE_SUB_CLASS',nm3type.c_varchar,4,'Y');
   --
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'XMRWA_MODIFY_INV_ITEM_LOCATION').nld_id;
   l_rec_nlfd.nlfd_seq    := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('IIT_NE_ID',l_rec_nlf.nlf_unique||'.IIT_NE_ID');
   upd_nlcd ('IIT_PRIMARY_KEY',l_rec_nlf.nlf_unique||'.IIT_PRIMARY_KEY');
   upd_nlcd ('IIT_INV_TYPE',l_rec_nlf.nlf_unique||'.IIT_INV_TYPE');
   upd_nlcd ('NM_START_DATE','TO_DATE('||l_rec_nlf.nlf_unique||'.NM_START_DATE,'||nm3flx.string('DD/MM/YYYY')||')');
   upd_nlcd ('NE_GROUP',l_rec_nlf.nlf_unique||'.NE_GROUP');
   upd_nlcd ('START_SLK',l_rec_nlf.nlf_unique||'.START_SLK');
   upd_nlcd ('END_SLK',l_rec_nlf.nlf_unique||'.END_SLK');
   upd_nlcd ('NE_SUB_CLASS',l_rec_nlf.nlf_unique||'.NE_SUB_CLASS');
   --
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
   --
END;
/

DECLARE
   --
   c_nlf_unique CONSTANT nm_load_files.nlf_unique%TYPE := 'UPD_ITEM_ATTR';
   --
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
   --
   PROCEDURE add_nlfc (p_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                      ,p_nlfc_datatype     nm_load_file_cols.nlfc_datatype%TYPE
                      ,p_nlfc_varchar_size nm_load_file_cols.nlfc_varchar_size%TYPE
                      ,p_nlfc_mandatory    nm_load_file_cols.nlfc_mandatory%TYPE
                      ) IS
   BEGIN
      l_rec_nlfc.nlfc_seq_no        := l_rec_nlfc.nlfc_seq_no + 1;
      l_rec_nlfc.nlfc_holding_col   := p_nlfc_holding_col;
      l_rec_nlfc.nlfc_datatype      := p_nlfc_datatype;
      l_rec_nlfc.nlfc_varchar_size  := p_nlfc_varchar_size;
      l_rec_nlfc.nlfc_mandatory     := p_nlfc_mandatory;
      nm3ins.ins_nlfc (l_rec_nlfc);
   END add_nlfc;
   --
   PROCEDURE upd_nlcd (p_nlcd_dest_col   VARCHAR2
                      ,p_nlcd_source_col VARCHAR2
                      ) IS
   BEGIN
      UPDATE nm_load_file_col_destinations
       SET   nlcd_source_col = p_nlcd_source_col
      WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id
       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id
       AND   nlcd_dest_col   = p_nlcd_dest_col;
   END upd_nlcd;
   --
BEGIN
   --
   nm3del.del_nlf (pi_nlf_unique      => c_nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
   --
   l_rec_nlf.nlf_id        := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_unique    := c_nlf_unique;
   l_rec_nlf.nlf_descr     := 'Update inv item attribute';
   l_rec_nlf.nlf_path      := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter := ',';
   nm3ins.ins_nlf (l_rec_nlf);
   --
   l_rec_nlfc.nlfc_nlf_id        := l_rec_nlf.nlf_id;
   l_rec_nlfc.nlfc_seq_no        := 0;
   --
   add_nlfc('IIT_NE_ID',nm3type.c_number,Null,'N');
   add_nlfc('IIT_PRIMARY_KEY',nm3type.c_varchar,50,'N');
   add_nlfc('IIT_INV_TYPE',nm3type.c_varchar,4,'Y');
   add_nlfc('IIT_START_DATE',nm3type.c_varchar,11,'Y');
   add_nlfc('ITA_VIEW_COL_NAME',nm3type.c_varchar,30,'Y');
   add_nlfc('IIT_NEW_VALUE',nm3type.c_varchar,500,'N');
   --
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'XMRWA_MODIFY_ITEM_ATTR').nld_id;
   l_rec_nlfd.nlfd_seq    := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('IIT_NE_ID',l_rec_nlf.nlf_unique||'.IIT_NE_ID');
   upd_nlcd ('IIT_PRIMARY_KEY',l_rec_nlf.nlf_unique||'.IIT_PRIMARY_KEY');
   upd_nlcd ('IIT_INV_TYPE',l_rec_nlf.nlf_unique||'.IIT_INV_TYPE');
   upd_nlcd ('IIT_START_DATE','TO_DATE('||l_rec_nlf.nlf_unique||'.IIT_START_DATE,'||nm3flx.string('DD/MM/YYYY')||')');
   upd_nlcd ('ITA_VIEW_COL_NAME',l_rec_nlf.nlf_unique||'.ITA_VIEW_COL_NAME');
   upd_nlcd ('IIT_NEW_VALUE',l_rec_nlf.nlf_unique||'.IIT_NEW_VALUE');
   --
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
   --
END;
/
