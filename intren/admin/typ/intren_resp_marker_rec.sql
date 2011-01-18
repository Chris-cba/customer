create or replace
type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_resp_marker_rec.sql-arc   3.0   Jan 18 2011 12:38:16   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_resp_marker_rec.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:16  $
--       Date fetched Out : $Modtime:   Jul 16 2010 14:07:08  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_resp_marker_rec as object
     (marker intren_marker_rec
     ,responce intren_responce_rec
     );