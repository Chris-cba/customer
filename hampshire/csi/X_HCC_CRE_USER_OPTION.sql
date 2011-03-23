-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hampshire/csi/X_HCC_CRE_USER_OPTION.sql-arc   1.0   Mar 23 2011 18:12:40   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_HCC_CRE_USER_OPTION.sql  $
--       Date into PVCS   : $Date:   Mar 23 2011 18:12:40  $
--       Date fetched Out : $Modtime:   Mar 23 2011 14:05:22  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : H.Buckley
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--

prompt HCC Script to create Default User Email product option

undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on

-- Spool to Logfile
define logfile='apply_ansectno_&log_extension'
spool &logfile

PROMPT Creating PEMEMAIL product option
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'PEMEMAIL'
       ,'ENQ'
       ,'Default customer email address'
       ,'This Product/User option requires a valid email address'
       , null
       ,'VARCHAR2'
       ,'Y'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'PEMEMAIL')
/

PROMPT Creating PEMEMAIL product option value
INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT  'PEMEMAIL'
       ,'highways-transport.north@hants.gov.uk' 
FROM DUAL
WHERE NOT EXISTS (SELECT null
                  FROM   HIG_OPTION_VALUES
                  WHERE HOV_ID = 'PEMEMAIL')
/

commit;

spool off

