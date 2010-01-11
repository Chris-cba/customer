/* Formatted on 2009/11/20 11:11 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW xsp_restraints (xsr_nw_type,
                                             xsr_ity_inv_code,
                                             xsr_scl_class,
                                             xsr_x_sect_value,
                                             xsr_descr,
                                             xsr_date_created,
                                             xsr_date_modified,
                                             xsr_modified_by,
                                             xsr_created_by
                                            )
AS
   SELECT 
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/sineco/admin/sql/sineco_xsp_restraints.sql-arc   3.1   Jan 11 2010 12:11:04   swilliams  $
--       Module Name      : $Workfile:   sineco_xsp_restraints.sql  $
--       Date into PVCS   : $Date:   Jan 11 2010 12:11:04  $
--       Date fetched Out : $Modtime:   Jan 11 2010 12:10:20  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
-- bespoke version modified by IT and SW to allow for the fact that
-- Sineco do not have D or L as network types.  This version created
-- 20-NOV-2009 the silly looking decode for network type is to force
-- the view column to varchar2(4) otherwise nm3inv package gives 
-- signature errors.
-- 11-JAN-2010 SW amended Ds to Ls as Sineco have gone from DoT to Local
--             referencing.
          decode(xsr_nw_type,xsr_nw_type,'L',null,'L','L   ') xsr_nw_type, xsr_ity_inv_code, xsr_scl_class, xsr_x_sect_value,
          xsr_descr, xsr_date_created, xsr_date_modified, xsr_modified_by,
          xsr_created_by
     FROM nm_xsp_restraints
   UNION
   SELECT 'L' nwx_nw_type, '$$', nwx_nsc_sub_class, nwx_x_sect, nwx_descr,
          NULL, NULL, NULL, NULL
     FROM nm_xsp;


