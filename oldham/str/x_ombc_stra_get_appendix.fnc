create or replace function x_ombc_stra_get_appendix( pi_appendix varchar2) return varchar2
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/x_ombc_stra_get_appendix.fnc-arc   3.0   Sep 10 2010 08:24:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_ombc_stra_get_appendix.fnc  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:48  $
--       Date fetched Out : $Modtime:   Sep 10 2010 08:22:34  $
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

   if pi_appendix is null then
      return null;
   end if;
      
    case pi_appendix
       when '(a)' then
          return 'A';
       when '(b)' then
          return 'B';
       when '(c)'  then
          return 'C';
       when  '( c)' then
          return 'C';   
       when '(d)' then
          return 'D';
       when '(e)' then
          return 'E';
     end case;
end;         