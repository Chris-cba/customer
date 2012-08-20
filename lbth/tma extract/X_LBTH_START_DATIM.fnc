create or replace function X_LBTH_START_DATIM(pi_act_start_date IN DATE , pi_proposed_start_date IN DATE) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/lbth/tma extract/X_LBTH_START_DATIM.fnc-arc   1.0   Aug 20 2012 09:09:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_LBTH_START_DATIM.fnc  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:09:48  $
--       Date fetched Out : $Modtime:   Aug 13 2012 09:17:32  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-- function written to create StartDatim XML fragment required by the view V_X_LBTH_TMA_EXTRACT 
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
as
begin
   if pi_act_start_date is not NULL then
     return  '<StartDatim Estimated="false">' || TO_CHAR(pi_act_start_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_act_start_date,'HH24:MI:SS') || '</StartDatim>'; 
   elsif pi_proposed_start_date IS NOT NULL then
      return  '<StartDatim Estimated="true">' || TO_CHAR(pi_proposed_start_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_proposed_start_date,'HH24:MI:SS') || '</StartDatim>'; 
  else
      return NULL;
  end if;       
end;
/