/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.11.14, JMM
*/

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'xaa_asset_type';
   name_array(2) := 'XAA_ASSET_ATTRIB';
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'TABLE';
		if i_count = 1 then
			execute immediate 'drop table ' || name_array(i);
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'VIEW';
		if i_count = 1 then
			execute immediate 'drop view ' || name_array(i);	
		end if;
   END LOOP;
END;
/
----------------------------------------------------
create table xaa_asset_type
(
	 ASSET_TYPE		VARCHAR2(4)
	,TABLE_NAME		VARCHAR2(30)
	,ROUTE_TYPE		VARCHAR2(4)
);

CREATE TABLE XAA_ASSET_ATTRIB
(
	ASSET_TYPE			VARCHAR2(4)
	,COLUMN_SEQ			NUMBER
	,COLUMN_NAME		VARCHAR2(30)
	--,COLUMN_DATATYPE	VARCHAR2(60)
	,COLUMN_DERIVATION	VARCHAR2(80)
);

------------------------------------
--insert default values
------------------------------------

SET DEFINE OFF;
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('FS', 'XAA_ASSET_FS', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('LN', 'XAA_ASSET_LN', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('RA', 'XAA_ASSET_RA', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('RW', 'XAA_ASSET_RW', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('SH', 'XAA_ASSET_SH', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('SL', 'XAA_ASSET_SL', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('TF', 'XAA_ASSET_TF', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('SS', 'XAA_ASSET_SS', 'RT');
Insert into EXOR.XAA_ASSET_TYPE
   (ASSET_TYPE, TABLE_NAME, ROUTE_TYPE)
 Values
   ('AL', 'XAA_ASSET_AL', 'RT');
COMMIT;

------------------------------------
------------------------------------
------------------------------------

SET DEFINE OFF;
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('AL', 1, 'AUXLANE', 'AUXLANE');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('AL', 2, 'AUXLNWID', 'AUXLNWID');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('AL', 3, 'AUXSURF', 'AUXSURF');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('FS', 1, 'URBAREA', 'URBAREA');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('FS', 2, 'STATUS', 'STATUS');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('FS', 3, 'FC', 'FC');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('FS', 4, 'NHS', 'NHS');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('LN', 1, 'LANEWID', 'LANEWID');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('LN', 2, 'LANES', 'LANES');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('LN', 3, 'LANESCRD', 'LANESCRD');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('LN', 4, 'LANESNC', 'LANESNC');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('RA', 1, 'SAFEINDX', 'SAFEINDX');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('RA', 2, 'SERVINDX', 'SERVINDX');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('RA', 3, 'COMPINDX', 'COMPINDX');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('RA', 4, 'PERCENTILE', 'PERCENTILE');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('RW', 1, 'ROW_WIDTH', 'ROW_WIDTH');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('SH', 1, 'SHLDTYPE', 'SHLDTYPE');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('SH', 2, 'SHLDWID', 'SHLDWID');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('SL', 1, 'SPEEDLIM', 'SPEEDLIM');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('SL', 2, 'OONUMBER', 'OONUMBER');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('SS', 1, 'STHWYSYS', 'STHWYSYS');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 1, 'LASTCNT', 'LASTCNT');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 2, 'LASTCNTYR', 'LASTCNTYR');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 3, 'ADTSINGLE', 'ADTSINGLE');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 4, 'ADTCOMBO', 'ADTCOMBO');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 5, 'PCSINGOP', 'PCSINGOP');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 6, 'PCCOMBOP', 'PCCOMBOP');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 7, 'PCSINGPK', 'PCSINGPK');
Insert into EXOR.XAA_ASSET_ATTRIB
   (ASSET_TYPE, COLUMN_SEQ, COLUMN_NAME, COLUMN_DERIVATION)
 Values
   ('TF', 8, 'PCCOMBPK', 'PCCOMBPK');
COMMIT;

