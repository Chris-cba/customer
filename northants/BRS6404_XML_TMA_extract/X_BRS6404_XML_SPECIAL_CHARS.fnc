create  or replace function X_BRS6404_XML_SPECIAL_CHARS(pi_text IN varchar2 ) return varchar2
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_BRS6404_XML_SPECIAL_CHARS.fnc-arc   1.0   Oct 10 2011 13:30:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRS6404_XML_SPECIAL_CHARS.fnc  $
--       Date into PVCS   : $Date:   Oct 10 2011 13:30:18  $
--       Date fetched Out : $Modtime:   Sep 27 2011 13:19:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--    X_BRS_6404_END_DATIM
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- this script will replace all the XML specail character with the appropriate string so
-- they don't mess up the XML
as
begin
   return replace(replace(replace( replace( pi_text, '&' , '&amp;'), '<', '&lt;'), '>',  '&gt;'), '"',  '&quot;');
end;

