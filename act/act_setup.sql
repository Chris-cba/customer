--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)act_setup.sql	1.1 06/23/04
--       Module Name      : act_setup.sql
--       Date into SCCS   : 04/06/23 10:59:06
--       Date fetched Out : 07/06/06 14:33:28
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--
ALTER TABLE DEFECTS
  ADD DEF_ADMIN_UNIT NUMBER(9) NOT NULL
/

ALTER TABLE WORK_ORDER_LINES
  ADD WOL_FIXED_COST VARCHAR2(1) NOT NULL
/

DECLARE
  lr_grp_rec  nm_elements_all%ROWTYPE;
  lr_sect_rec nm_elements_all%ROWTYPE;
  lr_code_rec hig_codes%ROWTYPE;
  lv_st_node_id nm_nodes.no_node_id%TYPE;
  lv_end_node_id nm_nodes.no_node_id%TYPE;
  lv_st_np_id    nm_points.np_id%TYPE;
  lv_end_np_id  nm_points.np_id%TYPE;
BEGIN
  --
  -- Insert ne_group into the domain.
  --
  lr_code_rec.hco_domain     := 'ACT ROADS';
  lr_code_rec.hco_code       := 'NO NETWORK SELECTED';
  lr_code_rec.hco_meaning    := 'NO NETWORK SELECTED';
  lr_code_rec.hco_system     := 'Y';
  --
  nm3ins.ins_hco(lr_code_rec);
  --
  -- Create Dummy Group.
  --
  lr_grp_rec.ne_unique          := 'NO NETWORK SELECTED';
  lr_grp_rec.ne_type            := 'G';
  lr_grp_rec.ne_nt_type         := 'ROAD';
  lr_grp_rec.ne_descr           := 'No Network Selected';
  lr_grp_rec.ne_admin_unit      := 1;
  lr_grp_rec.ne_start_date      := to_date( '01/01/1901 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM');
  lr_grp_rec.ne_gty_group_type  := 'ROAD';
  lr_grp_rec.ne_name_1          := 'RD';
  lr_grp_rec.ne_group           := 'NO NETWORK SELECTED';
  --
  nm3net.insert_any_element(lr_grp_rec,1,FALSE);
  --
  -- Create Nodes For Dummy Section.
  --
  nm3net.create_or_reuse_point_and_node(1
                                       ,1
                                       ,to_date( '01/01/1901 12:00:00 AM','MM/DD/YYYY HH:MI:SS AM')
                                       ,nm3get.get_nt(pi_nt_type           => 'LINK'
                                                     ,pi_raise_not_found   => null
                                                     ,pi_not_found_sqlcode => null).nt_node_type
                                       ,'START NODE FOR NO NETWORK SECTION'
                                       ,lv_st_node_id
                                       ,lv_st_np_id);
  nm3net.create_or_reuse_point_and_node(2
                                       ,2
                                       ,to_date( '01/01/1901 12:00:00 AM','MM/DD/YYYY HH:MI:SS AM')
                                       ,nm3get.get_nt(pi_nt_type           => 'LINK'
                                                     ,pi_raise_not_found   => null
                                                     ,pi_not_found_sqlcode => null).nt_node_type
                                       ,'END NODE FOR NO NETWORK SECTION'
                                       ,lv_end_node_id
                                       ,lv_end_np_id);
  --
  -- Create Dummy Section.
  --
  lr_sect_rec.ne_unique          := 'NO NETWORK SELECTED';
  lr_sect_rec.ne_type            := 'S';
  lr_sect_rec.ne_nt_type         := 'LINK';
  lr_sect_rec.ne_descr           := 'No Network Selected';
  lr_sect_rec.ne_length          := 999999;
  lr_sect_rec.ne_admin_unit      := 1;
  lr_sect_rec.ne_start_date      := to_date( '01/01/1901 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM');
  lr_sect_rec.ne_group           := 'NO NETWORK SELECTED';
  lr_sect_rec.ne_sub_class       := 'S';
  lr_sect_rec.ne_no_start        := lv_st_node_id;
  lr_sect_rec.ne_no_end          := lv_end_node_id;
  --
  nm3net.insert_any_element(lr_sect_rec,1,TRUE);
  --
  -- Populate Product Options
  --
  INSERT
    INTO HIG_OPTIONS
         (HOP_ID
         ,HOP_PRODUCT
         ,HOP_NAME
         ,HOP_VALUE
         ,HOP_REMARKS)
  VALUES ('NONETLINKL'
         ,'MAI'
         ,'DUMMY LINK RSE_HE_ID'
         ,lr_grp_rec.ne_id
         ,'Used To Identify The Dummy Local Link Used When No Network Location Is Selected.')
       ;
  --
  INSERT
    INTO HIG_OPTIONS
         (HOP_ID
         ,HOP_PRODUCT
         ,HOP_NAME
         ,HOP_VALUE
         ,HOP_REMARKS)
  VALUES ('NONETSECT'
         ,'MAI'
         ,'DUMMY SECT RSE_HE_ID'
         ,lr_sect_rec.ne_id
         ,'Used To Identify The Dummy Local Section Used When No Network Location Is Selected.')
       ;
  --
  COMMIT;
  --
