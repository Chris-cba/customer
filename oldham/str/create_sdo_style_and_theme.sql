--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/create_sdo_style_and_theme.sql-arc   3.0   Sep 10 2010 08:24:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_sdo_style_and_theme.sql  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:46  $
--       Date fetched Out : $Modtime:   Sep 10 2010 08:22:36  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--  This script was written by Aileen Heal as part of BRS 2704 
-- to create sdo style and theme for structures
--
Insert into ATLAS.USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.X.OMBC.STRUCTURES', 'MARKER',  
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in">  <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF0000;width:12;height:12;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<polyline points="50.0,199.0,0.0,100.0,50.0,1.0,149.0,1.0,199.0,100.0,149.0,199.0" /> </g> </svg>');

Insert into ATLAS.USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('STRUCTURES', 'V_NM_ONA_STRA_SDO_DT', 'GEOLOC', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="OBJECTID"> <rule> ' ||
    '<features style="M.X.OMBC.STRUCTURES"> </features> ' ||
    '<label column="BRIDGE_NAME" style="T.EXOR.SIMPLE"> 1 </label> ' ||
    '</rule> </styling_rules>');
