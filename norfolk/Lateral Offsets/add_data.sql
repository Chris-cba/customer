-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/add_data.sql-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   add_data.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:24:24  $
--       Version          : $Revision:   3.0  $
--
--   Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
ALTER TABLE NM_NW_XSP
    DISABLE CONSTRAINT NWX_NSC_FK;

DELETE FROM NM_TYPE_SUBCLASS;

COMMIT;

INSERT INTO NM_TYPE_SUBCLASS (NSC_NW_TYPE,
                              NSC_SUB_CLASS,
                              NSC_DESCR,
                              NSC_SEQ_NO)
   SELECT NSC_NW_TYPE,
          NSC_SUB_CLASS,
          NSC_DESCR,
          NSC_SEQ_NO
     FROM NM_TYPE_SUBCLASS_TEMP A
    WHERE NOT EXISTS (SELECT 'X' 
                      FROM NM_TYPE_SUBCLASS B 
                      WHERE A.NSC_NW_TYPE = B.NSC_NW_TYPE
                      AND A.NSC_SUB_CLASS = B.NSC_SUB_CLASS);

ALTER TABLE NM_XSP_RESTRAINTS
    DISABLE CONSTRAINT XSR_NWX_FK;

DELETE FROM NM_NW_XSP;

INSERT INTO NM_NW_XSP (NWX_NW_TYPE,
                       NWX_X_SECT,
                       NWX_NSC_SUB_CLASS,
                       NWX_DESCR,
                       NWX_SEQ,
                       NWX_OFFSET)
   SELECT NWX_NW_TYPE,
          NWX_X_SECT,
          NWX_NSC_SUB_CLASS,
          NWX_DESCR,
          NWX_SEQ,
          NWX_OFFSET
     FROM NM_NW_XSP_TEMP;

INSERT INTO NM_XSP_RESTRAINTS (XSR_NW_TYPE,
                               XSR_ITY_INV_CODE,
                               XSR_SCL_CLASS,
                               XSR_X_SECT_VALUE,
                               XSR_DESCR)
   SELECT DISTINCT XSR_NW_TYPE,
                   XSR_ITY_INV_CODE,
                   nwx_nsc_sub_class,
                   XSR_X_SECT_VALUE,
                   nwx_DESCR
     FROM NM_XSP_RESTRAINTS, NM_NW_XSP_TEMP,NM_INV_TYPES
    WHERE     NWX_NW_TYPE = XSR_NW_TYPE
          AND XSR_X_SECT_VALUE = NWX_X_SECT
          AND XSR_SCL_CLASS = 'PM'
          AND XSR_ITY_INV_CODE = NIT_INV_TYPE;

DELETE FROM NM_XSP_RESTRAINTS
      WHERE XSR_SCL_CLASS IN ('PM', 'NO');

INSERT INTO NM_XSP_REVERSAL (XRV_NW_TYPE,
                             XRV_OLD_SUB_CLASS,
                             XRV_OLD_XSP,
                             XRV_NEW_SUB_CLASS,
                             XRV_NEW_XSP,
                             XRV_MANUAL_OVERRIDE,
                             XRV_DEFAULT_XSP)
   SELECT XRV_NW_TYPE,
          o.NWX_NSC_SUB_CLASS,
          XRV_OLD_XSP,
          n.NWX_NSC_SUB_CLASS,
          XRV_NEW_XSP,
          XRV_MANUAL_OVERRIDE,
          XRV_DEFAULT_XSP
     FROM NM_XSP_REVERSAL, NM_NW_XSP_TEMP o, NM_NW_XSP_TEMP n
    WHERE     XRV_OLD_SUB_CLASS = 'PM'
          AND XRV_NW_TYPE = o.NWX_NW_TYPE
          AND XRV_NW_TYPE = n.NWX_NW_TYPE
          AND o.nwx_x_sect = xrv_old_xsp
          AND n.nwx_x_sect = xrv_new_xsp
          AND o.NWX_NW_TYPE = n.NWX_NW_TYPE
          AND o.nwx_nsc_sub_class = n.nwx_nsc_sub_class;

DELETE FROM NM_XSP_REVERSAL
      WHERE XRV_OLD_SUB_CLASS IN ('PM', 'NO');

ALTER TABLE NM_NW_XSP
    ENABLE CONSTRAINT NWX_NSC_FK;

ALTER TABLE NM_XSP_RESTRAINTS
    ENABLE CONSTRAINT XSR_NWX_FK;