EXCEPTION
  WHEN others
   THEN
      raise;
END;
/

INSERT
  INTO HIG_OPTIONS
       (HOP_ID
       ,HOP_PRODUCT
       ,HOP_NAME
       ,HOP_VALUE
       ,HOP_REMARKS)
VALUES ('NONETSECTD'
       ,'MAI'
       ,'DUMMY SECT RSE_HE_ID'
       ,''
       ,'Used To Identify The Dummy DOT Section Used When No Network Location Is Selected.')
/

INSERT
  INTO HIG_OPTIONS
       (HOP_ID
       ,HOP_PRODUCT
       ,HOP_NAME
       ,HOP_VALUE
       ,HOP_REMARKS)
VALUES ('NONETLINKD'
       ,'MAI'
       ,'DUMMY LINK RSE_HE_ID'
       ,''
       ,'Used To Identify The Dummy DOT Link Used When No Network Location Is Selected.')
/

INSERT
  INTO HIG_CODES
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ,HCO_START_DATE
      ,HCO_END_DATE)
VALUES('INITIATION_TYPE'
      ,'ACT'
      ,'Direct Defect Creation'
      ,'Y'
      ,140
      ,NULL
      ,NULL)
/

INSERT
  INTO HIG_OPTIONS
       (HOP_ID
       ,HOP_PRODUCT
       ,HOP_NAME
       ,HOP_VALUE
       ,HOP_REMARKS)
VALUES ('AREINITTYP'
       ,'MAI'
       ,'DUMMY INSP INIT'
       ,'ACT'
       ,'Used To Identify The Initiation Type To Use For Dummy Inspections')
/

INSERT
  INTO HIG_OPTIONS
      (HOP_ID
      ,HOP_PRODUCT
      ,HOP_NAME
      ,HOP_VALUE
      ,HOP_REMARKS)
VALUES('ARE_L_OR_D'
      ,'MAI'
      ,'DEFAULT L OR D'
      ,'L'
      ,'Set A Default SYS_FLAG To Be Used In Default Inspections, L For Local Raods, D For DOT Roads, A NULL Entry Will Cause Forms To Ask The User.')
/

INSERT
  INTO HIG_PRODUCTS
      (HPR_PRODUCT
      ,HPR_PRODUCT_NAME
      ,HPR_VERSION
      ,HPR_PATH_NAME
      ,HPR_KEY
      ,HPR_SEQUENCE
      ,HPR_IMAGE
      ,HPR_USER_MENU
      ,HPR_LAUNCHPAD_ICON
      ,HPR_IMAGE_TYPE)
