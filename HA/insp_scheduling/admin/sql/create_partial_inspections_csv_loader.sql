DECLARE
--
-- ###############################################################
--
--  File           : MCI_INSL_INSERT.sql
--  Path           : E:\exor\MAIDEV47\csv_loader
--  Extracted from : HIGHWAYS@maidev47.WARDEVDB1DY
--  Extracted by   : HIGHWAYS
--  At             : 20-JAN-2016 15:07:18
--
-- ###############################################################
--
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
--
   PROCEDURE add_nlfc (p_nlfc_holding_col      nm_load_file_cols.nlfc_holding_col%TYPE
                      ,p_nlfc_datatype         nm_load_file_cols.nlfc_datatype%TYPE
                      ,p_nlfc_varchar_size     nm_load_file_cols.nlfc_varchar_size%TYPE
                      ,p_nlfc_mandatory        nm_load_file_cols.nlfc_mandatory%TYPE
                      ,p_nlfc_seq_no           nm_load_file_cols.nlfc_seq_no%TYPE
                      ,p_nlfc_date_format_mask nm_load_file_cols.nlfc_date_format_mask%TYPE
                      ) IS
   BEGIN
      l_rec_nlfc.nlfc_seq_no           := p_nlfc_seq_no;
      l_rec_nlfc.nlfc_holding_col      := p_nlfc_holding_col;
      l_rec_nlfc.nlfc_datatype         := p_nlfc_datatype;
      l_rec_nlfc.nlfc_varchar_size     := p_nlfc_varchar_size;
      l_rec_nlfc.nlfc_mandatory        := p_nlfc_mandatory;
      l_rec_nlfc.nlfc_date_format_mask := p_nlfc_date_format_mask;
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
   l_rec_nlf.nlf_unique           := 'MCI_INSL_INSERT';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Bulk creation of Partial Inspections of Linear Assets';
   l_rec_nlf.nlf_path             := 'E:\exor\MAIDEV47\csv_loader';
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('INSPECTION_ID',nm3type.c_varchar,50,'N',1,Null);
   add_nlfc ('START_CHAINAGE',nm3type.c_number,Null,'N',2,Null);
   add_nlfc ('END_CHAINAGE',nm3type.c_number,Null,'N',3,Null);
   add_nlfc ('DATE_INSPECTED',nm3type.c_date,Null,'N',4,Null);
   add_nlfc ('DEFECTS_FOUND',nm3type.c_varchar,3,'N',5,Null);
   add_nlfc ('INSPECTION_COMPLETE',nm3type.c_varchar,3,'N',6,Null);
   add_nlfc ('CONDITION_RATING',nm3type.c_varchar,50,'N',7,Null);
   add_nlfc ('CONDITION_COMMENT',nm3type.c_varchar,500,'N',8,Null);
   add_nlfc ('START_EASTING',nm3type.c_number,Null,'N',9,Null);
   add_nlfc ('START_NORTHING',nm3type.c_number,Null,'N',10,Null);
   add_nlfc ('END_EASTING',nm3type.c_number,Null,'N',11,Null);
   add_nlfc ('END_NORTHING',nm3type.c_number,Null,'N',12,Null);
   add_nlfc ('SURVEY_DATE',nm3type.c_date,Null,'N',13,Null);
   add_nlfc ('SURVEY_TIME',nm3type.c_varchar,50,'N',14,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_HA_INS_INSL').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('INSL_START_CHAINAGE','MCI_INSL_INSERT.START_CHAINAGE');
   upd_nlcd ('INSL_END_CHAINAGE','MCI_INSL_INSERT.END_CHAINAGE');
   upd_nlcd ('INSL_DATE_INSPECTED','MCI_INSL_INSERT.DATE_INSPECTED');
   upd_nlcd ('INSL_DEF_FOUND','MCI_INSL_INSERT.DEFECTS_FOUND');
   upd_nlcd ('INSL_INSP_COMPLETE','MCI_INSL_INSERT.INSPECTION_COMPLETE');
   upd_nlcd ('INSL_CONDITION','MCI_INSL_INSERT.CONDITION_RATING');
   upd_nlcd ('INSL_CONDITION_COMMENT','MCI_INSL_INSERT.CONDITION_COMMENT');
   upd_nlcd ('INSL_START_EASTING','MCI_INSL_INSERT.START_EASTING');
   upd_nlcd ('INSL_START_NORTHING','MCI_INSL_INSERT.START_NORTHING');
   upd_nlcd ('INSL_END_EASTING','MCI_INSL_INSERT.END_EASTING');
   upd_nlcd ('INSL_END_NORTHING','MCI_INSL_INSERT.END_NORTHING');
   upd_nlcd ('INSL_SURVEY_DATE','MCI_INSL_INSERT.SURVEY_DATE');
   upd_nlcd ('INSL_SURVEY_TIME','MCI_INSL_INSERT.SURVEY_TIME');
   upd_nlcd ('INSL_INSP_INSPECTION_ID','MCI_INSL_INSERT.INSPECTION_ID');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

