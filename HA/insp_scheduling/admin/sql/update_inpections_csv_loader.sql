-
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/sql/update_inpections_csv_loader.sql-arc   1.0   Jun 06 2012 16:19:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   update_inpections_csv_loader.sql  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:19:30  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:32:56  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2012
-----------------------------------------------------------------------------
--

DECLARE
--
-- ###############################################################
--
--  File           : 544.INSPECTIONS_UPDATE.sql
--  Extracted from : HIGHWAYS@area51a.SGSPRDODB01
--  Extracted by   : HIGHWAYS
--  At             : 30-MAY-2012 13:52:17
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
   l_rec_nlf.nlf_unique           := 'INSPECTIONS_UPDATE';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Bulk Update of Inspection Assets';
   l_rec_nlf.nlf_path             := 'E:\exor_dir\area51a\asset_inspections\upload';
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('INSP_PRIMARY_KEY',nm3type.c_number,Null,'N',1,Null);
   add_nlfc ('INSP_DATE_INSPECTED',nm3type.c_date,Null,'N',2,Null);
   add_nlfc ('INSP_DEF_FOUND_YN',nm3type.c_varchar,3,'N',3,Null);
   add_nlfc ('INSP_INSPECTED_YN',nm3type.c_varchar,3,'N',4,Null);
   add_nlfc ('INSP_REASON_NOT_INSP',nm3type.c_varchar,500,'N',5,Null);
   add_nlfc ('INSP_CONDITION',nm3type.c_varchar,50,'N',6,Null);
   add_nlfc ('INSP_COND_COMMENT',nm3type.c_varchar,500,'N',7,Null);
   add_nlfc ('PARENT_ID',nm3type.c_number,Null,'N',8,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_HA_UPD_INSP').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('INSP_PRIMARY_KEY','INSPECTIONS_UPDATE.INSP_PRIMARY_KEY');
   upd_nlcd ('INSP_DATE_INSPECTED','INSPECTIONS_UPDATE.INSP_DATE_INSPECTED');
   upd_nlcd ('INSP_DEF_FOUND_YN','INSPECTIONS_UPDATE.INSP_DEF_FOUND_YN');
   upd_nlcd ('INSP_INSPECTED_YN','INSPECTIONS_UPDATE.INSP_INSPECTED_YN');
   upd_nlcd ('INSP_REASON_NOT_INSP','INSPECTIONS_UPDATE.INSP_REASON_NOT_INSP');
   upd_nlcd ('INSP_CONDITION','INSPECTIONS_UPDATE.INSP_CONDITION');
   upd_nlcd ('INSP_COND_COMMENT','INSPECTIONS_UPDATE.INSP_COND_COMMENT');
   upd_nlcd ('PARENT_ID','INSPECTIONS_UPDATE.PARENT_ID');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

