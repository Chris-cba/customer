create or replace function x_nhswm_permited_street( v_str_ne_id IN NUMBER ) return number
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/permiting_themes/x_nhswm_permited_street.fnc-arc   1.0   Dec 07 2010 08:41:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_nhswm_permited_street.fnc  $
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
-- This function checks to see if the streets is permitted
-----------------------------------------------------------------------------

   dummy number;
   cursor c1 is
     select TP61_STR_NE_ID
      from v_nm_nsg_asd_tp61
    where (tp61_int_auth,tp61_int_auth_district) 
          in ( select dist_org_ref,dist_ref
                  from nsg_districts
                where dist_function='9')
      and  TP61_STR_NE_ID =  v_str_ne_id;

begin

   open c1;
 
   fetch c1 into dummy;
   if c1%notfound then
       return 1;
   else
      return 0;
   end if;
   
   close c1;
   
end;
/
