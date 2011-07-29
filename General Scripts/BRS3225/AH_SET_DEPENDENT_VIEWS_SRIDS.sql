CREATE OR REPLACE PROCEDURE AH_SET_DEPENDENT_VIEWS_SRIDS( p_table  IN VARCHAR2
                                                                                                           , p_column IN VARCHAR2
                                                                                                           , p_theme_id IN NUMBER
                                                                                                           , p_srid  IN NUMBER )  AS 
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                    : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/AH_SET_DEPENDENT_VIEWS_SRIDS.sql-arc   1.2   Jul 29 2011 08:12:38   Ian.Turnbull  $
--       Module Name        : $Workfile:   AH_SET_DEPENDENT_VIEWS_SRIDS.sql  $
--       Date into PVCS     : $Date:   Jul 29 2011 08:12:38  $
--       Date fetched Out  : $Modtime:   Jul 28 2011 16:22:20  $
--       PVCS Version       : $Revision:   1.2  $
--
--
--   Author : Aileen Heal
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- These scripts are for use by exor consultants only. They should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
-- set dependent views srid in user_sdo_geom_metadata
   l_reg_sde_layer  hig_options.HOP_VALUE%type;

begin

   l_reg_sde_layer := hig.get_sysopt('REGSDELYR');

  -- set all the sub ordinates view on the base table
   update mdsys.SDO_GEOM_METADATA_TABLE
             set sdo_srid = p_srid
        where sdo_table_name = p_table 
           and sdo_column_name = p_column
           and sdo_owner != user;
     
   -- now do the dependent views    
   for rec in (select * from nm_themes_all where NTH_BASE_TABLE_THEME = p_theme_id )
   loop
      update mdsys.SDO_GEOM_METADATA_TABLE
            set sdo_srid = p_srid
       where sdo_table_name = rec.NTH_FEATURE_TABLE 
           and sdo_column_name = rec.NTH_FEATURE_SHAPE_COLUMN;
   end loop;
   
end;
/