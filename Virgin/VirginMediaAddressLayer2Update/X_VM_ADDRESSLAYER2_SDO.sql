CREATE TABLE X_VM_ADDRESSLAYER2_SDO
(
      ADDRESS,
       STREET,
       LOCALITY,
       TOWN,
       POST_TOWN,
       POST_CODE,
       ADMINISTRATIVE_AREA,
       EASTING,
       NORTHING,
       GEOMETRY,
       OBJECTID
) 
TABLESPACE ADDRESSLAYER2
NOLOGGING
AS 
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/VirginMediaAddressLayer2Update/X_VM_ADDRESSLAYER2_SDO.sql-arc   1.0   Dec 18 2012 12:21:32   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_VM_ADDRESSLAYER2_SDO.sql  $
--       Date into PVCS   : $Date:   Dec 18 2012 12:21:32  $
--       Date fetched Out : $Modtime:   Dec 18 2012 11:56:22  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : AILEEN HEAL
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
-----------------------------------------------------------------------------
--
       ADDRESS,
       STREET,
       LOCALITY,
       TOWN,
       POST_TOWN,
       POST_CODE,
       ADMINISTRATIVE_AREA,
       EASTING,
       NORTHING,
       SDO_GEOMETRY (2001,
                     81989,
                     SDO_POINT_TYPE (EASTING, NORTHING, NULL),
                     NULL,
                     NULL),
       ROWNUM
  FROM X_VM_V_ADDLYR2_PRIMARY_ADDS;

COMMENT ON TABLE X_VM_ADDRESSLAYER2_SDO IS 'Created by Aileen Heal to hold address layer 2 data for Virgin Media';

CREATE UNIQUE INDEX X_VM_ADDRESSLAYER2_SDO_INX ON X_VM_ADDRESSLAYER2_SDO(OBJECTID)
TABLESPACE ADDRESSLAYER2
NOLOGGING
/

delete from user_sdo_geom_metadata where table_name = 'X_VM_ADDRESSLAYER2_SDO';
 
insert into user_sdo_geom_metadata 
   VALUES ( 'X_VM_ADDRESSLAYER2_SDO', 
            'GEOMETRY', 
            MDSYS.SDO_DIM_ARRAY(
                MDSYS.SDO_DIM_ELEMENT ('X', 0, 700000, 0.005 ), 
                MDSYS.SDO_DIM_ELEMENT ('Y', 0, 1300000, 0.005 )),
            81989 )
/

drop index X_VM_ADDRESSLAYER2_SDO_ISX;

CREATE INDEX X_VM_ADDRESSLAYER2_SDO_ISX ON X_VM_ADDRESSLAYER2_SDO(GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
   PARAMETERS('sdo_indx_dims=2 Tablespace = ADDRESSLAYER2')
/

create index X_VM_ADDRESSLAYER2_SDO_IDX2 on X_VM_ADDRESSLAYER2_SDO(POST_CODE)
TABLESPACE ADDRESSLAYER2
NOLOGGING
/

create index X_VM_ADDRESSLAYER2_SDO_IDX3 on X_VM_ADDRESSLAYER2_SDO(STREET)
TABLESPACE ADDRESSLAYER2
NOLOGGING
/
--here

create index X_VM_ADDRESSLAYER2_SDO_IDX4 on X_VM_ADDRESSLAYER2_SDO(TOWN)
TABLESPACE ADDRESSLAYER2
NOLOGGING
/