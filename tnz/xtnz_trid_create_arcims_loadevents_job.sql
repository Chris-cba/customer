DECLARE
   l_job  BINARY_INTEGER;
   l_what nm3type.max_varchar2;
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_create_arcims_loadevents_job.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_create_arcims_loadevents_job.sql
--       Date into SCCS   : 05/03/15 03:46:16
--       Date fetched Out : 07/06/06 14:40:37
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   l_what :=            'BEGIN'
             ||CHR(10)||'   -- This runs nm3inv_sde.process_membership_changes and '
             ||CHR(10)||'   --  also runs the ArcIMS service rebuild batch file (name'
             ||CHR(10)||'   --  in TNZIMSBAT product option'
             ||CHR(10)||'--'
             ||CHR(10)||'   xtnz_trid_dbms_job;'
             ||CHR(10)||'--'
             ||CHR(10)||'END;';
   dbms_job.submit (job            => l_job
                   ,what           => l_what
                   ,next_date      => SYSDATE
                   ,interval       => 'SYSDATE+(2/1440)'
                   );
END;
/
