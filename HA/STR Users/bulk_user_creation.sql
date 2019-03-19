   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/STR Users/bulk_user_creation.sql-arc   1.0   Mar 19 2019 17:01:30   Sarah.Williams  $
   --       Module Name      : $Workfile:   bulk_user_creation.sql  $
   --       Date into PVCS   : $Date:   Mar 19 2019 17:01:30  $
   --       Date fetched Out : $Modtime:   Mar 19 2019 16:18:06  $
   --       PVCS Version     : $Revision:   1.0  $
   ------------------------------------------------------------------
   --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
   ------------------------------------------------------------------
DROP TABLE BULK_USER_CREATION CASCADE CONSTRAINTS;

CREATE TABLE BULK_USER_CREATION
(
  BUC_NAME           VARCHAR2(30),
  BUC_INITIALS       VARCHAR2(3),
  BUC_EMAIL_ADDRESS  VARCHAR2(255),
  BUC_USERNAME       VARCHAR2(30),
  BUC_AU1            VARCHAR2(10),
  BUC_AU2            VARCHAR2(10),
  BUC_AU3            VARCHAR2(10),
  BUC_AU4            VARCHAR2(10),
  BUC_TRAIN_DATE     DATE DEFAULT trunc(sysdate),
  BUC_ACTUAL_USERNAME VARCHAR2(30),
  BUC_ACTUAL_INITIALS VARCHAR2(3),
  BUC_ERROR          VARCHAR2(1000)
);


CREATE UNIQUE INDEX BULK_USER_CREATION_PK ON BULK_USER_CREATION
(BUC_NAME, BUC_USERNAME);


ALTER TABLE BULK_USER_CREATION ADD (
  CONSTRAINT BULK_USER_CREATION_PK
  PRIMARY KEY
  (BUC_NAME, BUC_USERNAME)
  USING INDEX BULK_USER_CREATION_PK
  ENABLE VALIDATE);

