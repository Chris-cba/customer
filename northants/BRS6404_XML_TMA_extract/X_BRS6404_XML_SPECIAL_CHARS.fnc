create  or replace function X_BRS6404_XML_SPECIAL_CHARS(pi_text IN varchar2 ) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_BRS6404_XML_SPECIAL_CHARS.fnc-arc   1.1   Dec 12 2012 11:47:34   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRS6404_XML_SPECIAL_CHARS.fnc  $
--       Date into PVCS   : $Date:   Dec 12 2012 11:47:34  $
--       Date fetched Out : $Modtime:   Dec 12 2012 11:47:12  $
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
-- this script will replace all the XML special character with the appropriate string so
-- they don't mess up the XML
--
-- 12-DEC-2012 updated by Aileen Heal to replace upside down ? as blank space (support call  ST 8001485922)
--
as
begin
   return replace(replace(replace(replace( replace( pi_text, '&' , '&amp;'), '<', '&lt;'), '>',  '&gt;'), '"',  '&quot;'), '¿', ' ');
end;

