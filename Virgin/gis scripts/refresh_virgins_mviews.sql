--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.2   Nov 27 2013 13:17:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Nov 27 2013 13:17:18  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:28:44  $
--       PVCS Version     : $Revision:   1.2  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) Bentley Systems (UK) Ltd 2013
---------------------------------------------------------------------------------------------------
--
-- This script will drop and recreate the Virgin NSG Materalised views. 
--
-- Updated 15th October 2013 to use different views and to remove unused materalized view
--
-- Updated 14th march 2011 by Aileen Heal to drop the spatial indexes before dropping the materalised views 
-- to overcome the error ORA-04020 When Dropping Materialized View with a Spatial Index
-- see http://www.oracledistilled.com/oracle-database/troubleshooting/ora-04020-when-dropping-materialized-view-with-a-spatial-index/
--
-- Updated 31st March 2011 to include PVCS header in view definition.
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='refresh_virgin_mviews_&log_extension'
set pages 0
set lines 200

spool &logfile1

set echo on
set time on

-- *********************** TYPE 21 ****************************
DROP INDEX MV_TYPE_21_LOCATOR_SPIDX;

DROP MATERIALIZED VIEW MV_TYPE_21_LOCATOR;

CREATE MATERIALIZED VIEW  MV_TYPE_21_LOCATOR 
TABLESPACE UKGAZ_DATA as
   SELECT 
--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.2   Nov 27 2013 13:17:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Nov 27 2013 13:17:18  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:28:44  $
--       PVCS Version     : $Revision:   1.2  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- Written to create materalised view for Virgin's theme TYPE 21
---------------------------------------------------------------------------------------------------
--    Copyright (c) Bentley Systems (UK) Ltd 2013
---------------------------------------------------------------------------------------------------
     *      FROM V_NM_NIT_TP21_SDO_DT;


COMMENT ON MATERIALIZED VIEW MV_TYPE_21_LOCATOR IS 'Bespoke materialised view created by Aileen Heal for Virgin Media';
 
commit;

create unique index MV_TYPE_21_LOCATOR_INX 
   on MV_TYPE_21_LOCATOR(objectid) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_21_LOCATOR_NE_INX 
   on MV_TYPE_21_LOCATOR(TP21_IIT_NE_ID) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_21_LOCATOR_SPIDX on 
   MV_TYPE_21_LOCATOR( GEOLOC ) 
   INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = UKGAZ_INDEX');

-- *********************** TYPE 22 ****************************
DROP INDEX MV_TYPE_22_LOCATOR_SPIDX;

DROP MATERIALIZED VIEW MV_TYPE_22_LOCATOR;

CREATE MATERIALIZED VIEW  MV_TYPE_22_LOCATOR 
TABLESPACE UKGAZ_DATA as
   SELECT 
--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.2   Nov 27 2013 13:17:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Nov 27 2013 13:17:18  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:28:44  $
--       PVCS Version     : $Revision:   1.2  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- Written to create materalised view for Virgin's theme TYPE 22
---------------------------------------------------------------------------------------------------
--    Copyright (c) Bentley Systems (UK) Ltd 2013
---------------------------------------------------------------------------------------------------
     *      FROM V_NM_NIT_TP22_SDO_DT;


COMMENT ON MATERIALIZED VIEW MV_TYPE_22_LOCATOR IS 'Bespoke materialised view created by Aileen Heal for Virgin Media';

commit;

create unique index MV_TYPE_22_LOCATOR_INX 
   on MV_TYPE_22_LOCATOR(objectid) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_22_LOCATOR_NE_INX 
   on MV_TYPE_22_LOCATOR(TP22_IIT_NE_ID) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_22_LOCATOR_SPIDX on 
   MV_TYPE_22_LOCATOR( GEOLOC ) 
   INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = UKGAZ_INDEX');

-- *********************** TYPE 23 ****************************
DROP INDEX MV_TYPE_23_LOCATOR_SPIDX;

DROP MATERIALIZED VIEW MV_TYPE_23_LOCATOR;

CREATE MATERIALIZED VIEW  MV_TYPE_23_LOCATOR 
TABLESPACE UKGAZ_DATA as
   SELECT 
--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.2   Nov 27 2013 13:17:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Nov 27 2013 13:17:18  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:28:44  $
--       PVCS Version     : $Revision:   1.2  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- Written to create materalised view for Virgin's theme TYPE 23
---------------------------------------------------------------------------------------------------
--    Copyright (c) Bentley Systems (UK) Ltd 2013
---------------------------------------------------------------------------------------------------
     *      FROM V_NM_NIT_TP23_SDO_DT;

COMMENT ON MATERIALIZED VIEW MV_TYPE_23_LOCATOR IS 'Bespoke materialised view created by Aileen Heal for Virgin Media';

commit;

create unique index MV_TYPE_23_LOCATOR_INX 
   on MV_TYPE_23_LOCATOR(objectid) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_23_LOCATOR_NE_INX 
   on MV_TYPE_23_LOCATOR(IIT_NE_ID) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_23_LOCATOR_SPIDX on 
   MV_TYPE_23_LOCATOR( GEOLOC ) 
   INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = UKGAZ_INDEX');

-- *********************** All Done ****************************

spool off

