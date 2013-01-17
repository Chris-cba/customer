-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/DRD/4into1/install/drd4into1.pkb-arc   1.1   Jan 17 2013 10:40:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   drd4into1.pkb  $
--       Date into PVCS   : $Date:   Jan 17 2013 10:40:12  $
--       Date fetched Out : $Modtime:   Jan 17 2013 10:39:52  $
--       Version          : $Revision:   1.1  $
--
--   Copyright (c) exor corporation ltd, 2010
--
-----------------------------------------------------------------------------CREATE OR REPLACE PACKAGE body drd4into1
AS


PROCEDURE create_table_old_new_id
IS
BEGIN
execute immediate 'CREATE TABLE old_new_id
                              ( area VARCHAR2(20)
                               ,table_name VARCHAR2(120)
                               ,old_id number
                               ,new_id NUMBER
                               )';
end create_table_old_new_id;
   
PROCEDURE init
IS
  tmp number;
BEGIN
  --areas(1) := 'EAST';
  areas(1) := 'WEST';
  areas(2) := 'NORTH';
  areas(3) := 'SOUTH';
  
  area_max('WEST')  := 1000000;
  area_max('NORTH') := 2000000;
  area_max('SOUTH') := 3000000;

  
  IF (NOT nm3ddl.does_object_exist('OLD_NEW_ID'))
   THEN 
    create_table_old_new_id;
  end if;
  

end init;



PROCEDURE DO_DOC_TYPES
IS
  l_code doc_types.dtp_code%type;
BEGIN
  FOR i IN 1..areas.count
   loop
   execute immediate 'INSERT INTO DOC_TYPES
                      SELECT * 
                      FROM DOC_TYPES@DB_LINK_'||areas(i)||'
                      WHERE DTP_CODE NOT IN ( SELECT DTP_CODE FROM DOC_TYPES)';
  
   execute immediate 'INSERT INTO DOC_class
                      SELECT * 
                      FROM doc_class@DB_LINK_'||areas(i)||'
                      WHERE (dcl_code,DCL_DTP_CODE) NOT IN ( SELECT dcl_code,DCL_DTP_CODE FROM doc_class)';
  
   execute immediate 'INSERT INTO DOC_enquiry_types
                      SELECT * 
                      FROM DOC_enquiry_types@DB_LINK_'||areas(i)||'
                      WHERE (DET_DTP_CODE, DET_DCL_CODE, DET_CODE) NOT IN ( SELECT DET_DTP_CODE, DET_DCL_CODE, DET_CODE FROM DOC_enquiry_types)';
  
  execute immediate 'INSERT INTO doc_gateways
                      SELECT * 
                      FROM doc_gateways@DB_LINK_'||areas(i)||'
                      WHERE (DGT_TABLE_NAME) NOT IN ( SELECT DGT_TABLE_NAME FROM doc_gateways)';  
  
  execute immediate 'INSERT INTO DOC_GATE_SYNS
                      SELECT * 
                      FROM DOC_GATE_SYNS@DB_LINK_'||areas(i)||'
                      WHERE (DGS_DGT_TABLE_NAME, DGS_TABLE_SYN) NOT IN ( SELECT DGS_DGT_TABLE_NAME, DGS_TABLE_SYN FROM DOC_GATE_SYNS)';
                      
  execute immediate 'INSERT INTO doc_media
                      SELECT * 
                      FROM DOC_media@DB_LINK_'||areas(i)||'
                      WHERE (DMD_ID) NOT IN ( SELECT DMD_ID FROM DOC_media)';
                      
  execute immediate 'INSERT INTO DOC_LOCATIONS
                      SELECT * 
                      FROM DOC_LOCATIONS@DB_LINK_'||areas(i)||'
                      WHERE (DLC_ID) NOT IN ( SELECT DLC_ID FROM DOC_LOCATIONS)';                        


  execute immediate 'INSERT INTO DOC_TEMPLATE_GATEWAYS
                      SELECT * 
                      FROM DOC_TEMPLATE_GATEWAYS@DB_LINK_'||areas(i)||'
                      WHERE (DTG_TEMPLATE_NAME) NOT IN ( SELECT DTG_TEMPLATE_NAME FROM DOC_TEMPLATE_GATEWAYS)';                        

  execute immediate 'INSERT INTO DOC_TEMPLATE_COLUMNS
                      SELECT * 
                      FROM DOC_TEMPLATE_COLUMNS@DB_LINK_'||areas(i)||'
                      WHERE (DTC_TEMPLATE_NAME,DTC_COL_ALIAS) NOT IN ( SELECT DTC_TEMPLATE_NAME, DTC_COL_ALIAS FROM DOC_TEMPLATE_COLUMNS)';                        
  
  END loop;
  COMMIT;
  
END do_doc_types;

PROCEDURE do_admin_units
IS
begin
-- need to create a new top level for DRD NI
-- need to move all current levels down one.

-- east 
update nm_admin_units_all
set nau_level = nau_level + 1;

Insert into nm_admin_units_all (NAU_ADMIN_UNIT,NAU_UNIT_CODE,NAU_LEVEL
                        ,NAU_AUTHORITY_CODE,NAU_NAME,NAU_ADDRESS1,NAU_ADDRESS2,NAU_ADDRESS3,NAU_ADDRESS4,NAU_ADDRESS5
                        ,NAU_PHONE,NAU_FAX,NAU_COMMENTS,NAU_LAST_WOR_NO,NAU_START_DATE,NAU_END_DATE
                        ,NAU_ADMIN_TYPE,NAU_NSTY_SUB_TYPE,NAU_PREFIX,NAU_POSTCODE,NAU_MINOR_UNDERTAKER
                        ,NAU_TCPIP,NAU_DOMAIN,NAU_DIRECTORY,NAU_EXTERNAL_NAME) 
values (1,'DRDNI',1,Null,'DRD Northern Ireland',null,null,null,null,null,null,null,null,null
,to_date('01-JAN-1960','DD-MON-RR'),null,'NETW',null,null,null,null,null,null,null,'DRD NI');


insert into nm_admin_units_all
select NAU_ADMIN_UNIT,
  NAU_UNIT_CODE,
  NAU_LEVEL + 1,
  NAU_AUTHORITY_CODE,
  NAU_NAME,
  NAU_ADDRESS1,
  NAU_ADDRESS2,
  NAU_ADDRESS3,
  NAU_ADDRESS4,
  NAU_ADDRESS5,
  NAU_PHONE,
  NAU_FAX,
  NAU_COMMENTS,
  NAU_LAST_WOR_NO,
  NAU_START_DATE,
  NAU_END_DATE,
  NAU_ADMIN_TYPE,
  NAU_NSTY_SUB_TYPE,
  NAU_PREFIX,
  NAU_POSTCODE,
  NAU_MINOR_UNDERTAKER,
  NAU_TCPIP,
  NAU_DOMAIN,
  NAU_DIRECTORY,
  NAU_EXTERNAL_NAME
from west_nm_admin_units_all
where nau_unit_code not in (select nau_unit_code from nm_admin_units_all);

insert into nm_admin_units_all
select NAU_ADMIN_UNIT,
  NAU_UNIT_CODE,
  NAU_LEVEL + 1,
  NAU_AUTHORITY_CODE,
  NAU_NAME,
  NAU_ADDRESS1,
  NAU_ADDRESS2,
  NAU_ADDRESS3,
  NAU_ADDRESS4,
  NAU_ADDRESS5,
  NAU_PHONE,
  NAU_FAX,
  NAU_COMMENTS,
  NAU_LAST_WOR_NO,
  NAU_START_DATE,
  NAU_END_DATE,
  NAU_ADMIN_TYPE,
  NAU_NSTY_SUB_TYPE,
  NAU_PREFIX,
  NAU_POSTCODE,
  NAU_MINOR_UNDERTAKER,
  NAU_TCPIP,
  NAU_DOMAIN,
  NAU_DIRECTORY,
  NAU_EXTERNAL_NAME
from north_nm_admin_units_all
where nau_unit_code not in (select nau_unit_code from nm_admin_units_all);

insert into nm_admin_units_all
select NAU_ADMIN_UNIT,
  NAU_UNIT_CODE,
  NAU_LEVEL + 1,
  NAU_AUTHORITY_CODE,
  NAU_NAME,
  NAU_ADDRESS1,
  NAU_ADDRESS2,
  NAU_ADDRESS3,
  NAU_ADDRESS4,
  NAU_ADDRESS5,
  NAU_PHONE,
  NAU_FAX,
  NAU_COMMENTS,
  NAU_LAST_WOR_NO,
  NAU_START_DATE,
  NAU_END_DATE,
  NAU_ADMIN_TYPE,
  NAU_NSTY_SUB_TYPE,
  NAU_PREFIX,
  NAU_POSTCODE,
  NAU_MINOR_UNDERTAKER,
  NAU_TCPIP,
  NAU_DOMAIN,
  NAU_DIRECTORY,
  NAU_EXTERNAL_NAME
from south_nm_admin_units_all
where nau_unit_code not in (select nau_unit_code from nm_admin_units_all);

