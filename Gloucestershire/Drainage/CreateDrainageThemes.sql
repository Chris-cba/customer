--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Gloucestershire/Drainage/CreateDrainageThemes.sql-arc   3.1   Mar 30 2010 13:54:46   iturnbull  $   
--       Module Name      : $Workfile:   CreateDrainageThemes.sql  $   
--       Date into PVCS   : $Date:   Mar 30 2010 13:54:46  $
--       Date fetched Out : $Modtime:   Mar 30 2010 13:33:04  $
--       PVCS Version     : $Revision:   3.1  $
--
--       Author: Aileen Heal
--------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
--------------------------------------------------------------------------------
--
-- This script was written by Aileen Heal to create the 
-- standard drainage asset themes
--
-- It is important that the asset metamodels have been loaded before this
-- script is run as it will only create themes for which the asset metamodel has 
-- beeen defined. 
--
-- You need to have loaded the drainiange styles (DRAIN_STYLES.DAT) using MapBuilder.
--
-- Before you run this script check that the nit_descr is unique in nm_inv_types. 
-- select nit_descr, count(*) num from nm_inv_types group by nit_descr having count(*) > 1
--
-- if not unique and you have 2 manholes, II and MM, change II to be interceptor.
--
--------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual;

define logfile1='CreateDrainageThemes_&log_extension'
set pages 0
set lines 200

spool &logfile1

set echo on
set time on

declare
  l_dt_view_name    nm_themes_all.nth_feature_table%type;
  l_view_name       nm_themes_all.nth_feature_table%type;
  l_gtype           nm_theme_gtypes.NTG_GTYPE%type;
  l_theme_id        nm_themes_all.nth_theme_id%type; 
  l_inv_type        nm_inv_types.NIT_INV_TYPE%type;
  l_theme_name      nm_themes_all.nth_theme_name%type;
  l_style_name      user_sdo_styles.NAME%TYPE;

  l_allow_debug     hig_options.HOP_VALUE%type;
  l_yes             varchar2(1);
  
