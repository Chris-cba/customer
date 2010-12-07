--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/permiting_themes/create_permitting_themes.sql-arc   1.0   Dec 07 2010 08:41:42   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_permitting_themes.sql  $
--       Date into PVCS   : $Date:   Dec 07 2010 08:41:42  $
--       Date fetched Out : $Modtime:   Dec 07 2010 08:40:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
-- Written by Aileen Heal to create the permiting themes for Northants (NHSWM)
-- as part of BRS 3384 
--
--
-- This script should be run as the HIG user
--
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='Create_permitting_themes&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

select instance_name from v$instance;

select user from dual;

@x_nhswm_permited_street.fnc

@x_nhswm_phase_permited.fnc

-- TMA PROP IN PROGRESS PERMIT
@X_NHCC_PROPINPROG_PERMIT_SDO.vw

@add_to_gis_themes.sql 'TMA PROP IN PROGRESS PERMIT' 'X_NHCC_PROPINPROG_PERMIT_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'


@X_NHCC_PROPINPROG_NRSWA_SDO.vw

@add_to_gis_themes.sql 'TMA PROP IN PROGRESS NRSWA' 'X_NHCC_PROPINPROG_NRSWA_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'


@X_NHCC_TMA_COMPLETE_NRSWA_SDO.vw

@add_to_gis_themes.sql 'TMA COMPLETE NRSWA' 'X_NHCC_TMA_COMPLETE_NRSWA_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'


@X_NHCC_TMA_COMPLETE_PERMIT_SDO.vw

@add_to_gis_themes.sql 'TMA COMPLETE PERMIT' 'X_NHCC_TMA_COMPLETE_PERMIT_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'

@X_NHCC_TMA_FWDPLAN_PERMIT_SDO.vw

@add_to_gis_themes.sql 'TMA FWD PLAN PERMIT' 'X_NHCC_TMA_FWDPLAN_PERMIT_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'

@X_NHCC_TMA_FWDPLAN_NRSWA_SDO.vw

@add_to_gis_themes.sql 'TMA FWD PLAN NRSWA' 'X_NHCC_TMA_FWDPLAN_NRSWA_SDO' 'TMA_PHASES_POINT_SDO' 'V_TMA_PHASES_PT_SDO'

@X_NHCC_TMA_SITES_PERMIT_SDO.vw

@add_to_gis_themes.sql 'TMA SITES PERMIT' 'X_NHCC_TMA_SITES_PERMIT_SDO' 'TMA_SITES_SDO' 'V_TMA_SITES_SDO'

@X_NHCC_TMA_SITES_NRSWA_SDO.vw

@add_to_gis_themes.sql 'TMA SITES NRSWA' 'X_NHCC_TMA_SITES_NRSWA_SDO' 'TMA_SITES_SDO' 'V_TMA_SITES_SDO'


update nm_themes_all
set nth_feature_pk_column = 'TPHS_PHASE_ID'
where nth_feature_table in ('X_NHCC_PROPINPROG_PERMIT_SDO', 'X_NHCC_PROPINPROG_NRSWA_SDO', 
                                          'X_NHCC_TMA_COMPLETE_NRSWA_SDO', 'X_NHCC_TMA_COMPLETE_PERMIT_SDO',
                                          'X_NHCC_TMA_FWDPLAN_PERMIT_SDO', 'X_NHCC_TMA_FWDPLAN_NRSWA_SDO' );

update nm_themes_visible
set NTV_VISIBLE = 'Y'
where NTV_NTH_THEME_ID in ( Select nth_theme_id from nm_themes_all
                                                   where nth_feature_table in ('X_NHCC_PROPINPROG_PERMIT_SDO', 
                                                                                             'X_NHCC_PROPINPROG_NRSWA_SDO')
                                                 );

spool off

select * from nm_themes_all order by nth_theme_id desc