-- admin groups.
-- rec 1 -- indirect to self
   insert into nm_admin_groups
   ( nag_parent_admin_unit
    ,nag_child_admin_unit
    ,nag_direct_link
   ) values
   ( 1
   , 1
   , 'N'
   );
   -- rec 2 -- direct to child
   insert into nm_admin_groups
   ( nag_parent_admin_unit
    ,nag_child_admin_unit
    ,nag_direct_link
    ) values
    ( 1
    , 2 -- east
    , 'Y'
    );

   insert into nm_admin_groups
   ( nag_parent_admin_unit
    ,nag_child_admin_unit
    ,nag_direct_link
    ) values
    ( 1
    , 6 -- west
    , 'Y'
    );

   insert into nm_admin_groups
   ( nag_parent_admin_unit
    ,nag_child_admin_unit
    ,nag_direct_link
    ) values
    ( 1
    , 3 -- north
    , 'Y'
    );

   insert into nm_admin_groups
   ( nag_parent_admin_unit
    ,nag_child_admin_unit
    ,nag_direct_link
    ) values
    ( 1
    , 4 -- south
    , 'Y'
    );


    INSERT INTO nm_admin_groups 
SELECT * FROM nm_admin_groups@db_link_west
where (NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT) not in (select NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT from nm_admin_groups);

INSERT INTO nm_admin_groups 
SELECT * FROM nm_admin_groups@db_link_north
where (NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT) not in (select NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT from nm_admin_groups);

INSERT INTO nm_admin_groups 
SELECT * FROM nm_admin_groups@db_link_south
WHERE (NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT) NOT IN (SELECT NAG_PARENT_ADMIN_UNIT,NAG_child_ADMIN_UNIT FROM nm_admin_groups);


commit;
end do_admin_units;

PROCEDURE do_hig_users
IS
   
