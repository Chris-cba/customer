DECLARE
--
-- ###############################################################
--
--  File           : 2233.RSDCSV.sql
--  Extracted from : RAMS@RAMS.ramsdb1
--  Extracted by   : RAMS
--  At             : 03-MAR-2015 07:20:43
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
   l_rec_nlf.nlf_date_format_mask := 'DD/MM/YYYY';
   l_rec_nlf.nlf_holding_table    := Null;
--
   nm3ins.ins_nlf (l_rec_nlf);
--
   l_rec_nlfc.nlfc_nlf_id         := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nlf_id         := l_rec_nlf.nlf_id;
--
   add_nlfc ('RSD_VENDOR_CODE',nm3type.c_varchar,4,'Y',1,Null);
   add_nlfc ('RSD_REFERENCE_ID',nm3type.c_number,Null,'Y',2,Null);
   add_nlfc ('RSD_ROAD_NUMBER',nm3type.c_varchar,125,'Y',3,Null);
   add_nlfc ('RSD_ASSET_TYPE_CODE',nm3type.c_varchar,5,'Y',4,Null);
   add_nlfc ('RSD_KEY_ID',nm3type.c_number,Null,'N',5,Null);
   add_nlfc ('RSD_ASSET_DESCRIPTION',nm3type.c_varchar,125,'N',6,Null);
   add_nlfc ('RSD_ROAD_MAINTENANCE_SEGMENT',nm3type.c_varchar,30,'N',7,Null);
   add_nlfc ('RSD_DATE_OF_CREATION',nm3type.c_date,Null,'Y',8,'DD/MM/YYYY');
   add_nlfc ('RSD_TIME_OF_CREATION',nm3type.c_varchar,5,'N',9,Null);
   add_nlfc ('RSD_LONGITUDE',nm3type.c_number,Null,'Y',10,Null);
   add_nlfc ('RSD_LATITUDE',nm3type.c_number,Null,'Y',11,Null);
   add_nlfc ('RSD_LGA',nm3type.c_varchar,50,'N',12,Null);
   add_nlfc ('RSAM_ACCOMPLISHMENT_NUMBER',nm3type.c_varchar,30,'N',13,Null);
   add_nlfc ('RSAM_ACCOMPLISHMENT_ID',nm3type.c_number,Null,'N',14,Null);
   add_nlfc ('RSAM_ACCOMPLISHMENT_DATE',nm3type.c_date,Null,'N',15,'DD/MM/YYYY');
   add_nlfc ('RSAM_ACTIVITY',nm3type.c_number,Null,'N',16,Null);
   add_nlfc ('RSAM_ACTIVITY_NAME',nm3type.c_varchar,255,'N',17,Null);
   add_nlfc ('RSAM_ACTIVITY_TYPE',nm3type.c_varchar,30,'N',18,Null);
   add_nlfc ('RSAM_QUANTITY_ACCOMPLISHED',nm3type.c_number,Null,'N',19,Null);
   add_nlfc ('RSAM_UNIT_OF_MEASURE',nm3type.c_varchar,30,'N',20,Null);
   add_nlfc ('RSAM_SECOND_QUANTITY',nm3type.c_number,Null,'N',21,Null);
   add_nlfc ('RSAM_SECOND_UNIT_OF_MEASURE',nm3type.c_varchar,30,'N',22,Null);
   add_nlfc ('RSAM_ACCOMPLISHMENT_COMMENTS',nm3type.c_varchar,255,'N',23,Null);
   add_nlfc ('RSAM_TIME_WORK',nm3type.c_number,Null,'N',24,Null);
   add_nlfc ('RSAM_COMPLETED',nm3type.c_varchar,1,'N',25,Null);
   add_nlfc ('RSDE_DEFECT_NUMBER',nm3type.c_varchar,12,'N',26,Null);
   add_nlfc ('RSDE_DEFECT_ID',nm3type.c_number,Null,'N',27,Null);
   add_nlfc ('RSDE_DATE_RAISED',nm3type.c_date,Null,'N',28,'DD/MM/YYYY');
   add_nlfc ('RSDE_TIME_RAISED',nm3type.c_varchar,5,'N',29,Null);
   add_nlfc ('RSDE_CAUSE_OF_DEFECT',nm3type.c_varchar,30,'N',30,Null);
   add_nlfc ('RSDE_REOCCURRING_DEFECT',nm3type.c_varchar,1,'N',31,Null);
   add_nlfc ('RSDE_DEFECT_TYPE',nm3type.c_varchar,50,'N',32,Null);
   add_nlfc ('RSDE_POSITION_WITHIN_LOCATIO',nm3type.c_number,Null,'N',33,Null);
   add_nlfc ('RSDE_DEFECT_COMPLETION_DATE',nm3type.c_date,Null,'N',34,'DD/MM/YYYY');
   add_nlfc ('RSDE_DEFECT_COMPLETION_TIME',nm3type.c_varchar,5,'N',35,Null);
   add_nlfc ('RSDE_ESTIMATED_QTY_FOR_REPAI',nm3type.c_number,Null,'N',36,Null);
   add_nlfc ('RSDE_UNIT_OF_MEASURE',nm3type.c_varchar,30,'N',37,Null);
   add_nlfc ('RSDE_ESTIMATED_SECOND_QUANTI',nm3type.c_number,Null,'N',38,Null);
   add_nlfc ('RSDE_SECOND_UNIT_OF_MEASURE',nm3type.c_varchar,30,'N',39,Null);
   add_nlfc ('RSDE_DEFECT_COMMENTS',nm3type.c_varchar,255,'N',40,Null);
   add_nlfc ('RSIC_INCIDENT_ID',nm3type.c_number,Null,'N',41,Null);
   add_nlfc ('RSIC_INCIDENT_TYPE',nm3type.c_varchar,30,'N',42,Null);
   add_nlfc ('RSIC_DATE_CALL_RECEIVED',nm3type.c_date,Null,'N',43,'DD/MM/YYYY');
   add_nlfc ('RSIC_TIME_CALL_RECEIVED',nm3type.c_varchar,5,'N',44,Null);
   add_nlfc ('RSIC_INCIDENT_DESCRIPTION',nm3type.c_varchar,255,'N',45,Null);
   add_nlfc ('RSIC_ADVICE_RECEIVED_FROM',nm3type.c_varchar,50,'N',46,Null);
   add_nlfc ('RSIC_CONDITION_AT_INCIDENT',nm3type.c_varchar,50,'N',47,Null);
   add_nlfc ('RSIC_ACTION_REQUIRED',nm3type.c_varchar,50,'N',48,Null);
   add_nlfc ('RSIC_DAMAGE_TO_PROPERTY',nm3type.c_varchar,30,'N',49,Null);
   add_nlfc ('RSIC_INCIDENT_COMPLETION_DAT',nm3type.c_date,Null,'N',50,'DD/MM/YYYY');
   add_nlfc ('RSIC_INCIDENT_COMPLETION_TIM',nm3type.c_varchar,5,'N',51,Null);
   add_nlfc ('RSIN_INSPECTION_NUMBER',nm3type.c_varchar,30,'N',52,Null);
   add_nlfc ('RSIN_INSPECTION_ID',nm3type.c_number,Null,'N',53,Null);
   add_nlfc ('RSIN_INSPECTION_TYPE',nm3type.c_varchar,30,'N',54,Null);
   add_nlfc ('RSIN_TARGET_DATE',nm3type.c_date,Null,'N',55,'DD/MM/YYYY');
   add_nlfc ('RSIN_TARGET_TIME',nm3type.c_varchar,5,'N',56,Null);
   add_nlfc ('RSIN_COMPLETION_DATE',nm3type.c_date,Null,'N',57,'DD/MM/YYYY');
   add_nlfc ('RSIN_COMPLETION_TIME',nm3type.c_varchar,5,'N',58,Null);
   add_nlfc ('RSIN_COMMENTS',nm3type.c_varchar,255,'N',59,Null);
   add_nlfc ('RSRE_REQUEST_ID',nm3type.c_number,Null,'N',60,Null);
   add_nlfc ('RSRE_REQUEST_TYPE',nm3type.c_varchar,30,'N',61,Null);
   add_nlfc ('RSRE_REQUEST_DATE_RECEIVED',nm3type.c_date,Null,'N',62,'DD/MM/YYYY');
   add_nlfc ('RSRE_REQUEST_TIME_RECEIVED',nm3type.c_varchar,5,'N',63,Null);
   add_nlfc ('RSRE_REQUEST_NUMBER',nm3type.c_varchar,30,'N',64,Null);
   add_nlfc ('RSRE_REQUEST_COMPLETION_DATE',nm3type.c_date,Null,'N',65,'DD/MM/YYYY');
   add_nlfc ('RSRE_REQUEST_COMPLETION_TIME',nm3type.c_varchar,5,'N',66,Null);
   add_nlfc ('RSRE_REQUEST_COMMENTS',nm3type.c_varchar,255,'N',67,Null);
