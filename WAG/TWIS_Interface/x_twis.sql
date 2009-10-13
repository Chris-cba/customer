ALTER TABLE WAG.X_TWIS_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE WAG.X_TWIS_LOG CASCADE CONSTRAINTS;

CREATE TABLE WAG.X_TWIS_LOG
(
  TCL_ID           NUMBER                       NOT NULL,
  TCL_DATE         DATE                         NOT NULL,
  TCL_TWIS_ID      VARCHAR2(5 BYTE)             NOT NULL,
  TCL_TWIS_ACTION  VARCHAR2(5 BYTE)             NOT NULL,
  TCL_FILENAME     VARCHAR2(80 BYTE),
  TCL_FTP_DIR      VARCHAR2(500 BYTE),
  TCL_ARCHIVE_DIR  VARCHAR2(500 BYTE),
  TCL_INTERPATH    VARCHAR2(500 BYTE),
  TCL_MESSAGE      VARCHAR2(1000 BYTE)
);


CREATE UNIQUE INDEX WAG.X_TWIS_LOG ON WAG.X_TWIS_LOG
(TCL_ID)
;

ALTER TABLE WAG.X_TWIS_LOG ADD (
  CONSTRAINT X_TWIS_LOG
 PRIMARY KEY
 (TCL_ID)
    USING INDEX 
);

@x_twis.pkh
@x_twis.pkb

@JOB_NEXT_DATES.pkh
@JOB_NEXT_DATES.pkb


SET DEFINE OFF;
Insert into X_FTP_DIRS
   (FTP_TYPE, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_ARC_USERNAME, FTP_ARC_PASSWORD, FTP_ARC_HOST, FTP_IN_DIR, FTP_OUT_DIR, FTP_ARC_IN_DIR, FTP_ARC_OUT_DIR)
 Values
   ('TWIS', 'NWTRA', 'twis_wag', 'jk83kfl', '84.22.180.58', 'twis_wag', 'jk83kfl', '84.22.180.58', '/in', '/out', '/in/archive', '/out/archive');
Insert into X_FTP_DIRS
   (FTP_TYPE, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_ARC_USERNAME, FTP_ARC_PASSWORD, FTP_ARC_HOST, FTP_IN_DIR, FTP_OUT_DIR, FTP_ARC_IN_DIR, FTP_ARC_OUT_DIR)
 Values
   ('TWIS', 'MWTRA', 'twis_wag', 'jk83kfl', '84.22.180.58', 'twis_wag', 'jk83kfl', '84.22.180.58', '/in', '/out', '/in/archive', '/out/archive');
Insert into X_FTP_DIRS
   (FTP_TYPE, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_ARC_USERNAME, FTP_ARC_PASSWORD, FTP_ARC_HOST, FTP_IN_DIR, FTP_OUT_DIR, FTP_ARC_IN_DIR, FTP_ARC_OUT_DIR)
 Values
   ('TWIS', 'SWTRA', 'twis_wag', 'jk83kfl', '84.22.180.58', 'twis_wag', 'jk83kfl', '84.22.180.58', '/in', '/out', '/in/archive', '/out/archive');
COMMIT;

@v_wag_twis.vw
@wag_twis_load.pkh
@wag_twis_load.pkb


@41.TWIS001NWTRA.sql
@42.TWIS001MWTRA.sql
@43.TWIS001SWTRA.sql


DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'x_twis.process_input_files;'
   ,next_date => to_date('02/11/2009 00:00:00','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'job_next_dates.monthly_first_working'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/