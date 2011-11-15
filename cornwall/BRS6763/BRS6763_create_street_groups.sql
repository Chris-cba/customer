-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--        pvcsid                 : $Header:   //vm_latest/archives/customer/cornwall/BRS6763/BRS6763_create_street_groups.sql-arc   1.0   Nov 15 2011 15:43:52   Ian.Turnbull  $
--       Module Name      : $Workfile:   BRS6763_create_street_groups.sql  $
--       Date into PVCS   : $Date:   Nov 15 2011 15:43:52  $
--       Date fetched Out : $Modtime:   Nov 15 2011 12:12:38  $
--       PVCS Version     : $Revision:   1.0  $
--       Author : Aileen Heal
--
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- Written by Aileen Heal as part of work package BRS 6763 for Cornwall Nov 2011
-- The shape file Stworks2011.shp supplied by Cornwall was loaded into the database 
-- using MapBuilder as table name STWORKS2011 (SRID = 81989, geometry column GEOMETRY)
-----------------------------------------------------------------------------
 insert into tma_street_groups (TSG_ID, TSG_NAME)
          select tma_tsg_id_seq.nextval, sub_area
            from STWORKS2011;
            
commit
/       