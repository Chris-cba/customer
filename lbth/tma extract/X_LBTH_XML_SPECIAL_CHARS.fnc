set define off;

create  or replace function X_LBTH_XML_SPECIAL_CHARS(pi_text IN varchar2 ) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/lbth/tma extract/X_LBTH_XML_SPECIAL_CHARS.fnc-arc   1.0   Aug 20 2012 09:09:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_LBTH_XML_SPECIAL_CHARS.fnc  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:09:50  $
--       Date fetched Out : $Modtime:   Aug 13 2012 09:17:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
-- 
-----------------------------------------------------------------------------
--    Copyright: (c) 2012 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- this script will replace all the XML special character with the appropriate string so
-- they don't mess up the XML
as
begin
   return replace(replace(replace( replace( pi_text, '&' , '&amp;'), '<', '&lt;'), '>',  '&gt;'), '"',  '&quot;');
end;
/
