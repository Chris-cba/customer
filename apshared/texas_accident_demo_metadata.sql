
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
DROP TABLE texas_user_messages;
--CREATE TABLE texas_user_messages
--   (tum_id                 NUMBER(9)               NOT NULL
--   ,tum_hus_user_id        NUMBER(9)               NOT NULL
--   ,tum_start_date         DATE                    NOT NULL
--   ,tum_status             VARCHAR2(1) DEFAULT 'N' NOT NULL
--   ,tum_priority           VARCHAR2(30)            NOT NULL
--   ,tum_sender_hus_user_id NUMBER(9)               NOT NULL
--   ,tum_message            VARCHAR2(240)           NOT NULL
--   );
------
DROP  SEQUENCE tum_id_seq;
--CREATE SEQUENCE tum_id_seq;
----
--ALTER TABLE texas_user_messages
-- ADD CONSTRAINT tum_pk
-- PRIMARY KEY (tum_id)
--/
----
--INSERT INTO texas_user_messages
--SELECT tum_id_seq.nextval
--      ,hus_user_id
--      ,TRUNC(SYSDATE)
--      ,'N'
--      ,'Normal'
--      ,1
--      ,'Welcome to CRIS'
-- FROM  hig_users;


DELETE FROM hig_module_roles
WHERE hmr_module LIKE 'CRIS000%';
DELETE FROM hig_modules
WHERE hmo_module LIKE 'CRIS000%';

DECLARE
--
--  HIG_MODULES and HIG_MODULE_ROLES
--
   TYPE tab_rec_module IS TABLE OF hig_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_hmo     hig_modules%ROWTYPE;
   l_tab_rec_hmo tab_rec_module;
--
   l_tab_hmr_module nm3type.tab_varchar30;
   l_tab_hmr_role   nm3type.tab_varchar30;
   l_tab_hmr_mode   nm3type.tab_varchar30;
--
   l_hmo_count      PLS_INTEGER := 0;
   l_hmr_count      PLS_INTEGER := 0;
--
   PROCEDURE add_hmo IS
   BEGIN
      l_hmo_count := l_hmo_count + 1;
      l_tab_rec_hmo(l_hmo_count) := l_rec_hmo;
   END add_hmo;
--
   PROCEDURE add_hmr (p_role   VARCHAR2
                     ,p_mode   VARCHAR2
                     ,p_module VARCHAR2 DEFAULT l_rec_hmo.hmo_module
                     ) IS
   BEGIN
      l_hmr_count := l_hmr_count + 1;
      l_tab_hmr_module(l_hmr_count) := UPPER(p_module);
      l_tab_hmr_role(l_hmr_count)   := UPPER(p_role);
      l_tab_hmr_mode(l_hmr_count)   := UPPER(p_mode);
   END add_hmr;