BEGIN
  drd4into1.init;
  
  
  DELETE old_new_id
  where table_name = 'HIG_USERS';
  
  -- create old new id data  
   FOR i IN 1..drd4into1.areas.count
    loop
      INSERT INTO old_new_id
      SELECT drd4into1.areas(i)
             ,'HIG_USERS'
             ,hus_user_id
             ,hus_user_id + area_max(drd4into1.areas(i))
       from hig_users;
   end loop;

   FOR i IN 1..drd4into1.areas.count
    loop 
    EXECUTE IMMEDIATE 
     'INSERT INTO hig_users
        SELECT HUS_USER_ID + '||area_max(drd4into1.areas(i))||' ,
          HUS_INITIALS,
          HUS_NAME,
          HUS_USERNAME,
          HUS_JOB_TITLE,
          HUS_AGENT_CODE,
          HUS_WOR_FLAG,
          HUS_WOR_VALUE_MIN,
          HUS_WOR_VALUE_MAX,
          HUS_START_DATE,
          HUS_END_DATE,
          HUS_UNRESTRICTED,
          HUS_IS_HIG_OWNER_FLAG,
          HUS_ADMIN_UNIT,
          HUS_WOR_AUR_MIN,
          HUS_WOR_AUR_MAX
        FROM HIG_USERS@db_link_'||drd4into1.areas(i)||'
        WHERE hus_username NOT IN ( SELECT hus_username FROM hig_users)
        AND hus_is_hig_owner_flag != ''Y''';
  END loop;   
end do_hig_users;

FUNCTION get_user_id(p_area VARCHAR2
                    ,p_table VARCHAR2 default 'HIG_USERS'
                    ,p_old_id number
                    )
RETURN hig_users.hus_user_id%TYPE
IS
  rtrn number;
BEGIN
  rtrn :=null;-- p_old_id;
  for crec in (
  SELECT new_id 
  FROM old_neW_id , hig_users
  WHERE old_id = p_old_id
    AND new_id = hus_useR_id
    AND table_name = p_table 
    AND area = p_area)
  loop
     rtrn := crec.new_id;
  END loop;
  
  IF rtrn IS NULL
   THEN
     EXECUTE IMMEDIATE 'select  hus_user_id from hig_users where hus_username in (select hus_username from hig_users@db_link_'||p_area||' where hus_user_id = '||nvl(p_old_id,1)||')'  INTO rtrn;    
  end if;
  
  return rtrn;

end get_user_id;  

PROCEDURE do_docs
IS
  str varchar2(4000);
BEGIN
   drd4into1.init;

  FOR i IN 1..drd4into1.areas.count
    loop
    EXECUTE IMMEDIATE 
                  'INSERT INTO docs
                  SELECT DOC_ID + '||area_max(drd4into1.areas(i))||',
                    DOC_TITLE,
                    DOC_DCL_CODE,
                    DOC_DTP_CODE,
                    DOC_DATE_EXPIRES,
                    DOC_DATE_ISSUED,
                    DOC_FILE,
                    DOC_REFERENCE_CODE,
                    DOC_ISSUE_NUMBER,
                    DOC_DLC_ID,
                    DOC_DLC_DMD_ID,
                    DOC_DESCR,
                    drd4into1.get_user_id('''||drd4into1.areas(i)||''',''HIG_USERS'',doc_user_id),
                    DOC_CATEGORY,
                    DOC_ADMIN_UNIT,
                    DOC_STATUS_CODE,
                    DOC_STATUS_DATE,
                    DOC_REASON,
                    DOC_COMPL_TYPE,
                    DOC_COMPL_SOURCE,
                    DOC_COMPL_ACK_FLAG,
                    DOC_COMPL_ACK_DATE,
                    DOC_COMPL_FLAG,
                    DOC_COMPL_CPR_ID,
                    drd4into1.get_user_id('''||drd4into1.areas(i)||''',''HIG_USERS'',DOC_COMPL_USER_ID),
                    DOC_COMPL_PEO_DATE,
                    DOC_COMPL_TARGET,
                    DOC_COMPL_COMPLETE,
                    DOC_COMPL_REFERRED_TO,
                    DOC_COMPL_LOCATION,
                    DOC_COMPL_REMARKS,
                    DOC_COMPL_NORTH,
                    DOC_COMPL_EAST,
                    DOC_COMPL_FROM,
                    DOC_COMPL_TO,
                    DOC_COMPL_CLAIM,
                    DOC_COMPL_CORRESP_DATE,
                    DOC_COMPL_CORRESP_DELIV_DATE,
                    DOC_COMPL_NO_OF_PETITIONERS,
                    DOC_COMPL_INCIDENT_DATE,
                    DOC_COMPL_POLICE_NOTIF_FLAG,
                    DOC_COMPL_DATE_POLICE_NOTIF,
                    DOC_COMPL_CAUSE,
                    DOC_COMPL_INJURIES,
                    DOC_COMPL_DAMAGE,
                    DOC_COMPL_ACTION,
                    DOC_COMPL_LITIGATION_FLAG,
                    DOC_COMPL_LITIGATION_REASON,
                    DOC_COMPL_CLAIM_NO,
                    DOC_COMPL_DETERMINATION,
                    DOC_COMPL_EST_COST,
                    DOC_COMPL_ADV_COST,
                    DOC_COMPL_ACT_COST,
                    DOC_COMPL_FOLLOW_UP1,
                    DOC_COMPL_FOLLOW_UP2,
                    DOC_COMPL_FOLLOW_UP3,
                    DOC_COMPL_INSURANCE_CLAIM,
                    DOC_COMPL_SUMMONS_RECEIVED,
                    DOC_COMPL_USER_TYPE,
                    DOC_DATE_TIME_ARRIVED,
                    DOC_REASON_FOR_LATER_ARRIVAL
                  FROM DOCS@db_link_'||drd4into1.areas(i)||
                  ' where (DOC_ID + '||area_max(drd4into1.areas(i))||') not in (select doc_id from docs)';
  END loop;
end do_docs;

PROCEDURE do_contact_address
IS
  str varchar2(4000);
BEGIN
   drd4into1.init;

  FOR i IN 1..drd4into1.areas.count
    loop
    EXECUTE IMMEDIATE 
                  'insert into HIG_ADDRESS
                  SELECT HAD_ID+ '||area_max(drd4into1.areas(i))||',
                          HAD_DEPARTMENT,
                          HAD_PO_BOX,
                          HAD_ORGANISATION,
                          HAD_SUB_BUILDING_NAME_NO,
                          HAD_BUILDING_NAME,
                          HAD_BUILDING_NO,
                          HAD_DEPENDENT_THOROUGHFARE,
                          HAD_THOROUGHFARE,
                          HAD_DOUBLE_DEP_LOCALITY_NAME,
                          HAD_DEPENDENT_LOCALITY_NAME,
                          HAD_POST_TOWN,
                          HAD_COUNTY,
                          HAD_POSTCODE,
                          HAD_OSAPR,
                          HAD_XCO,
                          HAD_YCO,
                          HAD_NOTES,
                          HAD_PROPERTY_TYPE
                        FROM HIG_ADDRESS@db_link_'||drd4into1.areas(i);
  END loop;

  FOR i IN 1..drd4into1.areas.count
    loop
    EXECUTE IMMEDIATE 
                  'insert into HIG_CONTACTS
                   SELECT HCT_ID+ '||area_max(drd4into1.areas(i))||',
                          HCT_ORG_OR_PERSON_FLAG,
                          HCT_VIP,
                          HCT_TITLE,
                          HCT_SALUTATION,
                          HCT_FIRST_NAME,
                          HCT_MIDDLE_INITIAL,
                          HCT_SURNAME,
                          HCT_ORGANISATION,
                          HCT_HOME_PHONE,
                          HCT_WORK_PHONE,
                          HCT_MOBILE_PHONE,
                          HCT_FAX,
                          HCT_PAGER,
                          HCT_EMAIL,
                          HCT_OCCUPATION,
                          HCT_EMPLOYER,
                          HCT_DATE_OF_BIRTH,
                          HCT_START_DATE,
                          HCT_END_DATE,
                          HCT_NOTES
                        FROM HIG_CONTACTS@db_link_'||drd4into1.areas(i);
  END loop;

  FOR i IN 1..drd4into1.areas.count
    loop
    EXECUTE IMMEDIATE 
                  'insert into HIG_CONTACT_ADDRESS
                   SELECT HCA_HCT_ID+ '||area_max(drd4into1.areas(i))||'
                        , HCA_HAD_ID+ '||area_max(drd4into1.areas(i))||'
                     FROM HIG_CONTACT_ADDRESS@db_link_'||drd4into1.areas(i);
  END loop;
  
  FOR i IN 1..drd4into1.areas.count
    loop
    EXECUTE IMMEDIATE 
                  'insert into DOC_ENQUIRY_CONTACTS
                   SELECT DEC_HCT_ID+ '||area_max(drd4into1.areas(i))||',
                          DEC_DOC_ID+ '||area_max(drd4into1.areas(i))||',
                          DEC_TYPE,
                          DEC_REF,
                          DEC_COMPLAINANT,
                          DEC_CONTACT
                        FROM DOC_ENQUIRY_CONTACTS@db_link_'||drd4into1.areas(i);
  END loop;
    
END do_contact_address;

PROCEDURE inv_metadata
IS
  TYPE inv_tables_list_type IS TABLE OF VARCHAR2(100) INDEX BY binary_integer;
  inv_table inv_tables_list_type;
  
  TYPE list_type IS TABLE OF VARCHAR2(100) INDEX BY binary_integer;
  list list_type;
  
  cols VARCHAR2(4000);
  primary_key_cols varchar2(4000);
  
  row_count number;
  
  FUNCTION remove_trailing_comma(pi_str VARCHAR2)
  RETURN VARCHAR2
  IS
  BEGIN 
     RETURN substr(pi_str,1,LENGTH(pi_str)-1);
  end remove_trailing_comma;
  
  FUNCTION list_to_string(list list_type)
  RETURN VARCHAR2
  IS
  cols varchar2(4000);
  BEGIN
    FOR i IN 1..LIST.count
     loop
      cols := cols || list(i);
    END loop;
    RETURN cols;
  end list_to_string;
  
BEGIN
  inv_table(1)  := 'NM_INV_CATEGORIES';
  inv_table(2)  := 'NM_INV_CATEGORY_MODULES';
  inv_table(3)  := 'NM_INV_DOMAINS_ALL';
  inv_table(4)  := 'NM_INV_ATTRI_LOOKUP_ALL';
  inv_table(5)  := 'NM_INV_TYPE_ROLES';
  inv_table(6)  := 'NM_INV_TYPE_GROUPINGS_ALL';
  inv_table(7)  := 'NM_INV_ITEM_GROUPINGS_ALL';
  inv_table(8)  := 'NM_INV_TYPE_COLOURS';
  inv_table(9)  := 'NM_INV_NW_ALL';
  inv_table(10) := 'NM_INV_TYPE_ATTRIB_BANDINGS';
  inv_table(11) := 'NM_INV_TYPE_ATTRIB_BAND_DETS';
  inv_table(12) := 'NM_INV_ATTRIBUTE_SET_INV_TYPES';
  inv_table(13) := 'NM_INV_ATTRIBUTE_SET_INV_ATTR';
  inv_table(14) := 'NM_INV_ATTRIBUTE_SETS';
  
  drd4into1.init;
    
  FOR i IN 1..inv_table.count
   loop
    cols := NULL;
    LIST.DELETE;
    
    EXECUTE IMMEDIATE 'select column_name ||'','' from user_tab_columns where table_name = :1'
    BULK COLLECT INTO list
    using inv_table(i);
    
    cols := list_to_string(list);
    
    cols := remove_trailing_comma(cols);
    
      
    primary_key_cols := NULL;
    LIST.DELETE;
    
    EXECUTE IMMEDIATE 'SELECT cols.column_name || '',''
                    FROM user_constraints cons, user_cons_columns cols
                    WHERE cons.constraint_type = ''P''
                    AND cons.constraint_name = cols.constraint_name
                    AND cons.owner = cols.owner
                    AND cols.table_name = :1
                    ORDER BY cols.table_name, cols.position'
    BULK COLLECT INTO LIST
    USING inv_table(i);
    
    primary_key_cols := list_to_string(list);
    primary_key_cols := remove_trailing_comma(primary_key_cols);
  
    FOR j IN 1..drd4into1.areas.count
      loop
        EXECUTE IMMEDIATE 'insert into ' || inv_table(i) || '('||cols||')'||
                      ' select ' || cols ||
                      ' from ' || inv_table(i)||'@db_link_'||drd4into1.areas(j) ||
                      ' where (' ||primary_key_cols||') not in (select '||primary_key_cols||' from ' ||inv_table(i)||')';
        row_count := SQL%ROWCOUNT;
    
            
        dbms_output.put_line(drd4into1.areas(j)|| ' ' ||inv_table(i)|| ' = '  ||ROW_COUNT);
    end loop;
  END loop;
  
end inv_metadata;

PROCEDURE do_inv_items
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  for CREC in (select TRIGGER_NAME 
               from user_triggers where table_name = 'NM_INV_ITEMS_ALL')
   loop
     execute immediate 'alter trigger '||CREC.TRIGGER_NAME|| ' disable';
  end loop;

  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_inv_items_all
                      SELECT IIT_NE_ID + '||area_max(drd4into1.areas(i))||',
                        IIT_INV_TYPE,
                        IIT_NE_ID + '||area_max(drd4into1.areas(i))||', 
                        IIT_START_DATE,
                        IIT_DATE_CREATED,
                        IIT_DATE_MODIFIED,
                        IIT_CREATED_BY,
                        IIT_MODIFIED_BY,
                        IIT_ADMIN_UNIT,
                        IIT_DESCR,
                        IIT_END_DATE,
                        IIT_FOREIGN_KEY,
                        IIT_LOCATED_BY,
                        IIT_POSITION,
                        IIT_X_COORD,
                        IIT_Y_COORD,
                        IIT_NUM_ATTRIB16,
                        IIT_NUM_ATTRIB17,
                        IIT_NUM_ATTRIB18,
                        IIT_NUM_ATTRIB19,
                        IIT_NUM_ATTRIB20,
                        IIT_NUM_ATTRIB21,
                        IIT_NUM_ATTRIB22,
                        IIT_NUM_ATTRIB23,
                        IIT_NUM_ATTRIB24,
                        IIT_NUM_ATTRIB25,
                        IIT_CHR_ATTRIB26,
                        IIT_CHR_ATTRIB27,
                        IIT_CHR_ATTRIB28,
                        IIT_CHR_ATTRIB29,
                        IIT_CHR_ATTRIB30,
                        IIT_CHR_ATTRIB31,
                        IIT_CHR_ATTRIB32,
                        IIT_CHR_ATTRIB33,
                        IIT_CHR_ATTRIB34,
                        IIT_CHR_ATTRIB35,
                        IIT_CHR_ATTRIB36,
                        IIT_CHR_ATTRIB37,
                        IIT_CHR_ATTRIB38,
                        IIT_CHR_ATTRIB39,
                        IIT_CHR_ATTRIB40,
                        IIT_CHR_ATTRIB41,
                        IIT_CHR_ATTRIB42,
                        IIT_CHR_ATTRIB43,
                        IIT_CHR_ATTRIB44,
                        IIT_CHR_ATTRIB45,
                        IIT_CHR_ATTRIB46,
                        IIT_CHR_ATTRIB47,
                        IIT_CHR_ATTRIB48,
                        IIT_CHR_ATTRIB49,
                        IIT_CHR_ATTRIB50,
                        IIT_CHR_ATTRIB51,
                        IIT_CHR_ATTRIB52,
                        IIT_CHR_ATTRIB53,
                        IIT_CHR_ATTRIB54,
                        IIT_CHR_ATTRIB55,
                        IIT_CHR_ATTRIB56,
                        IIT_CHR_ATTRIB57,
                        IIT_CHR_ATTRIB58,
                        IIT_CHR_ATTRIB59,
                        IIT_CHR_ATTRIB60,
                        IIT_CHR_ATTRIB61,
                        IIT_CHR_ATTRIB62,
                        IIT_CHR_ATTRIB63,
                        IIT_CHR_ATTRIB64,
                        IIT_CHR_ATTRIB65,
                        IIT_CHR_ATTRIB66,
                        IIT_CHR_ATTRIB67,
                        IIT_CHR_ATTRIB68,
                        IIT_CHR_ATTRIB69,
                        IIT_CHR_ATTRIB70,
                        IIT_CHR_ATTRIB71,
                        IIT_CHR_ATTRIB72,
                        IIT_CHR_ATTRIB73,
                        IIT_CHR_ATTRIB74,
                        IIT_CHR_ATTRIB75,
                        IIT_NUM_ATTRIB76,
                        IIT_NUM_ATTRIB77,
                        IIT_NUM_ATTRIB78,
                        IIT_NUM_ATTRIB79,
                        IIT_NUM_ATTRIB80,
                        IIT_NUM_ATTRIB81,
                        IIT_NUM_ATTRIB82,
                        IIT_NUM_ATTRIB83,
                        IIT_NUM_ATTRIB84,
                        IIT_NUM_ATTRIB85,
                        IIT_DATE_ATTRIB86,
                        IIT_DATE_ATTRIB87,
                        IIT_DATE_ATTRIB88,
                        IIT_DATE_ATTRIB89,
                        IIT_DATE_ATTRIB90,
                        IIT_DATE_ATTRIB91,
                        IIT_DATE_ATTRIB92,
                        IIT_DATE_ATTRIB93,
                        IIT_DATE_ATTRIB94,
                        IIT_DATE_ATTRIB95,
                        IIT_ANGLE,
                        IIT_ANGLE_TXT,
                        IIT_CLASS,
                        IIT_CLASS_TXT,
                        IIT_COLOUR,
                        IIT_COLOUR_TXT,
                        IIT_COORD_FLAG,
                        IIT_DESCRIPTION,
                        IIT_DIAGRAM,
                        IIT_DISTANCE,
                        IIT_END_CHAIN,
                        IIT_GAP,
                        IIT_HEIGHT,
                        IIT_HEIGHT_2,
                        IIT_ID_CODE,
                        IIT_INSTAL_DATE,
                        IIT_INVENT_DATE,
                        IIT_INV_OWNERSHIP,
                        IIT_ITEMCODE,
                        IIT_LCO_LAMP_CONFIG_ID,
                        IIT_LENGTH,
                        IIT_MATERIAL,
                        IIT_MATERIAL_TXT,
                        IIT_METHOD,
                        IIT_METHOD_TXT,
                        IIT_NOTE,
                        IIT_NO_OF_UNITS,
                        IIT_OPTIONS,
                        IIT_OPTIONS_TXT,
                        IIT_OUN_ORG_ID_ELEC_BOARD,
                        IIT_OWNER,
                        IIT_OWNER_TXT,
                        IIT_PEO_INVENT_BY_ID,
                        IIT_PHOTO,
                        IIT_POWER,
                        IIT_PROV_FLAG,
                        IIT_REV_BY,
                        IIT_REV_DATE,
                        IIT_TYPE,
                        IIT_TYPE_TXT,
                        IIT_WIDTH,
                        IIT_XTRA_CHAR_1,
                        IIT_XTRA_DATE_1,
                        IIT_XTRA_DOMAIN_1,
                        IIT_XTRA_DOMAIN_TXT_1,
                        IIT_XTRA_NUMBER_1,
                        IIT_X_SECT,
                        IIT_DET_XSP,
                        IIT_OFFSET,
                        IIT_X,
                        IIT_Y,
                        IIT_Z,
                        IIT_NUM_ATTRIB96,
                        IIT_NUM_ATTRIB97,
                        IIT_NUM_ATTRIB98,
                        IIT_NUM_ATTRIB99,
                        IIT_NUM_ATTRIB100,
                        IIT_NUM_ATTRIB101,
                        IIT_NUM_ATTRIB102,
                        IIT_NUM_ATTRIB103,
                        IIT_NUM_ATTRIB104,
                        IIT_NUM_ATTRIB105,
                        IIT_NUM_ATTRIB106,
                        IIT_NUM_ATTRIB107,
                        IIT_NUM_ATTRIB108,
                        IIT_NUM_ATTRIB109,
                        IIT_NUM_ATTRIB110,
                        IIT_NUM_ATTRIB111,
                        IIT_NUM_ATTRIB112,
                        IIT_NUM_ATTRIB113,
                        IIT_NUM_ATTRIB114,
                        IIT_NUM_ATTRIB115
                      FROM NM_INV_ITEMS_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        DBMS_OUTPUT.PUT_LINE(DRD4INTO1.AREAS(I)|| ' nm_inv_items_all = '  ||ROW_COUNT);                      
        
                      
  end LOOP;
  for CREC in (select TRIGGER_NAME 
               from user_triggers where table_name = 'NM_INV_ITEMS_ALL')
   LOOP
     execute immediate 'alter trigger '||CREC.TRIGGER_NAME|| ' enable';
  end LOOP;

end do_inv_items;

PROCEDURE do_points
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_points
                      SELECT NP_ID + '||area_max(drd4into1.areas(i))||',
                              NP_GRID_EAST,
                              NP_GRID_NORTH,
                              NP_DESCR,
                              NP_DATE_CREATED,
                              NP_DATE_MODIFIED,
                              NP_MODIFIED_BY,
                              NP_CREATED_BY
                      FROM nm_points@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' nm_points = '  ||ROW_COUNT);                      
                      
  end loop;
END do_points;

PROCEDURE do_nodes
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_nodes_All
                     SELECT NO_NODE_ID + '||area_max(drd4into1.areas(i))||',
                            NO_NODE_NAME,
                            NO_START_DATE,
                            NO_END_DATE,
                            NO_NP_ID,
                            NO_DESCR,
                            NO_NODE_TYPE,
                            NO_DATE_CREATED,
                            NO_DATE_MODIFIED,
                            NO_MODIFIED_BY,
                            NO_CREATED_BY
                          FROM NM_NODES_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' nm_nodes_All = '  ||ROW_COUNT);                      
                      
  END loop;
END do_nodes;

PROCEDURE do_elements
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;
  
   nm3net.g_bypass_nm_elements_trgs := TRUE;
   
   insert into nm_group_types_all
   select * from nm_group_types_all@db_link_west
   where ngt_group_type not in ( select ngt_group_type from nm_group_types_all);
   
   insert into nm_group_types_all
   select * from nm_group_types_all@db_link_north
   where ngt_group_type not in ( select ngt_group_type from nm_group_types_all);
   
   insert into nm_group_types_all
   select * from nm_group_types_all@db_link_south
   where ngt_group_type not in ( select ngt_group_type from nm_group_types_all);
   
  
   FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_elements
                      SELECT NE_ID + '||area_max(drd4into1.areas(i))||',
                            --  decode(ne_type,''G'',NE_UNIQUE||''-'||substr(drd4into1.areas(i),1,1)||''',''P'',NE_UNIQUE||''-'||substr(drd4into1.areas(i),1,1)||''',ne_unique),
                              NE_UNIQUE||''-'||substr(drd4into1.areas(i),1,1)||''',
                        NE_TYPE,
                        NE_NT_TYPE,
                        NE_DESCR,
                        NE_LENGTH,
                        NE_ADMIN_UNIT,
                        NE_DATE_CREATED,
                        NE_DATE_MODIFIED,
                        NE_MODIFIED_BY,
                        NE_CREATED_BY,
                        NE_START_DATE,
                        NE_END_DATE,
                        NE_GTY_GROUP_TYPE,
                        NE_OWNER,
                        NE_NAME_1,
                        NE_NAME_2,
                        NE_PREFIX,
                        NE_NUMBER,
                        NE_SUB_TYPE,
                        NE_GROUP,
                        decode(ne_no_start,NULL,NULL,NE_NO_START + '||area_max(drd4into1.areas(i))||'),
                        decode(ne_no_end,null,null,NE_NO_END + '||area_max(drd4into1.areas(i))||'),
                        NE_SUB_CLASS,
                        NE_NSG_REF,
                        NE_VERSION_NO
                      FROM NM_ELEMENTS_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' nm_elements = '  ||ROW_COUNT);                      
                      
  END loop;
   nm3net.g_bypass_nm_elements_trgs := false;
