
BEGIN


Insert into nm_load_destinations (NLD_ID,NLD_TABLE_NAME,NLD_TABLE_SHORT_NAME,NLD_INSERT_PROC,NLD_VALIDATION_PROC) values (nld_id_seq.nextval,'XNORFOLK_V_USER_ROLE','NORUR','XNORFOLK_USER_ROLE.CSV_LOADER',null);


-- INSERTING into NM_LOAD_DESTINATION_DEFAULTS
Insert into NM_LOAD_DESTINATION_DEFAULTS (NLDD_NLD_ID,NLDD_COLUMN_NAME,NLDD_VALUE) values (nld_id_seq.CURRVAL,'PROLE','No_Role');
Insert into NM_LOAD_DESTINATION_DEFAULTS (NLDD_NLD_ID,NLDD_COLUMN_NAME,NLDD_VALUE) values (nld_id_seq.CURRVAL,'PCOMMAND','None');
Insert into NM_LOAD_DESTINATION_DEFAULTS (NLDD_NLD_ID,NLDD_COLUMN_NAME,NLDD_VALUE) values (nld_id_seq.CURRVAL,'PUSER','No_User');
Insert into NM_LOAD_DESTINATION_DEFAULTS (NLDD_NLD_ID,NLDD_COLUMN_NAME,NLDD_VALUE) values (nld_id_seq.CURRVAL,'PADMIN_OPTION','N');

END;


/
commit;

DECLARE
--
-- ###############################################################
--
--  File           : 4502.XNOR_USER_ROLES.sql
--  Extracted from : TRANSINFO@transinf.GBEXOR740
--  Extracted by   : TRANSINFO
--  At             : 19-SEP-2012 19:19:02
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
   l_rec_nlf.nlf_unique           := 'XNOR_USER_ROLES';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'CSV Loader to modifiy exsiting user roles';
   l_rec_nlf.nlf_path             := Null;
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := 'DD-MON-YYYY';
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('PUSER',nm3type.c_varchar,50,'N',1,Null);
   add_nlfc ('PROLE',nm3type.c_varchar,50,'N',2,Null);
   add_nlfc ('PCOMMAND',nm3type.c_varchar,50,'N',3,Null);
   add_nlfc ('PADMIN_OPTION',nm3type.c_varchar,50,'N',4,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'XNORFOLK_V_USER_ROLE').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('PUSER','XNOR_USER_ROLES.PUSER');
   upd_nlcd ('PROLE','XNOR_USER_ROLES.PROLE');
   upd_nlcd ('PCOMMAND','XNOR_USER_ROLES.PCOMMAND');
   upd_nlcd ('PADMIN_OPTION','XNOR_USER_ROLES.PADMIN_OPTION');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

commit;

