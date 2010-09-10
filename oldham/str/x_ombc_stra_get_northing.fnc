create or replace function x_ombc_stra_get_northing( pi_os_map_ref IN varchar2) return varchar2
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/x_ombc_stra_get_northing.fnc-arc   3.0   Sep 10 2010 08:24:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_ombc_stra_get_northing.fnc  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:50  $
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
   v_os_tile varchar2(2);
   v_y_offset varchar2(10);
   v_str varchar2(10);
   v_pos number;
   
begin
   if pi_os_map_ref is null then
      return null;
   end if;

   v_os_tile := upper(substr(pi_os_map_ref, 1, 2));
   v_str := trim(substr( pi_os_map_ref, 3));
   if (v_str like '% %') then
        v_pos := instr( v_str, ' ');
        v_y_offset := substr(v_str, v_pos + 1);
   else
      v_pos := length(v_str)/2;
       v_y_offset := substr(v_str,v_pos+1);
   end if;
       
  v_y_offset := RPAD( v_y_offset, 5, '0');
       
   case v_os_tile
      when 'SE' then
         return 400000 + to_number(v_y_offset);
      when 'SD' then
         return 400000 + to_number(v_y_offset);
   end case;

 end;