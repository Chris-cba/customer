-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/set_base_theme_for_swr_views.sql-arc   1.1   Jul 29 2011 08:12:38   Ian.Turnbull  $
--       Module Name      : $Workfile:   set_base_theme_for_swr_views.sql  $
--       Date into PVCS   : $Date:   Jul 29 2011 08:12:38  $
--       Date fetched Out : $Modtime:   Jul 28 2011 16:24:20  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--
--   Author : Aileen Heal
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- These scripts are for use by exor consultants only. They should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
update nm_themes_all set NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'SWR_SITES_XY_SDO')
  where nth_feature_table in ('SWR_DETAILS_IN_PROGRESS_SDO',
                                          'SWR_DETAILS_ABANDONED_SDO',  
                                          'SWR_DETAILS_CLOSED_SDO',  
                                          'SWR_DETAILS_COMPLETE_SDO',  
                                          'SWR_DETAILS_IN_PROG_PROP_SDO',  
                                          'SWR_DETAILS_LAST_3_YEARS_SDO', 
                                          'SWR_DETAILS_LAST_6_MONTHS_SDO', 
                                          'SWR_DETAILS_OLDER_3_YEARS_SDO',  
                                          'SWR_DT_INPROG_PROP_6MONTHS_SDO')
  and nth_base_table_theme is null
/

