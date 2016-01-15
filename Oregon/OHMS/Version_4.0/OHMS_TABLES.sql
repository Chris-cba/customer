
@zDrop_OHMS_TV.sql



--Creating OHMS Tables


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
	
CREATE TABLE TRANSINFO.V_NM_OHMS_NW
(
  IIT_NE_ID        NUMBER,
  IIT_PRIMARY_KEY  NUMBER,
  SAMP_ID          NUMBER, 
  NE_ID_OF         NUMBER                       NOT NULL,
  NM_BEGIN_MP      NUMBER                       NOT NULL,
  NM_END_MP        NUMBER                       NOT NULL
);	

