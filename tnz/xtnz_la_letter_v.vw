CREATE OR REPLACE VIEW xtnz_la_letter_v AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_la_letter_v.vw	1.1 03/15/05
--       Module Name      : xtnz_la_letter_v.vw
--       Date into SCCS   : 05/03/15 03:46:07
--       Date fetched Out : 07/06/06 14:40:23
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
 xlgt_PRIMARY_KEY LAR_SECTION_NUMBER
,SUBSTR(xlgt_CHR_ATTRIB27,1,50) SECTION_NAME
,SUBSTR(xlgt_CHR_ATTRIB28,1,50) TERRITORIAL_LOCAL_AUTHORITY
,SUBSTR(xlgt_CHR_ATTRIB29,1,50) LAND_REGISTRY_OFFICE
,SUBSTR(xlgt_CHR_ATTRIB30,1,50) GAZETTE_NUMBER
,xlgt_DATE_ATTRIB86 DATE_OF_GAZETTE
,SUBSTR(xlgt_CHR_ATTRIB31,1,50) PAGE_NO
,SUBSTR(xlgt_CHR_ATTRIB32,1,50) PLAN_REFERENCE
,SUBSTR(xlgt_CHR_ATTRIB33,1,50) TQP_REFERENCE
,SUBSTR(xlgt_CHR_ATTRIB34,1,50) FILE_REFERENCE
,SUBSTR(xlgt_CHR_ATTRIB66,1,50) REASON_FOR_DECLARING_LAR
,SUBSTR(xlgt_CHR_ATTRIB35,1,50) NETWORK_CONSULTANT
,xlgt_NUM_ATTRIB99 LENGTH
,xlgt_DATE_ATTRIB87 CONSULT_LETTER_DATE
,xlgt_DATE_ATTRIB88 DRAFT_LETTER_DATE
,SUBSTR(xlgt_CHR_ATTRIB36,1,50) LAR_STATUS
FROM xtnz_lar_generic_table
WHERE xlgt_xll_id = 1
AND xlgt_username = USER
WITH READ ONLY
/
