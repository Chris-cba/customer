-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/rta/XRTA_CREATE_LOG_708593.sql-arc   1.0   Mar 11 2009 11:58:40   cstrettle  $
--       Module Name      : $Workfile:   XRTA_CREATE_LOG_708593.sql  $
--       Date into PVCS   : $Date:   Mar 11 2009 11:58:40  $
--       Date fetched Out : $Modtime:   Mar 11 2009 11:47:16  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : na
-------------------------------------------------------------------------
SET DEFINE OFF

PROMPT **----------- START XRTA CREATE SCRIPT --------------**
--
@XRTA_DROP_LOG_708593.sql;
--
PROMPT CREATE TABLE XRTA_NM_UNIQUES 

CREATE TABLE XRTA_NM_UNIQUES 
(
XRTA_NE_ID       NUMBER(9)            ,
XRTA_TYPE        VARCHAR2(1)  NOT NULL,
XRTA_DT_CREATED  DATE         NOT NULL,
XRTA_DT_MODIFIED DATE         NOT NULL,
XRTA_CREATED     VARCHAR2(30) NOT NULL,
XRTA_MODIFIED    VARCHAR2(30) NOT NULL
); 

PROMPT CREATE CONSTRAINT XRTA_NOT_UNIQUE

ALTER TABLE XRTA_NM_UNIQUES ADD (
  CONSTRAINT XRTA_NOT_UNIQUE_CON
 UNIQUE (XRTA_NE_ID));

@xrta_nm_uniques_who_me.trg;
/
PROMPT CREATE TABLE XRTA_ERRORS

CREATE TABLE XRTA_ERRORS 
(
XRTAE_NE_ID       NUMBER(9)               ,
XRTAE_TYPE        varchar2(1)     NOT NULL,
XRTAE_SQL_ERROR   VARCHAR2(4000)          ,
XRTAE_DT_CREATED  DATE            NOT NULL,
XRTAE_CREATED     VARCHAR2(30)    NOT NULL
);

PROMPT CREATE TRIGGER XRTA_ERRORS_WHO_ME

CREATE OR REPLACE TRIGGER XRTA_ERRORS_WHO_ME
 BEFORE insert
 ON XRTA_ERRORS
 FOR each row
DECLARE
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
   SELECT sysdate
         ,user
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
    :new.XRTAE_DT_CREATED  := l_sysdate;
    :new.XRTAE_CREATED  := l_user;
--
END X_RTA_ERRORS_WHO_ME;
/

PROMPT CREATE PACKAGE xrta_nm_unique HEADER

@xrta_nm_unique.pkh;
/
PROMPT CREATE PACKAGE xrta_nm_unique BODY

@xrta_nm_unique.pkw;
/
PROMPT CREATE TRIGGER XRTA_NM_UNIQUES_POP_ELEMENTS

CREATE OR REPLACE TRIGGER XRTA_NM_UNIQUES_POP_ELEMENTS
        BEFORE INSERT OR UPDATE OF NE_ID
        ON NM_ELEMENTS_ALL
        FOR EACH ROW
BEGIN
XRTA_NM_UNIQUE.XRTA_NM_UNIQUE_INSERT(P_NE_ID => :NEW.NE_ID, P_TYPE => 'E');
END;
/

PROMPT CREATE TRIGGER X_RTA_NM_UNIQUES_POP_INV_ITEMS

CREATE OR REPLACE TRIGGER X_RTA_NM_UNIQUES_POP_INV_ITEMS
        BEFORE INSERT OR UPDATE OF IIT_NE_ID
        ON NM_INV_ITEMS_ALL
        FOR EACH ROW
BEGIN
XRTA_NM_UNIQUE.XRTA_NM_UNIQUE_INSERT(P_NE_ID => :NEW.IIT_NE_ID, P_TYPE => 'I');
END;
/
PROMPT **------------ END XRTA CREATE SCRIPT -------------**
