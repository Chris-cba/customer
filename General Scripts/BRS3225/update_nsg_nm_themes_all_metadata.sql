-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/update_nsg_nm_themes_all_metadata.sql-arc   1.0   Jul 29 2011 08:13:38   Ian.Turnbull  $
--       Module Name      : $Workfile:   update_nsg_nm_themes_all_metadata.sql  $
--       Date into PVCS   : $Date:   Jul 29 2011 08:13:38  $
--       Date fetched Out : $Modtime:   Jul 28 2011 16:22:28  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : AILEEN HEAL
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- This script fixes the metadata held in nm_theme_all for the standard NSG themes
--
-----------------------------------------------------------------------------


col         log_extension new_value log_extension noprint
select  instance_name||'_update_nsg_nm_themes_all_metadata_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from v$instance
/
---------------------------------------------------------------------------------------------------
--
-- These scripts are for use by exor consultants only. They should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
-- Spool to Logfile

define logfile1= &log_extension
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

show user

select name from v$database;

update nm_themes_all 
   set nth_rse_fk_column  = null,
       nth_st_chain_column = null,
       nth_end_chain_column = null,
       nth_start_date_column = 'START_DATE',
       nth_end_date_column = 'END_DATE'
 where nth_table_name in ('V_NM_TP21', 'V_NM_TP22', 'V_NM_TP23', 'V_NM_TP64');  
  
update nm_themes_all 
   set nth_rse_fk_column  = null,
       nth_st_chain_column = null,
       nth_end_chain_column = null,
       nth_start_date_column = 'TP21_START_DATE',
       nth_end_date_column = 'TP21_END_DATE'
 where nth_table_name = 'V_NM_NSG_ASD_TP21'; 

update nm_themes_all 
   set nth_rse_fk_column  = null,
       nth_st_chain_column = null,
       nth_end_chain_column = null,
       nth_start_date_column = 'TP22_START_DATE',
       nth_end_date_column = 'TP22_END_DATE'
 where nth_table_name = 'V_NM_NSG_ASD_TP22'; 

update nm_themes_all 
   set nth_rse_fk_column  = null,
       nth_st_chain_column = null,
       nth_end_chain_column = null,
       nth_start_date_column = 'TP23_START_DATE',
       nth_end_date_column = 'TP23_END_DATE'
 where nth_table_name = 'V_NM_NSG_ASD_TP23';

update nm_themes_all 
   set nth_rse_fk_column  = null,
       nth_st_chain_column = null,
       nth_end_chain_column = null,
       nth_start_date_column = 'TP64_START_DATE',
       nth_end_date_column = 'TP64_END_DATE'
 where nth_table_name = 'V_NM_NSG_ASD_TP64';

update nm_themes_all 
   set NTH_LABEL_COLUMN = 'NE_ID'
 where nth_table_name IN ('NM_NAT_NSGN_OFFN_SDO', 
                          'V_NM_NAT_NSGN_OFFN_SDO',
                          'NM_NAT_NSGN_RDNM_SDO',
                          'V_NM_NAT_NSGN_RDNM_SDO',
                          'NM_NAT_NSGN_UOFF_SDO',
                          'V_NM_NAT_NSGN_UOFF_SDO' );
                         
update nm_themes_all 
   set nth_start_date_column = 'NE_START_DATE',
       nth_end_date_column = null 
 where nth_table_name IN ('V_NM_NAT_NSGN_OFFN_SDO_DT',
                          'V_NM_NAT_NSGN_RDNM_SDO_DT',
                          'V_NM_NAT_NSGN_UOFF_SDO_DT' );
                         

spool off

-----------------

PROMPT check log and issue a commit if all ok or rollback if errors

                         