--
   l_rec_nlfd.nlfd_nld_id         := nm3get.get_nld (pi_nld_table_name => 'X_RMS_RSD_CSV_HOLDING').nld_id;
   l_rec_nlfd.nlfd_seq            := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
--
   upd_nlcd ('RSD_VENDOR_CODE','RSDCSV.RSD_VENDOR_CODE');
   upd_nlcd ('RSD_REFERENCE_ID','RSDCSV.RSD_REFERENCE_ID');
   upd_nlcd ('RSD_ROAD_NUMBER','RSDCSV.RSD_ROAD_NUMBER');
   upd_nlcd ('RSD_ASSET_TYPE_CODE','RSDCSV.RSD_ASSET_TYPE_CODE');
   upd_nlcd ('RSD_KEY_ID','RSDCSV.RSD_KEY_ID');
   upd_nlcd ('RSD_ASSET_DESCRIPTION','RSDCSV.RSD_ASSET_DESCRIPTION');
   upd_nlcd ('RSD_ROAD_MAINTENANCE_SEGMENT','RSDCSV.RSD_ROAD_MAINTENANCE_SEGMENT');
   upd_nlcd ('RSD_DATE_OF_CREATION','RSDCSV.RSD_DATE_OF_CREATION');
   upd_nlcd ('RSD_TIME_OF_CREATION','RSDCSV.RSD_TIME_OF_CREATION');
   upd_nlcd ('RSD_LONGITUDE','RSDCSV.RSD_LONGITUDE');
   upd_nlcd ('RSD_LATITUDE','RSDCSV.RSD_LATITUDE');
   upd_nlcd ('RSD_LGA','RSDCSV.RSD_LGA');
   upd_nlcd ('RSAM_ACCOMPLISHMENT_NUMBER','RSDCSV.RSAM_ACCOMPLISHMENT_NUMBER');
   upd_nlcd ('RSAM_ACCOMPLISHMENT_ID','RSDCSV.RSAM_ACCOMPLISHMENT_ID');
   upd_nlcd ('RSAM_ACCOMPLISHMENT_DATE','RSDCSV.RSAM_ACCOMPLISHMENT_DATE');
   upd_nlcd ('RSAM_ACTIVITY','RSDCSV.RSAM_ACTIVITY');
   upd_nlcd ('RSAM_ACTIVITY_NAME','RSDCSV.RSAM_ACTIVITY_NAME');
   upd_nlcd ('RSAM_ACTIVITY_TYPE','RSDCSV.RSAM_ACTIVITY_TYPE');
   upd_nlcd ('RSAM_QUANTITY_ACCOMPLISHED','RSDCSV.RSAM_QUANTITY_ACCOMPLISHED');
   upd_nlcd ('RSAM_UNIT_OF_MEASURE','RSDCSV.RSAM_UNIT_OF_MEASURE');
   upd_nlcd ('RSAM_SECOND_QUANTITY','RSDCSV.RSAM_SECOND_QUANTITY');
   upd_nlcd ('RSAM_SECOND_UNIT_OF_MEASURE','RSDCSV.RSAM_SECOND_UNIT_OF_MEASURE');
   upd_nlcd ('RSAM_ACCOMPLISHMENT_COMMENTS','RSDCSV.RSAM_ACCOMPLISHMENT_COMMENTS');
   upd_nlcd ('RSAM_TIME_WORK','RSDCSV.RSAM_TIME_WORK');
   upd_nlcd ('RSAM_COMPLETED','RSDCSV.RSAM_COMPLETED');
   upd_nlcd ('RSDE_DEFECT_NUMBER','RSDCSV.RSDE_DEFECT_NUMBER');
   upd_nlcd ('RSDE_DEFECT_ID','RSDCSV.RSDE_DEFECT_ID');
   upd_nlcd ('RSDE_DATE_RAISED','RSDCSV.RSDE_DATE_RAISED');
   upd_nlcd ('RSDE_TIME_RAISED','RSDCSV.RSDE_TIME_RAISED');
   upd_nlcd ('RSDE_CAUSE_OF_DEFECT','RSDCSV.RSDE_CAUSE_OF_DEFECT');
   upd_nlcd ('RSDE_REOCCURRING_DEFECT','RSDCSV.RSDE_REOCCURRING_DEFECT');
   upd_nlcd ('RSDE_DEFECT_TYPE','RSDCSV.RSDE_DEFECT_TYPE');
   upd_nlcd ('RSDE_POSITION_WITHIN_LOCATION','RSDCSV.RSDE_POSITION_WITHIN_LOCATIO');
   upd_nlcd ('RSDE_DEFECT_COMPLETION_DATE','RSDCSV.RSDE_DEFECT_COMPLETION_DATE');
   upd_nlcd ('RSDE_DEFECT_COMPLETION_TIME','RSDCSV.RSDE_DEFECT_COMPLETION_TIME');
   upd_nlcd ('RSDE_ESTIMATED_QTY_FOR_REPAIR','RSDCSV.RSDE_ESTIMATED_QTY_FOR_REPAI');
   upd_nlcd ('RSDE_UNIT_OF_MEASURE','RSDCSV.RSDE_UNIT_OF_MEASURE');
   upd_nlcd ('RSDE_ESTIMATED_SECOND_QUANTITY','RSDCSV.RSDE_ESTIMATED_SECOND_QUANTI');
   upd_nlcd ('RSDE_SECOND_UNIT_OF_MEASURE','RSDCSV.RSDE_SECOND_UNIT_OF_MEASURE');
   upd_nlcd ('RSDE_DEFECT_COMMENTS','RSDCSV.RSDE_DEFECT_COMMENTS');
   upd_nlcd ('RSIC_INCIDENT_ID','RSDCSV.RSIC_INCIDENT_ID');
   upd_nlcd ('RSIC_INCIDENT_TYPE','RSDCSV.RSIC_INCIDENT_TYPE');
   upd_nlcd ('RSIC_DATE_CALL_RECEIVED','RSDCSV.RSIC_DATE_CALL_RECEIVED');
   upd_nlcd ('RSIC_TIME_CALL_RECEIVED','RSDCSV.RSIC_TIME_CALL_RECEIVED');
   upd_nlcd ('RSIC_INCIDENT_DESCRIPTION','RSDCSV.RSIC_INCIDENT_DESCRIPTION');
   upd_nlcd ('RSIC_ADVICE_RECEIVED_FROM','RSDCSV.RSIC_ADVICE_RECEIVED_FROM');
   upd_nlcd ('RSIC_CONDITION_AT_INCIDENT','RSDCSV.RSIC_CONDITION_AT_INCIDENT');
   upd_nlcd ('RSIC_ACTION_REQUIRED','RSDCSV.RSIC_ACTION_REQUIRED');
   upd_nlcd ('RSIC_DAMAGE_TO_PROPERTY','RSDCSV.RSIC_DAMAGE_TO_PROPERTY');
   upd_nlcd ('RSIC_INCIDENT_COMPLETION_DATE','RSDCSV.RSIC_INCIDENT_COMPLETION_DAT');
   upd_nlcd ('RSIC_INCIDENT_COMPLETION_TIME','RSDCSV.RSIC_INCIDENT_COMPLETION_TIM');
   upd_nlcd ('RSIN_INSPECTION_NUMBER','RSDCSV.RSIN_INSPECTION_NUMBER');
   upd_nlcd ('RSIN_INSPECTION_ID','RSDCSV.RSIN_INSPECTION_ID');
   upd_nlcd ('RSIN_INSPECTION_TYPE','RSDCSV.RSIN_INSPECTION_TYPE');
   upd_nlcd ('RSIN_TARGET_DATE','RSDCSV.RSIN_TARGET_DATE');
   upd_nlcd ('RSIN_TARGET_TIME','RSDCSV.RSIN_TARGET_TIME');
   upd_nlcd ('RSIN_COMPLETION_DATE','RSDCSV.RSIN_COMPLETION_DATE');
   upd_nlcd ('RSIN_COMPLETION_TIME','RSDCSV.RSIN_COMPLETION_TIME');
   upd_nlcd ('RSIN_COMMENTS','RSDCSV.RSIN_COMMENTS');
   upd_nlcd ('RSRE_REQUEST_ID','RSDCSV.RSRE_REQUEST_ID');
   upd_nlcd ('RSRE_REQUEST_TYPE','RSDCSV.RSRE_REQUEST_TYPE');
   upd_nlcd ('RSRE_REQUEST_DATE_RECEIVED','RSDCSV.RSRE_REQUEST_DATE_RECEIVED');
   upd_nlcd ('RSRE_REQUEST_TIME_RECEIVED','RSDCSV.RSRE_REQUEST_TIME_RECEIVED');
   upd_nlcd ('RSRE_REQUEST_NUMBER','RSDCSV.RSRE_REQUEST_NUMBER');
   upd_nlcd ('RSRE_REQUEST_COMPLETION_DATE','RSDCSV.RSRE_REQUEST_COMPLETION_DATE');
   upd_nlcd ('RSRE_REQUEST_COMPLETION_TIME','RSDCSV.RSRE_REQUEST_COMPLETION_TIME');
   upd_nlcd ('RSRE_REQUEST_COMMENTS','RSDCSV.RSRE_REQUEST_COMMENTS');
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
END;
/

