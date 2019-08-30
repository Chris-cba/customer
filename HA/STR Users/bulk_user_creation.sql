   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/STR Users/bulk_user_creation.sql-arc   1.1   Aug 30 2019 18:22:50   Sarah.Williams  $
   --       Module Name      : $Workfile:   bulk_user_creation.sql  $
   --       Date into PVCS   : $Date:   Aug 30 2019 18:22:50  $
   --       Date fetched Out : $Modtime:   Aug 30 2019 18:23:02  $
   --       PVCS Version     : $Revision:   1.1  $
   ------------------------------------------------------------------
   --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
   ------------------------------------------------------------------
DROP TABLE BULK_USER_CREATION CASCADE CONSTRAINTS;

CREATE TABLE BULK_USER_CREATION
(
   BUC_NAME              VARCHAR2 (30),
   BUC_INITIALS          VARCHAR2 (3),
   BUC_EMAIL_ADDRESS     VARCHAR2 (255),
   BUC_USERNAME          VARCHAR2 (30),
   BUC_AU1               VARCHAR2 (10),
   BUC_AU2               VARCHAR2 (10),
   BUC_AU3               VARCHAR2 (10),
   BUC_AU4               VARCHAR2 (10),
   BUC_TRAIN_DATE        DATE DEFAULT TRUNC (SYSDATE),
   BUC_ACTUAL_USERNAME   VARCHAR2 (30),
   BUC_ACTUAL_INITIALS   VARCHAR2 (3),
   BUC_ERROR             VARCHAR2 (1000),
   buc_hesro             VARCHAR2 (1),
   buc_hesc              VARCHAR2 (1),
   buc_hesie             VARCHAR2 (1),
   buc_henspad            VARCHAR2 (1),
   buc_henspo            VARCHAR2 (1),
   buc_henspau            VARCHAR2 (1),
   buc_hesmpc            VARCHAR2 (1),
   buc_hesmpa            VARCHAR2 (1),
   buc_hesmpm            VARCHAR2 (1),
   buc_hesca             VARCHAR2 (1),
   buc_hesu              VARCHAR2 (1),
   buc_spsro             VARCHAR2 (1),
   buc_spsie             VARCHAR2 (1),
   buc_spsi              VARCHAR2 (1),
   buc_spse              VARCHAR2 (1),
   buc_spsia             VARCHAR2 (1),
   buc_spsim             VARCHAR2 (1),
   buc_spslm             VARCHAR2 (1),
   buc_spspc             VARCHAR2 (1),
   buc_spspm             VARCHAR2 (1),
   buc_spsla             VARCHAR2 (1),
   buc_spssau            VARCHAR2 (1),
   buc_spsaau            VARCHAR2 (1),
   buc_spsrmu            VARCHAR2 (1),
   buc_tposro            VARCHAR2 (1),
   buc_tpospd            VARCHAR2 (1)
);


CREATE UNIQUE INDEX BULK_USER_CREATION_PK
   ON BULK_USER_CREATION (BUC_NAME, BUC_USERNAME);


ALTER TABLE BULK_USER_CREATION ADD (
  CONSTRAINT BULK_USER_CREATION_PK
  PRIMARY KEY
  (BUC_NAME, BUC_USERNAME)
  USING INDEX BULK_USER_CREATION_PK
  ENABLE VALIDATE);
