REM////////////////////////////////////////////////////////////////////////////
REM   Subversion controlled - SQL template
REM////////////////////////////////////////////////////////////////////////////
REM Id              : $Id:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/admin/pck/hig_data_cleansing.pkb-arc   1.0   Jan 14 2016 22:37:18   Sarah.Williams  $
REM Date            : $Date:   Jan 14 2016 22:37:18  $
REM Revision        : $Revision:   1.0  $
REM Changed         : $LastChangedDate:    $
REM Last Revision   : $LastChangedRevision:$
REM Last Changed By : $LastChangedBy: $
REM URL             : $URL: $
REM ///////////////////////////////////////////////////////////////////////////
REM Descr: This package was originally written by PS. I have been asked to
REM        modify the package so that it makes use of separate FTP locations.
REM        

CREATE OR REPLACE PACKAGE BODY hig_data_cleansing
as
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/admin/pck/hig_data_cleansing.pkb-arc   1.0   Jan 14 2016 22:37:18   Sarah.Williams  $
--       Module Name      : $Workfile:   hig_data_cleansing.pkb  $
--       Date into PVCS   : $Date:   Jan 14 2016 22:37:18  $
--       Date fetched Out : $Modtime:   Jul 08 2013 14:48:40  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : H.Buckley
--
--   %YourObjectName% body
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems ltd, 2012
-----------------------------------------------------------------------------
--
-- all global package variables here
--
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid  CONSTANT varchar2(2000) :='" "';

   g_package_name CONSTANT varchar2(30) := 'HIG_DATA_CLEANSING';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
----<PRAGMA>
  PRAGMA RESTRICT_REFERENCES(get_version, RNDS, WNPS, WNDS);
  PRAGMA RESTRICT_REFERENCES(get_body_version, RNDS, WNPS, WNDS);
--</PRAGMA>
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
Procedure RemoveData( expiration_date in date)
is
   now date:=trunc(sysdate);
begin

     if nvl(expiration_date,now) > now
     then -- log an error indicating that the entered date is not in the past.
          hig_process_api.log_it(pi_message     => 'Error: Entered expiration date is NOT in the past.'
                                ,pi_summary_flag=> 'N');
     else   -- hig_transfer_log
            -- there is no cascade delete between hig_file_transfer_log 
            -- and hig_file_transfer_queue - so remove children before the parent
            delete 
            from  hig_file_transfer_log
            where hftl_hftq_batch_no in (select c.dbfr_hftq_batch_no
                                         from  doc_bundles a
                                              ,doc_bundle_files b
                                              ,doc_bundle_file_relations c
                                         where a.dbun_success_flag = 'Y'
                                         and   a.dbun_date_created < expiration_date
                                         and   b.dbf_bundle_id     = a.dbun_bundle_id
                                         and   b.dbf_file_id       = c.dbfr_child_file_id);
            --
            hig_process_api.log_it(pi_message     => 'Info: Batch Transfer Log records removed.'
                                  ,pi_summary_flag=> 'Y');
            delete 
            from hig_file_transfer_queue
            where hftq_batch_no in (select c.dbfr_hftq_batch_no
                                    from doc_bundles a
                                        ,doc_bundle_files b
                                        ,doc_bundle_file_relations c
                                    where a.dbun_success_flag = 'Y'
                                    and a.dbun_date_created   < expiration_date
                                    and b.dbf_bundle_id       = a.dbun_bundle_id
                                    and b.dbf_file_id         = c.dbfr_child_file_id);
           --
           hig_process_api.log_it(pi_message     => 'Info: File Transfer Queue records removed.'
                                 ,pi_summary_flag=> 'Y');
           -- then clear any doc_bundles which will also cascade delete any doc_bundle_files
           --
           delete 
           from  doc_bundle_files
           where exists ( select null
                          from   doc_bundles
                          where dbun_success_flag = 'Y'
                          and   dbun_date_created < expiration_date);
           --
           hig_process_api.log_it(pi_message     => 'Info: Document Bundle Files removed.'
                                 ,pi_summary_flag=> 'Y');
           --
           delete 
           from  doc_bundles
           where dbun_success_flag = 'Y'
           and   dbun_date_created < expiration_date;
           --
           hig_process_api.log_it(pi_message     => 'Info: Doc Bundles records removed.'
                                 ,pi_summary_flag=> 'Y');
     end if;                                

end RemoveData;
--
-----------------------------------------------------------------------------
--
END hig_data_cleansing;
/
