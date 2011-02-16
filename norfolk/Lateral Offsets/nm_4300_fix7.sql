--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/nm_4300_fix7.sql-arc   3.3   Feb 16 2011 14:30:02   Mike.Alexander  $
--       Module Name      : $Workfile:   nm_4300_fix7.sql  $
--       Date into PVCS   : $Date:   Feb 16 2011 14:30:02  $
--       Date fetched Out : $Modtime:   Feb 16 2011 14:29:34  $
--       PVCS Version     : $Revision:   3.3  $
--       Based on SCCS version : 
--
--   Author : Chris Strettle
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='nm_4300_fix7_1_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT

--
-- Check that the user isn't sys or system
--
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
      END IF;
END;
/

--
-- Check that HIG has been installed @ v4.3.0.0 or v4.3.0.1
--
Declare
   l_rec_hpr    hig_products%Rowtype;
Begin
  --
  -- get row from hig products for product you are checking 
  l_rec_hpr := nm3get.get_hpr( pi_hpr_product     => 'HIG'--p_product
                             , pi_raise_not_found => TRUE
                             );
  --
  If l_rec_hpr.hpr_version Not In ('4.3.0.1','4.3.0.0')
  Or l_rec_hpr.hpr_key Is Null 
  Then
    RAISE_APPLICATION_ERROR(-20000,'Installation terminated: "HIG" version 4.3.0.1 or 4.3.0.0 must be installed and licensed');
  End If;
End;
/

WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_xsp.vw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm_xsp.vw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xsp_restraints.vw
SET TERM OFF
--
SET FEEDBACK ON
start 'xsp_restraints.vw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xsp_reversal.vw
SET TERM OFF
--
SET FEEDBACK ON
start 'xsp_reversal.vw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Tables
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT herm_xsp.sql
SET TERM OFF
--
SET FEEDBACK ON
start 'herm_xsp.sql'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Packages
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xncc_herm_xsp.pkh
SET TERM OFF
--
SET FEEDBACK ON
start 'xncc_herm_xsp.pkh'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xncc_herm_xsp.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'xncc_herm_xsp.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sdo_dynseg.pkh
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3sdo_dynseg.pkh'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sdo_dynseg.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3sdo_dynseg.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sdo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3sdo.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sdm.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3sdm.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3replace.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3replace.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3reclass.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3reclass.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3split.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3split.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3merge.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3merge.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3undo.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3undo.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3invval.pkw
SET TERM OFF
--
SET FEEDBACK ON
start 'nm3invval.pkw'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xncc_refresh_offsets.trg
SET TERM OFF
--
SET FEEDBACK ON
start 'xncc_refresh_offsets.trg'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT ins_nm_members.trg
SET TERM OFF
--
SET FEEDBACK ON
start 'ins_nm_members.trg'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_inv_items_all_xsp_shape.trg
SET TERM OFF
--
SET FEEDBACK ON
start 'nm_inv_items_all_xsp_shape.trg'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Compile Schema (there are some invalid objects)
--------------------------------------------------------------------------------
--
SET TERM ON
Prompt Compiling Schema
SET TERM OFF
--
SPOOL OFF
--
SET DEFINE ON
SET FEEDBACK ON
start compile_schema.sql
SET FEEDBACK OFF
--
-- SPOOL to Logfile
--
DEFINE logfile='nm_4300_fix7_2_&log_extension'
SPOOL &logfile
--
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version details
FROM v$instance;
--
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version details
FROM hig_products
WHERE hpr_product IN ('HIG','NET');
--
--
START compile_all.sql
--
--
alter view network_node compile;
--
alter synonym road_seg_membs_partial compile;
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT xspoffset metadata.sql
SET TERM OFF
--
SET FEEDBACK ON
start 'xspoffset metadata.sql'
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- XSP Data
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT CREATING XSP METADATA...
--
SET FEEDBACK ON
BEGIN
  xncc_herm_xsp.ins_herm_xsp;
  COMMIT;
END;
/
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Update hig_upgrades with fix ID
--
SET FEEDBACK ON
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4300_fix7.sql'
              ,p_remarks        => 'NET 4300 FIX 7'
              ,p_to_version     => Null);
--
  COMMIT;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
SET FEEDBACK OFF
EXIT;