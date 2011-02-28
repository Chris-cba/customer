create or replace function X_NHCC_STREET_DOCTOR_SYMBOL( p_doc_status IN VARCHAR2
                                                                                                ,p_doc_category IN VARCHAR2 ) return VARCHAR2
IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS4326_street_doctor/X_NHCC_STREET_DOCTOR_SYMBOL.fnc-arc   1.0   Feb 28 2011 16:08:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_NHCC_STREET_DOCTOR_SYMBOL.fnc  $
--       Date into PVCS   : $Date:   Feb 28 2011 16:08:12  $
--       Date fetched Out : $Modtime:   Feb 15 2011 12:25:34  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : Aileen Heal
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
BEGIN

   if p_doc_category = 'RFS' then 
       return 'RED_' || p_doc_status;
   else
     return  'GREEN_' || p_doc_status;
   end if;
 
END;
                                                                                                