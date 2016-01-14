Declare
c_i number;

BEGIN

select count(*) into c_i from user_tables where table_name = 'XIM_ICONS';

if c_i = 0 then
     execute immediate 'create table xIM_ICONS 
        (
        Imagedir  varchar2(50),
        item  varchar2(50),
        filename  varchar2(50)
        );';
end if;

end;
/


SET DEFINE OFF;
MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'MFCLOSED' as ITEM,
  'mfclosed.gif' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'MFOPEN' as ITEM,
  'mfopen.gif' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'GG' as ITEM,
  'grey_globe.png' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'G64' as ITEM,
  'globe_64.gif' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'SREPORT' as ITEM,
  'sample_report.gif' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'AMBULANCE' as ITEM,
  'ambulance-24x24x8b.png' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

MERGE INTO HIGHWAYS.XIM_ICONS A USING
 (SELECT
  'http://bip01.assetwiseonline.bentley.com/i/
' as IMAGEDIR,
  'CALC' as ITEM,
  'calculator_go.png' as FILENAME
  FROM DUAL) B
ON (A.ITEM = B.ITEM)
WHEN NOT MATCHED THEN 
INSERT (
  IMAGEDIR, ITEM, FILENAME)
VALUES (
  B.IMAGEDIR, B.ITEM, B.FILENAME)
WHEN MATCHED THEN
UPDATE SET 
  A.IMAGEDIR = B.IMAGEDIR,
  A.FILENAME = B.FILENAME;

COMMIT;

update xim_icons set IMAGEDIR = 'http://tallus.lc.gov/i/';

commit;