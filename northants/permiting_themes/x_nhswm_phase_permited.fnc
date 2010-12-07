create or replace function x_nhswm_phase_permited( v_works_id   IN NUMBER , 
                                                                                 v_phase_no  IN NUMBER ) return number
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/permiting_themes/x_nhswm_phase_permited.fnc-arc   1.0   Dec 07 2010 08:41:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_nhswm_phase_permited.fnc  $
--       Date into PVCS   : $Date:   Dec 07 2010 08:41:48  $
--       Date fetched Out : $Modtime:   Dec 07 2010 08:40:16  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : Aileen Heal
--
--   X_NHSWM_PHASE_PERMITTED
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- This unction check to see if it has received a 2010 notice (Permit Application)
-- or a 0200 ntice (initial notice for non-permitted works)
-- 
-- if 0210 notice found the return 1
-- if 0200 notice found then return 0
-- if neither found return -1 (unknown)
-----------------------------------------------------------------------------

   l_notice_type tma_notices.tnot_notice_type%TYPE;
begin
 
    begin
       select tnot_notice_type
          into l_notice_type
         from tma_notices
       where tnot_works_id = v_works_id
           and tnot_phase_no = v_phase_no   
           and tnot_notice_type in ('0200', '0210')
           and rownum =1
           order by tnot_notice_seq desc;   
   exception
      when NO_DATA_FOUND then -- no notices 
         return -1;
end;      
        
   if l_notice_type = '0210' then
      return 1;
  elsif  l_notice_type = '0200' then
      return 0;
  else
     return -1;    
  end if;                       

end;
/
