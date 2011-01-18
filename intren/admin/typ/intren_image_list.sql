create or replace type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_image_list.sql-arc   3.0   Jan 18 2011 12:38:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_image_list.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:12  $
--       Date fetched Out : $Modtime:   Sep 08 2010 15:53:12  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_image_list as varray(1048576) of intren_image_rec;
/