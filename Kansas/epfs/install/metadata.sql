-- create product option for SM
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Kanzas/epfs/install/metadata.sql-arc   2.0   Jul 06 2007 14:09:36   Ian Turnbull  $
--       Module Name      : $Workfile:   metadata.sql  $
--       Date into SCCS   : $Date:   Jul 06 2007 14:09:36  $
--       Date fetched Out : $Modtime:   Jul 06 2007 13:09:58  $
--       SCCS Version     : $Revision:   2.0  $

Insert into HIG_OPTION_LIST
   (HOL_ID
   , HOL_PRODUCT
   , HOL_NAME
   , HOL_REMARKS
   , HOL_DATATYPE
   , HOL_MIXED_CASE
   , HOL_USER_OPTION)
 Values
   ( 'SMPATH'
   , 'HIG'
   , 'Spatial Manager Path'
   , 'The path on the lcal machine for the arcmap executable for spatial manager'
   , 'VARCHAR2'
   , 'Y'
   , 'Y');

COMMIT;

insert into hig_option_values
   (HOV_ID
   , HOV_VALUE)
 values
   ( 'SMPATH'
   , 'c:\arcgis\arcexe83\bin\ArcMap.exe'
   );

CREATE TABLE NM3.X_KANSAS_EPFS_MAPS
(
  KEM_MODULE_ID     VARCHAR2(8 BYTE),
  KEM_MAP_NAME      VARCHAR2(250 BYTE),
  KEM_MAP_LOCATION  VARCHAR2(250 BYTE)
);

SET DEFINE OFF;
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS01', 'Non Interstate System Map', '\\exdl11\gkos_share\Temp\EPFS\epfs_ni_system');
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS02', 'Non-Interstate High Priority Project', '\\exdl11\gkos_share\Temp\EPFS\epfs_ni_projects');
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS03', 'Interstate System Map', '\\exdl11\gkos_share\Temp\EPFS\epfs_i_system');
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS04', 'Interstate High Priority Project', '\\exdl11\gkos_share\Temp\EPFS\epfs_i_projects');
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS05', 'Bridge Map', '\\exdl11\gkos_share\Temp\EPFS\epfs_bridges');
Insert into X_KANSAS_EPFS_MAPS
   (KEM_MODULE_ID, KEM_MAP_NAME, KEM_MAP_LOCATION)
 Values
   ('XEPFS06', 'Bridge High Priority Project', '\\exdl11\gkos_share\Temp\EPFS\epfs_bridge_projects');
COMMIT;


COMMIT;    