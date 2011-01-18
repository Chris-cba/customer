create or replace
type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_resp_marker_list.sql-arc   3.0   Jan 18 2011 12:38:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_resp_marker_list.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:14  $
--       Date fetched Out : $Modtime:   Jul 16 2010 14:08:18  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_resp_marker_list as object
     (markers intren_marker_rec_list
     ,responce intren_responce_rec
     );