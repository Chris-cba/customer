create or replace function x_ah_remove_extra_spaces( pi_in_string varchar2) return varchar2
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/x_ah_remove_extra_spaces.fnc-arc   3.0   Sep 10 2010 08:24:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_ah_remove_extra_spaces.fnc  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:48  $
--       Date fetched Out : $Modtime:   Sep 10 2010 08:22:32  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--  This function was written by Aileen Heal as part of BRS 2704 
-- it removes redundent spaces in text and then truncates the string to 40 characters
--
   v_retstr varchar2(100);
begin
   v_retstr := trim(pi_in_string);
   while( instr( v_retstr, '  ')  > 0 )
   loop
      v_retstr:= replace(v_retstr, '  ', ' ');
   end loop;
   
  return substr(v_retstr, 1, 40);
         
end;