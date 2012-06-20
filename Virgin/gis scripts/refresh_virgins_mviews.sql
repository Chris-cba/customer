--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.1   Jun 20 2012 09:21:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Jun 20 2012 09:21:48  $
--       Date fetched Out : $Modtime:   Jun 20 2012 08:14:34  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
---------------------------------------------------------------------------------------------------
--
--  this script will drop and recreate the Vrigin NSG Materalised views. 
--
-- updated 14th march 2011 by Aileen heal to drop the spatial indexes before dropping the materalised views 
-- to overcome the error ORA-04020 When Dropping Materialized View with a Spatial Index
-- see http://www.oracledistilled.com/oracle-database/troubleshooting/ora-04020-when-dropping-materialized-view-with-a-spatial-index/
--
-- updated 31st March 2011 to includ PVCS header in view definition.
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
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.1   Jun 20 2012 09:21:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Jun 20 2012 09:21:48  $
--       Date fetched Out : $Modtime:   Jun 20 2012 08:14:34  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- write to create materalised view for Virgin's theme TYPE 21
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
---------------------------------------------------------------------------------------------------
          i.TP21_IIT_NE_ID,
          i.TP21_ROAD_STATUS,
          s.objectid,
          s.geoloc
     FROM v_nm_nsg_asd_tp21 i, nm_nit_tp21_sdo s
    WHERE i.tp21_iit_ne_id = s.ne_id;


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
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.1   Jun 20 2012 09:21:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Jun 20 2012 09:21:48  $
--       Date fetched Out : $Modtime:   Jun 20 2012 08:14:34  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- write to create materalised view for Virgin's theme TYPE 22
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
---------------------------------------------------------------------------------------------------
          i.TP22_IIT_NE_ID,
          i.TP22_REINSTATEMENT,
          s.objectid, s.geoloc
     FROM v_nm_nsg_asd_tp22 i, nm_nit_tp22_sdo s
    WHERE i.tp22_iit_ne_id = s.ne_id; 

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
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.1   Jun 20 2012 09:21:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Jun 20 2012 09:21:48  $
--       Date fetched Out : $Modtime:   Jun 20 2012 08:14:34  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- write to create materalised view for Virgin's theme TYPE 23
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
---------------------------------------------------------------------------------------------------
          i.TP23_IIT_NE_ID,
          i.TP23_DESIG_CODE, 
          s.objectid, s.geoloc
     FROM v_nm_nsg_asd_tp23 i, nm_nit_tp23_sdo s
    WHERE i.tp23_iit_ne_id = s.ne_id;

COMMENT ON MATERIALIZED VIEW MV_TYPE_23_LOCATOR IS 'Bespoke materialised view created by Aileen Heal for Virgin Media';

commit;

create unique index MV_TYPE_23_LOCATOR_INX 
   on MV_TYPE_23_LOCATOR(objectid) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_23_LOCATOR_NE_INX 
   on MV_TYPE_23_LOCATOR(TP23_IIT_NE_ID) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

create index MV_TYPE_23_LOCATOR_SPIDX on 
   MV_TYPE_23_LOCATOR( GEOLOC ) 
   INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = UKGAZ_INDEX');


-- *********************** MV_TYPE_21_LOCATOR_ORG_1 ****************************

DROP INDEX MV_TYPE_21_LOCATOR_ORG_1_SPIDX;

DROP MATERIALIZED VIEW MV_TYPE_21_LOCATOR_ORG_1;

CREATE MATERIALIZED VIEW MV_TYPE_21_LOCATOR_ORG_1
TABLESPACE UKGAZ_DATA as
   SELECT 
--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/gis scripts/refresh_virgins_mviews.sql-arc   1.1   Jun 20 2012 09:21:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_virgins_mviews.sql  $
--       Date into PVCS   : $Date:   Jun 20 2012 09:21:48  $
--       Date fetched Out : $Modtime:   Jun 20 2012 08:14:34  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-- write to create materalised view for Virgin's theme TYPE 21 ORG 1
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
---------------------------------------------------------------------------------------------------
          i.TP21_IIT_NE_ID,
          i.TP21_ORG_TYPE,
          s.objectid,
          s.geoloc
     FROM v_nm_nsg_asd_tp21 i, nm_nit_tp21_sdo s
    WHERE i.tp21_iit_ne_id = s.ne_id
    AND i.tp21_org_type = '1';

COMMENT ON MATERIALIZED VIEW MV_TYPE_21_LOCATOR_ORG_1 IS 'Bespoke materialised view created by Jonny Heald for Virgin Media';

CREATE UNIQUE INDEX MV_TYPE_21_LOCATOR_ORG_1_IDX 
   ON MV_TYPE_21_LOCATOR_ORG_1(OBJECTID) 
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

CREATE INDEX MV_TYPE_21_LOCATOR_ORG_1_SPIDX 
   ON MV_TYPE_21_LOCATOR_ORG_1(GEOLOC)
   INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = UKGAZ_INDEX');

CREATE INDEX MV_TYPE_21_LOC_ORG_1_NE_IDX 
   ON MV_TYPE_21_LOCATOR_ORG_1(TP21_IIT_NE_ID)
   TABLESPACE UKGAZ_INDEX
   NOLOGGING;

commit;
/

-- *********************** All Done ****************************

spool off