END do_elements;  

PROCEDURE do_nm_node_usages_all
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO NM_NODE_USAGES_ALL
                     SELECT NNU_NO_NODE_ID + '||area_max(drd4into1.areas(i))||',
                            NNU_NE_ID + '||area_max(drd4into1.areas(i))||',
                            NNU_NODE_TYPE,
                            NNU_CHAIN,
                            NNU_LEG_NO,
                            NNU_START_DATE,
                            NNU_END_DATE
                          FROM NM_NODE_USAGES_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NM_NODE_USAGES_ALL = '  ||ROW_COUNT);                      
                      
  END loop;
END do_nm_node_usages_all;

PROCEDURE do_nm_members_all
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;
 
  for crec in (select trigger_name 
               from user_triggers where table_name = 'NM_MEMBERS_ALL')
   loop
     execute immediate 'alter trigger '||crec.trigger_name|| ' disable';
  end loop; 


  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_members_all
                     SELECT 
                            nm_ne_id_in + '||area_max(drd4into1.areas(i))||',
                            NM_NE_ID_OF + '||area_max(drd4into1.areas(i))||',
                            NM_TYPE,
                            NM_OBJ_TYPE,
                            NM_BEGIN_MP,
                            NM_START_DATE,
                            NM_END_DATE,
                            NM_END_MP,
                            NM_SLK,
                            NM_CARDINALITY,
                            NM_ADMIN_UNIT,
                            NM_DATE_CREATED,
                            NM_DATE_MODIFIED,
                            NM_MODIFIED_BY,
                            NM_CREATED_BY,
                            NM_SEQ_NO,
                            NM_SEG_NO,
                            NM_TRUE,
                            NM_END_SLK,
                            nm_end_true
                          FROM NM_MEMBERS_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' nm_members_all = '  ||ROW_COUNT);                      
        
  end loop;
  for crec in (select trigger_name 
               from user_triggers where table_name = 'NM_MEMBERS_ALL')
   loop
     execute immediate 'alter trigger '||crec.trigger_name|| ' enable';
  end loop; 

