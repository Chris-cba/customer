---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/Defect Scripts/create_sdo_themes.sql-arc   1.0   Jul 15 2010 14:32:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_sdo_themes.sql  $
--       Date into PVCS   : $Date:   Jul 15 2010 14:32:18  $
--       Date fetched Out : $Modtime:   Jul 15 2010 14:30:30  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create USER_SDO_THEME 
--
-- This script should be run as the HIG user
--
-- **** note this script is called with 5 parameter which are
-- base_table_name: table to base the theme on
-- geometry_column: geomeotry column for the theme
-- theme_name:      name of the theme to be created 
-- rule_column:     name of the column containing the attribute controling the style
-- style_name:      sdo_style name to be used.
--
---------------------------------------------------------------------------------------------------

declare 
  v_base_table user_sdo_themes.base_table%TYPE := '&1';
  v_geom_column user_sdo_geom_metadata.column_name%TYPE := '&2';   
  v_theme_name user_sdo_themes.name%type := '&3';
  v_rule_column varchar2(100) := '&4';
  v_style_name user_sdo_styles.name%type := '&5';
  v_dummy varchar2(1000);
  v_ok number := 0;
  
begin

  -- check we have 5 parameters
  if    length(v_base_table) = 0 
     or length(v_geom_column) = 0 
     or length(v_theme_name) = 0 
     or length(v_rule_column) = 0 
     or length(v_style_name) = 0 then
     
      dbms_output.put_line( 'invalid values for parameters base table: ' || v_base_table || 
                            ' geometry col: ' || v_geom_column ||
                            ' theme name: ' || v_theme_name ||
                            ' rule column: ' || v_rule_column ||
                            ' style name: ' || v_style_name );
        v_ok := -1;
  end if;
  
  -- check table and spatial column exists
  if v_ok <> -1 then
    begin
      select column_name
        into v_dummy
        from user_sdo_geom_metadata 
        where table_name = v_base_table and column_name = v_geom_column;
          
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dbms_output.put_line( v_base_table || '(' || v_geom_column || ') details not in USER_SDO_GEOM_METADATA ');
        v_ok := -1;
      when others then
        dbms_output.put_line( 'Error finding ' || v_base_table || ' (' || v_geom_column || ') in USER_SDO_GEOM_METADATA :' || 
                             SQLCODE||': '|| SQLERRM );
        v_ok := -1;
    end;    
  end if;
  
  -- rename the exor themes to sensible name
  if v_ok <> -1 then
    begin 
      dbms_output.put_line( 'Renaming EXOR Theme to ' || v_theme_name );
      update nm_themes_all 
        set nth_theme_name = v_theme_name
        where nth_feature_table = v_base_table;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dbms_output.put_line( 'Error finding theme for ' || v_base_table || ' in nm_theme_all.');
        v_ok := -1;
      when others then
        dbms_output.put_line( 'Error finding ' || v_base_table || ' in user_sdo_themes :' || SQLCODE||': '|| SQLERRM );
        v_ok := -1;
    end; 
  end if;
  
  -- delete sdo theme if exists
  IF v_ok <> -1 then
    dbms_output.put_line( 'backup and delete SDO theme if exists' );
    BEGIN
      insert into user_sdo_themes
         select v_theme_name || '_OLD', DESCRIPTION,BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES 
           from user_sdo_themes 
          where name = v_theme_name; 
         
      delete from user_sdo_themes where name = v_theme_name;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        null; -- ignore all OK
      when others then
        dbms_output.put_line( 'Error deleting sdo_theme ' || v_theme_name || ' from user_sdo_themes :' || SQLCODE||': '|| SQLERRM );
        v_ok := -1;
    END; 
  END IF;
  
  -- Creating SDO Theme 
  if v_ok <> -1 then
    dbms_output.put_line( 'Creating SDO Theme ' || v_theme_name );
    begin
      insert into user_sdo_themes (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES )
         values ( v_theme_name, 'EXOR THEME ' || v_theme_name,v_base_table, v_geom_column,
                  '<?xml version="1.0" standalone="yes"?>' ||
	          '<styling_rules key_column="OBJECTID">' ||
	          '<rule column="' || v_rule_column || '">' ||
	          '<features style="' || v_style_name || '"> </features>' ||
	          '</rule> </styling_rules>');  	          
    exception
      when others then
         dbms_output.put_line( 'Error creating theme: ' ||SQLCODE||': '|| SQLERRM );
         v_ok := -1;
    end;
  end if;
  
  if v_ok <> -1 then
    commit;
    dbms_output.put_line( 'SUCCESS');
  end if;  
    
END;
/