
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_derived_inv_cr8tab.sql	1.1 03/15/05
--       Module Name      : xexor_derived_inv_cr8tab.sql
--       Date into SCCS   : 05/03/15 22:46:51
--       Date fetched Out : 07/06/06 14:36:39
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
DROP TABLE xexor_derived_attributes CASCADE CONSTRAINTS
/

CREATE TABLE xexor_derived_attributes
   (xda_nit_inv_type_parent   VARCHAR2(4)    NOT NULL
   ,xda_nit_inv_type_child    VARCHAR2(4)    NOT NULL
   ,xda_ita_view_col_name     VARCHAR2(30)   NOT NULL
   ,xda_process_seq_no        NUMBER(2)      NOT NULL
   ,xda_formula               VARCHAR2(4000) NOT NULL
   ,CONSTRAINT xda_pk PRIMARY KEY (xda_nit_inv_type_parent,xda_nit_inv_type_child,xda_ita_view_col_name)
   ,CONSTRAINT xda_uk UNIQUE (xda_nit_inv_type_parent,xda_nit_inv_type_child,xda_process_seq_no)
   ,CONSTRAINT xda_nit_parent_fk FOREIGN KEY (xda_nit_inv_type_parent)
    REFERENCES nm_inv_types_all (nit_inv_type)
    ON DELETE CASCADE
   ,CONSTRAINT xda_nit_child_fk FOREIGN KEY (xda_nit_inv_type_child)
    REFERENCES nm_inv_types_all (nit_inv_type)
    ON DELETE CASCADE
   ,CONSTRAINT xda_ita_child_fk FOREIGN KEY (xda_nit_inv_type_child,xda_ita_view_col_name)
    REFERENCES nm_inv_type_attribs_all (ita_inv_type, ita_view_col_name)
    ON DELETE CASCADE
   )
/

