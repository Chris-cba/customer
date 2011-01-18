create or replace type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_image_rec.sql-arc   3.0   Jan 18 2011 12:38:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_image_rec.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:12  $
--       Date fetched Out : $Modtime:   Sep 28 2010 13:22:12  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_image_rec as object
  ( filename varchar2(180)
   ,filecontents blob
   ,filesize varchar2(100)
  )