create or replace
type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_responce_rec.sql-arc   3.0   Jan 18 2011 12:38:16   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_responce_rec.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:16  $
--       Date fetched Out : $Modtime:   Jul 21 2010 16:09:32  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_responce_rec as object
     (datetime varchar(50) -- date and time of the procedure call   
     ,message  varchar2(4000) -- success or fail message
     ,codeversion varchar2(100) -- pvcs version tags header and body
     ,responce_code varchar(12)
     );