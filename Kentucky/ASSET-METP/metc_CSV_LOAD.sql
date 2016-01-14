DECLARE
--
-- ###############################################################
--
--  File           : 329.METC_CSV.sql
--  Extracted from : EXOR@ktky.BRSCOMODB03
--  Extracted by   : EXOR
--  At             : 11-JUN-2013 15:52:27
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
   l_rec_nlf.nlf_unique           := 'METC_CSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'CSV Loader to load the METC data';
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
   add_nlfc ('TYPE',nm3type.c_varchar,5,'N',1,Null);
   add_nlfc ('ATTRIBUTE',nm3type.c_varchar,50,'N',2,Null);
   add_nlfc ('ACCESS_GROUP',nm3type.c_varchar,20,'N',3,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'NM_INV_ITEMS').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('IIT_NE_ID','NM3SEQ.NEXT_NE_ID_SEQ');
   upd_nlcd ('IIT_INV_TYPE',''||CHR(39)||'METC'||CHR(39)||'');
   upd_nlcd ('IIT_PRIMARY_KEY','NM3SEQ.CURR_NE_ID_SEQ');
   upd_nlcd ('IIT_START_DATE','trunc(sysdate)');
   upd_nlcd ('IIT_DATE_CREATED',Null);
   upd_nlcd ('IIT_DATE_MODIFIED',Null);
   upd_nlcd ('IIT_CREATED_BY',Null);
   upd_nlcd ('IIT_MODIFIED_BY',Null);
   upd_nlcd ('IIT_ADMIN_UNIT','160');
   upd_nlcd ('IIT_DESCR',Null);
   upd_nlcd ('IIT_END_DATE',Null);
   upd_nlcd ('IIT_FOREIGN_KEY','xKYTC_METP_fk(METC_CSV.TYPE)');
   upd_nlcd ('IIT_LOCATED_BY',Null);
   upd_nlcd ('IIT_POSITION',Null);
   upd_nlcd ('IIT_X_COORD',Null);
   upd_nlcd ('IIT_Y_COORD',Null);
   upd_nlcd ('IIT_NUM_ATTRIB16',Null);
   upd_nlcd ('IIT_NUM_ATTRIB17',Null);
   upd_nlcd ('IIT_NUM_ATTRIB18',Null);
   upd_nlcd ('IIT_NUM_ATTRIB19',Null);
   upd_nlcd ('IIT_NUM_ATTRIB20',Null);
   upd_nlcd ('IIT_NUM_ATTRIB21',Null);
   upd_nlcd ('IIT_NUM_ATTRIB22',Null);
   upd_nlcd ('IIT_NUM_ATTRIB23',Null);
   upd_nlcd ('IIT_NUM_ATTRIB24',Null);
   upd_nlcd ('IIT_NUM_ATTRIB25',Null);
   upd_nlcd ('IIT_CHR_ATTRIB26','METC_CSV.TYPE');
   upd_nlcd ('IIT_CHR_ATTRIB27','METC_CSV.ATTRIBUTE');
   upd_nlcd ('IIT_CHR_ATTRIB28','METC_CSV.ACCESS_GROUP');
   upd_nlcd ('IIT_CHR_ATTRIB29',Null);
   upd_nlcd ('IIT_CHR_ATTRIB30',Null);
   upd_nlcd ('IIT_CHR_ATTRIB31',Null);
   upd_nlcd ('IIT_CHR_ATTRIB32',Null);
   upd_nlcd ('IIT_CHR_ATTRIB33',Null);
   upd_nlcd ('IIT_CHR_ATTRIB34',Null);
   upd_nlcd ('IIT_CHR_ATTRIB35',Null);
   upd_nlcd ('IIT_CHR_ATTRIB36',Null);
   upd_nlcd ('IIT_CHR_ATTRIB37',Null);
   upd_nlcd ('IIT_CHR_ATTRIB38',Null);
   upd_nlcd ('IIT_CHR_ATTRIB39',Null);
   upd_nlcd ('IIT_CHR_ATTRIB40',Null);
   upd_nlcd ('IIT_CHR_ATTRIB41',Null);
   upd_nlcd ('IIT_CHR_ATTRIB42',Null);
   upd_nlcd ('IIT_CHR_ATTRIB43',Null);
   upd_nlcd ('IIT_CHR_ATTRIB44',Null);
   upd_nlcd ('IIT_CHR_ATTRIB45',Null);
   upd_nlcd ('IIT_CHR_ATTRIB46',Null);
   upd_nlcd ('IIT_CHR_ATTRIB47',Null);
   upd_nlcd ('IIT_CHR_ATTRIB48',Null);
   upd_nlcd ('IIT_CHR_ATTRIB49',Null);
   upd_nlcd ('IIT_CHR_ATTRIB50',Null);
   upd_nlcd ('IIT_CHR_ATTRIB51',Null);
   upd_nlcd ('IIT_CHR_ATTRIB52',Null);
   upd_nlcd ('IIT_CHR_ATTRIB53',Null);
   upd_nlcd ('IIT_CHR_ATTRIB54',Null);
   upd_nlcd ('IIT_CHR_ATTRIB55',Null);
   upd_nlcd ('IIT_CHR_ATTRIB56',Null);
   upd_nlcd ('IIT_CHR_ATTRIB57',Null);
   upd_nlcd ('IIT_CHR_ATTRIB58',Null);
   upd_nlcd ('IIT_CHR_ATTRIB59',Null);
   upd_nlcd ('IIT_CHR_ATTRIB60',Null);
   upd_nlcd ('IIT_CHR_ATTRIB61',Null);
   upd_nlcd ('IIT_CHR_ATTRIB62',Null);
   upd_nlcd ('IIT_CHR_ATTRIB63',Null);
   upd_nlcd ('IIT_CHR_ATTRIB64',Null);
   upd_nlcd ('IIT_CHR_ATTRIB65',Null);
   upd_nlcd ('IIT_CHR_ATTRIB66',Null);
   upd_nlcd ('IIT_CHR_ATTRIB67',Null);
   upd_nlcd ('IIT_CHR_ATTRIB68',Null);
   upd_nlcd ('IIT_CHR_ATTRIB69',Null);
   upd_nlcd ('IIT_CHR_ATTRIB70',Null);
   upd_nlcd ('IIT_CHR_ATTRIB71',Null);
   upd_nlcd ('IIT_CHR_ATTRIB72',Null);
   upd_nlcd ('IIT_CHR_ATTRIB73',Null);
   upd_nlcd ('IIT_CHR_ATTRIB74',Null);
   upd_nlcd ('IIT_CHR_ATTRIB75',Null);
   upd_nlcd ('IIT_NUM_ATTRIB76',Null);
   upd_nlcd ('IIT_NUM_ATTRIB77',Null);
   upd_nlcd ('IIT_NUM_ATTRIB78',Null);
   upd_nlcd ('IIT_NUM_ATTRIB79',Null);
   upd_nlcd ('IIT_NUM_ATTRIB80',Null);
   upd_nlcd ('IIT_NUM_ATTRIB81',Null);
   upd_nlcd ('IIT_NUM_ATTRIB82',Null);
   upd_nlcd ('IIT_NUM_ATTRIB83',Null);
   upd_nlcd ('IIT_NUM_ATTRIB84',Null);
   upd_nlcd ('IIT_NUM_ATTRIB85',Null);
   upd_nlcd ('IIT_DATE_ATTRIB86',Null);
   upd_nlcd ('IIT_DATE_ATTRIB87',Null);
   upd_nlcd ('IIT_DATE_ATTRIB88',Null);
   upd_nlcd ('IIT_DATE_ATTRIB89',Null);
   upd_nlcd ('IIT_DATE_ATTRIB90',Null);
   upd_nlcd ('IIT_DATE_ATTRIB91',Null);
   upd_nlcd ('IIT_DATE_ATTRIB92',Null);
   upd_nlcd ('IIT_DATE_ATTRIB93',Null);
   upd_nlcd ('IIT_DATE_ATTRIB94',Null);
   upd_nlcd ('IIT_DATE_ATTRIB95',Null);
   upd_nlcd ('IIT_ANGLE',Null);
   upd_nlcd ('IIT_ANGLE_TXT',Null);
   upd_nlcd ('IIT_CLASS',Null);
   upd_nlcd ('IIT_CLASS_TXT',Null);
   upd_nlcd ('IIT_COLOUR',Null);
   upd_nlcd ('IIT_COLOUR_TXT',Null);
   upd_nlcd ('IIT_COORD_FLAG',Null);
   upd_nlcd ('IIT_DESCRIPTION',Null);
   upd_nlcd ('IIT_DIAGRAM',Null);
   upd_nlcd ('IIT_DISTANCE',Null);
   upd_nlcd ('IIT_END_CHAIN',Null);
   upd_nlcd ('IIT_GAP',Null);
   upd_nlcd ('IIT_HEIGHT',Null);
   upd_nlcd ('IIT_HEIGHT_2',Null);
   upd_nlcd ('IIT_ID_CODE',Null);
   upd_nlcd ('IIT_INSTAL_DATE',Null);
   upd_nlcd ('IIT_INVENT_DATE',Null);
   upd_nlcd ('IIT_INV_OWNERSHIP',Null);
   upd_nlcd ('IIT_ITEMCODE',Null);
   upd_nlcd ('IIT_LCO_LAMP_CONFIG_ID',Null);
   upd_nlcd ('IIT_LENGTH',Null);
   upd_nlcd ('IIT_MATERIAL',Null);
   upd_nlcd ('IIT_MATERIAL_TXT',Null);
   upd_nlcd ('IIT_METHOD',Null);
   upd_nlcd ('IIT_METHOD_TXT',Null);
   upd_nlcd ('IIT_NOTE',Null);
   upd_nlcd ('IIT_NO_OF_UNITS',Null);
   upd_nlcd ('IIT_OPTIONS',Null);
   upd_nlcd ('IIT_OPTIONS_TXT',Null);
   upd_nlcd ('IIT_OUN_ORG_ID_ELEC_BOARD',Null);
   upd_nlcd ('IIT_OWNER',Null);
   upd_nlcd ('IIT_OWNER_TXT',Null);
   upd_nlcd ('IIT_PEO_INVENT_BY_ID',Null);
   upd_nlcd ('IIT_PHOTO',Null);
   upd_nlcd ('IIT_POWER',Null);
   upd_nlcd ('IIT_PROV_FLAG',Null);
   upd_nlcd ('IIT_REV_BY',Null);
   upd_nlcd ('IIT_REV_DATE',Null);
   upd_nlcd ('IIT_TYPE',Null);
   upd_nlcd ('IIT_TYPE_TXT',Null);
   upd_nlcd ('IIT_WIDTH',Null);
   upd_nlcd ('IIT_XTRA_CHAR_1',Null);
   upd_nlcd ('IIT_XTRA_DATE_1',Null);
   upd_nlcd ('IIT_XTRA_DOMAIN_1',Null);
   upd_nlcd ('IIT_XTRA_DOMAIN_TXT_1',Null);
   upd_nlcd ('IIT_XTRA_NUMBER_1',Null);
   upd_nlcd ('IIT_X_SECT',Null);
   upd_nlcd ('IIT_DET_XSP',Null);
   upd_nlcd ('IIT_OFFSET',Null);
   upd_nlcd ('IIT_X',Null);
   upd_nlcd ('IIT_Y',Null);
   upd_nlcd ('IIT_Z',Null);
   upd_nlcd ('IIT_NUM_ATTRIB96',Null);
   upd_nlcd ('IIT_NUM_ATTRIB97',Null);
   upd_nlcd ('IIT_NUM_ATTRIB98',Null);
   upd_nlcd ('IIT_NUM_ATTRIB99',Null);
   upd_nlcd ('IIT_NUM_ATTRIB100',Null);
   upd_nlcd ('IIT_NUM_ATTRIB101',Null);
   upd_nlcd ('IIT_NUM_ATTRIB102',Null);
   upd_nlcd ('IIT_NUM_ATTRIB103',Null);
   upd_nlcd ('IIT_NUM_ATTRIB104',Null);
   upd_nlcd ('IIT_NUM_ATTRIB105',Null);
   upd_nlcd ('IIT_NUM_ATTRIB106',Null);
   upd_nlcd ('IIT_NUM_ATTRIB107',Null);
   upd_nlcd ('IIT_NUM_ATTRIB108',Null);
   upd_nlcd ('IIT_NUM_ATTRIB109',Null);
   upd_nlcd ('IIT_NUM_ATTRIB110',Null);
   upd_nlcd ('IIT_NUM_ATTRIB111',Null);
   upd_nlcd ('IIT_NUM_ATTRIB112',Null);
   upd_nlcd ('IIT_NUM_ATTRIB113',Null);
   upd_nlcd ('IIT_NUM_ATTRIB114',Null);
   upd_nlcd ('IIT_NUM_ATTRIB115',Null);
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

