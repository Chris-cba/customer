---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/NSG Themes/readme.txt-arc   1.0   Jul 19 2010 09:33:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   readme.txt  $
--       Date into PVCS   : $Date:   Jul 19 2010 09:33:24  $
--       Date fetched Out : $Modtime:   Jul 19 2010 09:32:32  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--

These scripts creates the standard NSG themes 
   * Type 1 and 2 Streets
   * Type 3 Streets
   * Type 4 Streets
   * Type 61
   * Type 62
   * Type 63
   * Type 64
   
This script will not create they Scottish ASD layers i.e. Type 51, 52 & 53.    

WARNING:
=======
If the NSG theme already exists and were created before version 4200 the themes may actually be called TYPE 21, TYPE 22 & TYPE 23.  
After running the script you should either change these via the GIS Themes form or using MapBuilder duplicate the themes 'TYPE 61', 'Type 62', 'Type 63' and call them 'Type 21', 'Type 22' & 'Type 23 (you should do this before adding the themes to the map in MapBuilder).
   
The following files exits:

create_nsg_themes.sql
=====================
This file creates the themes listed above if they don't already exist.  

create_nsg_sdo_styles_and_themes.sql
====================================
This script will create the necessary sdo_styles and sdo_themes. If the sdo_style or sdo_theme already exists it is renamed <theme names>_old.
n.b. this script is 4200 complaint so the ASD themes are now called TYPE_61, TYPE_62, TYPE_63 & TYPE_64.

create_road_name_search.sql
============================
This creates the foreign table metadata model for RNAM and associates it with the theme for Type 1 & 2 Streets

What you needs to do.

1. Run create_nsg_themes.sql
2. Run create_nsg_sdo_styles_and_themes.sql
3. Run create_road_name_search.sql
4. Open up MapBuilder and add the new themes to the map. Remember to set the zoom layering.
5. Restart MapViewer
6. If you get error can not create map, make sure one of the layers on the map are sent to visible.

