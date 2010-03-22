--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Enfield/Task 0108973/docman_enfield_4200_upgrade.sql-arc   1.3   Mar 22 2010 15:06:02   aedwards  $
--       Module Name      : $Workfile:   docman_enfield_4200_upgrade.sql  $
--       Date into PVCS   : $Date:   Mar 22 2010 15:06:02  $
--       Date fetched Out : $Modtime:   Mar 22 2010 15:05:02  $
--       PVCS Version     : $Revision:   1.3  $
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

PROMPT Create WHO Trigger on DOC_FILES_ALL

--
DECLARE
--
   TYPE tab_comments IS TABLE of VARCHAR2(250) INDEX BY BINARY_INTEGER;
   l_tab_comments tab_comments;
--
   CURSOR cs_cols (p_table_name VARCHAR2, p_type VARCHAR2) IS
   SELECT column_name
         ,DECODE(data_type
                ,'DATE','sysdate'
                ,'VARCHAR2','user'
                ,'null'
                ) new_value
     from user_tab_columns
   where  table_name = p_table_name
    AND  (column_name    like '%'||p_type||'_BY'
          or column_name like '%DATE_'||p_type)
    order by column_id;
--
   l_trigger_name VARCHAR2(30);
--
   l_sql VARCHAR2(32767);
--
BEGIN
--
--  Stick the SCCS delta comments all into an array so that we can output this
--   as a comment within the trigger itself
   l_tab_comments(1)  := '--';
   l_tab_comments(2)  := '--   SCCS Identifiers :-';
   l_tab_comments(3)  := '--';
   l_tab_comments(4)  := '--       pvcsid                     : $Header:   //vm_latest/archives/customer/Enfield/Task 0108973/docman_enfield_4200_upgrade.sql-arc   1.3   Mar 22 2010 15:06:02   aedwards  $';
   l_tab_comments(5)  := '--       Module Name                : $Workfile:   docman_enfield_4200_upgrade.sql  $';
   l_tab_comments(6)  := '--       Date into PVCS             : $Date:   Mar 22 2010 15:06:02  $';
   l_tab_comments(7)  := '--       Date fetched Out           : $Modtime:   Mar 22 2010 15:05:02  $';
   l_tab_comments(8)  := '--       PVCS Version               : $Revision:   1.3  $';
   l_tab_comments(9)  := '--';
   l_tab_comments(10) := '--   table_name_WHO trigger';
   l_tab_comments(11) := '--';
   l_tab_comments(12) := '-----------------------------------------------------------------------------';
   l_tab_comments(13) := '--    Copyright (c) exor corporation ltd, 2007';
   l_tab_comments(14) := '-----------------------------------------------------------------------------';
   l_tab_comments(15) := '--';
--
   dbms_output.put_line('Started WHO trigger creation');
--
   FOR cs_rec IN (SELECT utc.table_name
                        ,max(length(utc.column_name)) max_col_name_length
                   FROM  user_tab_columns utc
                        ,user_objects     ut
                  where  utc.table_name  = ut.object_name
                    AND  ut.object_type  = 'TABLE'
                    AND  ut.temporary    = 'N'
                    AND (utc.column_name    like '%CREATED_BY'
                         or utc.column_name like '%MODIFIED_BY'
                         or utc.column_name like '%DATE_CREATED'
                         or utc.column_name like '%DATE_MODIFIED'
                        )
                    AND ut.object_name not like 'BIN%'        --sscanlon fix 11JAN2008, fix for 10g installs
                    AND ut.object_name = 'DOC_FILES_ALL'
                  GROUP BY utc.TABLE_NAME
                  HAVING COUNT(*) = 4
                 )
    LOOP
--
      l_trigger_name := LOWER(SUBSTR(cs_rec.table_name,1,26)||'_who');
--
      l_sql := 'CREATE OR REPLACE TRIGGER '||l_trigger_name;
      l_sql := l_sql||CHR(10)||' BEFORE insert OR update';
      l_sql := l_sql||CHR(10)||' ON '||cs_rec.table_name;
      l_sql := l_sql||CHR(10)||' FOR each row';
      l_sql := l_sql||CHR(10)||'DECLARE';
      --
      FOR l_count IN 1..l_tab_comments.COUNT
       LOOP
         l_sql := l_sql||CHR(10)||l_tab_comments(l_count);
      END LOOP;
      --
      l_sql := l_sql||CHR(10)||'   l_sysdate DATE;';
      l_sql := l_sql||CHR(10)||'   l_user    VARCHAR2(30);';
      l_sql := l_sql||CHR(10)||'BEGIN';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'-- Generated '||to_char(sysdate,'HH24:MI:SS DD-MON-YYYY');
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   SELECT sysdate';
      l_sql := l_sql||CHR(10)||'         ,user';
      l_sql := l_sql||CHR(10)||'    INTO  l_sysdate';
      l_sql := l_sql||CHR(10)||'         ,l_user';
      l_sql := l_sql||CHR(10)||'    FROM  dual;';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   IF inserting';
      l_sql := l_sql||CHR(10)||'    THEN';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'CREATED')
       LOOP
         l_sql := l_sql||CHR(10)||'      :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'   END IF;';
      l_sql := l_sql||CHR(10)||'--';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'MODIFIED')
       LOOP
         l_sql := l_sql||CHR(10)||'   :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'--';
--
      l_sql := l_sql||CHR(10)||'END '||l_trigger_name||';';
--
      execute immediate l_sql;
--
      l_sql := 'ALTER TRIGGER '||l_trigger_name||' COMPILE';
--
      execute immediate l_sql;
--
      dbms_output.put_line('Created trigger '||l_trigger_name);
--
   END LOOP;
--
   dbms_output.put_line('Finished WHO trigger creation');
--
END;
/


SPOOL OFF