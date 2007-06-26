DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_la_metadata.sql	1.1 03/15/05
--       Module Name      : xtnz_la_metadata.sql
--       Date into SCCS   : 05/03/15 03:46:08
--       Date fetched Out : 07/06/06 14:40:24
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   --
   c_nlf_unique CONSTANT nm_load_files.nlf_unique%TYPE := 'LA';
   c_start_date CONSTANT VARCHAR2(40) := 'TO_DATE('||nm3flx.string('01/01/1900')||','||nm3flx.string('DD/MM/YYYY')||')';
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
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_unique           := c_nlf_unique;
   l_rec_nlf.nlf_descr            := nm3get.get_nit (pi_nit_inv_type => c_nlf_unique).nit_descr;
   l_rec_nlf.nlf_path             := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter        := '|';
   l_rec_nlf.nlf_date_format_mask := 'DD/MM/YYYY';
   nm3ins.ins_nlf (l_rec_nlf);
   --
   l_rec_nlfc.nlfc_nlf_id  := l_rec_nlf.nlf_id;
   l_rec_nlfc.nlfc_seq_no  := 0;
   --
   add_nlfc ('LAR_SECTION_NUMBER',nm3type.c_varchar,500,'Y'); -- LAR Section Name
   add_nlfc ('LAR_STATUS',nm3type.c_varchar,500,'N'); -- LAR_Status
   add_nlfc ('REASON_FOR_DECLARING_LAR',nm3type.c_varchar,4000,'N'); -- Reason for declaring LAR
   add_nlfc ('LENGTH',nm3type.c_number,Null,'N'); -- Length
   add_nlfc ('TERRITORIAL_LOCAL_AUTHORITY',nm3type.c_varchar,500,'N'); -- Territorial Local Authority
   add_nlfc ('LAND_REGISTRY_OFFICE',nm3type.c_varchar,500,'N'); -- Land Registry Office
   add_nlfc ('GAZETTE_NUMBER',nm3type.c_varchar,500,'N'); -- Gazette Number
   add_nlfc ('PAGE_NO',nm3type.c_number,Null,'N'); -- Page_No
   add_nlfc ('DATE_OF_GAZETTE',nm3type.c_date,Null,'N'); -- Date of Gazette
   add_nlfc ('PLAN_REFERENCE',nm3type.c_varchar,500,'N'); -- Plan Reference
   add_nlfc ('TQP_REFERENCE',nm3type.c_varchar,500,'N'); -- TQP Reference
   add_nlfc ('FILE_REFERENCE',nm3type.c_varchar,500,'N'); -- File Reference
   add_nlfc ('NETWORK_CONSULTANT',nm3type.c_varchar,500,'N'); -- Network Consultant
   add_nlfc ('CONSULT_LETTER_DATE',nm3type.c_date,Null,'N'); -- Consult Letter date
   add_nlfc ('DRAFT_LETTER_DATE',nm3type.c_date,Null,'N'); -- Draft Letter Date
   add_nlfc ('MAORI_LAND_COURT_OFFICE',nm3type.c_varchar,500,'N'); -- Maori Land Court Office
--
   add_nlfc ('STATE_HIGHWAY',nm3type.c_varchar,3,'Y');
   add_nlfc ('START_RS',nm3type.c_varchar,4,'Y');
   add_nlfc ('START_MP',nm3type.c_number,Null,'Y');
   add_nlfc ('START_CARRIAGEWAY',nm3type.c_varchar,1,'Y');
   add_nlfc ('END_RS',nm3type.c_varchar,4,'Y');
   add_nlfc ('END_MP',nm3type.c_number,Null,'Y');
   add_nlfc ('END_CARRIAGEWAY',nm3type.c_varchar,1,'Y');
