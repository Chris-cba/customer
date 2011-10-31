create OR REPLACE view X_V_BRS6644_ADDRESS_SDO as
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Derby City/BRS6644/X_V_BRS6644_ADDRESS_SDO.vw-arc   1.0   Oct 31 2011 14:19:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_V_BRS6644_ADDRESS_SDO.vw  $
--       Date into PVCS   : $Date:   Oct 31 2011 14:19:24  $
--       Date fetched Out : $Modtime:   Oct 31 2011 11:56:32  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
--
-- Written as part of services work (BRS6644) for Derby City 
-----------------------------------------------------------------------------
-- $Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved. $  
-----------------------------------------------------------------------------
select 
UPRN                                                                                                                                                                                              
,x_brs6644_address( SAO_ST_NO,SAO_ST_SUF, SAO_END_NO,SAO_END_SUF,SAO_TEXT,                                                                                                                                                                                 
                    PAO_ST_NO,PAO_ST_SUF,PAO_END_NO,PAO_END_SUF,PAO_TEXT) HOUSE_NAME_NUM                                                                                                                                                                                 
,USRN                                                                                                                                                                                           
,STREET                                                                                                                                                                                   
,LOCALITY                                                                                                                                                                                  
,TOWN                                                                                                                                                                                      
,POSTCODE                                                                                                                                                                                  
,POSTABLE_ADDRESS                                                                                                                                                                                  
,ROAD_CLASS                                                                                                                                                                                  
,IIT_X                                                                                                                                                                                             
,IIT_Y   
,OBJECTID                                                                                                                                                                                         
,GEOLOC
,IIT_NE_ID
from V_NM_ONA_LLPG_SDO_DT;

insert into user_sdo_geom_metadata 
select 'X_V_BRS6644_ADDRESS_SDO', COLUMN_NAME, DIMINFO, SRID
from user_sdo_geom_metadata where table_name = 'V_NM_ONA_LLPG_SDO_DT';

commit;
