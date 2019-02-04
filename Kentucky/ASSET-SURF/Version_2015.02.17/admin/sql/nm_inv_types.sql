Insert into NM_INV_TYPES
   (NIT_INV_TYPE, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG, NIT_ELEC_DRAIN_CARR, NIT_CONTIGUOUS, 
    NIT_REPLACEABLE, NIT_EXCLUSIVE, NIT_CATEGORY, NIT_DESCR, NIT_LINEAR, 
    NIT_USE_XY, NIT_MULTIPLE_ALLOWED, NIT_END_LOC_ONLY, NIT_VIEW_NAME, NIT_START_DATE, 
    NIT_SHORT_DESCR, NIT_FLEX_ITEM_FLAG, NIT_ADMIN_TYPE, NIT_TOP, NIT_UPDATE_ALLOWED, 
    NIT_DATE_CREATED, NIT_MODIFIED_BY, NIT_CREATED_BY)
 Values
   ('SURF', 'C', 'N', 'C', 'Y','Y', 'Y', 'D', 'Derived Surface Information', 'N', 
    'N', 'Y', 'N', 'V_NM_SURF', to_date(sysdate), 'Derived Surface Information', 'N', 'INV', 'N', 'Y', 
    to_date(sysdate), 'EXOR', 'EXOR');