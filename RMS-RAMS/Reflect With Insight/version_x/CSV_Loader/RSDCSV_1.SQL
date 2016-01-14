DECLARE
--
-- ###############################################################
--
--  File           : 2193.RSDCSV.sql
--  Extracted from : RAMS@RAMS.ramsdb1
--  Extracted by   : RAMS
--  At             : 06-JAN-2015 08:37:36
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
   l_rec_nlf.nlf_unique           := 'RSDCSV';
--
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
--
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr            := 'Routine Services Data CSV Loader';
   l_rec_nlf.nlf_path             := Null;
   l_rec_nlf.nlf_delimiter        := '|';
   l_rec_nlf.nlf_date_format_mask := Null;
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
add_nlfc ('RSD_VENDOR_CODE',nm3type.c_varchar,4,'Y',1,Null);
ADD_NLFC ('RSD_REFERENCE_ID' ,NM3TYPE.C_NUMBER,NULL,'N',2, NULL);
ADD_NLFC ('RSD_ROAD_NUMBER' ,NM3TYPE.C_VARCHAR,125,'N',3, NULL);
ADD_NLFC ('RSD_ASSET_TYPE_CODE' ,NM3TYPE.C_VARCHAR,5,'N',4, NULL);
ADD_NLFC ('RSD_KEY_ID' ,NM3TYPE.C_NUMBER,NULL,'N',5, NULL);
ADD_NLFC ('RSD_ASSET_DESCRIPTION' ,NM3TYPE.C_VARCHAR,125,'N',6, NULL);
ADD_NLFC ('RSD_ROAD_MAINTENANCE_SEGMENT' ,NM3TYPE.C_VARCHAR,30,'N',7, NULL);
ADD_NLFC ('RSD_DATE_OF_CREATION' ,NM3TYPE.C_DATE,NULL,'N',8, NULL);
ADD_NLFC ('RSD_TIME_OF_CREATION' ,NM3TYPE.C_VARCHAR,5,'N',9, NULL);
ADD_NLFC ('RSD_LONGITUDE' ,NM3TYPE.C_NUMBER,NULL,'N',10, NULL);
ADD_NLFC ('RSD_LATITUDE' ,NM3TYPE.C_NUMBER,NULL,'N',11, NULL);
ADD_NLFC ('RSD_LGA' ,NM3TYPE.C_VARCHAR,50,'N',12, NULL);
ADD_NLFC ('RSAM_ACCOMPLISHMENT_NUMBER' ,NM3TYPE.C_VARCHAR,30,'N',13, NULL);
ADD_NLFC ('RSAM_ACCOMPLISHMENT_ID' ,NM3TYPE.C_NUMBER,NULL,'N',14, NULL);
ADD_NLFC ('RSAM_ACCOMPLISHMENT_DATE' ,NM3TYPE.C_DATE,NULL,'N',15, NULL);
ADD_NLFC ('RSAM_ACTIVITY' ,NM3TYPE.C_NUMBER,NULL,'N',16, NULL);
ADD_NLFC ('RSAM_ACTIVITY_NAME' ,NM3TYPE.C_VARCHAR,255,'N',17, NULL);
ADD_NLFC ('RSAM_ACTIVITY_TYPE' ,NM3TYPE.C_VARCHAR,30,'N',18, NULL);
ADD_NLFC ('RSAM_QUANTITY_ACCOMPLISHED' ,NM3TYPE.C_NUMBER,NULL,'N',19, NULL);
ADD_NLFC ('RSAM_UNIT_OF_MEASURE' ,NM3TYPE.C_VARCHAR,30,'N',20, NULL);
ADD_NLFC ('RSAM_SECOND_QUANTITY' ,NM3TYPE.C_NUMBER,NULL,'N',21, NULL);
ADD_NLFC ('RSAM_SECOND_UNIT_OF_MEASURE' ,NM3TYPE.C_VARCHAR,30,'N',22, NULL);
ADD_NLFC ('RSAM_ACCOMPLISHMENT_COMMENTS' ,NM3TYPE.C_VARCHAR,255,'N',23, NULL);
ADD_NLFC ('RSAM_TIME_WORK' ,NM3TYPE.C_NUMBER,NULL,'N',24, NULL);
ADD_NLFC ('RSAM_COMPLETED' ,NM3TYPE.C_VARCHAR,1,'N',25, NULL);
ADD_NLFC ('RSDE_DEFECT_NUMBER' ,NM3TYPE.C_VARCHAR,12,'N',26, NULL);
ADD_NLFC ('RSDE_DEFECT_ID' ,NM3TYPE.C_NUMBER,NULL,'N',27, NULL);
ADD_NLFC ('RSDE_DATE_RAISED' ,NM3TYPE.C_DATE,NULL,'N',28, NULL);
ADD_NLFC ('RSDE_TIME_RAISED' ,NM3TYPE.C_VARCHAR,5,'N',29, NULL);
ADD_NLFC ('CRSDE_AUSE_OF_DEFECT' ,NM3TYPE.C_VARCHAR,30,'N',30, NULL);
ADD_NLFC ('RSDE_REOCCURRING_DEFECT' ,NM3TYPE.C_VARCHAR,1,'N',31, NULL);
ADD_NLFC ('RSDE_DEFECT_TYPE' ,NM3TYPE.C_VARCHAR,50,'N',32, NULL);
ADD_NLFC ('RSDE_POSITION_WITHIN_LOCATION' ,NM3TYPE.C_NUMBER,NULL,'N',33, NULL);
ADD_NLFC ('RSDE_DEFECT_COMPLETION_DATE' ,NM3TYPE.C_DATE,NULL,'N',34, NULL);
ADD_NLFC ('RSDE_DEFECT_COMPLETION_TIME' ,NM3TYPE.C_VARCHAR,5,'N',35, NULL);
ADD_NLFC ('RSDE_ESTIMATED_QNT_FOR_REPAIR' ,NM3TYPE.C_NUMBER,NULL,'N',36, NULL);
ADD_NLFC ('RSDE_UNIT_OF_MEASURE_RSDE' ,NM3TYPE.C_VARCHAR,30,'N',37, NULL);
ADD_NLFC ('RSDE_ESTIMATED_SECOND_QUANTITY' ,NM3TYPE.C_NUMBER,NULL,'N',38, NULL);
ADD_NLFC ('RSDE_SECOND_UNIT_OF_MEASURE' ,NM3TYPE.C_VARCHAR,30,'N',39, NULL);
ADD_NLFC ('RSDE_DEFECT_COMMENTS' ,NM3TYPE.C_VARCHAR,255,'N',40, NULL);
ADD_NLFC ('RSIC_INCIDENT_ID' ,NM3TYPE.C_NUMBER,NULL,'N',41, NULL);
ADD_NLFC ('RSIC_INCIDENT_TYPE' ,NM3TYPE.C_VARCHAR,30,'N',42, NULL);
ADD_NLFC ('RSIC_DATE_CALL_RECEIVED' ,NM3TYPE.C_DATE,NULL,'N',43, NULL);
ADD_NLFC ('RSIC_TIME_CALL_RECEIVED' ,NM3TYPE.C_VARCHAR,5,'N',44, NULL);
ADD_NLFC ('RSIC_INCIDENT_DESCRIPTION' ,NM3TYPE.C_VARCHAR,255,'N',45, NULL);
ADD_NLFC ('RSIC_ADVICE_RECEIVED_FROM' ,NM3TYPE.C_VARCHAR,50,'N',46, NULL);
ADD_NLFC ('RSIC_CONDITION_AT_INCIDENT' ,NM3TYPE.C_VARCHAR,50,'N',47, NULL);
ADD_NLFC ('RSIC_ACTION_REQUIRED' ,NM3TYPE.C_VARCHAR,50,'N',48, NULL);
ADD_NLFC ('RSIC_DAMAGE_TO_PROPERTY' ,NM3TYPE.C_VARCHAR,30,'N',49, NULL);
ADD_NLFC ('RSIN_INCIDENT_COMPLETION_DATE' ,NM3TYPE.C_DATE,NULL,'N',50, NULL);
ADD_NLFC ('RSIN_INCIDENT_COMPLETION_TIME' ,NM3TYPE.C_VARCHAR,5,'N',51, NULL);
ADD_NLFC ('RSIN_INSPECTION_NUMBER' ,NM3TYPE.C_VARCHAR,30,'N',52, NULL);
ADD_NLFC ('RSIN_INSPECTION_ID' ,NM3TYPE.C_NUMBER,NULL,'N',53, NULL);
ADD_NLFC ('RSIN_INSPECTION_TYPE' ,NM3TYPE.C_VARCHAR,30,'N',54, NULL);
ADD_NLFC ('RSIN_TARGET_DATE' ,NM3TYPE.C_DATE,NULL,'N',55, NULL);
ADD_NLFC ('RSIN_TARGET_TIME' ,NM3TYPE.C_VARCHAR,5,'N',56, NULL);
ADD_NLFC ('RSIN_COMPLETION_DATE' ,NM3TYPE.C_DATE,NULL,'N',57, NULL);
ADD_NLFC ('RSIN_COMPLETION_TIME' ,NM3TYPE.C_VARCHAR,5,'N',58, NULL);
ADD_NLFC ('RSIN_COMMENTS' ,NM3TYPE.C_VARCHAR,255,'N',59, NULL);
ADD_NLFC ('RSRE_REQUEST_ID' ,NM3TYPE.C_NUMBER,NULL,'N',60, NULL);
ADD_NLFC ('RSRE_REQUEST_TYPE' ,NM3TYPE.C_VARCHAR,30,'N',61, NULL);
ADD_NLFC ('RSRE_REQUEST_DATE_RECEIVED' ,NM3TYPE.C_DATE,NULL,'N',62, NULL);
ADD_NLFC ('RSRE_REQUEST_TIME_RECEIVED' ,NM3TYPE.C_VARCHAR,5,'N',63, NULL);
ADD_NLFC ('RSRE_REQUEST_NUMBER' ,NM3TYPE.C_VARCHAR,30,'N',64, NULL);
ADD_NLFC ('RSRE_REQUEST_COMPLETION_DATE' ,NM3TYPE.C_DATE,NULL,'N',65, NULL);
ADD_NLFC ('RSRE_REQUEST_COMPLETION_TIME' ,NM3TYPE.C_VARCHAR,5,'N',66, NULL);
ADD_NLFC ('RSRE_REQUEST_COMMENTS' ,NM3TYPE.C_VARCHAR,255,'N',67, NULL);
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

