--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_portal_cr8tab.sql	1.2 03/15/05
--       Module Name      : xact_portal_cr8tab.sql
--       Date into SCCS   : 05/03/15 00:12:08
--       Date fetched Out : 07/06/06 14:33:47
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
DROP TABLE xact_portal_categories CASCADE CONSTRAINTS
/

CREATE TABLE xact_portal_categories
   (xpc_id         NUMBER(2)     NOT NULL PRIMARY KEY
   ,xpc_text       VARCHAR2(255) NOT NULL
   ,xpc_folder_url VARCHAR2(255)
   )
/

DROP TABLE xact_portal_links CASCADE CONSTRAINTS
/

CREATE TABLE xact_portal_links
   (xpl_xpc_id       NUMBER(2)     NOT NULL
   ,xpl_id           NUMBER(2)     NOT NULL
   ,xpl_text         VARCHAR2(255) NOT NULL
   ,xpl_url          VARCHAR2(255)
   ,xpl_module       VARCHAR2(30)
   ,xpl_module_dad   VARCHAR2(30)
   ,xpl_link_style   VARCHAR2(1)   NOT NULL CHECK (xpl_link_style IN ('S','P'))
   ,xpl_window_title VARCHAR2(50)
   ,xpl_width        NUMBER(4)   CHECK (xpl_WIDTH > 0)
   ,xpl_height       NUMBER(4)   CHECK (xpl_HEIGHT > 0)
   ,xpl_toolbar      VARCHAR2(5) CHECK (xpl_TOOLBAR IN ('TRUE','FALSE'))
   ,xpl_location     VARCHAR2(5) CHECK (xpl_LOCATION IN ('TRUE','FALSE'))
   ,xpl_directories  VARCHAR2(5) CHECK (xpl_DIRECTORIES IN ('TRUE','FALSE'))
   ,xpl_status       VARCHAR2(5) CHECK (xpl_STATUS IN ('TRUE','FALSE'))
   ,xpl_menubar      VARCHAR2(5) CHECK (xpl_MENUBAR IN ('TRUE','FALSE'))
   ,xpl_scrollbars   VARCHAR2(5) CHECK (xpl_SCROLLBARS IN ('TRUE','FALSE'))
   ,xpl_resizable    VARCHAR2(5) CHECK (xpl_RESIZABLE IN ('TRUE','FALSE'))
   )
/

ALTER TABLE xact_portal_links
 ADD CONSTRAINT xpl_pk
 PRIMARY KEY (xpl_xpc_id,xpl_id)
/

ALTER TABLE xact_portal_links
 ADD CONSTRAINT xpl_xpc_fk
 FOREIGN KEY (xpl_xpc_id)
 REFERENCES xact_portal_categories (xpc_id)
 ON DELETE CASCADE
/

ALTER TABLE xact_portal_links
   ADD CONSTRAINT xpl_url_module_chk
   CHECK (DECODE(xpl_url,Null,1,0)+DECODE(xpl_module,Null,1,0)=1)
/


ALTER TABLE xact_portal_links
   ADD CONSTRAINT xpl_module_dad_chk
   CHECK (DECODE(xpl_module_dad,Null,0,1)+DECODE(xpl_module,Null,1,0)!=2)
/


