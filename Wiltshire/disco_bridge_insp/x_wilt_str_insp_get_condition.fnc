CREATE OR REPLACE function x_wilt_str_insp_get_condition( p_item IN STR_INSP_LINES.SIL_CMP_SIT_ID%TYPE
                                                        , p_sip_id IN STR_INSP_LINES.SIL_SIP_ID%TYPE
                                                         ) return STR_INSP_LINES.sil_defect_code%TYPE
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid            : $Header:   //vm_latest/archives/customer/Wiltshire/disco_bridge_insp/x_wilt_str_insp_get_condition.fnc-arc   1.0   Oct 10 2012 09:16:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_wilt_str_insp_get_condition.fnc  $
--       Date into PVCS   : $Date:   Oct 10 2012 09:16:24  $
--       Date fetched Out : $Modtime:   Oct 10 2012 09:02:10  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley System 2012
----------------------------------------------------------------------------- 
--
-- functionten for Wiltshire by Aileen Heal(exor Consultant) in October 2012
-- to be use to createthe view x_wilt_brid_ge_insp
--
-----------------------------------------------------------------------------
--
   v_retval STR_INSP_LINES.SIL_SEVERITY%type;
begin
   select sil_defect_code 
   into v_retval
   from STR_INSP_LINES
   where sil_sip_id = p_sip_id
   and sil_cmp_sit_id = p_item;
   
   return v_retval;

exception
   when others then
      return null;
end;
/