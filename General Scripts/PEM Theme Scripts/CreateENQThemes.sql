---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/PEM Theme Scripts/CreateENQThemes.sql-arc   1.0   Jul 15 2010 14:34:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   CreateENQThemes.sql  $
--       Date into PVCS   : $Date:   Jul 15 2010 14:34:46  $
--       Date fetched Out : $Modtime:   Jul 15 2010 14:32:58  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the standard enquiry themes 'ENQUIRY BY SOURCE', 'ENQUIRY BY TYPE' 
--
-- Please read the readme.rtf document in the zip file before running this script.
--
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='CreateENQThemes&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

declare
  l_allow_debug hig_options.HOP_VALUE%type;
  CURSOR drop_existing_enq_lyrs IS
      select * from nm_themes_all 
         where nth_feature_table in ('ENQ_ENQUIRIES_XY_SDO', 
                                     'V_ENQ_BY_STATUS_XY_SDO',
                                     'V_ENQ_BY_SOURCE_XY_SDO', 
                                     'V_ENQ_BY_STATUS_SOURCE_XY_SDO');
begin
  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;
  
  -- drop enquiries layers
  nm_debug.debug('Dropping ENQ Layers');
  
  FOR i IN drop_existing_enq_lyrs
  LOOP
    nm_debug.debug('  Dropping '||i.nth_theme_name);
    nm3sdm.drop_layer(i.nth_theme_id);
    nm_debug.debug('  Dropped '||i.nth_theme_name);
  END LOOP;
  commit;

  -- drop metadata
  nm_debug.debug('Dropping ENQ metadata');
  delete from nm_inv_type_attribs_all where ita_inv_type = 'ENQ';
  delete from nm_inv_type_roles where itr_inv_type = 'ENQ';
  delete from nm_inv_types_all where nit_inv_type = 'ENQ';
  delete from nm_inv_attri_lookup where ial_domain like 'ENQ_%';
  
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_STATUS_CODE_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_SOURCE_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_CATEGORY_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_CLASS_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_TYPE_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_RECORDED_BY_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_RESP_OF_DOM';
  delete from nm_inv_domains where id_domain = 'ENQ_DOC_PRIORITY_DOM';
  commit;
  nm_debug.debug('Dropped ENQ metadata');
  
  -- create enquiry layers and metadata
  nm_debug.debug('Creating ENQ Layers');
  NM3LAYER_TOOL.CREATE_ENQ_LAYER(pi_theme_name    => 'ENQUIRIES',
                                 pi_asset_type    => 'ENQ',
                                 pi_asset_descr   => 'ENQUIRES',
                                 pi_x_column      => 'DOC_COMPL_EAST',
                                 pi_y_column      => 'DOC_COMPL_NORTH',
                                 pi_lr_ne_column  => NULL,
                                 pi_lr_st_chain   => NULL);
                                    
  nm_debug.debug('Created ENQ Layers');
 
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

-- update description for asset metamodel
update nm_inv_types_all set nit_descr = 'Enquiries' where nit_inv_type = 'ENQ';

@create_sdo_themes.sql 'V_ENQ_BY_SOURCE_XY_SDO' 'GEOLOC' 'ENQUIRIES BY SOURCE' 'DOC_SOURCE' 'V.EXOR.ENQ.SOURCE - V 1.0'

-- create enquiries by status sdo theme
@create_sdo_themes.sql 'V_ENQ_BY_STATUS_XY_SDO' 'GEOLOC' 'ENQUIRIES BY STATUS' 'DOC_STATUS' 'V.EXOR.ENQ.STATUS - V 1.0'

commit;

spool off