--
BEGIN
--
   l_rec_hmo.hmo_module           := 'CRIS0001';
   l_rec_hmo.hmo_title            := 'Crash Records Information System';
   l_rec_hmo.hmo_filename         := 'texas_accident_demo.launch';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_acc;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr('HIG_USER',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'CRIS0002';
   l_rec_hmo.hmo_title            := 'Modify/View a Crash Record (ST-3 Form)';
   l_rec_hmo.hmo_filename         := 'texas_accident_demo.launch';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_acc;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr('HIG_USER',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'CRIS0003';
   l_rec_hmo.hmo_title            := 'Enter a New Crash Record';
   l_rec_hmo.hmo_filename         := 'texas_accident_demo.launch';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_acc;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr('HIG_USER',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'CRIS0004';
   l_rec_hmo.hmo_title            := 'Find Crash Record';
   l_rec_hmo.hmo_filename         := 'texas_accident_demo.launch';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_acc;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr('HIG_USER',nm3type.c_normal);
--
   FOR i IN 1..l_hmo_count
    LOOP
      l_rec_hmo := l_tab_rec_hmo(i);
      INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
      SELECT l_rec_hmo.hmo_module
            ,l_rec_hmo.hmo_title
            ,l_rec_hmo.hmo_filename
            ,l_rec_hmo.hmo_module_type
            ,l_rec_hmo.hmo_fastpath_opts
            ,l_rec_hmo.hmo_fastpath_invalid
            ,l_rec_hmo.hmo_use_gri
            ,l_rec_hmo.hmo_application
            ,l_rec_hmo.hmo_menu
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_rec_hmo.hmo_module
                       );
   END LOOP;
--
   FORALL i IN 1..l_hmr_count
      INSERT INTO hig_module_roles
            (hmr_module
            ,hmr_role
            ,hmr_mode
            )
      SELECT l_tab_hmr_module(i)
            ,l_tab_hmr_role(i)
            ,l_tab_hmr_mode(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_module_roles
                        WHERE  hmr_module = l_tab_hmr_module(i)
                         AND   hmr_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_roles
                        WHERE  hro_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_tab_hmr_module(i)
                       );
--
END;
/


CREATE INDEX acc_texas_demo_ind ON ACC_ITEMS_ALL_ALL (acc_ait_id, acc_status) UNRECOVERABLE
/

DECLARE
--
-- HIG_DOMAINS and HIG_CODES
--
   l_tab_hdo_domain     nm3type.tab_varchar30;
   l_tab_hdo_product    nm3type.tab_varchar30;
   l_tab_hdo_title      nm3type.tab_varchar2000;
   l_tab_hdo_code_len   nm3type.tab_number;
--
   l_tab_hco_domain     nm3type.tab_varchar30;
   l_tab_hco_code       nm3type.tab_varchar30;
   l_tab_hco_meaning    nm3type.tab_varchar2000;
   l_tab_hco_system     nm3type.tab_varchar4;
   l_tab_hco_seq        nm3type.tab_number;
   l_tab_hco_start_date nm3type.tab_date;
   l_tab_hco_end_date   nm3type.tab_date;
--
   l_hdo_count        PLS_INTEGER := 0;
   l_hco_count        PLS_INTEGER := 0;
--
   PROCEDURE add_hdo (p_domain   VARCHAR2
                     ,p_product  VARCHAR2
                     ,p_title    VARCHAR2
                     ,p_code_len NUMBER
                     ) IS
   BEGIN
      l_hdo_count := l_hdo_count + 1;
      l_tab_hdo_domain(l_hdo_count)   := UPPER(p_domain);
      l_tab_hdo_product(l_hdo_count)  := UPPER(p_product);
      l_tab_hdo_title(l_hdo_count)    := p_title;
      l_tab_hdo_code_len(l_hdo_count) := p_code_len;
   END add_hdo;
--
   PROCEDURE add_hco (p_domain     VARCHAR2
                     ,p_code       VARCHAR2
                     ,p_meaning    VARCHAR2
                     ,p_system     VARCHAR2 DEFAULT 'Y'
                     ,p_seq        NUMBER   DEFAULT NULL
                     ,p_start_date DATE     DEFAULT NULL
                     ,p_end_date   DATE     DEFAULT NULL
                     ) IS
   BEGIN
      l_hco_count := l_hco_count + 1;
      l_tab_hco_domain(l_hco_count)     := UPPER(p_domain);
      l_tab_hco_code(l_hco_count)       := p_code;
      l_tab_hco_meaning(l_hco_count)    := p_meaning;
      l_tab_hco_system(l_hco_count)     := p_system;
      l_tab_hco_seq(l_hco_count)        := p_seq;
      l_tab_hco_start_date(l_hco_count) := p_start_date;
      l_tab_hco_end_date(l_hco_count)   := p_end_date;
   END add_hco;
--
BEGIN
--
   add_hdo ('PENDING_REASON',nm3type.c_acc,'Pending Reason',1);
   add_hco ('PENDING_REASON','0',' ','Y',1);
   add_hco ('PENDING_REASON','1','Incomplete Deposition','Y',2);
   add_hco ('PENDING_REASON','2','Unfinished Forms','Y',3);
   add_hco ('PENDING_REASON','3','Dispute In Progress','Y',4);
   add_hco ('PENDING_REASON','4','Invalid Entries','Y',5);
--
   FORALL i IN 1..l_hdo_count
      INSERT INTO hig_domains
            (hdo_domain
            ,hdo_product
            ,hdo_title
            ,hdo_code_length
            )
      SELECT l_tab_hdo_domain(i)
            ,l_tab_hdo_product(i)
            ,l_tab_hdo_title(i)
            ,l_tab_hdo_code_len(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hdo_domain(i)
                       );
   FORALL i IN 1..l_hco_count
      INSERT INTO hig_codes
            (hco_domain
            ,hco_code
            ,hco_meaning
            ,hco_system
            ,hco_seq
            ,hco_start_date
            ,hco_end_date
            )
      SELECT l_tab_hco_domain(i)
            ,l_tab_hco_code(i)
            ,l_tab_hco_meaning(i)
            ,l_tab_hco_system(i)
            ,l_tab_hco_seq(i)
            ,l_tab_hco_start_date(i)
            ,l_tab_hco_end_date(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_codes
                        WHERE  hco_domain = l_tab_hco_domain(i)
                         AND   hco_code   = l_tab_hco_code(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hco_domain(i)
                       );
--
END;
/


