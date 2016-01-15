drop table XODOT_LENGTH_CHANGE;

CREATE TABLE XODOT_LENGTH_CHANGE(
  CHANGE_ID			NUMBER(9)
, CHANGE_DATE		DATE
, EFFECTIVE_DATE		DATE
, DATUM_ID			NUMBER(9)
, DATUM_UNIQUE		VARCHAR2(30)
, DATUM_LENGTH		NUMBER
, DATUM_TYPE		VARCHAR2(5)
, OPERATION			VARCHAR2(50)
, OLD_BEGIN_MEASURE		NUMBER
, OLD_END_MEASURE		NUMBER
, NEW_BEGIN_MEASURE		NUMBER
, NEW_END_MEASURE		NUMBER
, CHANGE_START_MEASURE	NUMBER
, CHANGE_END_MEASURE	NUMBER
, MILEAGE_CHANGE		NUMBER
, HIGHWAY_ID		NUMBER(9)
, HIGHWAY_UNIQUE		VARCHAR2(30)
, HIGHWAY_NAME		VARCHAR2(240)
, REASON_FOR_CHANGE		VARCHAR2(80)
, DOCUMENT_ID		VARCHAR2(30)
, RTE			VARCHAR2(240));


drop sequence TRANSINFO.XODOT_LENG_CHANGE_SEQ;

CREATE SEQUENCE XODOT_LENG_CHANGE_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

@xodot_length_change_populate.sql;
/