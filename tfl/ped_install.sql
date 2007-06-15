-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/ped_install.sql-arc   2.0   Jun 15 2007 09:53:32   smarshall  $
--       Module Name      : $Workfile:   ped_install.sql  $
--       Date into SCCS   : $Date:   Jun 15 2007 09:53:32  $
--       Date fetched Out : $Modtime:   Jun 15 2007 09:37:14  $
--       SCCS Version     : $Revision:   2.0  $
--
-----------------------------------------------------------------------------
--
-- TFL PED production and file transfer.
--

insert into x_tfl_ftp_dirs
      (ftp_type, ftp_host, ftp_username, ftp_password)
   values 
      ('PED','host','username','password');
      

update hig_modules
set hmo_filename = 'TFL3863'
where hmo_module  = 'MAI3863';

commit;
 