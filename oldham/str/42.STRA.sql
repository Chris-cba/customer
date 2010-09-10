DECLARE
--
-- ###############################################################
--
--  File           : 42.STRA.sql
--  Extracted from : ATLAS@oldhamsb.GBEXOR710
--  Extracted by   : ATLAS
--  At             : 09-SEP-2010 10:30:29
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
   l_rec_nlf.nlf_unique           := 'STRA';
--
   IF nm3get.get_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                     ,pi_raise_not_found => FALSE
                     ).nlf_id IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => l_rec_nlf.nlf_unique
                    );
   END IF;
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Structures - Assets';
   l_rec_nlf.nlf_path             := Null;
   l_rec_nlf.nlf_delimiter        := ',';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('BRIDGE_NUMBER',nm3type.c_number,Null,'N',1,Null);
   add_nlfc ('APPENDIX',nm3type.c_varchar,4,'N',2,Null);
   add_nlfc ('BRIDGE_NAME',nm3type.c_varchar,80,'N',3,Null);
   add_nlfc ('STRUCTURE_TYPE',nm3type.c_varchar,10,'N',4,Null);
   add_nlfc ('ADOPTED_HWAY_YN',nm3type.c_varchar,1,'N',5,Null);
   add_nlfc ('ROAD_CLASS',nm3type.c_varchar,7,'N',6,Null);
   add_nlfc ('LOCATION',nm3type.c_varchar,70,'N',7,Null);
   add_nlfc ('OS_MAP_REF',nm3type.c_varchar,11,'N',8,Null);
   add_nlfc ('STREET_GUIDE',nm3type.c_varchar,10,'N',9,Null);
   add_nlfc ('STREET_DESCRIPTION',nm3type.c_varchar,30,'N',10,Null);
   add_nlfc ('TOWN_NAME',nm3type.c_varchar,20,'N',11,Null);
   add_nlfc ('USRN',nm3type.c_number,Null,'N',12,Null);
   add_nlfc ('OWNER_HA',nm3type.c_varchar,17,'N',13,Null);
   add_nlfc ('OWNER_OMBC',nm3type.c_varchar,3,'N',14,Null);
   add_nlfc ('SPAN_METERS',nm3type.c_varchar,11,'N',15,Null);
   add_nlfc ('NUM_OF_SPANS',nm3type.c_number,Null,'N',16,Null);
   add_nlfc ('HWAY_OVER_UNDER_OBSTACLE',nm3type.c_varchar,6,'N',17,Null);
   add_nlfc ('OBSTACLE',nm3type.c_varchar,25,'N',18,Null);
   add_nlfc ('INITIAL_BCI_INSP_DATE',nm3type.c_date,Null,'N',19,'DD/MM/YYYY');
   add_nlfc ('SUBSEQUENT_BCI_REQUIRED',nm3type.c_varchar,1,'N',20,Null);
   add_nlfc ('SPECIAL_SAFETY_INSP_REQ',nm3type.c_varchar,1,'N',21,Null);
   add_nlfc ('SECOND_BCI_INSP_DATE',nm3type.c_date,Null,'N',22,'DD/MM/YYYY');
   add_nlfc ('GEN_INSP_DATE',nm3type.c_varchar,10,'N',23,Null);
   add_nlfc ('PI_REQUIRED',nm3type.c_varchar,1,'N',24,Null);
   add_nlfc ('CONFINED_SPACE',nm3type.c_varchar,1,'N',25,Null);
   add_nlfc ('PRIN_INSP_DATE',nm3type.c_varchar,11,'N',26,Null);
   add_nlfc ('PAINTING',nm3type.c_varchar,3,'N',27,Null);
   add_nlfc ('CONSTRUCTION_TYPE',nm3type.c_varchar,70,'N',28,Null);
   add_nlfc ('PARAPET_TYPE',nm3type.c_varchar,5,'N',29,Null);
   add_nlfc ('PARAPET_MATERIAL',nm3type.c_varchar,60,'N',30,Null);
   add_nlfc ('PARAPET_HEIGHT',nm3type.c_varchar,10,'N',31,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'V_NM_STRA').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('IIT_NE_ID','nm3seq.next_ne_id_seq');
   upd_nlcd ('IIT_INV_TYPE',''||CHR(39)||'STRA'||CHR(39)||'');
   upd_nlcd ('IIT_PRIMARY_KEY',Null);
   upd_nlcd ('IIT_START_DATE',''||CHR(39)||'01-JAN-1901'||CHR(39)||'');
   upd_nlcd ('IIT_DATE_CREATED',Null);
   upd_nlcd ('IIT_DATE_MODIFIED',Null);
   upd_nlcd ('IIT_CREATED_BY',Null);
   upd_nlcd ('IIT_MODIFIED_BY',Null);
   upd_nlcd ('IIT_ADMIN_UNIT','49');
   upd_nlcd ('IIT_DESCR',' x_ah_remove_extra_spaces(STRA.BRIDGE_NAME)');
   upd_nlcd ('IIT_NOTE',Null);
   upd_nlcd ('IIT_PEO_INVENT_BY_ID',Null);
   upd_nlcd ('NAU_UNIT_CODE',Null);
   upd_nlcd ('IIT_END_DATE',Null);
   upd_nlcd ('BRIDGE_NUMBER','STRA.BRIDGE_NUMBER');
   upd_nlcd ('APPENDIX','x_ombc_stra_get_appendix(STRA.APPENDIX)');
   upd_nlcd ('BRIDGE_NAME','STRA.BRIDGE_NAME');
   upd_nlcd ('STRUCTURE_TYPE','STRA.STRUCTURE_TYPE');
   upd_nlcd ('ADOPTED_HIGHWAY','STRA.ADOPTED_HWAY_YN');
   upd_nlcd ('ROAD_CLASS','STRA.ROAD_CLASS');
   upd_nlcd ('LOCATION','STRA.LOCATION');
   upd_nlcd ('OS_MAP_REF','STRA.OS_MAP_REF');
   upd_nlcd ('EASTING','x_ombc_stra_get_easting(STRA.OS_MAP_REF)');
   upd_nlcd ('NORTHING','x_ombc_stra_get_northing(STRA.OS_MAP_REF)');
   upd_nlcd ('STREET_GUIDE','STRA.STREET_GUIDE');
   upd_nlcd ('STREET_NAME','STRA.STREET_DESCRIPTION');
   upd_nlcd ('TOWN','STRA.TOWN_NAME');
   upd_nlcd ('USRN','STRA.USRN');
   upd_nlcd ('OWNER_HA','x_ombc_stra_get_owner_ha(STRA.OWNER_HA)');
   upd_nlcd ('OWNER_OMBC','trim(STRA.OWNER_OMBC)');
   upd_nlcd ('SPAN_METRES','STRA.SPAN_METERS');
   upd_nlcd ('NUM_SPANS','STRA.NUM_OF_SPANS');
   upd_nlcd ('OVER_UNDER_OBSTACLE','UPPER(TRIM(STRA.HWAY_OVER_UNDER_OBSTACLE))');
   upd_nlcd ('OBSTACLE','STRA.OBSTACLE');
   upd_nlcd ('INITIAL_BCI_INSP_DATE','STRA.INITIAL_BCI_INSP_DATE');
   upd_nlcd ('SUBSEQUENT_BCI_REQUIRED','STRA.SUBSEQUENT_BCI_REQUIRED');
   upd_nlcd ('SSI_REQUIRED','STRA.SPECIAL_SAFETY_INSP_REQ');
   upd_nlcd ('SECOND_BCI_INSP_DATE','STRA.SECOND_BCI_INSP_DATE');
   upd_nlcd ('GENERAL_INSPECTION_DATE','STRA.GEN_INSP_DATE');
   upd_nlcd ('P_I_REQUIRED','STRA.PI_REQUIRED');
   upd_nlcd ('CONFINED_SPACE','STRA.CONFINED_SPACE');
   upd_nlcd ('PRIN_INSP_DATE','STRA.PRIN_INSP_DATE');
   upd_nlcd ('PAINTING','SUBSTR(STRA.PAINTING,1,1)');
   upd_nlcd ('CONSTRUCTION_TYPE','STRA.CONSTRUCTION_TYPE');
   upd_nlcd ('PARAPET_TYPE','UPPER(SUBSTR(STRA.PARAPET_TYPE,1,2))');
   upd_nlcd ('PARAPET_MATERIAL','STRA.PARAPET_MATERIAL');
   upd_nlcd ('PARAPET_HEIGHT','STRA.PARAPET_HEIGHT');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

