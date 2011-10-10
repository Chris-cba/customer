create or replace function X_BRS_6404_START_DATIM(pi_act_start_date IN DATE , pi_proposed_start_date IN DATE) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_BRS_6404_START_DATIM.fnc-arc   1.0   Oct 10 2011 13:30:20   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRS_6404_START_DATIM.fnc  $
--       Date into PVCS   : $Date:   Oct 10 2011 13:30:20  $
--       Date fetched Out : $Modtime:   Sep 26 2011 14:42:52  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--    X_BRS_6404_START_DATIM
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
as
begin
   if pi_act_start_date is not NULL then
     return  '<StartDatim Estimated="true">' || TO_CHAR(pi_act_start_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_act_start_date,'HH24:MI:SS') || '</StartDatim>'; 
   elsif pi_proposed_start_date IS NOT NULL then
      return  '<StartDatim Estimated="false">' || TO_CHAR(pi_proposed_start_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_proposed_start_date,'HH24:MI:SS') || '</StartDatim>'; 
  else
      return NULL;
  end if;       
end;