CREATE OR REPLACE
PROCEDURE xtnz_trid_dbms_job IS

--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_dbms_job.prc	1.1 03/15/05
--       Module Name      : xtnz_trid_dbms_job.prc
--       Date into SCCS   : 05/03/15 03:46:18
--       Date fetched Out : 07/06/06 14:40:38
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
--
   c_tnz_ims_batch_file_name CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('TNZIMSBAT');
--
   CURSOR cs_exists IS
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  nm_members_sde_temp
                        ,nm_inv_types
                  WHERE  nmst_obj_type       = nit_inv_type
                   AND   nit_elec_drain_carr = '#'
                 );
--
   CURSOR cs_inv_types IS
   SELECT nmst_obj_type
    FROM  nm_members_sde_temp
   GROUP BY nmst_obj_type;
--
   CURSOR cs_is_snapshot (c_snapshot_name VARCHAR2
                         ,c_owner         VARCHAR2
                         ) IS
   SELECT 1
    FROM  dba_snapshots s
   WHERE  s.owner      = c_owner
    AND   s.name       = c_snapshot_name;
--
   l_trid_found             BOOLEAN := FALSE;
   l_is_snapshot            BOOLEAN;
   l_dummy                  PLS_INTEGER;
--
   l_tab_inv_types          nm3type.tab_varchar4;
   l_snapshot_name          VARCHAR2(30);
   c_app_owner     CONSTANT VARCHAR2(30) := hig.get_application_owner;
--
BEGIN
--
   -- If we have a batch file set up to call
   --  see if there are any rows in the temp table
   --  which have the correct nit_elec_drain_carr - i.e. they are TRID records
   IF c_tnz_ims_batch_file_name IS NOT NULL
    THEN
      OPEN  cs_exists;
      FETCH cs_exists INTO l_dummy;
      l_trid_found := cs_exists%FOUND;
      CLOSE cs_exists;
   END IF;
--
   -- Get a distinct list of all inv types
   --  in the temp table
   OPEN  cs_inv_types;
   FETCH cs_inv_types
    BULK COLLECT
    INTO l_tab_inv_types;
   CLOSE cs_inv_types;
--
   IF l_tab_inv_types.COUNT != 0
    THEN
      -- Call the procedure to process the membership changes
      nm3inv_sde.process_membership_changes;
   END IF;
--
   -- if we have a batch file set and there are some
   --  items of the correct type which have changed then
   --  call the batch file
   IF   c_tnz_ims_batch_file_name IS NOT NULL
    AND l_trid_found
    THEN
      nm3javautil.exec_sde_bat_file (pi_filename => c_tnz_ims_batch_file_name);
   END IF;
--
   -- Loop through all the inventory types that were in the temporary table
   FOR i IN 1..l_tab_inv_types.COUNT
    LOOP
      --
      -- If the _SDE_VIEW view for this table is actually a snapshot then
      --  refresh it
      --
      l_snapshot_name := nm3inv_sde.get_inv_sde_view_name (l_tab_inv_types(i));
      OPEN  cs_is_snapshot (c_snapshot_name => l_snapshot_name
                           ,c_owner         => c_app_owner
                           );
      FETCH cs_is_snapshot
       INTO l_dummy;
      l_is_snapshot := cs_is_snapshot%FOUND;
      CLOSE cs_is_snapshot;
      IF l_is_snapshot
       THEN
         dbms_snapshot.refresh (l_snapshot_name);
      END IF;
   END LOOP;
--
END xtnz_trid_dbms_job;
/