END do_nm_members_all;

PROCEDURE do_nm_nw_ad_link_all
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      loop
          EXECUTE IMMEDIATE 'INSERT INTO nm_nw_ad_link_all
                     SELECT nad_id ,
                            nad_iit_ne_id + '||area_max(drd4into1.areas(i))||',
                            NAD_NE_ID + '||area_max(drd4into1.areas(i))||',
                            NAD_START_DATE,
                            NAD_END_DATE,
                            NAD_NT_TYPE,
                            NAD_GTY_TYPE,
                            NAD_INV_TYPE,
                            nad_primary_ad
                          FROM NM_NW_AD_LINK_ALL@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' nm_nw_ad_link_all = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_nm_nw_ad_link_all;

PROCEDURE do_activities
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO activities
                           (ATV_ACTY_AREA_CODE,
                            ATV_DTP_FLAG,
                            ATV_IF_SCHEDULED_FLAG,
                            ATV_MAINT_INSP_FLAG,
                            ATV_SEQUENCE_NO,
                            ATV_SPECIALIST_FLAG,
                            ATV_CALC_TYPE,
                            ATV_CAT1P_INT_CODE,
                            ATV_CAT1T_INT_CODE,
                            ATV_CAT2_1P_INT_CODE,
                            ATV_CAT2_2P_INT_CODE,
                            ATV_CAT2_3P_INT_CODE,
                            ATV_DESCR,
                            ATV_DTP_EXP_CODE,
                            ATV_LA_EXP_CODE,
                            ATV_MAINT_COST,
                            ATV_SEASONAL_FLAG,
                            ATV_UNIT,
                          --  ATV_MATERIAL,
                          --  ATV_XSP_TYPE,
                            ATV_START_DATE,
                            ATV_END_DATE,
                            ATV_ACTIVITY_DURATION)
                     SELECT ATV_ACTY_AREA_CODE,
                            ATV_DTP_FLAG,
                            ATV_IF_SCHEDULED_FLAG,
                            ATV_MAINT_INSP_FLAG,
                            ATV_SEQUENCE_NO,
                            ATV_SPECIALIST_FLAG,
                            ATV_CALC_TYPE,
                            ATV_CAT1P_INT_CODE,
                            ATV_CAT1T_INT_CODE,
                            ATV_CAT2_1P_INT_CODE,
                            ATV_CAT2_2P_INT_CODE,
                            ATV_CAT2_3P_INT_CODE,
                            ATV_DESCR,
                            ATV_DTP_EXP_CODE,
                            ATV_LA_EXP_CODE,
                            ATV_MAINT_COST,
                            ATV_SEASONAL_FLAG,
                            ATV_UNIT,
                          --  ATV_MATERIAL,
                          --  ATV_XSP_TYPE,
                            ATV_START_DATE,
                            ATV_END_DATE,
                            ATV_ACTIVITY_DURATION
                          FROM ACTIVITIES@db_link_'||drd4into1.areas(i)||'
                          where ATV_ACTY_AREA_CODE not in ( select ATV_ACTY_AREA_CODE from activities)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' activities = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_activities;

PROCEDURE do_activities_report
IS
  ROW_COUNT number;
  BATCH_ID_MAX AREA_MAX_TYPE; 
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  BATCH_ID_MAX('WEST')  := 200000;
  BATCH_ID_MAX('NORTH') := 300000;
  BATCH_ID_MAX('SOUTH') := 400000;

  FOR i IN 1..drd4into1.areas.count
      loop
          execute immediate 'INSERT INTO activities_report
                     SELECT ARE_REPORT_ID + '||area_max(drd4into1.areas(i))||',
                            ARE_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                            ARE_BATCH_ID  + '||batch_id_max(drd4into1.areas(i))||',
                            ARE_CREATED_DATE,
                            ARE_LAST_UPDATED_DATE,
                            ARE_MAINT_INSP_FLAG,
                            ARE_SCHED_ACT_FLAG,
                            ARE_DATE_WORK_DONE,
                            ARE_END_CHAIN,
                            ARE_INITIATION_TYPE,
                            ARE_INSP_LOAD_DATE,
                            ARE_PEO_PERSON_ID_ACTIONED,
                            ARE_PEO_PERSON_ID_INSP2,
                            ARE_ST_CHAIN,
                            ARE_SURFACE_CONDITION,
                            ARE_WEATHER_CONDITION,
                            ARE_WOL_WORKS_ORDER_NO
                          FROM ACTIVITIES_REPORT@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' activities_report = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_activities_report;

PROCEDURE do_act_freqs
IS
  row_count number;
BEGIN

  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'insert into ACT_FREQS
                              select * from ACT_FREQS@db_link_'||drd4into1.areas(i)||'
                              where (AFR_ITY_INV_CODE, AFR_ITY_SYS_FLAG, AFR_ATV_ACTY_AREA_CODE, AFR_SCL_SECT_CLASS)
                              not in (select AFR_ITY_INV_CODE, AFR_ITY_SYS_FLAG, AFR_ATV_ACTY_AREA_CODE, AFR_SCL_SECT_CLASS from ACT_FREQS)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' act_freqs = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_act_freqs;


PROCEDURE do_ACT_REPORT_LINES
IS
  ROW_COUNT number;
  BATCH_ID_MAX AREA_MAX_TYPE; 
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  BATCH_ID_MAX('WEST')  := 200000;
  BATCH_ID_MAX('NORTH') := 300000;
  BATCH_ID_MAX('SOUTH') := 400000;

  FOR i IN 1..drd4into1.areas.count
      loop
          execute immediate 'INSERT INTO ACT_REPORT_LINES
                     SELECT 
                              ARL_ACT_STATUS,
                              ARL_ARE_REPORT_ID + '||area_max(drd4into1.areas(i))||',
                              ARL_ATV_ACTY_AREA_CODE,
                              ARL_CREATED_DATE,
                              ARL_LAST_UPDATED_DATE,
                              ARL_NOT_SEQ_FLAG,
                              ARL_REPORT_ID_PART_OF
                            FROM ACT_REPORT_LINES@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' ACT_REPORT_LINES = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_ACT_REPORT_LINES;



PROCEDURE do_STANDARD_ITEMS
is
    ROW_COUNT number;
begin
  
  FOR i IN 1..drd4into1.areas.count
      loop
          execute immediate 'insert into STANDARD_ITEMS
                             select * from STANDARD_ITEMS@DB_LINK_'||drd4into1.areas(i)||'
                             where STA_ITEM_CODE not in ( select STA_ITEM_CODE from STANDARD_ITEMS)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' STANDARD_ITEMS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_STANDARD_ITEMS;

PROCEDURE do_contracts
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  

  FOR i IN 1..drd4into1.areas.count
      loop
          execute immediate 'INSERT INTO contracts
                     SELECT 
                            CON_ID + '||area_max(drd4into1.areas(i))||',
                            CON_CODE,
                            CON_NAME,
                            CON_ADMIN_ORG_ID,
                            CON_CONTR_ORG_ID,
                            CON_START_DATE,
                            CON_END_DATE,
                            CON_STATUS_CODE,
                            CON_EXTERNAL_REF,
                            CON_RETENTION_RATE,
                            CON_MAX_RETENTION,
                            CON_LIQUID_DAMAGES,
                            CON_LAST_WORK_SHEET_NO,
                            CON_LAST_PAYMENT_NO,
                            CON_LAST_WOR_NO,
                            CON_COST_CODE,
                            CON_SPEND_YTD,
                            CON_SPEND_TO_DATE,
                            CON_DAMAGES_TO_DATE,
                            CON_REMARKS,
                            CON_RETENTION_TO_DATE,
                            CON_GENERATE_GL,
                            CON_YEAR_END_DATE
                          from CONTRACTS@DB_LINK_'||drd4into1.areas(i)||'
                          where con_code not in ( select con_code from contracts)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' contracts = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_contracts;

PROCEDURE do_contract_items
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO contract_items
                     SELECT 
                            CNI_CON_ID + '||area_max(drd4into1.areas(i))||',
                            CNI_STA_ITEM_CODE,
                            CNI_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                            CNI_RATE,
                            CNI_CNG_DISC_GROUP,
                            CNI_EXTERNAL_REF,
                            CNI_USAGE_COUNT,
                            CNI_USAGE_QUANTITY,
                            CNI_USAGE_COST
                          FROM CONTRACT_ITEMS@DB_LINK_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' contract_items = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_contract_items;

PROCEDURE do_CONTRACT_PAYMENTS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO CONTRACT_PAYMENTS
                     SELECT 
                            CNP_ID  + '||area_max(drd4into1.areas(i))||',
                            CNP_CON_ID  + '||area_max(drd4into1.areas(i))||',
                            CNP_TOTAL_VALUE,
                            CNP_RETENTION_AMOUNT,
                            CNP_VAT_AMOUNT,
                            CNP_AMOUNT,
                            CNP_RUN_DATE,
                            CNP_USERNAME,
                            CNP_FIRST_PAYMENT_NO,
                            CNP_LAST_PAYMENT_NO
                          FROM CONTRACT_PAYMENTS@DB_LINK_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' CONTRACT_PAYMENTS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_CONTRACT_PAYMENTS;

