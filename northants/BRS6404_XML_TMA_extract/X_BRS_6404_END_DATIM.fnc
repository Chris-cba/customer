create  or replace function X_BRS_6404_END_DATIM(pi_act_end_date IN DATE , pi_est_end_date IN DATE) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_BRS_6404_END_DATIM.fnc-arc   1.0   Oct 10 2011 13:30:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRS_6404_END_DATIM.fnc  $
--       Date into PVCS   : $Date:   Oct 10 2011 13:30:18  $
--       Date fetched Out : $Modtime:   Sep 26 2011 14:41:20  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--    X_BRS_6404_END_DATIM
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
as
begin
   if pi_act_end_date is not NULL then
     return  '<EndDatim Estimated="true">' || TO_CHAR(pi_act_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_act_end_date,'HH24:MI:SS') || '</EndDatim>'; 
   elsif pi_est_end_date IS NOT NULL then
      return  '<StartDatim Estimated="false">' || TO_CHAR(pi_est_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_est_end_date,'HH24:MI:SS') || '</StartDatim>'; 
  else
      return NULL;
  end if;       
end;

