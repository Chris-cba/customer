REM////////////////////////////////////////////////////////////////////////////
REM   Subversion controlled - SQL template
REM////////////////////////////////////////////////////////////////////////////
REM Id              : $Id:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/cleansing/install/undo.sql-arc   1.0   Jan 14 2016 19:42:38   Sarah.Williams  $
REM Date            : $Date:   Jan 14 2016 19:42:38  $
REM Revision        : $Revision:   1.0  $
REM Changed         : $LastChangedDate:    $
REM Last Revision   : $LastChangedRevision:$
REM Last Changed By : $LastChangedBy: $
REM URL             : $URL: $
REM ///////////////////////////////////////////////////////////////////////////
REM Descr: This script was originally written by PS. 
REM        The script should reverse the metadata changes that are made for
REM        the document bundles data removal process.
REM    
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/cleansing/install/undo.sql-arc   1.0   Jan 14 2016 19:42:38   Sarah.Williams  $
--       Module Name      : $Workfile:   undo.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 19:42:38  $
--       Date fetched Out : $Modtime:   Jul 09 2013 13:05:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : H.Buckley
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2012
-----------------------------------------------------------------------------
--
--   HIG_PROCESS_TYPE_FREQUENCIES
--   HIG_PROCESS_TYPE_FILES
--   HIG_PROCESS_TYPE_FILE_EXT                    

set term on

prompt Info: Deleting Process Type Frequencies

delete 
from  hig_process_type_frequencies
where hpfr_process_type_id = ( select hpt_process_type_id
                               from   hig_process_types
                               where  hpt_name = 'Document Bundles Data Cleansing' );

prompt Info: Deleting Process Type Roles
delete 
from  hig_process_type_roles
where hptr_process_type_id = ( select hpt_process_type_id
                               from   hig_process_types
                               where  hpt_name = 'Document Bundles Data Cleansing' );


prompt Info: Deleting Processes
delete
from  hig_processes
where hp_process_type_id=( select hpt_process_type_id
                      from   hig_process_types
                      where  hpt_name = 'Document Bundles Data Cleansing' );

prompt Info: Deleting Process Types
delete 
from   hig_process_types
where  hpt_name = 'Document Bundles Data Cleansing';