PROCEDURE do_COST_CENTRES
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO COST_CENTRES
                            SELECT COC_ORG_ID,
                                  COC_COST_CENTRE,
                                  COC_START_DATE,
                                  COC_END_DATE
                                from COST_CENTRES@DB_LINK_'||drd4into1.areas(i)||'
                                where (coc_org_id, coc_cost_centre) not in (select coc_org_id, coc_cost_centre from cost_centres)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' COST_CENTRES = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_COST_CENTRES;

PROCEDURE do_defect_priorities
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO defect_priorities
                             SELECT DPR_ATV_ACTY_AREA_CODE,
                                    DPR_PRIORITY,
                                    DPR_ACTION_CAT,
                                    DPR_INT_CODE,
                                    DPR_USE_WORKING_DAYS,
                                    DPR_USE_NEXT_INSP,
                                    DPR_PRINT_TARGETS,
                                    DPR_TIME_MANDATORY
                                  FROM DEFECT_PRIORITIES@db_link_'||drd4into1.areas(i)||'
                                  where (DPR_ATV_ACTY_AREA_CODE, DPR_PRIORITY, DPR_ACTION_CAT)
                                  not in (select DPR_ATV_ACTY_AREA_CODE, DPR_PRIORITY, DPR_ACTION_CAT from defect_priorities)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' defect_priorities = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_defect_priorities;

PROCEDURE do_def_treats
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DEF_TREATS
                             SELECT DTR_DTY_ACTY_AREA_CODE,
                                    DTR_DTY_DEFECT_CODE,
                                    DTR_TRE_TREAT_CODE,
                                    DTR_TRE_RATE,
                                    DTR_SYS_FLAG
                                  FROM DEF_TREATS@db_link_'||drd4into1.areas(i)||'
                                  where (DTR_DTY_ACTY_AREA_CODE, DTR_DTY_DEFECT_CODE, DTR_TRE_TREAT_CODE, DTR_SYS_FLAG)
                                  not in (select DTR_DTY_ACTY_AREA_CODE, DTR_DTY_DEFECT_CODE, DTR_TRE_TREAT_CODE, DTR_SYS_FLAG
                                          from def_treats)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' def_treats = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_def_treats;

PROCEDURE do_DEF_MOVEMENTS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DEF_MOVEMENTS
                             SELECT DFM_DEF_DEFECT_ID + '||area_max(drd4into1.areas(i))||',
                                    DFM_DATE_MOD,
                                    DFM_PEO_PERSON_ID,
                                    DFM_OLD_DEF_PRIORITY,
                                    DFM_OLD_DEF_STATUS_CODE,
                                    DFM_NEW_DEF_PRIORITY,
                                    DFM_NEW_DEF_STATUS_CODE
                                  FROM DEF_MOVEMENTS';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' DEF_MOVEMENTS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_DEF_MOVEMENTS;

PROCEDURE do_DEFECTS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DEFECTS
                     SELECT DEF_DEFECT_ID + '||area_max(drd4into1.areas(i))||',
                            DEF_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                            DEF_ST_CHAIN,
                            DEF_ARE_REPORT_ID + '||area_max(drd4into1.areas(i))||',
                            DEF_ATV_ACTY_AREA_CODE,
                            DEF_SISS_ID,
                            DEF_WORKS_ORDER_NO,
                            DEF_CREATED_DATE,
                            DEF_DEFECT_CODE,
                            DEF_LAST_UPDATED_DATE,
                            DEF_ORIG_PRIORITY,
                            DEF_PRIORITY,
                            DEF_STATUS_CODE,
                            DEF_SUPERSEDED_FLAG,
                            DEF_AREA,
                            DEF_ARE_ID_NOT_FOUND,
                            DEF_COORD_FLAG,
                            DEF_DATE_COMPL,
                            DEF_DATE_NOT_FOUND,
                            DEF_DEFECT_CLASS,
                            DEF_DEFECT_DESCR,
                            DEF_DEFECT_TYPE_DESCR,
                            DEF_DIAGRAM_NO,
                            DEF_HEIGHT,
                            DEF_IDENT_CODE,
                            DEF_ITY_INV_CODE,
                            DEF_ITY_SYS_FLAG,
                            DEF_LENGTH,
                            DEF_LOCN_DESCR,
                            DEF_MAINT_WO,
                            DEF_MAND_ADV,
                            DEF_NOTIFY_ORG_ID,
                            DEF_NUMBER,
                            DEF_PER_CENT,
                            DEF_PER_CENT_ORIG,
                            DEF_PER_CENT_REM,
                            DEF_RECHAR_ORG_ID,
                            DEF_SERIAL_NO,
                            DEF_SKID_COEFF,
                            DEF_SPECIAL_INSTR,
                            DEF_SUPERSEDED_ID,
                            DEF_TIME_HRS,
                            DEF_TIME_MINS,
                            DEF_UPDATE_INV,
                            DEF_X_SECT,
                            DEF_RESPONSE_CATEGORY,
                            DEF_NORTHING,
                            DEF_EASTING,
                            DEF_IIT_ITEM_ID + '||area_max(drd4into1.areas(i))||'
                          FROM DEFECTS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' DEFECTS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_DEFECTS;

PROCEDURE do_NM_AUDIT_ACTIONS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO NM_AUDIT_ACTIONS
                     SELECT 
                            NA_AUDIT_ID + '||area_max(drd4into1.areas(i))||',
                            NA_TIMESTAMP,
                            NA_PERFORMED_BY,
                            NA_SESSION_ID,
                            NA_TABLE_NAME,
                            NA_AUDIT_TYPE,
                            NA_KEY_INFO_1,
                            NA_KEY_INFO_2,
                            NA_KEY_INFO_3,
                            NA_KEY_INFO_4,
                            NA_KEY_INFO_5,
                            NA_KEY_INFO_6,
                            NA_KEY_INFO_7,
                            NA_KEY_INFO_8,
                            NA_KEY_INFO_9,
                            NA_KEY_INFO_10
                          FROM NM_AUDIT_ACTIONS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NM_AUDIT_ACTIONS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_NM_AUDIT_ACTIONS;

PROCEDURE do_NM_AUDIT_changes
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO NM_AUDIT_changes
                     SELECT 
                            NACH_AUDIT_ID + '||area_max(drd4into1.areas(i))||',
                            NACH_COLUMN_ID,
                            NACH_COLUMN_NAME,
                            NACH_OLD_VALUE,
                            NACH_NEW_VALUE
                          FROM NM_AUDIT_CHANGES@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NM_AUDIT_changes = '  ||ROW_COUNT);                      
                      
  end LOOP;
end do_NM_AUDIT_changes;

PROCEDURE do_NM_ELEMENT_HISTORY
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO NM_ELEMENT_HISTORY
                     SELECT NEH_ID + '||area_max(drd4into1.areas(i))||',
                            NEH_NE_ID_OLD + '||area_max(drd4into1.areas(i))||',
                            NEH_NE_ID_NEW + '||area_max(drd4into1.areas(i))||',
                            NEH_OPERATION,
                            NEH_EFFECTIVE_DATE,
                            NEH_ACTIONED_DATE,
                            NEH_ACTIONED_BY,
                            NEH_OLD_NE_LENGTH,
                            NEH_NEW_NE_LENGTH,
                            NEH_PARAM_1,
                            NEH_PARAM_2
                          FROM NM_ELEMENT_HISTORY@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NM_ELEMENT_HISTORY = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_NM_ELEMENT_HISTORY;

PROCEDURE do_NOTICES
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO NOTICES
                      SELECT NOT_ID + '||area_max(drd4into1.areas(i))||',
                            NOT_ORG_ID_ADMIN,
                            NOT_ORG_ID_NOTIFIED,
                            NOT_DATE_PRINTED,
                            NOT_RESPOND_BY,
                            NOT_DATE_FROM,
                            NOT_DATE_TO
                          FROM NOTICES@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NOTICES = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_NOTICES;

PROCEDURE do_NOTICE_DEFECTS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO NOTICE_DEFECTS
                            SELECT NOD_NOT_ID + '||area_max(drd4into1.areas(i))||',
                                  NOD_DEF_DEFECT_ID + '||area_max(drd4into1.areas(i))||',
                                  NOD_RESPONSE_DATE,
                                  NOD_RESPONSE_TYPE,
                                  NOD_RESPONSE_TEXT
                                FROM NOTICE_DEFECTS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' NOTICE_DEFECTS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_NOTICE_DEFECTS;

PROCEDURE do_repairs
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--'||drd4into1.areas(i)||'

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO repairs
                            SELECT 
                                  REP_ACTION_CAT,
                                  REP_ATV_ACTY_AREA_CODE,
                                  REP_DATE_DUE,
                                  REP_DEF_DEFECT_ID + '||area_max(drd4into1.areas(i))||',
                                  REP_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                                  REP_SUPERSEDED_FLAG,
                                  REP_COMPLETED_HRS,
                                  REP_COMPLETED_MINS,
                                  REP_DATE_COMPLETED,
                                  REP_DESCR,
                                  REP_TRE_TREAT_CODE,
                                  REP_OLD_DUE_DATE,
                                  REP_LOCAL_DATE_DUE,
                                  REP_CREATED_DATE,
                                  REP_LAST_UPDATED_DATE
                                FROM REPAIRS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' repairs = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_repairs;


