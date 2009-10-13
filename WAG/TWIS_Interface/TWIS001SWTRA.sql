DECLARE
--
-- ###############################################################
--
--  File           : 43.TWIS001SWTRA.sql
--  Path           : d:\databases\wag\mai3863sql
--  Extracted from : WAG@wagsb.GBEXOR740
--  Extracted by   : WAG
--  At             : 08-OCT-2009 12:57:11
--
-- ###############################################################
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/WAG/TWIS_Interface/TWIS001SWTRA.sql-arc   3.1   Oct 13 2009 10:08:38   Ian Turnbull  $
--       Module Name      : $Workfile:   TWIS001SWTRA.sql  $
--       Date into PVCS   : $Date:   Oct 13 2009 10:08:38  $
--       Date fetched Out : $Modtime:   Oct 13 2009 10:08:12  $
--       PVCS Version     : $Revision:   3.1  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
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
   l_rec_nlf.nlf_unique           := 'TWIS001SWTRA';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'TWIS Loader Interface';
   l_rec_nlf.nlf_path             := 'd:\databases\wag\mai3863sql';
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('TIL_SCHEME_TYPE',nm3type.c_varchar,255,'Y',1,Null);
   add_nlfc ('TIL_ROUTE_NUMBER',nm3type.c_varchar,255,'Y',2,Null);
   add_nlfc ('TIL_SCHEME_NO',nm3type.c_varchar,10,'Y',3,Null);
   add_nlfc ('TIL_DESCRIPTION',nm3type.c_varchar,254,'Y',4,Null);
   add_nlfc ('TIL_APPROVED_CODE',nm3type.c_number,Null,'Y',5,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_WAG_TWIS').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('TIL_SCHEME_TYPE','TWIS001SWTRA.TIL_SCHEME_TYPE');
   upd_nlcd ('TIL_ROUTE_NUMBER','TWIS001SWTRA.TIL_ROUTE_NUMBER');
   upd_nlcd ('TIL_SCHEME_NUMBER','TWIS001SWTRA.TIL_SCHEME_NO');
   upd_nlcd ('TIL_DESCRIPTION','TWIS001SWTRA.TIL_DESCRIPTION');
   upd_nlcd ('TIL_APPROVED_CODE','TWIS001SWTRA.TIL_APPROVED_CODE');
   upd_nlcd ('TIL_AGENCY',''||CHR(39)||'15'||CHR(39)||'');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

