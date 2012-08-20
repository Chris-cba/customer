create  or replace function X_LBTH_END_DATIM(pi_act_end_date IN DATE , pi_est_end_date IN DATE) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/lbth/tma extract/X_LBTH_END_DATIM.fnc-arc   1.0   Aug 20 2012 09:09:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_LBTH_END_DATIM.fnc  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:09:46  $
--       Date fetched Out : $Modtime:   Aug 13 2012 09:08:20  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-- function written to create EndDatim XML fragment required by the view V_X_LBTH_TMA_EXTRACT 
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2012 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
as
begin
   if pi_act_end_date is not NULL then
     return  '<EndDatim Estimated="false">' || TO_CHAR(pi_act_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_act_end_date,'HH24:MI:SS') || '</EndDatim>'; 
   elsif pi_est_end_date IS NOT NULL then
      return  '<EndDatim Estimated="true">' || TO_CHAR(pi_est_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_est_end_date,'HH24:MI:SS') || '</EndDatim>'; 
  else
      return NULL;
  end if;       
end;
/