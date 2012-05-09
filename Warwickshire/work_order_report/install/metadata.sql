--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/install/metadata.sql-arc   1.0   May 09 2012 11:12:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   metadata.sql  $
--       Date into PVCS   : $Date:   May 09 2012 11:12:24  $
--       Date fetched Out : $Modtime:   May 09 2012 09:08:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems Ltd, 2012
-----------------------------------------------------------------------------
-- alter the server for the client site
-- These values are correct for Warwickshires deployment as of May 2012
insert into  x_bi_pub_reports
values
(  'WORK ORDER PRINT',
   'http://shvxor01:7780/',
   'EXOR REPORTS',
   'RUN_ID')
/