begin

  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;
  
  -- 1st make sure all asset views exist
  nm_debug.debug('Calling NM3INV.create_all_inv_views');
  NM3INV.create_all_inv_views;
  nm_debug.debug('Done NM3INV.create_all_inv_views');

  nm_debug.debug('Creating drainage asset themes' );
  
  for rec in (select nit_INV_TYPE, NIT_PNT_OR_CONT, nit_descr
                from nm_inv_types
               where nit_inv_type in ('PP','OU','IT','GU','CQ','II','SO','BI','PS',
                                      'RE','GN','RT','CU','LD','SY','CN','EN','MM',
                                      'DB','GR','SC','DT','CE','LI','CF','FN','ND',
                                      'CK','FR','OE','CJ','RC','SP','DP','RP','IB',
                                      'PC','WL') 
             )
  loop
     nm_debug.debug('Creating theme for ' || rec.nit_INV_TYPE || ': ' || rec.nit_descr );
     
     l_inv_type := rec.nit_INV_TYPE;
     l_theme_name := substr(UPPER(rec.NIT_DESCR),1,30);
     
     l_dt_view_name := 'V_NM_ONA_' || l_inv_type || '_SDO_DT';
     l_view_name := 'V_NM_ONA_' || l_inv_type;
      
     case rec.NIT_PNT_OR_CONT
       WHEN 'P' then 
         l_gtype := '2001';
         l_style_name := 'M.EXOR.DRAIN.ASSET.' || l_inv_type;
      WHEN 'C' then
         l_gtype := '2002';
          l_style_name := 'L.EXOR.DRAIN.ASSET.' || l_inv_type;
     end case;

    -- 1st check if theme exisits
    begin
       select nth_theme_id 
         into l_theme_id
         from nm_themes_all
        where nth_feature_table = l_dt_view_name;
    exception
       when NO_DATA_FOUND then
         l_theme_id := -1;
    end;
      
    if l_theme_id < 0 then -- themes does not already exist
         nm_debug.debug('Creating GIS Theme for ' || l_inv_type || ': ' || rec.nit_descr );

       nm3sdm.make_ona_inv_spatial_layer  ( pi_nit_inv_type => l_inv_type
                                          , pi_nth_gtype    => l_gtype
                                          , pi_s_date_col   => NULL
                                          , pi_e_date_col   => NULL);
       
       -- now set theme name
       update nm_themes_all 
          set nth_theme_name = l_theme_name
        where nth_feature_table = l_dt_view_name;
 
         nm_debug.debug('Theme ' || l_theme_name || ' created for ' || l_inv_type  );
                                         
    else
         nm_debug.debug('Theme already exists for ' || l_inv_type || ' Name: ' || 
                         l_theme_name || '. So have not created.' );

    end if;
  
    -- check theme has s geometry type
    nm_debug.debug('Setting gtype for theme ' || l_theme_name || ' if necessary'  );

    insert into nm_theme_gtypes (NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO, NTG_XML_URL ) 
         select nth_theme_id, l_gtype, 1, null  
           from nm_themes_all 
          where nth_feature_table = l_dt_view_name
            and not exists (select 'x' from nm_theme_gtypes
                            where NTG_THEME_ID = nth_theme_id ); 
                            
    -- remove role from  view and add to dt_view if necessary
    nm_debug.debug('Setting roles for themes if necessary'  );
    delete from nm_theme_roles 
           where NTHR_THEME_ID in (select nth_theme_id 
                                     from nm_themes_all 
                                    where nth_feature_table = l_view_name );
    
    insert into nm_theme_roles(NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE )
       select  nth_theme_id, 'HIG_USER', 'NORMAL'
       from nm_themes_all where  nth_feature_table = l_dt_view_name 
       and   not exists (select 'x' from nm_theme_roles
                            where NTHR_THEME_ID = nth_theme_id );             
                             
     -- create useer_sdo_theme if necessary
     nm_debug.debug( 'Creating user_sdo_theme ' || l_theme_name || ' if it does not already exist' );
     
     Insert into USER_SDO_THEMES (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
          select l_theme_name, 
                 l_dt_view_name, 
                 'GEOLOC', 
                 '<?xml version="1.0" standalone="yes"?> ' ||
                 '<styling_rules key_column="OBJECTID" caching="NONE"> ' ||
                 '<rule> <features style="' || l_style_name ||
                 '"> </features> </rule> </styling_rules>' 
            from dual
           where not exists (select 'x' 
                                from USER_SDO_THEMES
                                where NAME = l_theme_name );  

     nm_debug.debug('Done ' || l_inv_type || ': ' || rec.nit_descr );

     commit;

  end loop; -- loop over all asset types

  nm_debug.debug('Completed all drainage asset themes' );

  nm_debug.debug('Creating network sdo_themes' );
  Insert into USER_SDO_THEMES (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
   Select 'PIPE NETWORK', 'DRN_NET_SDO', 'SHAPE', 
          '<?xml version="1.0" standalone="yes"?> ' ||
          '<styling_rules key_column="NE_ID" caching="NONE"> ' ||
          '<rule> <features style="L.EXOR.DRAIN.PIPE NETWORK"> </features> </rule> ' ||
          '</styling_rules>'
    from dual
         where not exists (select 'x' 
                             from USER_SDO_THEMES where NAME = 'PIPE NETWORK' );
                             
  nm_debug.debug('Completed all drainage themes' );
  
  nm_debug.debug_off;

  update hig_options
     set hop_value=l_allow_debug 
    where hop_id='ALLOWDEBUG';  

  commit;
end;
/
--report on creation of themes
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
  from nm_dbug
 where nd_session_id=USERENV('SESSIONID')
 order by nd_id;

spool off
