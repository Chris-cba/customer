--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Enfield/Task 0108973/docman_enfield_4200_upgrade.sql-arc   1.2   Mar 18 2010 15:48:38   aedwards  $
--       Module Name      : $Workfile:   docman_enfield_4200_upgrade.sql  $
--       Date into PVCS   : $Date:   Mar 18 2010 15:48:38  $
--       Date fetched Out : $Modtime:   Mar 18 2010 15:47:58  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--

SPOOL docman_enfield_4200_upgrade.log

SET verify OFF head OFF term ON

UNDEFINE def_tablespace
UNDEFINE doc_tablespace
UNDEFINE default_tablespace
UNDEFINE dot_tablespace

col def_tablespace new_value def_tablespace noprint
col doc_tablespace new_value doc_tablespace noprint
col dot_tablespace new_value dot_tablespace noprint

SELECT default_tablespace def_tablespace
  FROM dba_users
 WHERE username = user
/

col default_tablespace new_value def_tablespace
DEFINE default_tablespace=&def_tablespace

PROMPT ===========================================
PROMPT Task # 0108973 - Enfield Document Archiving
PROMPT ===========================================
PROMPT 
PROMPT
PROMPT Installation of
PROMPT
PROMPT   DDL :
PROMPT
PROMPT     > DOC_FILES_ALL       Table
PROMPT     > DOC_FILE_LOCKS      Table
PROMPT     > DOC_LOCATION_TABLES Table
PROMPT     > WEBUTIL_DB          Package
PROMPT     > NM3DOC_FILES        Package
PROMPT     > Synonyms
PROMPT
PROMPT   Metadata :
PROMPT
PROMPT     > WORKFOLDER          User Option
PROMPT     > DIRMOVE             System Option
PROMPT
PROMPT

ACCEPT doc_tablespace DEFAULT &&def_tablespace PROMPT "Please enter tablespace for DOC_FILES_ALL table [&default_tablespace] : "


--
--------------------------------------------------------------------------------
--

PROMPT Create System Option WORKFOLDER

INSERT INTO hig_option_list
SELECT 'WORKFOLDER','DOC','Working Folder'
     , 'Default working folder'
     , NULL, 'VARCHAR2','Y','Y'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_option_list
     WHERE hol_id = 'WORKFOLDER');

--
--------------------------------------------------------------------------------
--
PROMPT Create HIGOWNER User Option Value for WORKFOLDER

INSERT INTO hig_user_options
  SELECT hus_user_id, 'WORKFOLDER', 'C:\doc_files'
    FROM hig_users
   WHERE hus_is_hig_owner_flag = 'Y'
     AND NOT EXISTS
     (SELECT 1 FROM hig_user_options
       WHERE huo_hus_user_id = hus_user_id
         AND huo_id = 'WORKFOLDER');

--
--------------------------------------------------------------------------------
--

PROMPT Create System Option DIRMOVE

INSERT INTO hig_option_list
SELECT 'DIRMOVE','DOC','Move to/from Oracle Directory' 
     , 'Dump/Read files to/from Database Directory during Doc Manager processes'
     , 'Y_OR_N', 'VARCHAR2','N','N'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_option_list
     WHERE hol_id = 'DIRMOVE');

INSERT INTO hig_option_values
SELECT 'DIRMOVE','Y'
  FROM DUAL
 WHERE NOT EXISTS
   (SELECT 1 FROM hig_option_values
     WHERE hov_id = 'DIRMOVE');

--
--------------------------------------------------------------------------------
--

PROMPT Create table DOC_FILES_ALL

CREATE TABLE doc_files_all
( df_doc_id        NUMBER NOT NULL
, df_revision      NUMBER NOT NULL
, df_start_date    DATE NOT NULL
, df_full_path     VARCHAR2(4000) NOT NULL
, df_filename      VARCHAR2(4000) NOT NULL
, df_end_date      DATE
, df_content       BLOB 
, df_audit         VARCHAR2(4000)
, df_file_info     VARCHAR2(2000) 
, df_date_created  DATE
, df_date_modified DATE
, df_created_by    VARCHAR2(30)
, df_modified_by   VARCHAR2(30)
) TABLESPACE &&doc_tablespace;

ALTER TABLE doc_files_all ADD (
  CONSTRAINT DOC_FILES_PK
 PRIMARY KEY
 (DF_DOC_ID, DF_REVISION));

