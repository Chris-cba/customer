create  or replace function X_BRS_6404_END_DATIM(pi_act_end_date IN DATE , pi_est_end_date IN DATE) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_BRS_6404_END_DATIM.fnc-arc   1.1   Oct 12 2011 09:27:54   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRS_6404_END_DATIM.fnc  $
--       Date into PVCS   : $Date:   Oct 12 2011 09:27:54  $
--       Date fetched Out : $Modtime:   Oct 11 2011 17:03:02  $
--       PVCS Version     : $Revision:   1.1  $
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
     return  '<EndDatim Estimated="false">' || TO_CHAR(pi_act_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_act_end_date,'HH24:MI:SS') || '</EndDatim>'; 
   elsif pi_est_end_date IS NOT NULL then
      return  '<StartDatim Estimated="true">' || TO_CHAR(pi_est_end_date,'YYYY-MM-DD') || 'T' ||TO_CHAR(pi_est_end_date,'HH24:MI:SS') || '</StartDatim>'; 
  else
      return NULL;
  end if;       
end;

