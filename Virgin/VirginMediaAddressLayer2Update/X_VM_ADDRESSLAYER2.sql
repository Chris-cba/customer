--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/VirginMediaAddressLayer2Update/X_VM_ADDRESSLAYER2.sql-arc   1.0   Dec 18 2012 12:21:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_VM_ADDRESSLAYER2.sql  $
--       Date into PVCS   : $Date:   Dec 18 2012 12:21:30  $
--       Date fetched Out : $Modtime:   Dec 18 2012 11:55:20  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2012
-----------------------------------------------------------------------------
--
drop table X_VM_ADDRESSLAYER2;

CREATE TABLE X_VM_ADDRESSLAYER2
(
  OBJECT_ID                       NUMBER(38),
  OS_THEME                        VARCHAR2(20 BYTE),
  OS_ADDRESS_TOID                 VARCHAR2(20 BYTE) NOT NULL,
  OS_APR                          VARCHAR2(20 BYTE),
  RM_UDPRN                        NUMBER,
  RM_UMRRN                        NUMBER,
  RM_ADDRESS_KEY                  NUMBER,
  RM_ORGANISATION_KEY             NUMBER,
  VO_CT_UARN                      NUMBER,
  VO_NDR_UARN                     NUMBER,
  OS_REF_TO_ADDRESS_TOID          VARCHAR2(20 BYTE),
  OS_REF_TO_OSAPR                 VARCHAR2(20 BYTE),
  OS_REF_TO_TOPOGRAPHY_TOID       VARCHAR2(20 BYTE),
  OS_REF_TO_CARTO_TEXT_TOID       VARCHAR2(20 BYTE),
  OS_REF_TO_ITN_ROAD_LINK_TOID    VARCHAR2(20 BYTE),
  OS_REF_TO_ITN_ROAD_TOID         VARCHAR2(20 BYTE),
  RM_REF_TO_UDPRN                 NUMBER,
  RM_REF_TO_ADDRESS_KEY           NUMBER,
  RM_REF_TO_ORGANISATION_KEY      NUMBER,
  OS_ADDRESS_VERSION              NUMBER,
  OS_REASON_FOR_CHANGE_1          VARCHAR2(30 BYTE),
  OS_CHANGE_DATE_1                DATE,
  OS_REASON_FOR_CHANGE_2          VARCHAR2(30 BYTE),
  OS_CHANGE_DATE_2                DATE,
  OS_ADDRESS_VERSION_DATE         DATE,
  OS_TOPOGRAPHY_VERSION           NUMBER,
  OS_CARTO_TEXT_VERSION           NUMBER,
  OS_ITN_ROAD_LINK_VERSION        NUMBER,
  OS_ITN_ROAD_VERSION             NUMBER,
  RM_POSTAL_ADDRESS_DATE          DATE,
  OS_BS7666_SECDARY_ADD_OBJ_NAME  VARCHAR2(110 BYTE),
  OS_BS7666_PRIMARY_ADD_OBJ_NAME  VARCHAR2(200 BYTE),
  OS_BS7666_STREET                VARCHAR2(80 BYTE),
  OS_BS7666_LOCALITY              VARCHAR2(80 BYTE),
  OS_BS7666_TOWN                  VARCHAR2(60 BYTE),
  OS_BS7666_ADMINISTRATIVE_AREA   VARCHAR2(100 BYTE),
  OS_BS7666_POSTCODE              VARCHAR2(8 BYTE),
  OS_ALT_SUB_BUILDING_NAME        VARCHAR2(30 BYTE),
  OS_ALT_BUILDING_NAME            VARCHAR2(50 BYTE),
  OS_ALT_BUILDING_NUMBER          NUMBER,
  OS_ALT_DEPEND_THOROUGHFARE      VARCHAR2(80 BYTE),
  OS_ALT_THOROUGHFARE_NAME        VARCHAR2(80 BYTE),
  RM_DP_ORGANISATION_NAME         VARCHAR2(60 BYTE),
  RM_DP_DEPARTMENT_NAME           VARCHAR2(60 BYTE),
  RM_DP_PO_BOX_NUMBER             VARCHAR2(6 BYTE),
  RM_DP_SUB_BUILDING_NAME         VARCHAR2(30 BYTE),
  RM_DP_BUILDING_NAME             VARCHAR2(50 BYTE),
  RM_DP_BUILDING_NUMBER           NUMBER,
  RM_DP_DEPENDENT_THOROUGHFARE    VARCHAR2(80 BYTE),
  RM_DP_THOROUGHFARE_NAME         VARCHAR2(80 BYTE),
  RM_DP_DOUBLE_DEPEND_LOCALITY    VARCHAR2(35 BYTE),
  RM_DP_DEPENDENT_LOCALITY        VARCHAR2(35 BYTE),
  RM_DP_POST_TOWN                 VARCHAR2(30 BYTE),
  RM_DP_POSTCODE                  VARCHAR2(8 BYTE),
  RM_DP_POSTCODE_TYPE             VARCHAR2(5 BYTE),
  RM_DP_DELIVERY_POINT_SUFFIX     VARCHAR2(2 BYTE),
  RM_WEL_DP_DEPEND_THOROUGHFARE   VARCHAR2(80 BYTE),
  RM_WELSH_DP_THOROUGHFARE_NAME   VARCHAR2(80 BYTE),
  RM_WEL_DP_DP_DEPEND_LOCALITY    VARCHAR2(35 BYTE),
  RM_WELSH_DP_DEPENDENT_LOCALITY  VARCHAR2(35 BYTE),
  RM_WELSH_DP_POST_TOWN           VARCHAR2(30 BYTE),
  RM_ALIAS_DP_ALSO_KNOWN_AS       VARCHAR2(50 BYTE),
  RM_ALIAS_DP_BUILDING_NAME       VARCHAR2(50 BYTE),
  RM_ALIAS_DP_DEPARTMENT_NAME     VARCHAR2(50 BYTE),
  RM_ALIAS_DP_ORG_DESCRIPTION     VARCHAR2(50 BYTE),
  RM_ALIAS_DP_ORG_ATA_RESIDENT    VARCHAR2(50 BYTE),
  RM_ALIAS_DP_TRADING_NAME        VARCHAR2(50 BYTE),
  RM_ALIAS_WELSH_ALTERNATIVE      VARCHAR2(50 BYTE),
  RM_TPO_ORGANISATION_NAME        VARCHAR2(60 BYTE),
  RM_TPO_PO_BOX_NUMBER            VARCHAR2(6 BYTE),
  RM_TPO_GEOGRAPHICAL_ADDRESS     VARCHAR2(325 BYTE),
  RM_TPO_POSTCODE                 VARCHAR2(8 BYTE),
  RM_MR_ORGANISATION_NAME         VARCHAR2(60 BYTE),
  RM_MR_DEPARTMENT_NAME           VARCHAR2(60 BYTE),
  RM_MR_SUB_BUILDING_NAME         VARCHAR2(30 BYTE),
  RM_MR_BUILDING_NAME             VARCHAR2(50 BYTE),
  RM_MR_BUILDING_NUMBER           NUMBER,
  RM_MR_DEPEND_THOROUGHFARE       VARCHAR2(80 BYTE),
  RM_MR_THOROUGHFARE_NAME         VARCHAR2(80 BYTE),
  RM_MR_DB_DEPENDENT_LOCALITY     VARCHAR2(35 BYTE),
  RM_MR_DEPENDENT_LOCALITY        VARCHAR2(35 BYTE),
  RM_MR_POST_TOWN                 VARCHAR2(30 BYTE),
  RM_MR_POSTCODE                  VARCHAR2(8 BYTE),
  VO_NDR_FIRM_NAME                VARCHAR2(50 BYTE),
  OS_PO_BOX_FLAG                  VARCHAR2(6 BYTE),
  RM_MULTI_OCC_COUNT              NUMBER,
  LA_CODE                         NUMBER,
  OS_EASTING                      NUMBER,
  OS_NORTHING                     NUMBER,
  OS_MATCH_STATUS                 VARCHAR2(37 BYTE),
  OS_PHYSICAL_STATUS              VARCHAR2(10 BYTE),
  OS_POSITION_ACCURACY            VARCHAR2(20 BYTE),
  OS_POSITION_STATUS              VARCHAR2(20 BYTE),
  OS_STRUCTURE_TYPE               VARCHAR2(18 BYTE),
  OS_SPATIAL_REFERENCING_SYSTEM   VARCHAR2(5 BYTE),
  OS_BASE_FUNCTION                VARCHAR2(120 BYTE),
  NLUD_LAND_USE_GROUP             VARCHAR2(4 BYTE),
  VO_NDR_PDESC_CODE               VARCHAR2(5 BYTE),
  VO_NDR_SCAT_CODE                VARCHAR2(4 BYTE),
  OS_CLASSIFICATION_CONFIDENCE    NUMBER
) 
TABLESPACE ADDRESSLAYER2
NOLOGGING;

COMMENT ON TABLE X_VM_ADDRESSLAYER2 IS 'Tables created by Aileen Heal to hold address layer 2 data for Virgin Media';


ALTER TABLE X_VM_ADDRESSLAYER2 ADD (
  PRIMARY KEY
 (OBJECT_ID)
    USING INDEX 
    TABLESPACE ADDRESSLAYER2 );
    
