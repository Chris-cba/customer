DROP TABLE OHMS_SUBMIT_SAMPLES;

CREATE TABLE OHMS_SUBMIT_SAMPLES
(
  SAMPLE_ID       VARCHAR2(12 BYTE),
  SECTION_LENGTH  NUMBER(8,3),
  END_POINT       NUMBER(8,3),
  BEGIN_POINT     NUMBER(8,3),
  ROUTE_ID        VARCHAR2(32 BYTE),
  STATE_CODE      NUMBER(2),
  YEAR_RECORD     NUMBER(4)
);

DROP TABLE TRANSINFO.OHMS_SUBMIT_SECTIONS CASCADE CONSTRAINTS;

CREATE TABLE TRANSINFO.OHMS_SUBMIT_SECTIONS
(
  YEAR_RECORD     NUMBER(4),
  STATE_CODE      NUMBER(2),
  ROUTE_ID        VARCHAR2(32 BYTE),
  BEGIN_POINT     NUMBER(8,3),
  END_POINT       NUMBER(8,3),
  DATA_ITEM       VARCHAR2(25 BYTE),
  SECTION_LENGTH  NUMBER(8,3),
  VALUE_NUMERIC   NUMBER,
  VALUE_TEXT      VARCHAR2(50 BYTE),
  VALUE_DATE      DATE,
  COMMENTS        VARCHAR2(50 BYTE)
);


DROP TABLE TRANSINFO.V_NM_OHMS_NW CASCADE CONSTRAINTS;

CREATE TABLE TRANSINFO.V_NM_OHMS_NW
(
  IIT_NE_ID        NUMBER,
  IIT_PRIMARY_KEY  NUMBER,
  SAMP_ID          NUMBER, 
  NE_ID_OF         NUMBER                       NOT NULL,
  NM_BEGIN_MP      NUMBER                       NOT NULL,
  NM_END_MP        NUMBER                       NOT NULL
);

