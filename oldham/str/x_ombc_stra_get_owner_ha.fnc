create or replace function x_ombc_stra_get_owner_ha( pi_owner_ha varchar2) return varchar2
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/x_ombc_stra_get_owner_ha.fnc-arc   3.0   Sep 10 2010 08:24:52   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_ombc_stra_get_owner_ha.fnc  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:52  $
--       Date fetched Out : $Modtime:   Sep 10 2010 08:22:36  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--  This function was written by Aileen Heal as part of BRS 2704 
-- to loads the structures data (as assets)
--
begin

   if pi_owner_ha is null then
      return null;
   end if;

   case pi_owner_ha
      when 'BR' then    
         return 'BR';

      when 'BWB' then
         return 'BWB';

      when 'CEGB' then
         return 'CEGB';

      when 'DTp' then
         return 'DTP';
       
      when 'Education' then
         return 'EDU';  

      when 'GMC' then
         return 'GMC';  

      when 'HSG' then
         return 'HSG';  

      when 'Leisure' then
         return 'LE';  

      when 'NWWA' then
         return 'NWWA';  

      when 'Network Rail' then
         return 'NR';  

      when 'Network Rail/OMBC' then
         return 'NROMBC';  

      when 'OMBC' then 
         return  'OMBC';
      
      when 'Private' then 
         return  'PRI';

      when 'Tameside' then 
         return  'TAM';
         
      when 'Unknown' then 
         return  'NK';
 
   end case;
end;   


end;
   