PROCEDURE do_SCHEDULES
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

--+ '||area_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO SCHEDULES
                            SELECT SCHD_ID + '||area_max(drd4into1.areas(i))||',
                                    SCHD_NAME,
                                    SCHD_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                                    SCHD_SISS_ID,
                                    SCHD_ICB_WORK_CODE,
                                    SCHD_INT_CODE,
                                    SCHD_AGENCY,
                                    SCHD_DESCR,
                                    SCHD_CALC_DATE,
                                    SCHD_START_DATE,
                                    SCHD_END_DATE,
                                    SCHD_BY_ASSET
                                  FROM SCHEDULES@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' SCHEDULES = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_SCHEDULES;

PROCEDURE do_SCHEDULE_ITEMS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO SCHEDULE_ITEMS
                            SELECT SCHI_SCHD_ID + '||area_max(drd4into1.areas(i))||',
                                    SCHI_STA_ITEM_CODE,
                                    SCHI_CALC_QUANTITY,
                                    SCHI_ACT_QUANTITY,
                                    SCHI_LAST_UPDATED
                                  FROM SCHEDULE_ITEMS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' SCHEDULE_ITEMS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_SCHEDULE_ITEMS;

PROCEDURE do_SCHEDULE_ROADS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO SCHEDULE_ROADS
                            SELECT  SCHR_SCHD_ID  + '||area_max(drd4into1.areas(i))||',
                                    SCHR_STA_ITEM_CODE,
                                    SCHR_RSE_HE_ID + '||area_max(drd4into1.areas(i))||',
                                    SCHR_CALC_QUANTITY,
                                    SCHR_ACT_QUANTITY,
                                    SCHR_LAST_UPDATED,
                                    SCHR_IIT_ITEM_ID  + '||area_max(drd4into1.areas(i))||'
                                  FROM SCHEDULE_ROADS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' SCHEDULE_ROADS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_SCHEDULE_ROADS;

PROCEDURE do_SECTION_FREQS
IS
  ROW_COUNT number;
  
begin
  
  drd4into1.init;

  area_max('WEST')  := 20000000;
  area_max('NORTH') := 30000000;
  area_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO SECTION_FREQS
                            SELECT SFR_ATV_ACTY_AREA_CODE,
                                    SFR_INT_CODE,
                                    SFR_RSE_HE_ID  + '||area_max(drd4into1.areas(i))||',
                                    SFR_ARE_REPORT_ID  + '||area_max(drd4into1.areas(i))||',
                                    SFR_CHANGED_BY,
                                    SFR_DATE_CHANGED
                                  FROM SECTION_FREQS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' SECTION_FREQS = '  ||ROW_COUNT);                      
                      
  end LOOP;
end DO_SECTION_FREQS;

PROCEDURE do_work_orders
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  execute immediate 'alter trigger WOR_AUDIT disable';

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO work_orders
                     select WOR_WORKS_ORDER_NO || '''||substr(drd4into1.areas(i),1,1) ||''',
                            WOR_SYS_FLAG,
                            WOR_RSE_HE_ID_GROUP + '||big_max(drd4into1.areas(i))||',
                            WOR_FLAG,
                            WOR_CON_ID + '||big_max(drd4into1.areas(i))||',
                            WOR_ACT_COST_CODE,
                            WOR_ACT_BALANCING_SUM,
                            WOR_ACT_COST,
                            WOR_ACT_LABOUR,
                            WOR_AGENCY,
                            WOR_ARE_SCHED_ACT_FLAG,
                            WOR_CHEAPEST_FLAG,
                            WOR_CLOSED_BY_ID,
                            WOR_COC_COST_CENTRE,
                            WOR_COST_RECHARG,
                            WOR_DATE_CLOSED,
                            WOR_DATE_CONFIRMED,
                            WOR_DATE_MOD,
                            WOR_DATE_RAISED,
                            WOR_DESCR,
                            WOR_DIV_CODE,
                            WOR_DTP_EXPEND_CODE,
                            WOR_EST_BALANCING_SUM,
                            WOR_EST_COMPLETE,
                            WOR_EST_COST,
                            WOR_EST_LABOUR,
                            WOR_ICB_ITEM_CODE,
                            WOR_ICB_SUB_ITEM_CODE,
                            WOR_ICB_SUB_SUB_ITEM_CODE,
                            WOR_JOB_NUMBER,
                            WOR_LAST_PRINT_DATE,
                            WOR_LA_EXPEND_CODE,
                            WOR_MOD_BY_ID + '||area_max(drd4into1.areas(i))||',
                            WOR_OUN_ORG_ID,
                            WOR_PEO_PERSON_ID + '||area_max(drd4into1.areas(i))||',
                            WOR_PRICE_TYPE,
                            WOR_REMARKS,
                            WOR_ROAD_TYPE,
                            WOR_RSE_HE_ID_LINK + '||big_max(drd4into1.areas(i))||',
                            WOR_SCHEME_REF,
                            WOR_SCHEME_TYPE,
                            WOR_SCORE,
                            WOR_YEAR_CODE,
                            WOR_INTERIM_PAYMENT_FLAG,
                            WOR_RISK_ASSESSMENT_FLAG,
                            WOR_METHOD_STATEMENT_FLAG,
                            WOR_WORKS_PROGRAMME_FLAG,
                            WOR_ADDITIONAL_SAFETY_FLAG,
                            WOR_DEF_CORRECTION,
                            WOR_DEF_CORRECTION_ACCEPTABLE,
                            WOR_CORR_EXTENSION_TIME,
                            WOR_REVISED_COMP_DATE,
                            WOR_PRICE_VARIATION,
                            WOR_COMMENCE_BY,
                            WOR_ACT_COMMENCE_BY,
                            WOR_DEF_CORRECTION_PERIOD,
                            WOR_REASON_NOT_CHEAPEST,
                            WOR_PRIORITY,
                            WOR_PERC_ITEM_COMP,
                            WOR_CONTACT,
                            WOR_DATE_RECEIVED,
                            WOR_RECEIVED_BY,
                            WOR_RECHARGEABLE,
                            WOR_SUPP_DOCUMENTS,
                            WOR_EARLIEST_START_DATE,
                            WOR_PLANNED_COMP_DATE,
                            WOR_LATEST_COMP_DATE,
                            WOR_SITE_COMPLETE_DATE,
                            WOR_EST_DURATION,
                            WOR_ACT_DURATION,
                            WOR_CERT_COMPLETE,
                            WOR_CON_CERT_COMPLETE,
                            WOR_AGREED_BY + '||area_max(drd4into1.areas(i))||',
                            WOR_AGREED_BY_DATE,
                            WOR_CON_AGREED_BY + '||area_max(drd4into1.areas(i))||',
                            WOR_CON_AGREED_BY_DATE,
                            WOR_LATE_COSTS,
                            WOR_LATE_COST_CERTIFIED_BY,
                            WOR_LATE_COST_CERTIFIED_DATE,
                            WOR_LOCATION_PLAN,
                            WOR_UTILITY_PLANS,
                            WOR_WORK_RESTRICTIONS,
                            nvl(WOR_REGISTER_FLAG,''N''),
                            WOR_REGISTER_STATUS
                          from WORK_ORDERS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' work_orders = '  ||ROW_COUNT);                      
                     
  end LOOP;
  execute immediate 'alter trigger WOR_AUDIT enable';
end do_work_orders;

PROCEDURE DO_WORK_ORDER_LINES
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',


  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO WORK_ORDER_LINES
                            select WOL_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_WORKS_ORDER_NO || '''||substr(drd4into1.areas(i),1,1) ||''',
                            WOL_RSE_HE_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_SISS_ID,
                            WOL_ICB_WORK_CODE,
                            WOL_DEF_DEFECT_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_REP_ACTION_CAT,
                            WOL_SCHD_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_CNP_ID,
                            WOL_ACT_AREA_CODE,
                            WOL_ACT_COST,
                            WOL_ACT_LABOUR,
                            WOL_ARE_END_CHAIN,
                            WOL_ARE_REPORT_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_ARE_ST_CHAIN,
                            WOL_CHECK_CODE,
                            WOL_CHECK_COMMENTS,
                            WOL_CHECK_DATE,
                            WOL_CHECK_ID,
                            WOL_CHECK_PEO_ID,
                            WOL_CHECK_RESULT,
                            WOL_DATE_COMPLETE,
                            WOL_DATE_CREATED,
                            WOL_DATE_PAID,
                            WOL_DESCR,
                            WOL_DISCOUNT,
                            WOL_EST_COST,
                            WOL_EST_LABOUR,
                            WOL_FLAG,
                            WOL_MONTH_DUE,
                            WOL_ORIG_EST,
                            WOL_PAYMENT_CODE,
                            WOL_QUANTITY,
                            WOL_RATE,
                            WOL_SS_TRE_TREAT_CODE,
                            WOL_STATUS,
                            WOL_STATUS_CODE,
                            WOL_UNIQUE_FLAG,
                            WOL_WORK_SHEET_DATE,
                            WOL_WORK_SHEET_ISSUE,
                            WOL_WORK_SHEET_NO,
                            WOL_WOR_FLAG,
                            WOL_DATE_REPAIRED,
                            WOL_INVOICE_STATUS,
                            WOL_BUD_ID,
                            WOL_UNPOSTED_EST,
                            WOL_IIT_ITEM_ID + '||big_max(drd4into1.areas(i))||',
                            WOL_GANG,
                            WOL_FINAL
                          FROM WORK_ORDER_LINES@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' WORK_ORDER_LINES = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_WORK_ORDER_LINES;