SELECT 'ACT'
      ,'ACT Enhancements'
      ,'3.1.1.0'
      ,''
      ,null
      ,null
      ,''
      ,''
      ,''
      ,'' FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT = 'ACT')
/

INSERT
  INTO HIG_ERRORS
      (HER_APPL
      ,HER_NO
      ,HER_TYPE
      ,HER_DESCR
      ,HER_ACTION_1
      ,HER_ACTION_2
      ,HER_ACTION_3
      ,HER_ACTION_4
      ,HER_ACTION_5
      ,HER_ACTION_6
      ,HER_ACTION_7)
VALUES('ACT'
      ,1
      ,'A'
      ,'BOQs Are Not Allowed On Fixed Cost Lines.'
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL)
/

--
-- Missing M_MGR errors.
--
DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 889
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,889
       ,'E'
       ,'Cannot complete, works order cost is outside user limits '
       ,'The limit the current user can authorise, or raise'
       ,'does not cover the cost of the works order'
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 890
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,890
       ,'W'
       ,'You must authorise the work order before it can be instructed '
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 891
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,891
       ,'E'
       ,'No available budget for item code %s1'
       ,'There is no budget for this work item code'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 892
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,892
       ,'E'
       ,'Defect start chainage must be within start and end chainage of inspection'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 893
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,893
       ,'I'
       ,'No new budgets created'
       ,'This years budgets already have budgets for next year.'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 894
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,894
       ,'E'
       ,'Invalid Inventory (Asset) Type for Group'
       ,'ACTION: Please add a valid Inventory (Asset) Type for Group'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 895
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,895
       ,'E'
       ,'Cannot assign new Contract. Contract Items not defined for existing BOQs'
       ,'Update Contract Items for Contract or choose a different Contract'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 896
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,896
       ,'E'
       ,'Item Code seletced must be defined at top Admin unit'
       ,'Select Item Code from LOV or define at top admin unit'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 897
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,897
       ,'E'
       ,'Sub Item Code seletced must be defined at top Admin unit'
       ,'Select Item Code from LOV or define at top admin unit'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 898
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,898
       ,'E'
       ,'The Agency you have entered is invalid according to your Admin Unit'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 899
/

INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,899
       ,'E'
       ,'Contract Items related to the BOQs on this Work Order Line are being updated by another User'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL
/

INSERT
  INTO HIG_MODULES
      (HMO_MODULE
      ,HMO_TITLE
      ,HMO_FILENAME
      ,HMO_MODULE_TYPE
      ,HMO_FASTPATH_OPTS
      ,HMO_FASTPATH_INVALID
      ,HMO_USE_GRI
      ,HMO_APPLICATION
      ,HMO_MENU)
VALUES('MAI3809'
      ,'Create Defects'
      ,'mai3809'
      ,'FMX'
      ,NULL
      ,'N'
      ,'N'
      ,'MAI'
      ,'FORM')
/

insert
  into HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE)
select 'MAI3809'
      ,'MAI_ADMIN'
      ,'NORMAL'
  from dual
 where not exists(select 'not exists'
                    from HIG_MODULE_ROLES
                   where HMR_MODULE = 'MAI3809'
                     and HMR_ROLE = 'MAI_ADMIN')
/

insert
  into HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE)
select 'MAI3809'
      ,'MAI_USER'
      ,'NORMAL'
  from dual
 where not exists(select 'not exists'
                    from HIG_MODULE_ROLES
                   where HMR_MODULE = 'MAI3809'
                     and HMR_ROLE = 'MAI_USER')
/

insert
  into HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE)
select 'MAI3809'
      ,'MAI_READONLY'
      ,'NORMAL'
  from dual
 where not exists(select 'not exists'
                    from HIG_MODULE_ROLES
                   where HMR_MODULE = 'MAI3809'
                     and HMR_ROLE = 'MAI_READONLY')
/

commit
/
