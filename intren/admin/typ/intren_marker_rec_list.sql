create or replace type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_marker_rec_list.sql-arc   3.0   Jan 18 2011 12:38:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_marker_rec_list.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:14  $
--       Date fetched Out : $Modtime:   Jul 14 2010 10:50:26  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_marker_rec_list AS VARRAY(1048576) OF intren_marker_rec;
/
