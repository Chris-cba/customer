LOAD DATA
APPEND
INTO TABLE X_VM_ADDRESSLAYER2 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
trailing nullcols
 ( OBJECT_ID sequence(MAX,1),
   OS_THEME,
   OS_ADDRESS_TOID,
   OS_APR,
   RM_UDPRN,
   RM_UMRRN,
   RM_ADDRESS_KEY,
   RM_ORGANISATION_KEY,
   VO_CT_UARN,
   VO_NDR_UARN,
   OS_REF_TO_ADDRESS_TOID, 
   OS_REF_TO_OSAPR, 
   OS_REF_TO_TOPOGRAPHY_TOID,
   OS_REF_TO_CARTO_TEXT_TOID,
   OS_REF_TO_ITN_ROAD_LINK_TOID,
   OS_REF_TO_ITN_ROAD_TOID,
   RM_REF_TO_UDPRN,
   RM_REF_TO_ADDRESS_KEY,
   RM_REF_TO_ORGANISATION_KEY,
   OS_ADDRESS_VERSION,
   OS_REASON_FOR_CHANGE_1,
   OS_CHANGE_DATE_1 			DATE "YYYY-MM-DD",
   OS_REASON_FOR_CHANGE_2,
   OS_CHANGE_DATE_2 			DATE "YYYY-MM-DD",
   OS_ADDRESS_VERSION_DATE 		DATE "YYYY-MM-DD",
   OS_TOPOGRAPHY_VERSION,
   OS_CARTO_TEXT_VERSION,
   OS_ITN_ROAD_LINK_VERSION,
   OS_ITN_ROAD_VERSION,
   RM_POSTAL_ADDRESS_DATE 		DATE "YYYY-MM-DD",
   OS_BS7666_SECDARY_ADD_OBJ_NAME,
   OS_BS7666_PRIMARY_ADD_OBJ_NAME,
   OS_BS7666_STREET,
   OS_BS7666_LOCALITY,
   OS_BS7666_TOWN,
   OS_BS7666_ADMINISTRATIVE_AREA,
   OS_BS7666_POSTCODE,
   OS_ALT_SUB_BUILDING_NAME,
   OS_ALT_BUILDING_NAME,
   OS_ALT_BUILDING_NUMBER,
   OS_ALT_DEPEND_THOROUGHFARE,
   OS_ALT_THOROUGHFARE_NAME,
   RM_DP_ORGANISATION_NAME,
   RM_DP_DEPARTMENT_NAME,
   RM_DP_PO_BOX_NUMBER,
   RM_DP_SUB_BUILDING_NAME,
   RM_DP_BUILDING_NAME,
   RM_DP_BUILDING_NUMBER,
   RM_DP_DEPENDENT_THOROUGHFARE,
   RM_DP_THOROUGHFARE_NAME,
   RM_DP_DOUBLE_DEPEND_LOCALITY,
   RM_DP_DEPENDENT_LOCALITY,
   RM_DP_POST_TOWN,
   RM_DP_POSTCODE,
   RM_DP_POSTCODE_TYPE,
   RM_DP_DELIVERY_POINT_SUFFIX,
   RM_WEL_DP_DEPEND_THOROUGHFARE,
   RM_WELSH_DP_THOROUGHFARE_NAME,
   RM_WEL_DP_DP_DEPEND_LOCALITY,
   RM_WELSH_DP_DEPENDENT_LOCALITY,
   RM_WELSH_DP_POST_TOWN,
 RM_ALIAS_DP_ALSO_KNOWN_AS,
 RM_ALIAS_DP_BUILDING_NAME,
 RM_ALIAS_DP_DEPARTMENT_NAME,
 RM_ALIAS_DP_ORG_DESCRIPTION,
 RM_ALIAS_DP_ORG_ATA_RESIDENT,
 RM_ALIAS_DP_TRADING_NAME,
 RM_ALIAS_WELSH_ALTERNATIVE,
 RM_TPO_ORGANISATION_NAME,
 RM_TPO_PO_BOX_NUMBER,
 RM_TPO_GEOGRAPHICAL_ADDRESS,
 RM_TPO_POSTCODE,
 RM_MR_ORGANISATION_NAME,
 RM_MR_DEPARTMENT_NAME,
 RM_MR_SUB_BUILDING_NAME,
 RM_MR_BUILDING_NAME,
 RM_MR_BUILDING_NUMBER,
 RM_MR_DEPEND_THOROUGHFARE,
 RM_MR_THOROUGHFARE_NAME,
 RM_MR_DB_DEPENDENT_LOCALITY,
 RM_MR_DEPENDENT_LOCALITY,
 RM_MR_POST_TOWN,
 RM_MR_POSTCODE,
 VO_NDR_FIRM_NAME,
 OS_PO_BOX_FLAG,
 RM_MULTI_OCC_COUNT,
 LA_CODE,
 OS_EASTING,
 OS_NORTHING,
 OS_MATCH_STATUS,
 OS_PHYSICAL_STATUS,
 OS_POSITION_ACCURACY,
 OS_POSITION_STATUS,
 OS_STRUCTURE_TYPE, 
 OS_SPATIAL_REFERENCING_SYSTEM, 
 OS_BASE_FUNCTION, 
 NLUD_LAND_USE_GROUP, 
 VO_NDR_PDESC_CODE, 
 VO_NDR_SCAT_CODE, 
 OS_CLASSIFICATION_CONFIDENCE  )