ALTER TABLE doc_files_all ADD (
  CONSTRAINT DOC_FILES_DOC_ID_FK 
 FOREIGN KEY (DF_DOC_ID) 
 REFERENCES DOCS (DOC_ID));

--
--------------------------------------------------------------------------------
--

PROMPT Create table DOC_FILE_LOCKS

CREATE TABLE doc_file_locks
( dfl_doc_id   NUMBER NOT NULL
, dfl_revision NUMBER NOT NULL
, dfl_username VARCHAR2(30) NOT NULL
, dfl_date     DATE NOT NULL
, dfl_terminal VARCHAR2(2000) NOT NULL
);

ALTER TABLE DOC_FILE_LOCKS ADD (
  CONSTRAINT DOC_FILE_LOCKS_PK
 PRIMARY KEY
 (DFL_DOC_ID, DFL_REVISION));

ALTER TABLE DOC_FILE_LOCKS ADD (
  CONSTRAINT DFL_DOC_ID_DF_DOC_ID_FK 
 FOREIGN KEY (DFL_DOC_ID, DFL_REVISION) 
 REFERENCES DOC_FILES_ALL (DF_DOC_ID,DF_REVISION)
    ON DELETE CASCADE);

--
--------------------------------------------------------------------------------
--

PROMPT Create table DOC_LOCATION_TABLES

CREATE TABLE doc_location_tables
     ( dlt_id              NUMBER       NOT NULL,
       dlt_dlc_id          NUMBER       NOT NULL,
       dlt_table           VARCHAR2(30) NOT NULL,
       dlt_pk_col          VARCHAR2(30) NOT NULL,
       dlt_content_col     VARCHAR2(30) NOT NULL,
       dlt_revision_col    VARCHAR2(30),
       dlt_start_date_col  VARCHAR2(30),
       dlt_end_date_col    VARCHAR2(30),
       dlt_full_path_col   VARCHAR2(30),
       dlt_filename        VARCHAR2(30),
       dlt_audit_col       VARCHAR2(30),
       dlt_file_info_col   VARCHAR2(30) );

ALTER TABLE DOC_LOCATION_TABLES ADD (
  CONSTRAINT DOC_LOCATION_TABLES_PK
 PRIMARY KEY
 (DLT_ID));

ALTER TABLE DOC_LOCATION_TABLES ADD (
  CONSTRAINT DOC_LOCATION_TABLES_UK
 UNIQUE (DLT_DLC_ID, DLT_TABLE));
 
 ALTER TABLE DOC_LOCATION_TABLES ADD (
  CONSTRAINT DLT_DLC_ID_DLC_ID_FK 
 FOREIGN KEY (DLT_DLC_ID) 
 REFERENCES DOC_LOCATIONS (DLC_ID));
 
CREATE SEQUENCE dlt_id_seq;

--INSERT INTO doc_location_tables
--SELECT dlt_id_seq.nextval
--     , dlc_id
--     , 'DOC_FILES_ALL'
--     , 'DF_DOC_ID'
--     , 'DF_CONTENT'
--     , 'DF_REVISION'
--     , 'DF_START_DATE'
--     , 'DF_END_DATE'
--     , 'DF_FULL_PATH'
--     , 'DF_FILENAME'
--     , 'DF_AUDIT_COL'
--     , 'DF_FILE_INFO'
--   FROM doc_locations;

--
--------------------------------------------------------------------------------
--
PROMPT Apply WEBUTIL_DB Package

@webutil_db.pkh
@webutil_db.pkw
--
--------------------------------------------------------------------------------
--
PROMPT Apply NM3DOC_FILES Package

@nm3doc_files.pkh
@nm3doc_files.pkw
--
--------------------------------------------------------------------------------
--
PROMPT Create synonyms for new Objects

BEGIN
  nm3ddl.create_synonym_for_object('DOC_FILES_ALL');
  nm3ddl.create_synonym_for_object('DOC_FILE_LOCKS');
  nm3ddl.create_synonym_for_object('DOC_LOCATION_TABLES');
  nm3ddl.create_synonym_for_object('WEBUTIL_DB');
  nm3ddl.create_synonym_for_object('NM3DOC_FILES');
END;
/
--
--------------------------------------------------------------------------------
--

SPOOL OFF