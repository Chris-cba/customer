DECLARE
--
-- ###############################################################
--
--  File           : 674.BIKE_PARTIAL_UPDATE.sql
--  Extracted from : HIGHWAYS@iam09fn.SGSPRDODB08
--  Extracted by   : HIGHWAYS
--  At             : 11-AUG-2014 15:48:49
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
   l_rec_nlf.nlf_unique           := 'BIKE_PARTIAL_UPDATE';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Cycle Track:  Line [Validate]';
   l_rec_nlf.nlf_path             := 'C:\';
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := 'DD-MON-YYYY';
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('OPERATION',nm3type.c_varchar,1,'Y',	1,Null);
   add_nlfc ('IIT_NE_ID',nm3type.c_number,Null,'Y',2,Null);
   add_nlfc ('TYPE',nm3type.c_varchar,50,'N',3,Null);
   add_nlfc ('ASSET_ID',nm3type.c_varchar,50,'N',4,Null);
   add_nlfc ('SOURCE_ID',nm3type.c_number,Null,'N',5,Null);
   add_nlfc ('SURFACE_MATERIAL',nm3type.c_varchar,25,'Y',6,Null);
   add_nlfc ('LENGTH_M',nm3type.c_number,Null,'N',7,Null);
   add_nlfc ('WIDTH_M',nm3type.c_number,Null,'N',8,Null);
   add_nlfc ('DATE_OF_CONSTRUCTION',nm3type.c_date,Null,'Y',9,Null);
   add_nlfc ('OWNER',nm3type.c_varchar,30,'Y',10,Null);
   add_nlfc ('CURRENT_MAINTENANCE_CONTRACT',nm3type.c_varchar,50,'Y',11,Null);
   add_nlfc ('CURRENTLY_MAINTAINED_BY',nm3type.c_varchar,50,'Y',12,Null);
   add_nlfc ('DEPARTURE__DAS_ID',nm3type.c_varchar,25,'N',13,Null);
   add_nlfc ('CONDITION_RATING_MANUAL',nm3type.c_number,Null,'N',14,Null);
   add_nlfc ('RISK_RATING',nm3type.c_number,Null,'N',15,Null);
   add_nlfc ('INSPECTION_TYPE_1_INTERVAL',nm3type.c_varchar,3,'N',16,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_1',nm3type.c_date,Null,'N',17,Null);
   add_nlfc ('INSPECTION_TYPE_2_INTERVAL',nm3type.c_varchar,3,'N',18,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_2',nm3type.c_date,Null,'N',19,Null);
   add_nlfc ('INSPECTION_TYPE_3_INTERVAL',nm3type.c_varchar,3,'N',20,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_3',nm3type.c_date,Null,'N',21,Null);
   add_nlfc ('INSPECTION_TYPE_4_INTERVAL',nm3type.c_varchar,3,'N',22,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_4',nm3type.c_date,Null,'N',23,Null);
   add_nlfc ('INSPECTION_TYPE_5_INTERVAL',nm3type.c_varchar,3,'N',24,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_5',nm3type.c_date,Null,'N',25,Null);
   add_nlfc ('INSPECTION_TYPE_6_INTERVAL',nm3type.c_varchar,3,'N',26,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_6',nm3type.c_date,Null,'N',27,Null);
   add_nlfc ('INSPECTION_TYPE_7_INTERVAL',nm3type.c_varchar,3,'N',28,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_7',nm3type.c_date,Null,'N',29,Null);
   add_nlfc ('INSPECTION_TYPE_8_INTERVAL',nm3type.c_varchar,3,'N',30,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_8',nm3type.c_date,Null,'N',31,Null);
   add_nlfc ('INSPECTION_TYPE_9_INTERVAL',nm3type.c_varchar,3,'N',32,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_9',nm3type.c_date,Null,'N',33,Null);
   add_nlfc ('INSPECTION_TYPE_10_INTERVAL',nm3type.c_varchar,3,'N',34,Null);
   add_nlfc ('DATE_LAST_INSPECTED_TYPE_10',nm3type.c_date,Null,'N',35,Null);
   add_nlfc ('LAST_MAINTAINED_DATE',nm3type.c_date,Null,'N',36,Null);
   add_nlfc ('ADDITIONAL_ASSET_INFORMATION',nm3type.c_varchar,500,'N',37,Null);
   add_nlfc ('XSP',nm3type.c_varchar,3,'Y',38,Null);
   add_nlfc ('ROUTENUMBER',nm3type.c_varchar,32,'Y',39,Null);
   add_nlfc ('FROM_MP',nm3type.c_varchar,32,'Y',40,Null);
   add_nlfc ('TO_MP',nm3type.c_varchar,32,'Y',41,Null);
   add_nlfc ('START_DATE',nm3type.c_date,Null,'Y',42,'DD-MON-YYYY');
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_HA_UPDATE_INV').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('OPERATION','BIKE_PARTIAL_UPDATE.OPERATION');
   upd_nlcd ('IIT_NE_ID','BIKE_PARTIAL_UPDATE.IIT_NE_ID');
   upd_nlcd ('IIT_INV_TYPE',''||CHR(39)||'BIKE'||CHR(39)||'');
   upd_nlcd ('IIT_PRIMARY_KEY','BIKE_PARTIAL_UPDATE.IIT_NE_ID');
   upd_nlcd ('IIT_START_DATE','BIKE_PARTIAL_UPDATE.START_DATE');
   upd_nlcd ('IIT_DATE_CREATED',Null);
   upd_nlcd ('IIT_DATE_MODIFIED',Null);
   upd_nlcd ('IIT_CREATED_BY',Null);
   upd_nlcd ('IIT_MODIFIED_BY',Null);
   upd_nlcd ('IIT_ADMIN_UNIT',''||CHR(39)||'44'||CHR(39)||'');
   upd_nlcd ('IIT_DESCR',Null);
   upd_nlcd ('IIT_END_DATE',Null);
   upd_nlcd ('IIT_FOREIGN_KEY',Null);
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
   upd_nlcd ('IIT_CHR_ATTRIB26',Null);
   upd_nlcd ('IIT_CHR_ATTRIB27',Null);
   upd_nlcd ('IIT_CHR_ATTRIB28','BIKE_PARTIAL_UPDATE.ASSET_ID');
   upd_nlcd ('IIT_CHR_ATTRIB29','BIKE_PARTIAL_UPDATE.OWNER');
   upd_nlcd ('IIT_CHR_ATTRIB30','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_1_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB31','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_2_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB32','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_3_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB33','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_4_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB34','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_5_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB35','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_6_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB36','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_7_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB37','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_8_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB38','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_9_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB39','BIKE_PARTIAL_UPDATE.INSPECTION_TYPE_10_INTERVAL');
   upd_nlcd ('IIT_CHR_ATTRIB40','UPPER(BIKE_PARTIAL_UPDATE.CURRENT_MAINTENANCE_CONTRACT)');
   upd_nlcd ('IIT_CHR_ATTRIB41','UPPER(BIKE_PARTIAL_UPDATE.CURRENTLY_MAINTAINED_BY)');
   upd_nlcd ('IIT_CHR_ATTRIB42','BIKE_PARTIAL_UPDATE.TYPE');
   upd_nlcd ('IIT_CHR_ATTRIB43','BIKE_PARTIAL_UPDATE.DEPARTURE__DAS_ID');
   upd_nlcd ('IIT_CHR_ATTRIB44',Null);
   upd_nlcd ('IIT_CHR_ATTRIB45',Null);
   upd_nlcd ('IIT_CHR_ATTRIB46','BIKE_PARTIAL_UPDATE.SURFACE_MATERIAL');
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
   upd_nlcd ('IIT_CHR_ATTRIB68','BIKE_PARTIAL_UPDATE.ADDITIONAL_ASSET_INFORMATION');
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
   upd_nlcd ('IIT_DATE_ATTRIB86','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_1');
   upd_nlcd ('IIT_DATE_ATTRIB87','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_2');
   upd_nlcd ('IIT_DATE_ATTRIB88','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_3');
   upd_nlcd ('IIT_DATE_ATTRIB89','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_4');
   upd_nlcd ('IIT_DATE_ATTRIB90','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_5');
   upd_nlcd ('IIT_DATE_ATTRIB91','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_6');
   upd_nlcd ('IIT_DATE_ATTRIB92','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_7');
   upd_nlcd ('IIT_DATE_ATTRIB93','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_8');
   upd_nlcd ('IIT_DATE_ATTRIB94','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_9');
   upd_nlcd ('IIT_DATE_ATTRIB95','BIKE_PARTIAL_UPDATE.DATE_LAST_INSPECTED_TYPE_10');
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
   upd_nlcd ('IIT_INSTAL_DATE','BIKE_PARTIAL_UPDATE.DATE_OF_CONSTRUCTION');
   upd_nlcd ('IIT_INVENT_DATE',Null);
   upd_nlcd ('IIT_INV_OWNERSHIP',Null);
   upd_nlcd ('IIT_ITEMCODE',Null);
   upd_nlcd ('IIT_LCO_LAMP_CONFIG_ID',Null);
   upd_nlcd ('IIT_LENGTH','BIKE_PARTIAL_UPDATE.LENGTH_M');
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
   upd_nlcd ('IIT_WIDTH','BIKE_PARTIAL_UPDATE.WIDTH_M');
   upd_nlcd ('IIT_XTRA_CHAR_1',Null);
   upd_nlcd ('IIT_XTRA_DATE_1','BIKE_PARTIAL_UPDATE.LAST_MAINTAINED_DATE');
   upd_nlcd ('IIT_XTRA_DOMAIN_1',Null);
   upd_nlcd ('IIT_XTRA_DOMAIN_TXT_1',Null);
   upd_nlcd ('IIT_XTRA_NUMBER_1',Null);
   upd_nlcd ('IIT_X_SECT','BIKE_PARTIAL_UPDATE.XSP');
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
   upd_nlcd ('IIT_NUM_ATTRIB103','BIKE_PARTIAL_UPDATE.RISK_RATING');
   upd_nlcd ('IIT_NUM_ATTRIB104','BIKE_PARTIAL_UPDATE.CONDITION_RATING_MANUAL');
   upd_nlcd ('IIT_NUM_ATTRIB105','BIKE_PARTIAL_UPDATE.SOURCE_ID');
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