PROCEDURE DO_BOQ_ITEMS
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO BOQ_ITEMS
                            SELECT BOQ_WORK_FLAG,
                                    BOQ_DEFECT_ID + '||big_max(drd4into1.areas(i))||',
                                    nvl(BOQ_REP_ACTION_CAT,''P''),
                                    BOQ_WOL_ID + '||big_max(drd4into1.areas(i))||',
                                    BOQ_STA_ITEM_CODE,
                                    BOQ_ITEM_NAME,
                                    BOQ_DATE_CREATED,
                                    BOQ_ICB_WORK_CODE,
                                    BOQ_EST_DIM1,
                                    BOQ_EST_DIM2,
                                    BOQ_EST_DIM3,
                                    BOQ_EST_QUANTITY,
                                    BOQ_EST_RATE,
                                    BOQ_EST_DISCOUNT,
                                    BOQ_EST_COST,
                                    BOQ_EST_LABOUR,
                                    BOQ_ACT_DIM1,
                                    BOQ_ACT_DIM2,
                                    BOQ_ACT_DIM3,
                                    BOQ_ACT_QUANTITY,
                                    BOQ_ACT_COST,
                                    BOQ_ACT_LABOUR,
                                    BOQ_ACT_RATE,
                                    BOQ_ACT_DISCOUNT,
                                    BOQ_ID  + '||big_max(drd4into1.areas(i))||',
                                    BOQ_PARENT_ID  + '||big_max(drd4into1.areas(i))||'
                                  FROM BOQ_ITEMS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' BOQ_ITEMS = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_BOQ_ITEMS;

PROCEDURE DO_BUDGETS
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO BUDGETS
                            SELECT BUD_SYS_FLAG,
                                    BUD_AGENCY,
                                    BUD_RSE_HE_ID + '||big_max(drd4into1.areas(i))||',
                                    BUD_JOB_CODE,
                                    BUD_ICB_ITEM_CODE,
                                    BUD_ICB_SUB_ITEM_CODE,
                                    BUD_ICB_SUB_SUB_ITEM_CODE,
                                    BUD_FYR_ID,
                                    BUD_VALUE,
                                    BUD_COST_CODE,
                                    BUD_COMMENT,
                                    BUD_ID,
                                    BUD_COMMITTED,
                                    BUD_ACTUAL,
                                    BUD_BID_ID
                                  FROM BUDGETS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' BUDGETS = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_BUDGETS;


PROCEDURE DO_CLAIM_PAYMENTS
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO CLAIM_PAYMENTS
                            select CP_WOC_CLAIM_REF  + '||big_max(drd4into1.areas(i))||',
                                    CP_WOC_CON_ID + '||big_max(drd4into1.areas(i))||',
                                    CP_WOL_ID + '||big_max(drd4into1.areas(i))||',
                                    CP_STATUS,
                                    CP_CLAIM_VALUE,
                                    CP_PAYMENT_ID,
                                    CP_PAYMENT_VALUE,
                                    CP_PAYMENT_DATE,
                                    CP_FIS_PAYMENT_REF,
                                    CP_FYR_ID,
                                    CP_INVOICE_NO
                                  FROM CLAIM_PAYMENTS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' CLAIM_PAYMENTS = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_CLAIM_PAYMENTS;

PROCEDURE DO_CLAIM_PAYMENTS_AUDIT
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO CLAIM_PAYMENTS_AUDIT
                            select CPA_ID + '||big_max(drd4into1.areas(i))||',
                                    CPA_WOC_CLAIM_REF + '||big_max(drd4into1.areas(i))||',
                                    CPA_WOC_CON_ID + '||big_max(drd4into1.areas(i))||',
                                    CPA_WOL_ID + '||big_max(drd4into1.areas(i))||',
                                    CPA_DATE,
                                    CPA_STATUS,
                                    CPA_CLAIM_VALUE,
                                    CPA_PAYMENT_ID,
                                    CPA_PAYMENT_VALUE,
                                    CPA_PAYMENT_DATE,
                                    CPA_FIS_PAYMENT_REF,
                                    CPA_FYR_ID,
                                    CPA_INVOICE_NO
                                  FROM CLAIM_PAYMENTS_AUDIT@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' CLAIM_PAYMENTS_AUDIT = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_CLAIM_PAYMENTS_AUDIT;

PROCEDURE DO_DOC_ACTIONS
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DOC_ACTIONS
                            SELECT DAC_ID + '||area_max(drd4into1.areas(i))||',
                                    DAC_DOC_ID + '||area_max(drd4into1.areas(i))||',
                                    DAC_CODE,
                                    DAC_DESCR,
                                    DAC_DATE_ASSIGNED,
                                    DAC_PRIORITY_ID,
                                    DAC_TARGET_DATE,
                                    DAC_COMPLETION_DATE,
                                    DAC_ASSIGNEE,
                                    DAC_STATUS,
                                    DAC_SEQ,
                                    DAC_PARALLEL_FLAG,
                                    DAC_SECURITY_LEVEL,
                                    DAC_OUTCOME,
                                    DAC_REFERENCE,
                                    DAC_TOTAL_AMOUNT
                                  FROM DOC_ACTIONS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' DOC_ACTIONS = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_DOC_ACTIONS;

PROCEDURE DO_DOC_ACTION_HISTORY
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DOC_ACTION_HISTORY
                            SELECT DAH_DAC_ID  + '||area_max(drd4into1.areas(i))||',
                                    DAH_CODE,
                                    DAH_DATE_CHANGED,
                                    DAH_CHANGED_BY,
                                    DAH_DATE_ASSIGNED,
                                    DAH_PRIORITY_ID,
                                    DAH_ASSIGNEE,
                                    DAH_STATUS,
                                    DAH_SECURITY_LEVEL,
                                    DAH_TOTAL_AMOUNT,
                                    DAH_COMPLETION_DATE,
                                    DAH_TARGET_DATE,
                                    DAH_OUTCOME
                                  FROM DOC_ACTION_HISTORY@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' DOC_ACTION_HISTORY = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_DOC_ACTION_HISTORY;

PROCEDURE DO_DOC_ASSOCS
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO DOC_ASSOCS
                            select DAS_TABLE_NAME
                                  , DECODE(DAS_TABLE_NAME, ''DOCS'',DAS_REC_ID  + '||area_max(drd4into1.areas(i))||',''DOCS2VIEW'',DAS_REC_ID + '||area_max(drd4into1.areas(i))||',DAS_REC_ID +  + '||big_max(drd4into1.areas(i))||')
                                  , DAS_DOC_ID + '||area_max(drd4into1.areas(i))||'
                                  FROM DOC_ASSOCS@db_link_'||drd4into1.areas(i);

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' DOC_ASSOCS = '  ||ROW_COUNT);                      
                     
  end LOOP;
  
end DO_DOC_ASSOCS;

PROCEDURE DO_roles
IS
  ROW_COUNT number;
 type BIG_MAX_TYPE is table of number index by varchar2(20);
  big_max area_max_type;   
begin
  
  drd4into1.init;

  BIG_MAX('WEST')  := 20000000;
  BIG_MAX('NORTH') := 30000000;
  big_max('SOUTH') := 40000000;

-- + '||area_max(drd4into1.areas(i))||',
-- + '||big_max(drd4into1.areas(i))||',

  execute immediate 'alter table HIG_USER_ROLES disable all triggers';

  FOR i IN 1..drd4into1.areas.count
      LOOP
          execute immediate 'INSERT INTO hig_roles
                            select HRO_ROLE
                                 , HRO_PRODUCT
                                 , HRO_DESCR 
                            from HIG_ROLES@db_link_'||drd4into1.areas(i)||'
                            where hro_role not in ( select hro_role from hig_roles)';

        row_count := SQL%ROWCOUNT;
            
        dbms_output.put_line(drd4into1.areas(i)|| ' hig_roles = '  ||ROW_COUNT);                      
        
          execute immediate 'INSERT INTO hig_user_roles
                                  select HUR_USERNAME, 
                                         HUR_ROLE, 
                                         HUR_START_DATE 
                                  from HIG_USER_ROLES@DB_LINK_'||drd4into1.areas(i)||'
                                  where (HUR_USERNAME, HUR_ROLE) not in (select HUR_USERNAME, HUR_ROLE from HIG_USER_ROLES)
                                  and hur_username != ''AREA_'||drd4into1.areas(i)||'''';
        row_count := SQL%ROWCOUNT;
            
        DBMS_OUTPUT.PUT_LINE(DRD4INTO1.AREAS(I)|| ' hig_roles = '  ||ROW_COUNT);                      
        
                     
  end LOOP;
  
  execute immediate 'alter table HIG_USER_ROLES enable all triggers';
end DO_roles;



end drd4into1;
/