--
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'NM_INV_ITEMS').nld_id;
   l_rec_nlfd.nlfd_seq    := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('IIT_INV_TYPE',nm3flx.string(c_nlf_unique));
   upd_nlcd ('IIT_START_DATE',c_start_date); -- Effective Date
   upd_nlcd ('IIT_ADMIN_UNIT','xtnz_load_inv.get_rs_au(LPAD('||l_rec_nlf.nlf_unique||'.STATE_HIGHWAY,3,'||nm3flx.string('0')||'),LPAD('||l_rec_nlf.nlf_unique||'.START_RS,4,'||nm3flx.string('0')||'))'); -- AU
   upd_nlcd ('IIT_PRIMARY_KEY','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAR_SECTION_NUMBER)');
   upd_nlcd ('IIT_CHR_ATTRIB36','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAR_STATUS)');
   upd_nlcd ('IIT_CHR_ATTRIB66','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.REASON_FOR_DECLARING_LAR)');
   upd_nlcd ('IIT_NUM_ATTRIB99',l_rec_nlf.nlf_unique||'.LENGTH');
   upd_nlcd ('IIT_CHR_ATTRIB28','xtnz_load_inv.check_for_hig_contact('||l_rec_nlf.nlf_unique||'.TERRITORIAL_LOCAL_AUTHORITY)');
   upd_nlcd ('IIT_CHR_ATTRIB29','xtnz_load_inv.check_for_hig_contact('||l_rec_nlf.nlf_unique||'.LAND_REGISTRY_OFFICE)');
   upd_nlcd ('IIT_CHR_ATTRIB30','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.GAZETTE_NUMBER)');
   upd_nlcd ('IIT_CHR_ATTRIB31',l_rec_nlf.nlf_unique||'.PAGE_NO');
   upd_nlcd ('IIT_DATE_ATTRIB86',l_rec_nlf.nlf_unique||'.DATE_OF_GAZETTE');
   upd_nlcd ('IIT_CHR_ATTRIB32','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.PLAN_REFERENCE)');
   upd_nlcd ('IIT_CHR_ATTRIB33','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.TQP_REFERENCE)');
   upd_nlcd ('IIT_CHR_ATTRIB34','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.FILE_REFERENCE)');
   upd_nlcd ('IIT_CHR_ATTRIB35','xtnz_load_inv.check_for_hig_contact('||l_rec_nlf.nlf_unique||'.NETWORK_CONSULTANT)');
   upd_nlcd ('IIT_DATE_ATTRIB87',l_rec_nlf.nlf_unique||'.CONSULT_LETTER_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB88',l_rec_nlf.nlf_unique||'.DRAFT_LETTER_DATE');
   upd_nlcd ('IIT_CHR_ATTRIB67','xtnz_load_inv.check_for_hig_contact('||l_rec_nlf.nlf_unique||'.MAORI_LAND_COURT_OFFICE)');
   --
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'XTNZ_LOAD_INV_ON_ROUTE').nld_id;
   l_rec_nlfd.nlfd_seq    := 2;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('STATE_HWY','LPAD('||l_rec_nlf.nlf_unique||'.STATE_HIGHWAY,3,'||nm3flx.string('0')||')');
   upd_nlcd ('START_RS','LPAD('||l_rec_nlf.nlf_unique||'.START_RS,4,'||nm3flx.string('0')||')');
   upd_nlcd ('START_MP',l_rec_nlf.nlf_unique||'.START_MP');
   upd_nlcd ('START_CWY',l_rec_nlf.nlf_unique||'.START_CARRIAGEWAY');
   upd_nlcd ('END_RS','LPAD('||l_rec_nlf.nlf_unique||'.END_RS,4,'||nm3flx.string('0')||')');
   upd_nlcd ('END_MP',l_rec_nlf.nlf_unique||'.END_MP');
   upd_nlcd ('END_CWY',l_rec_nlf.nlf_unique||'.END_CARRIAGEWAY');
   upd_nlcd ('IIT_NE_ID','IIT.IIT_NE_ID');
   upd_nlcd ('IIT_INV_TYPE','IIT.IIT_INV_TYPE');
   upd_nlcd ('NM_START_DATE','IIT.IIT_START_DATE');
   --
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
   --
END;
/
