

Insert into NM_MRG_NIT_DERIVATION
   (NMND_NIT_INV_TYPE, NMND_NMQ_ID, NMND_LAST_REFRESH_DATE, NMND_REFRESH_INTERVAL_DAYS, NMND_LAST_REBUILD_DATE, 
    NMND_REBUILD_INTERVAL_DAYS, NMND_MAINTAIN_HISTORY, NMND_NMU_ID_ADMIN, NMND_WHERE_CLAUSE, NMND_DATE_CREATED, 
    NMND_DATE_MODIFIED, NMND_MODIFIED_BY, NMND_CREATED_BY, nmnd_nt_type, NMND_NGT_GROUP_TYPE)
 Values
   ('OP', 
   (select nmq_id from nm_mrg_query
   where nmq_unique = 'TYPEOP'),
   SYSDATE, 7, to_date(SYSDATE), 
    1, 'N', 2058, null, to_date(SYSDATE), 
    to_date(SYSDATE), 'EXOR', 'EXOR', 'RT', 'RT');
---------------------------------------------------------------

--X
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB26', 1, 'MRG.BD_TYPE_OF_OPERATION');
   
--X rt_neid
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB16', 2, 'MRG.NMS_OFFSET_NE_ID');
   
--X RT_NE_UNQue
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB27', 3, 'x_OPBD_LOOKUP_CHAR(''NE_UNIQUE'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');

--BEGIN Mile Point Need FUNCTION
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB17', 4, 'x_OPBD_LOOKUP_NUM(''BMP'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
--end MP Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB18', 5, 'x_OPBD_LOOKUP_NUM(''EMP'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');

--X District   Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB28', 6, 'x_OPBD_LOOKUP_CHAR(''DISTRICT'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');

--X COUNTY NAME Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB29', 7, 'x_OPBD_LOOKUP_CHAR(''COUNTY_NAME'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
--County Code Need Function  need attrib
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB21', 8, 'x_OPBD_LOOKUP_NUM(''COUNTY_CODE'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
--X Route Prefix  Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB30', 9, 'x_OPBD_LOOKUP_CHAR(''RT_PREFIX'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
-- RT_NUMBER
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB19', 10, 'x_OPBD_LOOKUP_NUM(''ROUTE'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
-- X Route Suffix  Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB31', 11, 'x_OPBD_LOOKUP_CHAR(''RT_SUFFIX'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   
-- Route Section   Need Function

   insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_NUM_ATTRIB20', 12, 'x_OPBD_LOOKUP_NUM(''ROUTE_SECTION'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   

--Route Description   Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB66', 13, 'x_OPBD_LOOKUP_CHAR(''RT_DESCR'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   

--Gov Level   Need Function
insert into NM_MRG_ITA_DERIVATION (
NMID_ITA_INV_TYPE, NMID_ITA_ATTRIB_NAME, NMID_SEQ_NO, NMID_DERIVATION)
Values
   ('OP', 'IIT_CHR_ATTRIB33', 14, 'x_OPBD_LOOKUP_CHAR(''GOV_LEVEL'', MRG.NQR_MRG_JOB_ID, MRG.NMS_MRG_SECTION_ID)');
   


------------------------------------------------------------------

INSERT INTO NM_MRG_NIT_DERIVATION_NW (
NMNDN_NMND_NIT_INV_TYPE, NMNDN_NT_TYPE, NMNDN_DATE_CREATED, NMNDN_DATE_MODIFIED, NMNDN_MODIFIED_BY, NMNDN_CREATED_BY)
VALUES
  ('OP', 'RT', TO_DATE(sysdate), TO_DATE(sysdate), 'EXOR', 'EXOR');

COMMIT;
