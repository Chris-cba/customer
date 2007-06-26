
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_valuations_cr8tab.sql	1.1 03/14/05
--       Module Name      : xact_valuations_cr8tab.sql
--       Date into SCCS   : 05/03/14 23:11:00
--       Date fetched Out : 07/06/06 14:33:49
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
DROP SEQUENCE xf_id_seq
/

CREATE SEQUENCE xf_id_seq
/

DROP TABLE xval_formulae CASCADE CONSTRAINTS
/

CREATE  TABLE xval_formulae
   (xf_id      NUMBER(9)      NOT NULL
   ,xf_formula VARCHAR2(4000) NOT NULL
   ,CONSTRAINT xf_pk PRIMARY KEY (xf_id)
   ,CONSTRAINT xf_uk UNIQUE (xf_formula)
   )
/

DROP TABLE xval_valuation_columns CASCADE CONSTRAINTS
/

CREATE TABLE xval_valuation_columns
   (xvc_nit_inv_type          VARCHAR2(4)  NOT NULL
   ,xvc_ita_view_col_name     VARCHAR2(30) NOT NULL
   ,xvc_process_seq_no        NUMBER(2)    NOT NULL
--   ,xvc_prompt                VARCHAR2(30)
--   ,xvc_prompt_hdo_domain     VARCHAR2(30)
   ,xvc_xf_id_ad_hoc          NUMBER(9)
   ,xvc_xf_id_year_end_dep    NUMBER(9)
   ,xvc_xf_id_year_end_val    NUMBER(9)
   ,xvc_process_year_end_dep  VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_prompt_year_end_dep   VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_process_year_end_val  VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_prompt_year_end_val   VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_process_ad_hoc        VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_prompt_ad_hoc         VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_process_ad_hoc_many   VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_prompt_ad_hoc_many    VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,xvc_sum_for_report        VARCHAR2(1)  DEFAULT 'N' NOT NULL
   ,CONSTRAINT xvc_pk PRIMARY KEY (xvc_nit_inv_type,xvc_ita_view_col_name)
   ,CONSTRAINT xvc_uk UNIQUE (xvc_nit_inv_type,xvc_process_seq_no)
   ,CONSTRAINT xvc_nit_fk FOREIGN KEY (xvc_nit_inv_type)
    REFERENCES nm_inv_types_all (nit_inv_type)
    ON DELETE CASCADE
   ,CONSTRAINT xvc_xf_fk_1 FOREIGN KEY (xvc_xf_id_ad_hoc)
    REFERENCES xval_formulae (xf_id)
    ON DELETE SET NULL
   ,CONSTRAINT xvc_xf_fk_2 FOREIGN KEY (xvc_xf_id_year_end_dep)
    REFERENCES xval_formulae (xf_id)
    ON DELETE SET NULL
   ,CONSTRAINT xvc_xf_fk_3 FOREIGN KEY (xvc_xf_id_year_end_val)
    REFERENCES xval_formulae (xf_id)
    ON DELETE SET NULL
   ,CONSTRAINT xvc_prompt_year_end_dep_chk      CHECK (xvc_prompt_year_end_dep IN ('Y','N'))
   ,CONSTRAINT xvc_process_year_end_dep_chk     CHECK (xvc_process_year_end_dep IN ('Y','N'))
   ,CONSTRAINT xvc_prompt_year_end_val_chk      CHECK (xvc_prompt_year_end_val IN ('Y','N'))
   ,CONSTRAINT xvc_process_year_end_val_chk     CHECK (xvc_process_year_end_val IN ('Y','N'))
   ,CONSTRAINT xvc_process_ad_hoc_chk           CHECK (xvc_process_ad_hoc IN ('Y','N'))
   ,CONSTRAINT xvc_prompt_ad_hoc_chk            CHECK (xvc_prompt_ad_hoc IN ('Y','N'))
   ,CONSTRAINT xvc_process_ad_hoc_many_chk      CHECK (xvc_process_ad_hoc_many IN ('Y','N'))
   ,CONSTRAINT xvc_prompt_ad_hoc_many_chk       CHECK (xvc_prompt_ad_hoc_many IN ('Y','N'))
   ,CONSTRAINT xvc_sum_for_report_chk           CHECK (xvc_sum_for_report IN ('Y','N'))
   ,CONSTRAINT xvc_ita_view_col_name_chk        CHECK (xvc_ita_view_col_name=UPPER(xvc_ita_view_col_name))
--   ,CONSTRAINT xvc_prompt_formula_chk   CHECK (DECODE(xvc_xf_id,Null,0,5)+DECODE(xvc_prompt_for_input,'Y',1,0) != 6)
   )
/

DROP TABLE xval_valuation_reports CASCADE CONSTRAINTS
/

CREATE TABLE xval_valuation_reports
   (xvr_dq_title VARCHAR2(80)
   ,xvr_seq_no NUMBER(2)
   ,CONSTRAINT xvr_pk PRIMARY KEY (xvr_dq_title)
   ,CONSTRAINT xvr_uk UNIQUE (xvr_seq_no)
   ,CONSTRAINT xvr_dq_fk FOREIGN KEY (xvr_dq_title)
    REFERENCES doc_query (dq_title)
    ON DELETE CASCADE
   )
/
