--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_create_all_tables.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_create_all_tables.sql
--       Date into SCCS   : 05/03/15 23:05:26
--       Date fetched Out : 07/06/06 14:39:30
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
CREATE TABLE rrl_la_aud (
  seq        NUMBER(9),     -- from audit_id_seq.nextval
  action     VARCHAR2(10),  -- 'add', 'update', 'delete', 'undo'
  lt_type    VARCHAR2(30),  -- from  nm_inv_attri_lookup_all.ial_domain
  la_code    VARCHAR2(30),  -- from  nm_inv_attri_lookup_all.ial_value
  la_descr   VARCHAR2(80),  -- from  nm_inv_attri_lookup_all.ial_meaning
  start_date DATE           -- from  nm_inv_attri_lookup_all.ial_start_date
);


CREATE TABLE rrl_la_rel_aud (
  seq          NUMBER(9),     -- from audit_id_seq.nextval
  action       VARCHAR2(10),  -- 'add', 'update', 'delete'
  la_code_reg  VARCHAR2(10),  -- admin unit code of the group
  la_code_lga  VARCHAR2(52),  -- from  hig_codes.hco_meaning
  start_date   DATE           -- from  nm_members_all.nm_start_date
);


CREATE TABLE rrl_lcwy_aud (
  seq              NUMBER(9),      -- from audit_id_seq.nextval
  action           VARCHAR2(10),   -- 'add', 'update', 'delete'
  lc_id            NUMBER(9),      -- ne_id of element
  rd_no            VARCHAR2(30),   -- ne_group of element
  sc_no            VARCHAR2(2),    -- ne_sub_type of element
  lc_link_no       VARCHAR2(4),    -- ne_owner of element
  lc_cway_code     VARCHAR2(4),    -- ne_prefix of element
  lc_cway_ver      VARCHAR2(240),  -- ne_version_no of element
  lc_length        NUMBER,         -- ne_length of element
  lc_local_street  VARCHAR2(80),   -- ne_descr of element
  lc_update_auth   VARCHAR2(10),   -- nm_admin_units_all.nau_unit_code
  ne_number        VARCHAR2(8),    -- ne_number of element
  start_date       DATE
);


CREATE TABLE rrl_lcwy_in_la_aud (
  seq              NUMBER(9),      -- from audit_id_seq.nextval
  action           VARCHAR2(10),   -- 'add', 'update', 'delete', 'undo'
  lc_id            NUMBER(9),      -- ne_id of element
  ca_offset_start  NUMBER,         -- nm_members_all.nm_begin_mp
  ca_offset_end    NUMBER,         -- nm_members_all.nm_end_mp
  lt_type          VARCHAR2(4),    -- nm_members_all.nm_obj_type
  la_code          VARCHAR2(50),   -- iit_inv_items_all.iit_chr_attrib26
  la_code2         VARCHAR2(50),   -- iit_inv_items_all.iit_chr_attrib27
  ne_number        VARCHAR2(8),    -- nm_members_all.ne_number
  start_date       DATE
);


CREATE TABLE rrl_lcwy_lc_class_aud (
  seq              NUMBER(9),     -- from audit_id_seq.nextval
  action           VARCHAR2(10),  -- 'add', 'update', 'delete', 'undo'
  lc_id            NUMBER(9),
  lc_class         VARCHAR2(30),
  ne_number        VARCHAR2(8),
  start_date       DATE
);


CREATE TABLE rrl_rf_on_lcwy_aud (
  seq                NUMBER(9),      -- from audit_id_seq.nextval
  action             VARCHAR2(10),   -- 'add', 'update', 'delete', 'undo'
  ne_number          VARCHAR2(8),    -- from  nm_elements_all.ne_number
  lc_id              NUMBER(9),      -- from  nm_members_all.nm_ne_id_of
  rf_id              VARCHAR2(50),   -- from  nm_inv_items_all.iit_primary_key
  rt_type            VARCHAR2(50),   -- from  nm_inv_items_all.iit_chr_attrib26
  rf_descr           VARCHAR2(200),  -- from  nm_inv_items_all.iit_chr_attrib56
  rf_dist_from_start NUMBER,         -- from  nm_members_all.nm_start_mp
  rf_lrb             VARCHAR2(50),   -- from  nm_inv_items_all.iit_chr_attrib27
  start_date         DATE            -- from  nm_members_all.nm_start_date
);


CREATE TABLE rrl_rf_type_aud (
  seq        NUMBER(9),     -- from audit_id_seq.nextval
  action     VARCHAR2(10),
  rt_type    VARCHAR2(30),
  rt_descr   VARCHAR2(80),
  start_date DATE
);


CREATE TABLE rrl_road_aud (
  seq        NUMBER(9),     -- from audit_id_seq.nextval
  action     VARCHAR2(10),
  rd_no      VARCHAR2(20),
  rd_descr   VARCHAR2(52),
  start_date DATE
);


CREATE TABLE rrl_sect_aud (
  seq          NUMBER(9),     -- from audit_id_seq.nextval
  action       VARCHAR2(10),  -- 'add', 'update', 'delete'
  rd_no        VARCHAR2(30),  -- from NE_GROUP
  sc_no        VARCHAR2(2),   -- from NE_SUB_TYPE
  sc_fpo_descr VARCHAR2(80),  -- from NE_NAME_1
  sc_fpo_dist  VARCHAR2(8),   -- from NE_NUMBER
  sc_fpd_descr VARCHAR2(80),  -- from NE_NAME_2
  sc_fpd_dist  VARCHAR2(240), -- from NE_NSG_REF
  start_date   DATE           -- from nm_elements_all.nm_start_date
);
