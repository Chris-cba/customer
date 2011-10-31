create or replace function x_brs6644_address( pi_sao_start_num IN NUMBER
                                                                             , pi_sao_start_suffix IN VARCHAR2
                                                                             , pi_sao_end_num IN NUMBER
                                                                             , pi_sao_end_suffix IN VARCHAR2
                                                                             , pi_sao_text  IN VARCHAR2
                                                                             , pi_pao_start_num IN NUMBER
                                                                             , pi_pao_start_suffix IN VARCHAR2
                                                                             , pi_pao_end_num IN NUMBER
                                                                             , pi_pao_end_suffix IN VARCHAR2
                                                                             , pi_pao_text  IN VARCHAR2 ) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:$
--       Module Name      : $Workfile:$
--       Date into PVCS   : $Date:$
--       Date fetched Out : $Modtime:$
--       PVCS Version     : $Revision:$
--
--   Author : Aileen Heal
--
-- Written as part of services work (BRS6644) for Derby City to construct the
-- name/number portion of an address from the LLPG fields.
-- To be used to construct the spatial view X_V_BRS6644_ADDRESS_SDO
-----------------------------------------------------------------------------
-- $Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved. $  
-----------------------------------------------------------------------------
as
   v_pao VARCHAR2(128);
   v_sao VARCHAR2(128);
BEGIN
   if pi_sao_start_num is not null then
      v_sao := to_char(pi_sao_start_num);
   end if;
   if pi_sao_start_suffix is not null then
      v_sao := v_sao || pi_sao_start_suffix;
   end if;
--      
   if pi_sao_end_num is not null then
      if  v_sao is not null then 
         v_sao := v_sao || ' - ';
      end if;
      v_sao := v_sao || pi_sao_end_num;
   end if;
   if pi_sao_end_suffix is not null then
      v_sao := v_sao || pi_sao_end_suffix;
   end if;
--   
   if pi_sao_text is not null then
     if v_sao is not null then
                v_sao := v_sao || ' ';
     end if;
     v_sao := v_sao || pi_sao_text;
  end if;           
--      
   if pi_pao_start_num is not null then
         v_pao :=  to_char(pi_pao_start_num);
   end if;
   if pi_pao_start_suffix is not null then
      v_pao := v_pao || pi_pao_start_suffix;
   end if;
--      
   if pi_pao_end_num is not null then
      if  v_pao is not null then 
         v_pao := v_pao || ' - ';
      end if;
      v_pao := v_pao || pi_pao_end_num;
   end if;
--      
   if pi_pao_end_suffix is not null then
      v_pao := v_pao || pi_pao_end_suffix;
   end if;      
--
   if pi_pao_text is not null then
     if v_pao is not null then
                v_pao := v_pao || ' ';
     end if;
     v_pao := v_pao || pi_pao_text;
  end if;           

   if v_sao is not null and v_pao is not null then
        return v_sao || ' ' || v_pao;
   elsif v_sao is not null then
        return v_sao;
   elsif v_pao is not null then
      return v_pao;
   else
      return null;
   end if;       
END;
/                                                                             