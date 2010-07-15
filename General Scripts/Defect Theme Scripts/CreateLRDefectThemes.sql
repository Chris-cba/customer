---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/Defect Scripts/CreateLRDefectThemes.sql-arc   1.0   Jul 15 2010 14:32:20   Ian.Turnbull  $
--       Module Name      : $Workfile:   CreateLRDefectThemes.sql  $
--       Date into PVCS   : $Date:   Jul 15 2010 14:32:20  $
--       Date fetched Out : $Modtime:   Jul 15 2010 14:30:28  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the standandard defect LRS themes
--
-- Please read the readme.rtf document in the zip file before running this script.
--
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='CreateLRDefectsTheme&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on


declare
  l_allow_debug hig_options.HOP_VALUE%type;
  CURSOR drop_existing_defect_lyrs IS
      select * from nm_themes_all 
         where nth_feature_table in ('MAI_DEFECTS_LR_SDO', 
                                     'V_MAI_DEF_ACTIVITY_LR_SDO',
                                     'V_MAI_DEF_ACT_STA_LR_SDO', 
                                     'V_MAI_DEF_STATUS_LR_SDO');
  --

begin
  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;

  -- drop defect layers
  nm_debug.debug('Dropping LR Defect Layers');
  
  FOR i IN drop_existing_defect_lyrs
  LOOP
    nm_debug.debug('  Dropping '||i.nth_theme_name);
    nm3sdm.drop_layer(i.nth_theme_id);
  END LOOP;
  commit;

  -- create defect layers
  nm_debug.debug('Creating LR Defect Layers');
  NM3LAYER_TOOL.CREATE_DEFECT_LAYER(pi_theme_name    => 'DEFECTS',
                                    pi_asset_type    => 'DEFX',
                                    pi_asset_descr   => 'Defects LRS',
                                    pi_x_column      =>  NULL,
                                    pi_y_column      =>  NULL,
                                    pi_lr_ne_column  => 'DEF_RSE_HE_ID',
                                    pi_lr_st_chain   => 'DEF_ST_CHAIN');
                                    
  nm_debug.debug('Created LR Defect Layers');
 
   nm_debug.debug_off;
 
   update hig_options
   set hop_value=l_allow_debug 
   where hop_id='ALLOWDEBUG';

end;
/

--report on layer creation
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
from nm_dbug
where nd_session_id=USERENV('SESSIONID')
and substr(nd_text,1,2) in ('  ','Dr','Cr','Co')
order by nd_id

/

-- now update the description for the metamodel
update nm_inv_types_all set nit_descr = 'Defects' where nit_inv_type = 'DEFX';
commit;


-- create defects by status sdo theme
@create_sdo_themes.sql 'V_MAI_DEF_STATUS_LR_SDO' 'GEOLOC' 'DEFECTS BY STATUS' 'DEFECT_STATUS_CODE' 'V.EXOR.DEFECT.STATUS - V1.0'

-- create defects by CATEGORY sdo theme
@create_sdo_themes.sql 'V_MAI_DEF_ACT_STA_LR_SDO' 'GEOLOC' 'DEFECTS BY CATEGORY' 'DEFECT_PRIORITY' 'V.EXOR.DEFECT.CATEGORY - V1.0'


insert into nm_theme_functions_all 
  select nth_theme_id, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'N'
    from nm_themes_all 
   where nth_theme_name in ('DEFECTS', 'DEFECTS BY STATUS', 'DEFECTS BY CATEGORY')
     and not exists ( select 'x' from nm_theme_functions_all 
                   where nth_theme_id = ntf_nth_theme_id and ntf_hmo_module = 'NM0572' )
/
                  
commit;

spool off


