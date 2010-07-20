---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/NSG Themes/create_nsg_themes.sql-arc   1.1   Jul 20 2010 14:37:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_nsg_themes.sql  $
--       Date into PVCS   : $Date:   Jul 20 2010 14:37:22  $
--       Date fetched Out : $Modtime:   Jul 20 2010 13:59:44  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the standard NSG Themes. 
--
-- Please read the readme.txt document in the zip file before running this script.
--
---------------------------------------------------------------------------------------------------
--
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual;

---------------------------------------------------------------------------------------------------
-- Spool to Logfile
define logfile1='create_nsg_themes_&log_extension'
set pages 0
set lines 200

spool &logfile1

set echo on
set time on

declare

  l_allow_debug hig_options.HOP_VALUE%type;
  l_yes varchar2(1);
  l_count number;

begin
  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';
 
  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;

  -- check ESU theme exists
  select count(*) 
    into l_count
    from nm_themes_all 
   where nth_feature_table = 'NM_NSG_ESU_SHAPES';
   
  if l_count = 0 then -- we have a problem ESU view does not exist.
       nm_debug.debug('ESU view NM_NSG_ESU_SHAPES is missing. Fix and then re-run script');
  else    
     insert into user_sdo_geom_metadata
        select 'NM_NSG_ESU_SHAPES',column_name,diminfo,srid
          from user_sdo_geom_metadata
         where table_name='NM_NSG_ESU_SHAPES_TABLE'
           and not exists
               (select 'x' from user_Sdo_geom_metadata
                where table_name='NM_NSG_ESU_SHAPES');

     commit;
 
     -- build point locations  
     nm_debug.debug('Building point locations');
     nm3layer_tool.BUILD_NPL_DATA;
     nm_debug.debug('Built point locations');

     -- Create street layers
     nm_debug.debug('Creating Street Layer');
  
     select count(*) 
       into l_count
       from nm_themes_all 
      where nth_feature_table in ('NM_NAT_NSGN_OFFN_SDO', 
                                  'V_NM_NAT_NSGN_OFFN_SDO', 
                                  'V_NM_NAT_NSGN_OFFN_SDO_DT');
     if l_count < 1 then       
        nm_debug.debug('Creating OFFN themes');
        nm3layer_tool.create_nsgn_layer('OFFN');
        nm_debug.debug_on;
        nm_debug.debug('OFFN themes created');
        commit;
     else -- theme already exists
        nm_debug.debug('OFFN themes already exist - Skipping');
     end if;   
   
     select count(*) 
       into l_count
       from nm_themes_all 
      where nth_feature_table in ('NM_NAT_NSGN_RDNM_SDO', 
                                  'V_NM_NAT_NSGN_RDNM_SDO', 
                                  'V_NM_NAT_NSGN_RDNM_SDO_DT');
     if l_count < 1 then       
        nm_debug.debug('Creating RDNM themes');
        nm3layer_tool.create_nsgn_layer('RDNM');
        nm_debug.debug_on;
        nm_debug.debug('RDNM themes created');
        commit;
     else -- theme already existis
        nm_debug.debug('RDNM themes already exist - Skipping');
     end if;   
    
     select count(*) 
       into l_count
       from nm_themes_all 
      where nth_feature_table in ('NM_NAT_NSGN_UOFF_SDO', 
                                  'V_NM_NAT_NSGN_UOFF_SDO', 
                                  'V_NM_NAT_NSGN_UOFF_SDO_DT');
     if l_count < 1 then       
        nm_debug.debug('  Creating UOFF');
        nm3layer_tool.create_nsgn_layer('UOFF');
        nm_debug.debug_on;
        nm_debug.debug('UOFF themes created');
        commit;
     else -- theme already existis
        nm_debug.debug('UOFF themes already exist - Skipping');
     end if;   

     nm_debug.debug('Completed Street Layer Creation');
 
     -- Create ASD layers
     nm_debug.debug('Creating ASD Layers');
     select nacl_in_use 
       into l_yes
       from nsg_asd_classifications
      where upper(NACL_DESCRIPTION) like '%ENGLAND%'; -- england

     if l_yes = 'Y' then 
        select count(*) 
          into l_count
          from nm_themes_all 
         where nth_feature_table in ('NM_NIT_TP21_SDO', 
                                     'V_NM_NIT_TP21_SDO', 
                                     'V_NM_NIT_TP21_SDO_DT');
        if l_count < 1 then       
           nm_debug.debug('Creating TP61');
           nm3layer_tool.create_nsgn_asd_layer('TP21');
           nm_debug.debug('Created TP61');
           commit;
        else
           nm_debug.debug('TP61 themes already exist - Skipping');  
        end if;

        select count(*) 
          into l_count
          from nm_themes_all 
         where nth_feature_table in ('NM_NIT_TP22_SDO', 
                                     'V_NM_NIT_TP22_SDO', 
                                      'V_NM_NIT_TP22_SDO_DT');
        if l_count < 1 then       
           nm_debug.debug('Creating TP62');
           nm3layer_tool.create_nsgn_asd_layer('TP22');
           nm_debug.debug('Created TP62');
           commit;
        else
           nm_debug.debug('TP62 themes already exist - Skipping');  
        end if;

        select count(*) 
          into l_count
          from nm_themes_all 
         where nth_feature_table in ('NM_NIT_TP23_SDO', 
                                     'V_NM_NIT_TP23_SDO', 
                                     'V_NM_NIT_TP23_SDO_DT');

        if l_count < 1 then       
           nm_debug.debug('Creating TP63');
           nm3layer_tool.create_nsgn_asd_layer('TP23');
           nm_debug.debug('Created TP63');
           commit;
        else
           nm_debug.debug('TP63 themes already exist - Skipping');  
        end if;
        
        select count(*) 
          into l_count
          from nm_themes_all 
         where nth_feature_table in ('NM_NIT_TP64_SDO', 
                                     'V_NM_NIT_TP64_SDO', 
                                     'V_NM_NIT_TP64_SDO_DT');
        if l_count < 1 then       
           nm_debug.debug('Creating TP64');
           nm3layer_tool.create_nsgn_asd_layer('TP64');
           nm_debug.debug('Created TP64');
           commit;
        else
           nm_debug.debug('TP64 themes already exist - Skipping');  
        end if;
     end if; 
     
     nm_debug.debug('Completed ASD Layer Creation');
     
     -- add locator function
     nm_debug.debug('Add Locator function');
     insert into nm_theme_functions_all
          select nth_theme_id, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'N'
            from nm_themes_all
           where nth_feature_table in ( 'V_NM_NAT_NSGN_OFFN_SDO_DT',
                                        'V_NM_NAT_NSGN_RDNM_SDO_DT',
                                        'V_NM_NAT_NSGN_UOFF_SDO_DT',
                                        'V_NM_NIT_TP21_SDO_DT', 
                                        'V_NM_NIT_TP22_SDO_DT',
                                        'V_NM_NIT_TP23_SDO_DT',
                                        'V_NM_NIT_TP64_SDO_DT')
                  and not exists (select 1 
                                    from nm_theme_functions_all 
                                   where NTF_NTH_THEME_ID  =   NTH_THEME_ID
                                    and  NTF_HMO_MODULE = 'NM0572');    
     
     commit;
     
     nm_debug.debug('All done');

   end if; -- ESU layer present
  
   nm_debug.debug_off;

   update hig_options
      set hop_value=l_allow_debug 
     where hop_id='ALLOWDEBUG';  
END;
/

--report on layer creation
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
  from nm_dbug
 where nd_session_id=USERENV('SESSIONID')
 order by nd_id;

spool off
