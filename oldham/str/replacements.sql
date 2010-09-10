--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/replacements.sql-arc   3.0   Sep 10 2010 08:24:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   replacements.sql  $
--       Date into PVCS   : $Date:   Sep 10 2010 08:24:46  $
--       Date fetched Out : $Modtime:   Sep 10 2010 08:22:32  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--  This script was written by Aileen Heal as part of BRS 2704 
--
--Script to to replace special character used for loading:

-- | is comma
  
update  nm_inv_items
set IIT_CHR_ATTRIB56 = replace(IIT_CHR_ATTRIB56, '|', ',')
where IIT_CHR_ATTRIB56 like '%|%'
and  iit_inv_type = 'STRA' ;

update  nm_inv_items
set IIT_CHR_ATTRIB57 = replace(IIT_CHR_ATTRIB57, '|', ',')
where IIT_CHR_ATTRIB57 like '%|%'
and  iit_inv_type = 'STRA' ;

update  nm_inv_items
set IIT_CHR_ATTRIB58 = replace(IIT_CHR_ATTRIB58, '|', ',')
where IIT_CHR_ATTRIB58 like '%|%'
and  iit_inv_type = 'STRA' ;

update  nm_inv_items
set IIT_CHR_ATTRIB59 = replace(IIT_CHR_ATTRIB59, '|', ',')
where IIT_CHR_ATTRIB59 like '%|%'
and  iit_inv_type = 'STRA' ;


-- \ is single quote '
update  nm_inv_items
set IIT_CHR_ATTRIB56 = replace(IIT_CHR_ATTRIB56, '\', '')
where IIT_CHR_ATTRIB56 like '%\%'
and  iit_inv_type = 'STRA' ;


update  nm_inv_items
set IIT_CHR_ATTRIB57 = replace(IIT_CHR_ATTRIB57, '\', '')
where IIT_CHR_ATTRIB57 like '%\%'
and  iit_inv_type = 'STRA' ;


update  nm_inv_items
set IIT_CHR_ATTRIB58 = replace(IIT_CHR_ATTRIB58, '\', '')
where IIT_CHR_ATTRIB58 like '%\%'
and  iit_inv_type = 'STRA' ;


update  nm_inv_items
set IIT_CHR_ATTRIB59 = replace(IIT_CHR_ATTRIB59, '\', '')
where IIT_CHR_ATTRIB59 like '%\%'
and  iit_inv_type = 'STRA' ;

update  nm_inv_items
set IIT_CHR_ATTRIB38 = replace(IIT_CHR_ATTRIB38, '\', '')
where IIT_CHR_ATTRIB38 like '%\%'
and  iit_inv_type = 'STRA' ;


