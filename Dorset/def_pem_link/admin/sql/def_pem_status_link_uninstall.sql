-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Dorset/def_pem_link/admin/sql/def_pem_status_link_uninstall.sql-arc   1.0   Sep 06 2011 16:21:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   def_pem_status_link_uninstall.sql  $
--       Date into PVCS   : $Date:   Sep 06 2011 16:21:46  $
--       Date fetched Out : $Modtime:   Sep 06 2011 15:18:48  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : PStanton

drop table x_def_pem_status;

drop trigger x_dorset_def_pem_status_link;