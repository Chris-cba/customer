DECLARE
--
-- ###############################################################
--
--  File           : 328.VIP_LOADER.sql
--  Extracted from : ATLAS@ctdotsb.SGSPRDODB04
--  Extracted by   : ATLAS
--  At             : 11-JUN-2014 20:51:55
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
   l_rec_nlf.nlf_unique           := 'VIP_LOADER';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Maintenance Projects - Loader';
   l_rec_nlf.nlf_path             := 'c:\temp';
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('VIPID',nm3type.c_varchar,50,'N',1,Null);
   add_nlfc ('TOWN_ID',nm3type.c_varchar,50,'N',2,Null);
   add_nlfc ('YEAR',nm3type.c_varchar,50,'N',3,Null);
   add_nlfc ('DISTRICT',nm3type.c_varchar,50,'N',4,Null);
   add_nlfc ('SECT',nm3type.c_varchar,50,'N',5,Null);
   add_nlfc ('PROJECT_NUMBER',nm3type.c_varchar,50,'Y',6,Null);
   add_nlfc ('APP_FUNCT',nm3type.c_varchar,50,'N',7,Null);
   add_nlfc ('PROJECT_ID_LETTER',nm3type.c_varchar,50,'N',8,Null);
   add_nlfc ('ROAD_UNIQUE',nm3type.c_varchar,30,'Y',9,Null);
   add_nlfc ('ROUTE_SUFFIX_LETTER',nm3type.c_varchar,30,'N',10,Null);
   add_nlfc ('ROUTE_DIR',nm3type.c_varchar,50,'N',11,Null);
   add_nlfc ('TOWN1',nm3type.c_varchar,50,'N',12,Null);
   add_nlfc ('TOIWN2',nm3type.c_varchar,50,'N',13,Null);
   add_nlfc ('TOWN3',nm3type.c_varchar,50,'N',14,Null);
   add_nlfc ('TOWN4',nm3type.c_varchar,50,'N',15,Null);
   add_nlfc ('NUMBER_VIP',nm3type.c_varchar,50,'N',16,Null);
   add_nlfc ('TERMINI',nm3type.c_varchar,200,'N',17,Null);
   add_nlfc ('START_MP',nm3type.c_number,Null,'Y',18,Null);
   add_nlfc ('END_MP',nm3type.c_number,Null,'Y',19,Null);
   add_nlfc ('LMILE',nm3type.c_number,Null,'N',20,Null);
   add_nlfc ('CLASS_OF_MATERIAL',nm3type.c_varchar,50,'N',21,Null);
   add_nlfc ('DEPTH',nm3type.c_number,Null,'N',22,Null);
   add_nlfc ('PSR',nm3type.c_varchar,50,'N',23,Null);
   add_nlfc ('RATING_VIP',nm3type.c_varchar,50,'N',24,Null);
   add_nlfc ('ADT',nm3type.c_number,Null,'N',25,Null);
   add_nlfc ('COMP_2_LANE',nm3type.c_number,Null,'N',26,Null);
   add_nlfc ('CONTRACTOR',nm3type.c_varchar,50,'N',27,Null);
   add_nlfc ('SUBCONTRACTOR',nm3type.c_varchar,50,'N',28,Null);
   add_nlfc ('PURCHASE_ORDER',nm3type.c_varchar,50,'N',29,Null);
   add_nlfc ('PREP_WORK_START_DATE',nm3type.c_date,Null,'N',30,Null);
   add_nlfc ('PREP_WORK_END_DATE',nm3type.c_date,Null,'N',31,Null);
   add_nlfc ('PRECON_MEETING_DATE',nm3type.c_date,Null,'N',32,Null);
   add_nlfc ('MACHINE_START_DATE',nm3type.c_date,Null,'N',33,Null);
   add_nlfc ('MACHINE_END_DATE',nm3type.c_date,Null,'N',34,Null);
   add_nlfc ('HANDWORK_START_DATE',nm3type.c_date,Null,'N',35,Null);
   add_nlfc ('HANDWORK_END_DATE',nm3type.c_date,Null,'N',36,Null);
   add_nlfc ('INCIDENTALS_START_DATE',nm3type.c_date,Null,'N',37,Null);
   add_nlfc ('INCIDENTALS_END_DATE',nm3type.c_date,Null,'N',38,Null);
   add_nlfc ('REQUISITION_NUMBERS',nm3type.c_varchar,50,'N',39,Null);
   add_nlfc ('ESTIMATED_TONS',nm3type.c_number,Null,'N',40,Null);
   add_nlfc ('FINAL_TONS',nm3type.c_number,Null,'N',41,Null);
   add_nlfc ('ESTIMATED_PO_AMOUNT',nm3type.c_number,Null,'N',42,Null);
   add_nlfc ('FINAL_AMOUNT',nm3type.c_number,Null,'N',43,Null);
   add_nlfc ('REMARKS',nm3type.c_varchar,200,'N',44,Null);
   add_nlfc ('CANCELLED',nm3type.c_varchar,10,'N',45,Null);
   add_nlfc ('LAST_VIP_UPDATE',nm3type.c_date,Null,'N',46,Null);
   add_nlfc ('INITIAL_VIP_DATE',nm3type.c_date,Null,'N',47,Null);
   add_nlfc ('LAST_VIP_UPDATER',nm3type.c_varchar,50,'N',48,Null);
   add_nlfc ('SPRING_SUMMER_PLAN',nm3type.c_varchar,50,'N',49,Null);
   add_nlfc ('NIGHT_PAVING_FLAG',nm3type.c_varchar,50,'N',50,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'NM_INV_ITEMS').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('IIT_NE_ID','NM3NET.GET_NEXT_NE_ID');
   upd_nlcd ('IIT_INV_TYPE',''||CHR(39)||'VIP'||CHR(39)||'');
   upd_nlcd ('IIT_PRIMARY_KEY','VIP_LOADER.VIPID');
   upd_nlcd ('IIT_START_DATE',''||CHR(39)||'01-JAN-1901'||CHR(39)||'');
   upd_nlcd ('IIT_DATE_CREATED',Null);
   upd_nlcd ('IIT_DATE_MODIFIED',Null);
   upd_nlcd ('IIT_CREATED_BY',Null);
   upd_nlcd ('IIT_MODIFIED_BY',Null);
   upd_nlcd ('IIT_ADMIN_UNIT','nm3get.get_nau(pi_nau_unit_code=>'||CHR(39)||'CTA'||CHR(39)||',pi_NAU_ADMIN_TYPE=>'||CHR(39)||'AST'||CHR(39)||').nau_admin_unit');
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
   upd_nlcd ('IIT_CHR_ATTRIB26','VIP_LOADER.YEAR');
   upd_nlcd ('IIT_CHR_ATTRIB27','VIP_LOADER.SECT');
   upd_nlcd ('IIT_CHR_ATTRIB28','substr(VIP_LOADER.PROJECT_NUMBER, 1,3)||'||CHR(39)||'-'||CHR(39)||'||substr(VIP_LOADER.PROJECT_NUMBER,4,3)');
   upd_nlcd ('IIT_CHR_ATTRIB29','VIP_LOADER.PROJECT_ID_LETTER');
   upd_nlcd ('IIT_CHR_ATTRIB30','VIP_LOADER.VIPID');
   upd_nlcd ('IIT_CHR_ATTRIB31','VIP_LOADER.CLASS_OF_MATERIAL');
   upd_nlcd ('IIT_CHR_ATTRIB32','VIP_LOADER.TOWN_ID');
   upd_nlcd ('IIT_CHR_ATTRIB33','VIP_LOADER.DISTRICT');
   upd_nlcd ('IIT_CHR_ATTRIB34','VIP_LOADER.APP_FUNCT');
   upd_nlcd ('IIT_CHR_ATTRIB35','VIP_LOADER.ROUTE_DIR');
   upd_nlcd ('IIT_CHR_ATTRIB36','VIP_LOADER.NUMBER_VIP');
   upd_nlcd ('IIT_CHR_ATTRIB37','VIP_LOADER.PSR');
   upd_nlcd ('IIT_CHR_ATTRIB38','VIP_LOADER.RATING_VIP');
   upd_nlcd ('IIT_CHR_ATTRIB39','VIP_LOADER.CONTRACTOR');
   upd_nlcd ('IIT_CHR_ATTRIB40','VIP_LOADER.SUBCONTRACTOR');
   upd_nlcd ('IIT_CHR_ATTRIB41','VIP_LOADER.PURCHASE_ORDER');
   upd_nlcd ('IIT_CHR_ATTRIB42','VIP_LOADER.REQUISITION_NUMBERS');
   upd_nlcd ('IIT_CHR_ATTRIB43','VIP_LOADER.LAST_VIP_UPDATER');
   upd_nlcd ('IIT_CHR_ATTRIB44','VIP_LOADER.SPRING_SUMMER_PLAN');
   upd_nlcd ('IIT_CHR_ATTRIB45','VIP_LOADER.NIGHT_PAVING_FLAG');
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
   upd_nlcd ('IIT_CHR_ATTRIB56','VIP_LOADER.TERMINI');
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
   upd_nlcd ('IIT_DATE_ATTRIB86','VIP_LOADER.PREP_WORK_START_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB87','VIP_LOADER.PREP_WORK_END_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB88','VIP_LOADER.PRECON_MEETING_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB89','VIP_LOADER.MACHINE_START_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB90','VIP_LOADER.MACHINE_END_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB91','VIP_LOADER.HANDWORK_START_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB92','VIP_LOADER.HANDWORK_END_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB93','VIP_LOADER.INCIDENTALS_START_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB94','VIP_LOADER.INCIDENTALS_END_DATE');
   upd_nlcd ('IIT_DATE_ATTRIB95','VIP_LOADER.LAST_VIP_UPDATE');
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
   upd_nlcd ('IIT_XTRA_DATE_1','VIP_LOADER.INITIAL_VIP_DATE');
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
   upd_nlcd ('IIT_NUM_ATTRIB100','VIP_LOADER.LMILE');
   upd_nlcd ('IIT_NUM_ATTRIB101','VIP_LOADER.DEPTH');
   upd_nlcd ('IIT_NUM_ATTRIB102','VIP_LOADER.ADT');
   upd_nlcd ('IIT_NUM_ATTRIB103','VIP_LOADER.COMP_2_LANE');
   upd_nlcd ('IIT_NUM_ATTRIB104','VIP_LOADER.ESTIMATED_TONS');
   upd_nlcd ('IIT_NUM_ATTRIB105','VIP_LOADER.FINAL_TONS');
   upd_nlcd ('IIT_NUM_ATTRIB106','VIP_LOADER.ESTIMATED_PO_AMOUNT');
   upd_nlcd ('IIT_NUM_ATTRIB107','VIP_LOADER.FINAL_AMOUNT');
   upd_nlcd ('IIT_NUM_ATTRIB108',Null);
   upd_nlcd ('IIT_NUM_ATTRIB109',Null);
   upd_nlcd ('IIT_NUM_ATTRIB110',Null);
   upd_nlcd ('IIT_NUM_ATTRIB111',Null);
   upd_nlcd ('IIT_NUM_ATTRIB112',Null);
   upd_nlcd ('IIT_NUM_ATTRIB113',Null);
   upd_nlcd ('IIT_NUM_ATTRIB114',Null);
   upd_nlcd ('IIT_NUM_ATTRIB115',Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_LOAD_INV_MEM_ON_ELEMENT').nld_id;
   l_rec_nlfd.nlfd_seq            := 2;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('NE_UNIQUE','VIP_LOADER.ROAD_UNIQUE || '||CHR(39)||'[]'||CHR(39)||' || VIP_LOADER.ROUTE_SUFFIX_LETTER || '||CHR(39)||'[]'||CHR(39)||' || VIP_LOADER.ROUTE_DIR');
   upd_nlcd ('NE_NT_TYPE',''||CHR(39)||'RTE'||CHR(39)||'');
   upd_nlcd ('BEGIN_MP','VIP_LOADER.START_MP');
   upd_nlcd ('END_MP','VIP_LOADER.END_MP');
   upd_nlcd ('IIT_NE_ID','IIT.IIT_NE_ID');
   upd_nlcd ('IIT_INV_TYPE',''||CHR(39)||'VIP'||CHR(39)||'');
   upd_nlcd ('NM_START_DATE','NM3USER.GET_EFFECTIVE_DATE');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

