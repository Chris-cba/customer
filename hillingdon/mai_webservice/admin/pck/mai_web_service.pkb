set define off
CREATE OR REPLACE PACKAGE BODY mai_web_service AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/pck/pck/mai_web_service.pkb-arc   1.6   May 07 2009 17:29:48   mhuitson  $
--       Module Name      : $Workfile:   mai_web_service.pkb  $
--       Date into PVCS   : $Date:   May 07 2009 17:29:48  $
--       Date fetched Out : $Modtime:   May 06 2009 17:59:50  $
--       PVCS Version     : $Revision:   1.6  $
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_body_sccsid   CONSTANT  VARCHAR2(2000) := '$Revision:   1.6  $';
  g_package_name  CONSTANT  VARCHAR2(30)   := 'mai_web_service';
  c_date_format   CONSTANT  VARCHAR2(20)   := 'DD-MON-YYYY';
  c_xmlns         CONSTANT  VARCHAR2(50)   := ' xmlns="http://exor_mai_ws/exor_mai_ws"';
  c_xsd_uri       CONSTANT  VARCHAR2(50)   := 'Exor_mai_ws-v2-2.xsd';
  --
  date_format_error EXCEPTION;
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION xml_extract(pi_xml   IN XMLTYPE
                    ,pi_xpath IN VARCHAR2
                    ,pi_xmlns IN VARCHAR2 default NULL)
  RETURN VARCHAR2 IS
  --
BEGIN
  --
  RETURN CASE WHEN pi_xml.extract(pi_xpath,pi_xmlns) IS NOT NULL
              THEN pi_xml.extract(pi_xpath,pi_xmlns).getstringval()
              ELSE NULL
         END;
END xml_extract;
--
-----------------------------------------------------------------------------
--
FUNCTION valid_xml(pi_xml     IN XMLType
                  ,pi_xsd_uri IN VARCHAR2)
  RETURN BOOLEAN IS
  --
  lv_xml    XMLType;
  --
BEGIN
  /*
  ||Associate The Given Schema
  ||With The XMLType Object.
  */
  lv_xml := pi_xml.createSchemaBasedXML(pi_xsd_uri);
  /*
  ||Validate The XMLType Object
  ||Against The Schema.
  */
  xmltype.schemaValidate(lv_xml);
  /*
  ||No Errors Occured So Return TRUE.
  */
  RETURN TRUE;
  --
EXCEPTION
  WHEN others
   THEN
      raise_application_error(-20000,'Invalid Input XML Supplied: '||SQLERRM);
      --RETURN FALSE;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION escape_xml(pi_data IN VARCHAR2)
  RETURN VARCHAR2 IS
BEGIN
  --
  RETURN dbms_xmlgen.convert(pi_data);
  --
END escape_xml;
--
-----------------------------------------------------------------------------
--
FUNCTION build_error_xml(pi_wrapper IN VARCHAR2 DEFAULT NULL
                        ,pi_sqlerrm IN VARCHAR2)
  RETURN xmltype IS
  --
  lv_retval xmltype;
  --
BEGIN
  IF pi_wrapper IS NOT NULL
   THEN
      lv_retval := xmltype('<'||pi_wrapper||' '||c_xmlns||'><error>'||escape_xml(pi_sqlerrm)||'</error></'||pi_wrapper||'>');
  ELSE
      lv_retval := xmltype('<error>'||escape_xml(pi_sqlerrm)||'</error>');
  END IF;
  --
  RETURN lv_retval;
  --
END;
--
-----------------------------------------------------------------------------
--
FUNCTION date_to_varchar(pi_date_in DATE)
  RETURN VARCHAR2 IS
  --
  lv_retval VARCHAR2(100);
  --
BEGIN
  --
  IF pi_date_in IS NOT NULL
   THEN
      lv_retval := to_char(pi_date_in,'DD-MON-YYYY');
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RAISE date_format_error;
END date_to_varchar;
--
-----------------------------------------------------------------------------
--
FUNCTION datetime_to_varchar(pi_date_in DATE)
  RETURN VARCHAR2 IS
  --
  lv_retval VARCHAR2(100);
  --
BEGIN
  --
  IF pi_date_in IS NOT NULL
   THEN
      lv_retval := to_char(pi_date_in,'DD-MON-YYYY HH24:MI:SS');
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RAISE date_format_error;
END datetime_to_varchar;
--
-----------------------------------------------------------------------------
--
FUNCTION varchar_to_date(pi_date_in VARCHAR2)
  RETURN DATE IS
  --
  lv_retval DATE;
  --
BEGIN
  --
  IF pi_date_in IS NULL
   THEN
      RAISE date_format_error;
  END IF;
  --
  lv_retval := to_date(pi_date_in,'DD-MON-YYYY');
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RAISE date_format_error;
END varchar_to_date;
--
-----------------------------------------------------------------------------
--
FUNCTION varchar_to_datetime(pi_date_in VARCHAR2)
  RETURN DATE IS
  --
  lv_retval DATE;
  --
BEGIN
  --
  IF pi_date_in IS NULL
   THEN
      RAISE date_format_error;
  END IF;
  --
  lv_retval := to_date(pi_date_in,'DD-MON-YYYY HH24:MI:SS');
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RAISE date_format_error;
END varchar_to_datetime;
--
-----------------------------------------------------------------------------
--
FUNCTION gen_tags(pi_indent     IN PLS_INTEGER
                 ,pi_element    IN VARCHAR2
                 ,pi_data       IN VARCHAR2
                 ,pi_linefeed   IN VARCHAR2 DEFAULT 'Y')
  RETURN varchar2 IS
  --
  lv_retval   nm3type.max_varchar2;
  lv_indent   nm3type.max_varchar2;
  lv_linefeed VARCHAR2(1) := NULL;
  --
BEGIN
  --
  IF pi_linefeed = 'Y'
   THEN
      lv_linefeed := CHR(10);
  END IF;
  --
  IF pi_data IS NOT NULL
   THEN
      --
      FOR i IN 1..pi_indent LOOP
        lv_indent := lv_indent||' ';
      END LOOP;
      --
      lv_retval := lv_linefeed||lv_indent||'<'||pi_element||'>'||escape_xml(pi_data)||'</'||pi_element||'>';
      --
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      nm_debug.debug('gen_tags element ['|| pi_element ||'] data ['|| pi_data ||'] '|| sqlerrm);
      RAISE;
END gen_tags;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sd_flags
  RETURN xmltype IS
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  --
BEGIN
  --
  lv_str := '<GetSDFlagsResponse'||c_xmlns||'><SD_Flags>'
            ||'<SD_Flag>'
              ||'<Safety_Detailed_Flag>S</Safety_Detailed_Flag>'
              ||'<Description>Safety</Description>'
            ||'</SD_Flag>'
            ||'<SD_Flag>'
              ||'<Safety_Detailed_Flag>D</Safety_Detailed_Flag>'
              ||'<Description>Detailed</Description>'
            ||'</SD_Flag>'
          ||'</SD_Flags></GetSDFlagsResponse>'
          ;
  --
  lv_retval := xmltype(lv_str);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_sqlerrm => SQLERRM);
END get_sd_flags;
--
-----------------------------------------------------------------------------
--
FUNCTION get_users
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hus_user_id    hig_users.hus_user_id%TYPE
                           ,hus_initials   hig_users.hus_initials%TYPE
                           ,hus_name       hig_users.hus_name%TYPE
                           ,hus_admin_unit hig_users.hus_admin_unit%TYPE
                           ,hus_start_date hig_users.hus_start_date%TYPE
                           ,hus_end_date   hig_users.hus_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetUsersResponse '||c_xmlns||'><Users>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT hus_user_id
        ,hus_initials
        ,hus_name
        ,hus_admin_unit
        ,hus_start_date
        ,hus_end_date
    BULK COLLECT
    INTO lt_retval
    FROM hig_users
   WHERE hus_admin_unit IS NOT NULL
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<User>'
                      ||'<User_Id>'||lt_retval(i).hus_user_id||'</User_Id>'
                      ||'<Initials>'||escape_xml(lt_retval(i).hus_initials)||'</Initials>'
                      ||'<User_Name>'||escape_xml(lt_retval(i).hus_name)||'</User_Name>'
                      ||'<Admin_Unit_Id>'||lt_retval(i).hus_admin_unit||'</Admin_Unit_Id>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hus_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hus_end_date)||'</Enddate>'
                    ||'</User>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Users></GetUsersResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetUsersResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_users;
--
-----------------------------------------------------------------------------
--
FUNCTION get_admin_units
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hau_admin_unit     hig_admin_units.hau_admin_unit%TYPE
                           ,hau_unit_code      hig_admin_units.hau_unit_code%TYPE
                           ,hau_name           hig_admin_units.hau_name%TYPE
                           ,hau_authority_code hig_admin_units.hau_authority_code%TYPE
                           ,hau_start_date     hig_admin_units.hau_start_date%TYPE
                           ,hau_end_date       hig_admin_units.hau_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetAdminUnitsResponse'||c_xmlns||'><Admin_Units>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT hau_admin_unit
        ,hau_unit_code
        ,hau_name
        ,hau_authority_code
        ,hau_start_date
        ,hau_end_date
    BULK COLLECT
    INTO lt_retval
    FROM hig_admin_units
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Admin_Unit>'
                      ||'<Admin_Unit_Id>'||TO_CHAR(lt_retval(i).hau_admin_unit)||'</Admin_Unit_Id>'
                      ||'<Admin_Unit_Code>'||escape_xml(lt_retval(i).hau_unit_code)||'</Admin_Unit_Code>'
                      ||'<Admin_Unit_Name>'||escape_xml(lt_retval(i).hau_name)||'</Admin_Unit_Name>'
                      ||'<Authority_Code>'||escape_xml(lt_retval(i).hau_authority_code)||'</Authority_Code>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hau_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hau_end_date)||'</Enddate>'
                    ||'</Admin_Unit>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Admin_Units></GetAdminUnitsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAdminUnitsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_admin_units;
--
-----------------------------------------------------------------------------
--
FUNCTION get_admin_groups
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hag_parent_admin_unit  hig_admin_groups.hag_parent_admin_unit%TYPE
                           ,hag_child_admin_unit   hig_admin_groups.hag_child_admin_unit%TYPE
                           ,hag_direct_link        hig_admin_groups.hag_direct_link%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetAdminGroupsResponse'||c_xmlns||'><Admin_Groups>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT hag_parent_admin_unit
        ,hag_child_admin_unit
        ,hag_direct_link
    BULK COLLECT
    INTO lt_retval
    FROM hig_admin_groups
   WHERE hag_parent_admin_unit IN(SELECT hau_admin_unit
                                    FROM hig_admin_units)
     AND hag_child_admin_unit IN (SELECT hau_admin_unit
                                    FROM hig_admin_units)
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Admin_Group>'
                      ||'<Parent_Admin_Unit_Id>'||TO_CHAR(lt_retval(i).hag_parent_admin_unit)||'</Parent_Admin_Unit_Id>'
                      ||'<Child_Admin_Unit_Id>'||TO_CHAR(lt_retval(i).hag_child_admin_unit)||'</Child_Admin_Unit_Id>'
                      ||'<Direct_Link>'||escape_xml(lt_retval(i).hag_direct_link)||'</Direct_Link>'
                    ||'</Admin_Group>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Admin_Groups></GetAdminGroupsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAdminGroupsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_admin_groups;
--
-----------------------------------------------------------------------------
--
FUNCTION get_road_sections
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(rse_he_id      road_sections.rse_he_id      %TYPE
                           ,rse_unique     road_sections.rse_unique     %TYPE
                           ,rse_descr      road_sections.rse_descr      %TYPE
                           ,rse_admin_unit road_sections.rse_admin_unit %TYPE
                           ,rse_length     road_sections.rse_length     %TYPE
                           ,rse_sys_flag   road_sections.rse_sys_flag   %TYPE
                           ,rse_start_date road_sections.rse_start_date %TYPE
                           ,rse_end_date   road_sections.rse_end_date   %TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetRoadSectionsResponse'||c_xmlns||'><Road_Sections>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT rse_he_id
        ,rse_unique
        ,rse_descr
        ,rse_admin_unit
        ,rse_length
        ,rse_sys_flag
        ,rse_start_date
        ,rse_end_date
    BULK COLLECT
    INTO lt_retval
    FROM road_sections_all
   WHERE rse_sys_flag in ('L','D')
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Road_Section>'
                      ||'<Section_Id>'||lt_retval(i).rse_he_id||'</Section_Id>'
                      ||'<Section_Unique>'||escape_xml(lt_retval(i).rse_unique)||'</Section_Unique>'
                      ||'<Description>'||escape_xml(lt_retval(i).rse_descr)||'</Description>'
                      ||'<Admin_Unit_Id>'||lt_retval(i).rse_admin_unit||'</Admin_Unit_Id>'
                      ||'<Length>'||lt_retval(i).rse_length||'</Length>'
                      ||'<Sys_Flag>'||lt_retval(i).rse_sys_flag||'</Sys_Flag>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).rse_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).rse_end_date)||'</Enddate>'
                    ||'</Road_Section>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Road_Sections></GetRoadSectionsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetRoadSectionsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_road_sections;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_types
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(nit_inv_type    nm_inv_types_all.nit_inv_type%TYPE
                           ,nit_descr       nm_inv_types_all.nit_descr%TYPE
                           ,ity_sys_flag    inv_type_translations.ity_sys_flag%TYPE
                           ,nit_screen_seq  nm_inv_types_all.nit_screen_seq%TYPE
                           ,nit_start_date  nm_inv_types_all.nit_start_date%TYPE
                           ,nit_end_date    nm_inv_types_all.nit_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetAssetTypesResponse'||c_xmlns||'><Asset_Types>';
  --
BEGIN
  --
  SELECT nit.nit_inv_type
        ,nit.nit_descr
        ,itt.ity_sys_flag
        ,NVL(nit.nit_screen_seq,999)
        ,nit.nit_start_date
        ,nit.nit_end_date
    BULK COLLECT
    INTO lt_retval
    FROM nm_inv_types_all nit
        ,inv_type_translations itt
   WHERE itt.nit_inv_type = nit.nit_inv_type
       ;

  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Asset_Type>'
                      ||'<Asset_Type_Code>'||escape_xml(lt_retval(i).nit_inv_type)||'</Asset_Type_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).nit_descr)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).ity_sys_flag||'</Sys_Flag>'
                      ||'<Display_Sequence>'||lt_retval(i).nit_screen_seq||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).nit_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).nit_end_date)||'</Enddate>'
                    ||'</Asset_Type>'
                    ;
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Asset_Types></GetAssetTypesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAssetTypesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_asset_types;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_type_attribs
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(ita_inv_type     nm_inv_type_attribs_all.ita_inv_type   %TYPE
                           ,ita_scrn_text    nm_inv_type_attribs_all.ita_scrn_text  %TYPE
                           ,ita_attrib_name  nm_inv_type_attribs_all.ita_attrib_name%TYPE
                           ,ita_format       nm_inv_type_attribs_all.ita_format     %TYPE
                           ,ita_disp_seq_no  nm_inv_type_attribs_all.ita_disp_seq_no%TYPE
                           ,ita_start_date   nm_inv_type_attribs_all.ita_start_date %TYPE
                           ,ita_end_date     nm_inv_type_attribs_all.ita_end_date   %TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetAssetTypeAttribsResponse'||c_xmlns||'><Asset_Attributes>';
  --
BEGIN
  --
  SELECT ita_inv_type
        ,ita_scrn_text
        ,ita_attrib_name
        ,ita_format
        ,ita_disp_seq_no
        ,ita_start_date
        ,ita_end_date
    BULK COLLECT
    INTO lt_retval
    FROM nm_inv_type_attribs_all
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Asset_Attribute>'
                      ||'<Asset_Type_Code>'||escape_xml(lt_retval(i).ita_inv_type)||'</Asset_Type_Code>'
                      ||'<Attribute_Name>'||escape_xml(lt_retval(i).ita_scrn_text)||'</Attribute_Name>'
                      ||'<Asset_Column>'||escape_xml(lt_retval(i).ita_attrib_name)||'</Asset_Column>'
                      ||'<Datatype>'||escape_xml(lt_retval(i).ita_format)||'</Datatype>'
                      ||'<Display_Sequence>'||lt_retval(i).ita_disp_seq_no||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).ita_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).ita_end_date)||'</Enddate>'
                    ||'</Asset_Attribute>'
                    ;
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Asset_Attributes></GetAssetTypeAttribsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAssetTypeAttribsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_asset_type_attribs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_ids(pi_xml IN XMLTYPE)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Asset_Type_Code',cp_xmlns) asset_type
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  lv_asset_type nm_inv_types_all.nit_inv_type%TYPE;
  --
  TYPE retval_tab IS TABLE OF nm_inv_items_all.iit_ne_id%TYPE;
  lt_retval retval_tab;
  lv_retval XMLTYPE;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetAssetIDsResponse'||c_xmlns||'><Assets>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 50;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetAssetIDs/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_asset_type := lr_params.asset_type;
      --
      SELECT iit_ne_id
        BULK COLLECT
        INTO lt_retval
        FROM nm_inv_items_all
       WHERE iit_inv_type = lv_asset_type
           ;
      --
      IF lt_retval.count = 0
       THEN
          raise no_data_found;
      END IF;
      --
      FOR i IN 1..lt_retval.count LOOP
        --
        lv_str := lv_str||'<Id>'||TO_CHAR(lt_retval(i))||'</Id>';
        --
        IF length(lv_str) > lv_max_size
         THEN
            lv_clob := lv_clob||lv_str;
            lv_str := NULL;
        END IF;
        --
      END LOOP;
      --
      lv_clob := lv_clob||lv_str||'</Assets></GetAssetIDsResponse>';
      --
      lv_retval := xmltype(lv_clob);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAssetIDsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_asset_ids;
--
-----------------------------------------------------------------------------
--
FUNCTION get_modified_asset_ids(pi_xml IN XMLTYPE)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Asset_Type_Code',cp_xmlns) asset_type
        ,EXTRACTVALUE(cp_xml,cp_root||'Modified_Date',cp_xmlns) modified_date
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  lv_asset_type  nm_inv_types_all.nit_inv_type%TYPE;
  --
  TYPE retval_tab IS TABLE OF nm_inv_items_all.iit_ne_id%TYPE;
  --
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetModifiedAssetIDsResponse'||c_xmlns||'><Assets>';
  lv_mod_date DATE;
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 50;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  nm_debug.debug('Getting params');
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetModifiedAssetIDs/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      nm_debug.debug('Asset Type = '||lr_params.asset_type);
      nm_debug.debug('Date = '||lr_params.modified_date);
      lv_asset_type := lr_params.asset_type;
      lv_mod_date := varchar_to_date(lr_params.modified_date);
      --
      SELECT iit_ne_id
        BULK COLLECT
        INTO lt_retval
        FROM nm_inv_items_all
       WHERE iit_inv_type = lv_asset_type
         AND iit_date_modified >= lv_mod_date
           ;
      --
      IF lt_retval.count = 0
       THEN
          raise no_data_found;
      END IF;
      --
      FOR i IN 1..lt_retval.count LOOP
        --
        lv_str := lv_str||'<Id>'||TO_CHAR(lt_retval(i))||'</Id>';
        --
        IF length(lv_str) > lv_max_size
         THEN
            lv_clob := lv_clob||lv_str;
            lv_str := NULL;
        END IF;
        --
      END LOOP;
      --
      lv_clob := lv_clob||lv_str||'</Assets></GetModifiedAssetIDsResponse>';
      --
      lv_retval := xmltype(lv_clob);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetModifiedAssetIDsResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetModifiedAssetIDsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_modified_asset_ids;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_details(pi_xml IN XMLTYPE)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Id',cp_xmlns) asset_id
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  lv_asset_id  nm_inv_items_all.iit_ne_id%TYPE;
  --
  lr_retval nm_inv_items_all%ROWTYPE;
  lv_str    CLOB;
  lv_retval XMLType;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  --
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetAssetDetails/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_asset_id := lr_params.asset_id;
      --
      SELECT *
        INTO lr_retval
        FROM nm_inv_items_all
       WHERE iit_ne_id = lv_asset_id
           ;
      --
      lv_str := lv_str||'<GetAssetDetailsResponse'||c_xmlns||'><AssetDetails>'
                      ||gen_tags(4,'iit_ne_id',TO_CHAR(lr_retval.iit_ne_id))
                      ||gen_tags(4,'iit_inv_type',TO_CHAR(lr_retval.iit_inv_type))
                      ||gen_tags(4,'iit_primary_key',lr_retval.iit_primary_key)
                      ||gen_tags(4,'iit_start_date',date_to_varchar(lr_retval.iit_start_date))
                      ||gen_tags(4,'iit_date_created',datetime_to_varchar(lr_retval.iit_date_created))
                      ||gen_tags(4,'iit_date_modified',datetime_to_varchar(lr_retval.iit_date_modified))
                      ||gen_tags(4,'iit_created_by',lr_retval.iit_created_by)
                      ||gen_tags(4,'iit_modified_by',lr_retval.iit_modified_by)
                      ||gen_tags(4,'iit_admin_unit',TO_CHAR(lr_retval.iit_admin_unit))
                      ||gen_tags(4,'iit_descr',lr_retval.iit_descr)
                      ||gen_tags(4,'iit_end_date',date_to_varchar(lr_retval.iit_end_date))
                      ||gen_tags(4,'iit_foreign_key',lr_retval.iit_foreign_key)
                      ||gen_tags(4,'iit_located_by',TO_CHAR(lr_retval.iit_located_by))
                      ||gen_tags(4,'iit_position',TO_CHAR(lr_retval.iit_position))
                      ||gen_tags(4,'iit_x_coord',TO_CHAR(lr_retval.iit_x_coord))
                      ||gen_tags(4,'iit_y_coord',TO_CHAR(lr_retval.iit_y_coord))
                      ||gen_tags(4,'iit_num_attrib16',TO_CHAR(lr_retval.iit_num_attrib16))
                      ||gen_tags(4,'iit_num_attrib17',TO_CHAR(lr_retval.iit_num_attrib17))
                      ||gen_tags(4,'iit_num_attrib18',TO_CHAR(lr_retval.iit_num_attrib18))
                      ||gen_tags(4,'iit_num_attrib19',TO_CHAR(lr_retval.iit_num_attrib19))
                      ||gen_tags(4,'iit_num_attrib20',TO_CHAR(lr_retval.iit_num_attrib20))
                      ||gen_tags(4,'iit_num_attrib21',TO_CHAR(lr_retval.iit_num_attrib21))
                      ||gen_tags(4,'iit_num_attrib22',TO_CHAR(lr_retval.iit_num_attrib22))
                      ||gen_tags(4,'iit_num_attrib23',TO_CHAR(lr_retval.iit_num_attrib23))
                      ||gen_tags(4,'iit_num_attrib24',TO_CHAR(lr_retval.iit_num_attrib24))
                      ||gen_tags(4,'iit_num_attrib25',TO_CHAR(lr_retval.iit_num_attrib25))
                      ||gen_tags(4,'iit_chr_attrib26',lr_retval.iit_chr_attrib26)
                      ||gen_tags(4,'iit_chr_attrib27',lr_retval.iit_chr_attrib27)
                      ||gen_tags(4,'iit_chr_attrib28',lr_retval.iit_chr_attrib28)
                      ||gen_tags(4,'iit_chr_attrib29',lr_retval.iit_chr_attrib29)
                      ||gen_tags(4,'iit_chr_attrib30',lr_retval.iit_chr_attrib30)
                      ||gen_tags(4,'iit_chr_attrib31',lr_retval.iit_chr_attrib31)
                      ||gen_tags(4,'iit_chr_attrib32',lr_retval.iit_chr_attrib32)
                      ||gen_tags(4,'iit_chr_attrib33',lr_retval.iit_chr_attrib33)
                      ||gen_tags(4,'iit_chr_attrib34',lr_retval.iit_chr_attrib34)
                      ||gen_tags(4,'iit_chr_attrib35',lr_retval.iit_chr_attrib35)
                      ||gen_tags(4,'iit_chr_attrib36',lr_retval.iit_chr_attrib36)
                      ||gen_tags(4,'iit_chr_attrib37',lr_retval.iit_chr_attrib37)
                      ||gen_tags(4,'iit_chr_attrib38',lr_retval.iit_chr_attrib38)
                      ||gen_tags(4,'iit_chr_attrib39',lr_retval.iit_chr_attrib39)
                      ||gen_tags(4,'iit_chr_attrib40',lr_retval.iit_chr_attrib40)
                      ||gen_tags(4,'iit_chr_attrib41',lr_retval.iit_chr_attrib41)
                      ||gen_tags(4,'iit_chr_attrib42',lr_retval.iit_chr_attrib42)
                      ||gen_tags(4,'iit_chr_attrib43',lr_retval.iit_chr_attrib43)
                      ||gen_tags(4,'iit_chr_attrib44',lr_retval.iit_chr_attrib44)
                      ||gen_tags(4,'iit_chr_attrib45',lr_retval.iit_chr_attrib45)
                      ||gen_tags(4,'iit_chr_attrib46',lr_retval.iit_chr_attrib46)
                      ||gen_tags(4,'iit_chr_attrib47',lr_retval.iit_chr_attrib47)
                      ||gen_tags(4,'iit_chr_attrib48',lr_retval.iit_chr_attrib48)
                      ||gen_tags(4,'iit_chr_attrib49',lr_retval.iit_chr_attrib49)
                      ||gen_tags(4,'iit_chr_attrib50',lr_retval.iit_chr_attrib50)
                      ||gen_tags(4,'iit_chr_attrib51',lr_retval.iit_chr_attrib51)
                      ||gen_tags(4,'iit_chr_attrib52',lr_retval.iit_chr_attrib52)
                      ||gen_tags(4,'iit_chr_attrib53',lr_retval.iit_chr_attrib53)
                      ||gen_tags(4,'iit_chr_attrib54',lr_retval.iit_chr_attrib54)
                      ||gen_tags(4,'iit_chr_attrib55',lr_retval.iit_chr_attrib55)
                      ||gen_tags(4,'iit_chr_attrib56',lr_retval.iit_chr_attrib56)
                      ||gen_tags(4,'iit_chr_attrib57',lr_retval.iit_chr_attrib57)
                      ||gen_tags(4,'iit_chr_attrib58',lr_retval.iit_chr_attrib58)
                      ||gen_tags(4,'iit_chr_attrib59',lr_retval.iit_chr_attrib59)
                      ||gen_tags(4,'iit_chr_attrib60',lr_retval.iit_chr_attrib60)
                      ||gen_tags(4,'iit_chr_attrib61',lr_retval.iit_chr_attrib61)
                      ||gen_tags(4,'iit_chr_attrib62',lr_retval.iit_chr_attrib62)
                      ||gen_tags(4,'iit_chr_attrib63',lr_retval.iit_chr_attrib63)
                      ||gen_tags(4,'iit_chr_attrib64',lr_retval.iit_chr_attrib64)
                      ||gen_tags(4,'iit_chr_attrib65',lr_retval.iit_chr_attrib65)
                      ||gen_tags(4,'iit_chr_attrib66',lr_retval.iit_chr_attrib66)
                      ||gen_tags(4,'iit_chr_attrib67',lr_retval.iit_chr_attrib67)
                      ||gen_tags(4,'iit_chr_attrib68',lr_retval.iit_chr_attrib68)
                      ||gen_tags(4,'iit_chr_attrib69',lr_retval.iit_chr_attrib69)
                      ||gen_tags(4,'iit_chr_attrib70',lr_retval.iit_chr_attrib70)
                      ||gen_tags(4,'iit_chr_attrib71',lr_retval.iit_chr_attrib71)
                      ||gen_tags(4,'iit_chr_attrib72',lr_retval.iit_chr_attrib72)
                      ||gen_tags(4,'iit_chr_attrib73',lr_retval.iit_chr_attrib73)
                      ||gen_tags(4,'iit_chr_attrib74',lr_retval.iit_chr_attrib74)
                      ||gen_tags(4,'iit_chr_attrib75',lr_retval.iit_chr_attrib75)
                      ||gen_tags(4,'iit_num_attrib76',TO_CHAR(lr_retval.iit_num_attrib76))
                      ||gen_tags(4,'iit_num_attrib77',TO_CHAR(lr_retval.iit_num_attrib77))
                      ||gen_tags(4,'iit_num_attrib78',TO_CHAR(lr_retval.iit_num_attrib78))
                      ||gen_tags(4,'iit_num_attrib79',TO_CHAR(lr_retval.iit_num_attrib79))
                      ||gen_tags(4,'iit_num_attrib80',TO_CHAR(lr_retval.iit_num_attrib80))
                      ||gen_tags(4,'iit_num_attrib81',TO_CHAR(lr_retval.iit_num_attrib81))
                      ||gen_tags(4,'iit_num_attrib82',TO_CHAR(lr_retval.iit_num_attrib82))
                      ||gen_tags(4,'iit_num_attrib83',TO_CHAR(lr_retval.iit_num_attrib83))
                      ||gen_tags(4,'iit_num_attrib84',TO_CHAR(lr_retval.iit_num_attrib84))
                      ||gen_tags(4,'iit_num_attrib85',TO_CHAR(lr_retval.iit_num_attrib85))
                      ||gen_tags(4,'iit_date_attrib86',datetime_to_varchar(lr_retval.iit_date_attrib86))
                      ||gen_tags(4,'iit_date_attrib87',datetime_to_varchar(lr_retval.iit_date_attrib87))
                      ||gen_tags(4,'iit_date_attrib88',datetime_to_varchar(lr_retval.iit_date_attrib88))
                      ||gen_tags(4,'iit_date_attrib89',datetime_to_varchar(lr_retval.iit_date_attrib89))
                      ||gen_tags(4,'iit_date_attrib90',datetime_to_varchar(lr_retval.iit_date_attrib90))
                      ||gen_tags(4,'iit_date_attrib91',datetime_to_varchar(lr_retval.iit_date_attrib91))
                      ||gen_tags(4,'iit_date_attrib92',datetime_to_varchar(lr_retval.iit_date_attrib92))
                      ||gen_tags(4,'iit_date_attrib93',datetime_to_varchar(lr_retval.iit_date_attrib93))
                      ||gen_tags(4,'iit_date_attrib94',datetime_to_varchar(lr_retval.iit_date_attrib94))
                      ||gen_tags(4,'iit_date_attrib95',datetime_to_varchar(lr_retval.iit_date_attrib95))
                      ||gen_tags(4,'iit_angle',TO_CHAR(lr_retval.iit_angle))
                      ||gen_tags(4,'iit_angle_txt',lr_retval.iit_angle_txt)
                      ||gen_tags(4,'iit_class',lr_retval.iit_class)
                      ||gen_tags(4,'iit_class_txt',lr_retval.iit_class_txt)
                      ||gen_tags(4,'iit_colour',lr_retval.iit_colour)
                      ||gen_tags(4,'iit_colour_txt',lr_retval.iit_colour_txt)
                      ||gen_tags(4,'iit_coord_flag',lr_retval.iit_coord_flag)
                      ||gen_tags(4,'iit_description',lr_retval.iit_description)
                      ||gen_tags(4,'iit_diagram',lr_retval.iit_diagram)
                      ||gen_tags(4,'iit_distance',TO_CHAR(lr_retval.iit_distance))
                      ||gen_tags(4,'iit_end_chain',TO_CHAR(lr_retval.iit_end_chain))
                      ||gen_tags(4,'iit_gap',TO_CHAR(lr_retval.iit_gap))
                      ||gen_tags(4,'iit_height',TO_CHAR(lr_retval.iit_height))
                      ||gen_tags(4,'iit_height_2',TO_CHAR(lr_retval.iit_height_2))
                      ||gen_tags(4,'iit_id_code',lr_retval.iit_id_code)
                      ||gen_tags(4,'iit_instal_date',datetime_to_varchar(lr_retval.iit_instal_date))
                      ||gen_tags(4,'iit_invent_date',datetime_to_varchar(lr_retval.iit_invent_date))
                      ||gen_tags(4,'iit_inv_ownership',lr_retval.iit_inv_ownership)
                      ||gen_tags(4,'iit_itemcode',lr_retval.iit_itemcode)
                      ||gen_tags(4,'iit_lco_lamp_config_id',TO_CHAR(lr_retval.iit_lco_lamp_config_id))
                      ||gen_tags(4,'iit_length',TO_CHAR(lr_retval.iit_length))
                      ||gen_tags(4,'iit_material',lr_retval.iit_material)
                      ||gen_tags(4,'iit_material_txt',lr_retval.iit_material_txt)
                      ||gen_tags(4,'iit_method',lr_retval.iit_method)
                      ||gen_tags(4,'iit_method_txt',lr_retval.iit_method_txt)
                      ||gen_tags(4,'iit_note',lr_retval.iit_note)
                      ||gen_tags(4,'iit_no_of_units',TO_CHAR(lr_retval.iit_no_of_units))
                      ||gen_tags(4,'iit_options',lr_retval.iit_options)
                      ||gen_tags(4,'iit_options_txt',lr_retval.iit_options_txt)
                      ||gen_tags(4,'iit_oun_org_id_elec_board',TO_CHAR(lr_retval.iit_oun_org_id_elec_board))
                      ||gen_tags(4,'iit_owner',lr_retval.iit_owner)
                      ||gen_tags(4,'iit_owner_txt',lr_retval.iit_owner_txt)
                      ||gen_tags(4,'iit_peo_invent_by_id',TO_CHAR(lr_retval.iit_peo_invent_by_id))
                      ||gen_tags(4,'iit_photo',lr_retval.iit_photo)
                      ||gen_tags(4,'iit_power',TO_CHAR(lr_retval.iit_power))
                      ||gen_tags(4,'iit_prov_flag',lr_retval.iit_prov_flag)
                      ||gen_tags(4,'iit_rev_by',lr_retval.iit_rev_by)
                      ||gen_tags(4,'iit_rev_date',datetime_to_varchar(lr_retval.iit_rev_date))
                      ||gen_tags(4,'iit_type',lr_retval.iit_type)
                      ||gen_tags(4,'iit_type_txt',lr_retval.iit_type_txt)
                      ||gen_tags(4,'iit_width',TO_CHAR(lr_retval.iit_width))
                      ||gen_tags(4,'iit_xtra_char_1',lr_retval.iit_xtra_char_1)
                      ||gen_tags(4,'iit_xtra_date_1',datetime_to_varchar(lr_retval.iit_xtra_date_1))
                      ||gen_tags(4,'iit_xtra_domain_1',lr_retval.iit_xtra_domain_1)
                      ||gen_tags(4,'iit_xtra_domain_txt_1',lr_retval.iit_xtra_domain_txt_1)
                      ||gen_tags(4,'iit_xtra_number_1',TO_CHAR(lr_retval.iit_xtra_number_1))
                      ||gen_tags(4,'iit_x_sect',lr_retval.iit_x_sect)
                      ||gen_tags(4,'iit_det_xsp',lr_retval.iit_det_xsp)
                      ||gen_tags(4,'iit_offset',TO_CHAR(lr_retval.iit_offset))
                      ||gen_tags(4,'iit_x',TO_CHAR(lr_retval.iit_x))
                      ||gen_tags(4,'iit_y',TO_CHAR(lr_retval.iit_y))
                      ||gen_tags(4,'iit_z',TO_CHAR(lr_retval.iit_z))
                      ||gen_tags(4,'iit_num_attrib96',TO_CHAR(lr_retval.iit_num_attrib96))
                      ||gen_tags(4,'iit_num_attrib97',TO_CHAR(lr_retval.iit_num_attrib97))
                      ||gen_tags(4,'iit_num_attrib98',TO_CHAR(lr_retval.iit_num_attrib98))
                      ||gen_tags(4,'iit_num_attrib99',TO_CHAR(lr_retval.iit_num_attrib99))
                      ||gen_tags(4,'iit_num_attrib100',TO_CHAR(lr_retval.iit_num_attrib100))
                      ||gen_tags(4,'iit_num_attrib101',TO_CHAR(lr_retval.iit_num_attrib101))
                      ||gen_tags(4,'iit_num_attrib102',TO_CHAR(lr_retval.iit_num_attrib102))
                      ||gen_tags(4,'iit_num_attrib103',TO_CHAR(lr_retval.iit_num_attrib103))
                      ||gen_tags(4,'iit_num_attrib104',TO_CHAR(lr_retval.iit_num_attrib104))
                      ||gen_tags(4,'iit_num_attrib105',TO_CHAR(lr_retval.iit_num_attrib105))
                      ||gen_tags(4,'iit_num_attrib106',TO_CHAR(lr_retval.iit_num_attrib106))
                      ||gen_tags(4,'iit_num_attrib107',TO_CHAR(lr_retval.iit_num_attrib107))
                      ||gen_tags(4,'iit_num_attrib108',TO_CHAR(lr_retval.iit_num_attrib108))
                      ||gen_tags(4,'iit_num_attrib109',TO_CHAR(lr_retval.iit_num_attrib109))
                      ||gen_tags(4,'iit_num_attrib110',TO_CHAR(lr_retval.iit_num_attrib110))
                      ||gen_tags(4,'iit_num_attrib111',TO_CHAR(lr_retval.iit_num_attrib111))
                      ||gen_tags(4,'iit_num_attrib112',TO_CHAR(lr_retval.iit_num_attrib112))
                      ||gen_tags(4,'iit_num_attrib113',TO_CHAR(lr_retval.iit_num_attrib113))
                      ||gen_tags(4,'iit_num_attrib114',TO_CHAR(lr_retval.iit_num_attrib114))
                      ||gen_tags(4,'iit_num_attrib115',TO_CHAR(lr_retval.iit_num_attrib115))
                      ||CHR(10)||'  </AssetDetails></GetAssetDetailsResponse>';
      --
      lv_retval := xmltype(lv_str);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAssetDetailsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_asset_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_initiation_types
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hco_code       hig_codes.hco_code%TYPE
                           ,hco_meaning    hig_codes.hco_meaning%TYPE
                           ,hco_seq        hig_codes.hco_seq%TYPE
                           ,hco_start_date hig_codes.hco_start_date%TYPE
                           ,hco_end_date   hig_codes.hco_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetInitiationTypesResponse'||c_xmlns||'><Initiation_Types>';
  --
BEGIN
  --
  SELECT hco_code
        ,hco_meaning
        ,NVL(hco_seq,9999)
        ,hco_start_date
        ,hco_end_date
    BULK COLLECT
    INTO lt_retval
    FROM hig_codes
   WHERE hco_domain = 'INITIATION_TYPE'
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Initiation_Type>'
                      ||'<Initiation_Code>'||escape_xml(lt_retval(i).hco_code)||'</Initiation_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Display_Sequence>'||lt_retval(i).hco_seq||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hco_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hco_end_date)||'</Enddate>'
                    ||'</Initiation_Type>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Initiation_Types></GetInitiationTypesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetInitiationTypesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_initiation_types;
--
-----------------------------------------------------------------------------
--
FUNCTION get_repair_types
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hco_code       hig_codes.hco_code%TYPE
                           ,hco_meaning    hig_codes.hco_meaning%TYPE
                           ,hco_seq        hig_codes.hco_seq%TYPE
                           ,hco_start_date hig_codes.hco_start_date%TYPE
                           ,hco_end_date   hig_codes.hco_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetRepairTypesResponse'||c_xmlns||'><Repair_Types>';
  --
BEGIN
  --
  SELECT hco_code
        ,hco_meaning
        ,NVL(hco_seq,9999)
        ,hco_start_date
        ,hco_end_date
    BULK COLLECT
    INTO lt_retval
    FROM hig_codes
   WHERE hco_domain = 'REPAIR_TYPE'
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Repair_Type>'
                      ||'<Repair_Type_Code>'||escape_xml(lt_retval(i).hco_code)||'</Repair_Type_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Display_Sequence>'||TO_CHAR(lt_retval(i).hco_seq)||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hco_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hco_end_date)||'</Enddate>'
                    ||'</Repair_Type>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Repair_Types></GetRepairTypesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetRepairTypesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_repair_types;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nw_activities
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(atv_acty_area_code  activities.atv_acty_area_code%TYPE
                           ,atv_descr           activities.atv_descr%TYPE
                           ,atv_dtp_flag        activities.atv_dtp_flag%TYPE
                           ,atv_maint_insp_flag activities.atv_maint_insp_flag%TYPE
                           ,atv_sequence_no     activities.atv_sequence_no%TYPE
                           ,atv_start_date      activities.atv_start_date%TYPE
                           ,atv_end_date        activities.atv_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetNWActivitiesResponse'||c_xmlns||'><NWActivities>';
  --
BEGIN
  --
  SELECT atv_acty_area_code
        ,atv_descr
        ,atv_dtp_flag
        ,atv_maint_insp_flag
        ,NVL(atv_sequence_no,9999)
        ,atv_start_date
        ,atv_end_date
    BULK COLLECT
    INTO lt_retval
    FROM activities
   WHERE atv_maint_insp_flag IN('S','D')
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<NWActivity>'
                      ||'<Activity_Code>'||escape_xml(lt_retval(i).atv_acty_area_code)||'</Activity_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).atv_descr)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).atv_dtp_flag||'</Sys_Flag>'
                      ||'<Safety_Detailed_Flag>'||escape_xml(lt_retval(i).atv_maint_insp_flag)||'</Safety_Detailed_Flag>'
                      ||'<Display_Sequence>'||lt_retval(i).atv_sequence_no||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).atv_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).atv_end_date)||'</Enddate>'
                    ||'</NWActivity>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</NWActivities></GetNWActivitiesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetNWActivitiesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_nw_activities;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_activities
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(mia_atv_acty_area_code  mai_inv_activities.mia_atv_acty_area_code%TYPE
                           ,atv_descr               activities.atv_descr%TYPE
                           ,mia_nit_inv_type        mai_inv_activities.mia_nit_inv_type%TYPE
                           ,atv_dtp_flag            activities.atv_dtp_flag%TYPE
                           ,atv_maint_insp_flag     activities.atv_maint_insp_flag%TYPE
                           ,atv_sequence_no         activities.atv_sequence_no%TYPE
                           ,atv_start_date          activities.atv_start_date%TYPE
                           ,atv_end_date            activities.atv_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetAssetActivitiesResponse'||c_xmlns||'><AssetActivities>';
  --
BEGIN
  --
  SELECT mia_atv_acty_area_code
        ,atv_descr
        ,mia_nit_inv_type
        ,atv_dtp_flag
        ,atv_maint_insp_flag
        ,NVL(atv_sequence_no,9999)
        ,atv_start_date
        ,atv_end_date
    BULK COLLECT
    INTO lt_retval
    FROM activities
        ,mai_inv_activities
   WHERE mia_sys_flag           = atv_dtp_flag
     AND mia_atv_acty_area_code = atv_acty_area_code
     AND atv_maint_insp_flag IN('S','D')
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<AssetActivity>'
                      ||'<Activity_Code>'||escape_xml(lt_retval(i).mia_atv_acty_area_code)||'</Activity_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).atv_descr)||'</Description>'
                      ||'<Asset_Type_Code>'||escape_xml(lt_retval(i).mia_nit_inv_type)||'</Asset_Type_Code>'
                      ||'<Sys_Flag>'||lt_retval(i).atv_dtp_flag||'</Sys_Flag>'
                      ||'<Safety_Detailed_Flag>'||lt_retval(i).atv_maint_insp_flag||'</Safety_Detailed_Flag>'
                      ||'<Display_Sequence>'||lt_retval(i).atv_sequence_no||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).atv_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).atv_end_date)||'</Enddate>'
                    ||'</AssetActivity>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</AssetActivities></GetAssetActivitiesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAssetActivitiesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_asset_activities;
--
-----------------------------------------------------------------------------
--
FUNCTION get_priorities
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(dpr_priority           defect_priorities.dpr_priority%TYPE
                           ,hco_meaning            hig_codes.hco_meaning%TYPE
                           ,dpr_atv_acty_area_code defect_priorities.dpr_atv_acty_area_code%TYPE
                           ,hco_seq                hig_codes.hco_seq%TYPE
                           ,hco_start_date         hig_codes.hco_start_date%TYPE
                           ,hco_end_date           hig_codes.hco_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetPrioritiesResponse'||c_xmlns||'><Priorities>';
  --
BEGIN
  --
  SELECT dpr_priority
        ,hco_meaning
        ,dpr_atv_acty_area_code
        ,NVL(hco_seq,9999)
        ,hco_start_date
        ,hco_end_date
    BULK COLLECT
    INTO lt_retval
    FROM defect_priorities
        ,hig_codes
   WHERE dpr_action_cat = 'P'
     AND dpr_priority   = hco_code
     AND hco_domain     = 'DEFECT_PRIORITIES'
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Priority>'
                      ||'<Priority_Code>'||escape_xml(lt_retval(i).dpr_priority)||'</Priority_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Activity_Code>'||escape_xml(lt_retval(i).dpr_atv_acty_area_code)||'</Activity_Code>'
                      ||'<Display_Sequence>'||lt_retval(i).hco_seq||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hco_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hco_end_date)||'</Enddate>'
                    ||'</Priority>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Priorities></GetPrioritiesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetPrioritiesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_priorities;
--
-----------------------------------------------------------------------------
--
FUNCTION get_treatments
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(tre_treat_code         treatments.tre_treat_code%TYPE
                           ,tre_descr              treatments.tre_descr%TYPE
                           ,dtr_sys_flag           def_treats.dtr_sys_flag%TYPE
                           ,dtr_dty_acty_area_code def_treats.dtr_dty_acty_area_code%TYPE
                           ,dtr_dty_defect_code    def_treats.dtr_dty_defect_code%TYPE
                           ,tre_sequence_no        treatments.tre_sequence_no%TYPE
                           ,tre_start_date         treatments.tre_start_date%TYPE
                           ,tre_end_date           treatments.tre_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetTreatmentsResponse'||c_xmlns||'><Treatments>';
  --
BEGIN
  --
  SELECT tre_treat_code
        ,tre_descr
        ,dtr_sys_flag
        ,dtr_dty_acty_area_code
        ,dtr_dty_defect_code
        ,NVL(tre_sequence_no,99)
        ,tre_start_date
        ,tre_end_date
    BULK COLLECT
    INTO lt_retval
    FROM def_treats
        ,treatments
   WHERE tre_treat_code = dtr_tre_treat_code
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Treatment>'
                      ||'<Treatment_Code>'||escape_xml(lt_retval(i).tre_treat_code)||'</Treatment_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).tre_descr)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).dtr_sys_flag ||'</Sys_Flag>'
                      ||'<Activity_Code>'||escape_xml(lt_retval(i).dtr_dty_acty_area_code)||'</Activity_Code>'
                      ||'<Defect_Code>'||escape_xml(lt_retval(i).dtr_dty_defect_code)||'</Defect_Code>'
                      ||'<Display_Sequence>'||to_char(lt_retval(i).tre_sequence_no)||'</Display_Sequence>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).tre_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).tre_end_date)||'</Enddate>'
                    ||'</Treatment>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Treatments></GetTreatmentsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetTreatmentsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_treatments;
--
-----------------------------------------------------------------------------
--
FUNCTION get_defect_codes
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(dty_defect_code        def_types.dty_defect_code%TYPE
                           ,dty_descr1             def_types.dty_descr1%TYPE
                           ,dty_dtp_flag           def_types.dty_dtp_flag%TYPE
                           ,dty_atv_acty_area_code def_types.dty_atv_acty_area_code%TYPE
                           ,dty_start_date         def_types.dty_start_date%TYPE
                           ,dty_end_date           def_types.dty_end_date%TYPE
                           ,dty_hh_attribute_1     def_types.dty_hh_attribute_1%TYPE
                           ,dty_hh_attri_text_1    def_types.dty_hh_attri_text_1%TYPE
                           ,dty_hh_attribute_2     def_types.dty_hh_attribute_2%TYPE
                           ,dty_hh_attri_text_2    def_types.dty_hh_attri_text_2%TYPE
                           ,dty_hh_attribute_3     def_types.dty_hh_attribute_3%TYPE
                           ,dty_hh_attri_text_3    def_types.dty_hh_attri_text_3%TYPE
                           ,dty_hh_attribute_4     def_types.dty_hh_attribute_4%TYPE
                           ,dty_hh_attri_text_4    def_types.dty_hh_attri_text_4%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetDefectTypesResponse'||c_xmlns||'><Defect_Types>';
  --
  TYPE attr_detail_rec IS RECORD(attr_datatype    all_tab_columns.data_type%TYPE
                                ,attr_length      NUMBER
                                ,attr_format      VARCHAR2(100));
  TYPE attr_detail_tab IS TABLE OF attr_detail_rec INDEX BY VARCHAR2(100);
  lt_attr_detail attr_detail_tab;
  --
  PROCEDURE pop_attr_detail_tab
    IS
    --
    CURSOR get_attr_details
        IS
    SELECT column_name
          ,data_type
          ,DECODE(data_type,'VARCHAR2',data_length
                           ,'DATE'    ,11
                           ,'NUMBER'  ,DECODE(data_precision,NULL,38
                                                                 ,NVL(data_precision,0)+DECODE(NVL(data_scale,0),0,0
                                                                                                                  ,1
                                                                                              )
                                             )
                 ) len
          ,DECODE(data_type,'DATE'  ,'DD-MON-YYYY'
                           ,'NUMBER',DECODE(data_scale,NULL,NULL
                                                    ,0   ,RTRIM(LPAD('9',data_precision,'9'))
                                                         ,RTRIM(LPAD('9',data_precision-(data_scale),'9'))||'.'||RTRIM(LPAD('9',data_scale,'9')))
                 ) fmt
      FROM all_tab_columns
     WHERE table_name  = 'DEFECTS'
       AND owner = hig.get_application_owner
         ;
    --
  BEGIN
    --
    FOR attr_rec IN get_attr_details LOOP
      --
      lt_attr_detail(attr_rec.column_name).attr_datatype := attr_rec.data_type;
      lt_attr_detail(attr_rec.column_name).attr_length   := attr_rec.len;
      lt_attr_detail(attr_rec.column_name).attr_format   := attr_rec.fmt;
      --
    END LOOP;
    --
  END pop_attr_detail_tab;
  --
  FUNCTION get_attr_datatype(pi_column IN all_tab_columns.data_type%TYPE)
    RETURN all_tab_columns.data_type%TYPE IS
    --
    lv_retval all_tab_columns.data_type%TYPE;
    --
  BEGIN
    IF pi_column IS NOT NULL
     THEN
        lv_retval := lt_attr_detail(pi_column).attr_datatype;
    END IF;
    RETURN lv_retval;
  END get_attr_datatype;
  --
  FUNCTION get_attr_length(pi_column IN all_tab_columns.data_type%TYPE)
    RETURN VARCHAR2 IS
    --
    lv_retval VARCHAR2(40);
    --
  BEGIN
    IF pi_column IS NOT NULL
     THEN
        lv_retval := TO_CHAR(lt_attr_detail(pi_column).attr_length);
    END IF;
    RETURN lv_retval;
  END get_attr_length;
  --
  FUNCTION get_attr_format(pi_column IN all_tab_columns.data_type%TYPE)
    RETURN VARCHAR2 IS
    --
    lv_retval VARCHAR2(100);
    --
  BEGIN
    IF pi_column IS NOT NULL
     THEN
        lv_retval := lt_attr_detail(pi_column).attr_format;
    END IF;
    RETURN lv_retval;
  END get_attr_format;
  --
BEGIN
  --
  pop_attr_detail_tab;
  --
  SELECT dty_defect_code
        ,dty_descr1
        ,dty_dtp_flag
        ,dty_atv_acty_area_code
        ,dty_start_date
        ,dty_end_date
        ,dty_hh_attribute_1
        ,dty_hh_attri_text_1
        ,dty_hh_attribute_2
        ,dty_hh_attri_text_2
        ,dty_hh_attribute_3
        ,dty_hh_attri_text_3
        ,dty_hh_attribute_4
        ,dty_hh_attri_text_4
    BULK COLLECT
    INTO lt_retval
    FROM def_types
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Defect_Type>'
                      ||'<Defect_Code>'||escape_xml(lt_retval(i).dty_defect_code)||'</Defect_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).dty_descr1)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).dty_dtp_flag||'</Sys_Flag>'
                      ||'<Activity_Code>'||escape_xml(lt_retval(i).dty_atv_acty_area_code)||'</Activity_Code>'
                      ||'<Attribute1>'||escape_xml(lt_retval(i).dty_hh_attri_text_1)||'</Attribute1>'
                      ||'<Attribute1_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_1)||'</Attribute1_Datatype>'
                      ||'<Attribute1_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_1)||'</Attribute1_Length>'
                      ||'<Attribute1_Format>'||escape_xml(get_attr_format(lt_retval(i).dty_hh_attribute_1))||'</Attribute1_Format>'
                      ||'<Attribute2>'||escape_xml(lt_retval(i).dty_hh_attri_text_2)||'</Attribute2>'
                      ||'<Attribute2_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_2)||'</Attribute2_Datatype>'
                      ||'<Attribute2_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_2)||'</Attribute2_Length>'
                      ||'<Attribute2_Format>'||escape_xml(get_attr_format(lt_retval(i).dty_hh_attribute_2))||'</Attribute2_Format>'
                      ||'<Attribute3>'||escape_xml(lt_retval(i).dty_hh_attri_text_3)||'</Attribute3>'
                      ||'<Attribute3_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_3)||'</Attribute3_Datatype>'
                      ||'<Attribute3_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_3)||'</Attribute3_Length>'
                      ||'<Attribute3_Format>'||escape_xml(get_attr_format(lt_retval(i).dty_hh_attribute_3))||'</Attribute3_Format>'
                      ||'<Attribute4>'||escape_xml(lt_retval(i).dty_hh_attri_text_4)||'</Attribute4>'
                      ||'<Attribute4_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_4)||'</Attribute4_Datatype>'
                      ||'<Attribute4_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_4)||'</Attribute4_Length>'
                      ||'<Attribute4_Format>'||escape_xml(get_attr_format(lt_retval(i).dty_hh_attribute_4))||'</Attribute4_Format>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).dty_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).dty_end_date)||'</Enddate>'
                    ||'</Defect_Type>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Defect_Types></GetDefectTypesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetDefectTypesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_defect_codes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_siss_codes
  RETURN xmltype IS
  --
  lv_perc_item  hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  --
  TYPE retval_rec IS RECORD(siss_id         standard_item_sub_sections.siss_id%TYPE
                           ,siss_name       standard_item_sub_sections.siss_name%TYPE
                           ,siss_start_date standard_item_sub_sections.siss_start_date%TYPE
                           ,siss_end_date   standard_item_sub_sections.siss_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetSISSCodesResponse'||c_xmlns||'><Siss_Codes>';
  --
BEGIN
  --
  SELECT siss_id
        ,siss_name
        ,siss_start_date
        ,siss_end_date
    BULK COLLECT
    INTO lt_retval
    FROM standard_item_sub_sections
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := NULL;
    --
    lv_str := lv_str||'<Siss_Code>'
                      ||'<Siss_Id>'||escape_xml(lt_retval(i).siss_id)||'</Siss_Id>'
                      ||'<Description>'||escape_xml(lt_retval(i).siss_name)||'</Description>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).siss_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).siss_end_date)||'</Enddate>'
                    ||'</Siss_Code>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Siss_Codes></GetSISSCodesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetSISSCodesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_siss_codes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_items
  RETURN xmltype IS
  --
  lv_perc_item  hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  --
  TYPE retval_rec IS RECORD(sta_item_code     standard_items.sta_item_code%TYPE
                           ,sta_item_name     standard_items.sta_item_name%TYPE
                           ,sta_unit          standard_items.sta_unit%TYPE
                           ,sta_rate          standard_items.sta_rate%TYPE
                           ,sta_labour_units  standard_items.sta_labour_units%TYPE
                           ,sta_max_quantity  standard_items.sta_max_quantity%TYPE
                           ,sta_min_quantity  standard_items.sta_min_quantity%TYPE
                           ,sta_dim1_text     standard_items.sta_dim1_text%TYPE
                           ,sta_dim2_text     standard_items.sta_dim2_text%TYPE
                           ,sta_dim3_text     standard_items.sta_dim3_text%TYPE
                           ,sta_allow_percent standard_items.sta_allow_percent%TYPE
                           ,sta_start_date    standard_items.sta_start_date%TYPE
                           ,sta_end_date      standard_items.sta_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetStandardItemsResponse'||c_xmlns||'><Standard_Items>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT sta_item_code
        ,sta_item_name
        ,sta_unit
        ,NVL(sta_rate, 0) sta_rate
        ,sta_labour_units
        ,sta_max_quantity
        ,sta_min_quantity
        ,sta_dim1_text
        ,sta_dim2_text
        ,sta_dim3_text
        ,NVL(sta_allow_percent,'N')
        ,sta_start_date
        ,sta_end_date
    BULK COLLECT
    INTO lt_retval
    FROM standard_items
   WHERE sta_unit != lv_perc_item
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Standard_Item>'
                      ||'<Item_Code>'||escape_xml(lt_retval(i).sta_item_code)||'</Item_Code>'
                      ||'<Item_Name>'||escape_xml(lt_retval(i).sta_item_name)||'</Item_Name>'
                      ||'<Unit>'||escape_xml(lt_retval(i).sta_unit)||'</Unit>'
                      ||'<Rate>'||TO_CHAR(lt_retval(i).sta_rate)||'</Rate>'
                      ||'<Labour_Units>'||TO_CHAR(lt_retval(i).sta_labour_units)||'</Labour_Units>'
                      ||'<Max_Quantity>'||TO_CHAR(lt_retval(i).sta_max_quantity)||'</Max_Quantity>'
                      ||'<Min_Quantity>'||TO_CHAR(lt_retval(i).sta_min_quantity)||'</Min_Quantity>'
                      ||'<Dimension1_Name>'||escape_xml(lt_retval(i).sta_dim1_text)||'</Dimension1_Name>'
                      ||'<Dimension2_Name>'||escape_xml(lt_retval(i).sta_dim2_text)||'</Dimension2_Name>'
                      ||'<Dimension3_Name>'||escape_xml(lt_retval(i).sta_dim3_text)||'</Dimension3_Name>'
                      ||'<Allow_Percent_Item>'||lt_retval(i).sta_allow_percent||'</Allow_Percent_Item>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).sta_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).sta_end_date)||'</Enddate>'
                    ||'</Standard_Item>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Standard_Items></GetStandardItemsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetStandardItemsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_standard_items;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_percent_items
  RETURN xmltype IS
  --
  lv_perc_item  hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  --
  TYPE retval_rec IS RECORD(sta_item_code     standard_items.sta_item_code%TYPE
                           ,sta_item_name     standard_items.sta_item_name%TYPE
                           ,sta_unit          standard_items.sta_unit%TYPE
                           ,sta_rate          standard_items.sta_rate%TYPE
                           ,sta_dim1_text     standard_items.sta_dim1_text%TYPE
                           ,sta_start_date    standard_items.sta_start_date%TYPE
                           ,sta_end_date      standard_items.sta_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetStandardPercentItemsResponse'||c_xmlns||'><Standard_Percent_Items>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT sta_item_code
        ,sta_item_name
        ,sta_unit
        ,NVL(sta_rate, 0) sta_rate
        ,sta_dim1_text
        ,sta_start_date
        ,sta_end_date
    BULK COLLECT
    INTO lt_retval
    FROM standard_items
   WHERE sta_unit = lv_perc_item
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Standard_Percent_Item>'
                      ||'<Item_Code>'||escape_xml(lt_retval(i).sta_item_code)||'</Item_Code>'
                      ||'<Item_Name>'||escape_xml(lt_retval(i).sta_item_name)||'</Item_Name>'
                      ||'<Unit>'||escape_xml(lt_retval(i).sta_unit)||'</Unit>'
                      ||'<Rate>'||TO_CHAR(lt_retval(i).sta_rate)||'</Rate>'
                      ||'<Max_Quantity>1</Max_Quantity>'
                      ||'<Min_Quantity>1</Min_Quantity>'
                      ||'<Dimension1_Name>'||escape_xml(lt_retval(i).sta_dim1_text)||'</Dimension1_Name>'
                      ||'<Allow_Percent_Item>N</Allow_Percent_Item>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).sta_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).sta_end_date)||'</Enddate>'
                    ||'</Standard_Percent_Item>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Standard_Percent_Items></GetStandardPercentItemsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetStandardPercentItemsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_standard_percent_items;
--
-----------------------------------------------------------------------------
--
FUNCTION get_notify_orgs
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(oun_org_id       org_units.oun_org_id%TYPE
                           ,oun_unit_code    org_units.oun_unit_code%TYPE
                           ,oun_name         org_units.oun_name%TYPE
                           ,oun_admin_org_id org_units.oun_admin_org_id%TYPE
                           ,oun_start_date   org_units.oun_start_date%TYPE
                           ,oun_end_date     org_units.oun_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetNotifyOrgsResponse'||c_xmlns||'><Notify_Orgs>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT oun_org_id
        ,oun_unit_code
        ,oun_name
        ,oun_admin_org_id
        ,oun_start_date
        ,oun_end_date
    BULK COLLECT
    INTO lt_retval
    FROM org_units
   WHERE oun_org_unit_type = 'NO'
   UNION
  SELECT oun_org_id
        ,oun_unit_code
        ,oun_name
        ,oun_admin_org_id
        ,oun_start_date
        ,oun_end_date
    FROM hig_options
        ,org_units
   WHERE oun_unit_code     = hop_value
     AND oun_org_unit_type = 'NO'
     AND hop_id            = 'UNKNOWNORG'
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Notify_Org>'
                      ||'<Org_Id>'||TO_CHAR(lt_retval(i).oun_org_id)||'</Org_Id>'
                      ||'<Org_Code>'||escape_xml(lt_retval(i).oun_unit_code)||'</Org_Code>'
                      ||'<Org_Name>'||escape_xml(lt_retval(i).oun_name)||'</Org_Name>'
                      ||'<Admin_Unit_Id>'||TO_CHAR(lt_retval(i).oun_admin_org_id)||'</Admin_Unit_Id>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).oun_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).oun_end_date)||'</Enddate>'
                    ||'</Notify_Org>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Notify_Orgs></GetNotifyOrgsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetNotifyOrgsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_notify_orgs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_recharge_orgs
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(oun_org_id       org_units.oun_org_id%TYPE
                           ,oun_unit_code    org_units.oun_unit_code%TYPE
                           ,oun_name         org_units.oun_name%TYPE
                           ,oun_admin_org_id org_units.oun_admin_org_id%TYPE
                           ,oun_start_date   org_units.oun_start_date%TYPE
                           ,oun_end_date     org_units.oun_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetRechargeOrgsResponse'||c_xmlns||'><Recharge_Orgs>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT oun_org_id
        ,oun_unit_code
        ,oun_name
        ,oun_admin_org_id
        ,oun_start_date
        ,oun_end_date
    BULK COLLECT
    INTO lt_retval
    FROM org_units
   WHERE oun_org_unit_type = 'RE'
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Recharge_Org>'
                      ||'<Org_Id>'||TO_CHAR(lt_retval(i).oun_org_id)||'</Org_Id>'
                      ||'<Org_Code>'||escape_xml(lt_retval(i).oun_unit_code)||'</Org_Code>'
                      ||'<Org_Name>'||escape_xml(lt_retval(i).oun_name)||'</Org_Name>'
                      ||'<Admin_Unit_Id>'||TO_CHAR(lt_retval(i).oun_admin_org_id)||'</Admin_Unit_Id>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).oun_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).oun_end_date)||'</Enddate>'
                    ||'</Recharge_Org>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Recharge_Orgs></GetRechargeOrgsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetRechargeOrgsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_recharge_orgs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_contracts
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(con_id           contracts.con_id%TYPE
                           ,con_code         contracts.con_code%TYPE
                           ,con_name         contracts.con_name%TYPE
                           ,con_admin_org_id contracts.con_admin_org_id%TYPE
                           ,con_status_code  contracts.con_status_code%TYPE
                           ,con_start_date   contracts.con_start_date%TYPE
                           ,con_end_date     contracts.con_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetContractsResponse'||c_xmlns||'><Contracts>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT con_id
        ,con_code
        ,con_name
        ,con_admin_org_id
        ,con_status_code
        ,con_start_date
        ,con_end_date
    BULK COLLECT
    INTO lt_retval
    FROM contracts
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Contract>'
                      ||'<Contract_Id>'||TO_CHAR(lt_retval(i).con_id)||'</Contract_Id>'
                      ||'<Contract_Code>'||escape_xml(lt_retval(i).con_code)||'</Contract_Code>'
                      ||'<Contract_Name>'||escape_xml(lt_retval(i).con_name)||'</Contract_Name>'
                      ||'<Admin_Unit_Id>'||TO_CHAR(lt_retval(i).con_admin_org_id)||'</Admin_Unit_Id>'
                      ||'<Contract_Status>'||escape_xml(lt_retval(i).con_status_code)||'</Contract_Status>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).con_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).con_end_date)||'</Enddate>'
                    ||'</Contract>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Contracts></GetContractsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetContractsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_contracts;
--
-----------------------------------------------------------------------------
--
FUNCTION get_contract_items(pi_xml IN XMLTYPE)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Contract_Id',cp_xmlns) con_id
   FROM dual
      ;
  --
  lr_params  get_params%ROWTYPE;
  lv_con_id  contracts.con_id%TYPE;
  --
  TYPE retval_tab IS TABLE OF contract_items%ROWTYPE;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetContractItemsResponse'||c_xmlns||'><ContractItems>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  --
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetContractItems/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_con_id := lr_params.con_id;
      --
      SELECT cni.*
        BULK COLLECT
        INTO lt_retval
        FROM standard_items sta
            ,contract_items cni
       WHERE cni_con_id = lv_con_id
         AND cni_sta_item_code = sta_item_code
           ;
      --
      IF lt_retval.count = 0
       THEN
          raise no_data_found;
      END IF;
      --
      FOR i IN 1..lt_retval.count LOOP
        --
        lv_str := lv_str||'<ContractItem>'
                          ||'<Item_Code>'||escape_xml(lt_retval(i).cni_sta_item_code)||'</Item_Code>'
                          ||'<Rate>'||TO_CHAR(lt_retval(i).cni_rate)||'</Rate>'
                          ||'<Road_Group_Id>'||TO_CHAR(lt_retval(i).cni_rse_he_id)||'</Road_Group_Id>'
                        ||'</ContractItem>'
             ;
        --
        IF length(lv_str) > lv_max_size
         THEN
            lv_clob := lv_clob||lv_str;
            lv_str := NULL;
        END IF;
        --
      END LOOP;
      --
      lv_clob := lv_clob||lv_str||'</ContractItems></GetContractItemsResponse>';
      --
      lv_retval := xmltype(lv_clob);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetContractItemsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_contract_items;
--
-----------------------------------------------------------------------------
--
FUNCTION get_scheme_types
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hco_code        hig_codes.hco_code%TYPE
                           ,hco_meaning     hig_codes.hco_meaning%TYPE
                           ,icb_dtp_flag    item_code_breakdowns.icb_dtp_flag%TYPE
                           ,hco_start_date  hig_codes.hco_start_date%TYPE
                           ,hco_end_date    hig_codes.hco_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetSchemeTypesResponse'||c_xmlns||'><Scheme_Types>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT DISTINCT hco_code
        ,hco_meaning
        ,icb_dtp_flag
        ,hco_start_date
        ,hco_end_date
    BULK COLLECT
    INTO lt_retval
    FROM hig_codes
        ,item_code_breakdowns
   WHERE hco_domain = 'SCHEME_TYPES'
     AND hco_code = icb_type_of_scheme
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Scheme_Type>'
                      ||'<Scheme_Type_Code>'||escape_xml(lt_retval(i).hco_code)||'</Scheme_Type_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).icb_dtp_flag||'</Sys_Flag>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hco_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hco_end_date)||'</Enddate>'
                    ||'</Scheme_Type>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Scheme_Types></GetSchemeTypesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetSchemeTypesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_scheme_types;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_budgets
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(bud_id                  budgets.bud_id%TYPE
                           ,bud_fyr_id              budgets.bud_fyr_id%TYPE
                           ,bud_comment             budgets.bud_comment%TYPE
                           ,icb_id                  item_code_breakdowns.icb_id%TYPE
                           ,icb_work_code           item_code_breakdowns.icb_work_code%TYPE
                           ,icb_work_category_name  item_code_breakdowns.icb_work_category_name%TYPE
                           ,icb_type_of_scheme      item_code_breakdowns.icb_type_of_scheme%TYPE
                           ,bud_sys_flag            budgets.bud_sys_flag%TYPE
                           ,bud_rse_he_id           budgets.bud_rse_he_id%TYPE
                           ,fyr_start_date          financial_years.fyr_start_date%TYPE
                           ,fyr_end_date            financial_years.fyr_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetCurrentBudgetsResponse'||c_xmlns||'><Budgets>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 2000;
  --
  FUNCTION get_budget_activities(pi_icb_id ihms_conversions.ihc_icb_id%TYPE)
    RETURN varchar2 IS
    --
    lv_retval nm3type.max_varchar2;
    --
    TYPE activities_tab IS TABLE OF ihms_conversions.ihc_atv_acty_area_code%TYPE;
    lt_activities activities_tab;
    --
  BEGIN
    --
    SELECT ihc_atv_acty_area_code
      BULK COLLECT
      INTO lt_activities
      FROM ihms_conversions
     WHERE ihc_icb_id = pi_icb_id
         ;
    --
    IF lt_activities.count > 0
     THEN
        --
        lv_retval := '<Budget_Activities>';
        --
        FOR j IN 1..lt_activities.count LOOP
          --
          lv_retval := lv_retval||'<Activity_Code>'||escape_xml(lt_activities(j))||'</Activity_Code>';
          --
        END LOOP;
        --
        lv_retval := lv_retval||'</Budget_Activities>';
        --
    END IF;
    --
    RETURN lv_retval;
    --
  END get_budget_activities;
  --
BEGIN
  --
  select bud_id
        ,bud_fyr_id
        ,bud_comment
        ,icb_id
        ,icb_work_code
        ,icb_work_category_name
        ,icb_type_of_scheme
        ,bud_sys_flag
        ,bud_rse_he_id
        ,fyr_start_date
        ,fyr_end_date
    BULK COLLECT
    INTO lt_retval
    from item_code_breakdowns
        ,budgets
        ,financial_years
   where fyr_end_date >= sysdate
     AND fyr_id = bud_fyr_id
     AND bud_icb_item_code = icb_item_code
     AND bud_icb_sub_item_code = icb_sub_item_code
     AND bud_icb_sub_sub_item_code = icb_sub_sub_item_code
     AND bud_sys_flag = icb_dtp_flag
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Budget>'
                      ||'<Budget_Id>'||TO_CHAR(lt_retval(i).bud_id)||'</Budget_Id>'
                      ||'<Budget_Year>'||escape_xml(lt_retval(i).bud_fyr_id)||'</Budget_Year>'
                      ||'<Budget_Comment>'||escape_xml(lt_retval(i).bud_comment)||'</Budget_Comment>'
                      ||'<Budget_Road_Group_Id>'||TO_CHAR(lt_retval(i).bud_rse_he_id)||'</Budget_Road_Group_Id>'
                      ||'<Work_Category>'||escape_xml(lt_retval(i).icb_work_code)||'</Work_Category>'
                      ||'<Work_Category_Name>'||escape_xml(lt_retval(i).icb_work_category_name)||'</Work_Category_Name>'
                      ||'<Scheme_Type_Code>'||escape_xml(lt_retval(i).icb_type_of_scheme)||'</Scheme_Type_Code>'
                      ||'<Sys_Flag>'||lt_retval(i).bud_sys_flag||'</Sys_Flag>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).fyr_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).fyr_end_date)||'</Enddate>'
                      ||get_budget_activities(pi_icb_id => lt_retval(i).icb_id)
                    ||'</Budget>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Budgets></GetCurrentBudgetsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetCurrentBudgetsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_current_budgets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_road_group_section_ids(pi_xml IN XMLTYPE)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Road_Group_Id',cp_xmlns) road_group_id
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  lv_road_group_id  nm_elements.ne_id%TYPE;
  --
  TYPE retval_tab IS TABLE OF nm_elements_all.ne_id%TYPE;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetRoadGroupSectionIDsResponse'||c_xmlns||'><Road_Group_Sections>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  --
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetRoadGroupSectionIDs/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_road_group_id := lr_params.road_group_id;
      --
      SELECT rse_he_id
        BULK COLLECT
        INTO lt_retval
        FROM road_sections_all
       WHERE rse_sys_flag IN ('L','D')
         AND rse_he_id IN(SELECT nm_ne_id_of
                            FROM nm_members
                           WHERE nm_type = 'G'
                         CONNECT BY
                           PRIOR nm_ne_id_of = nm_ne_id_in
                           START
                            WITH nm_ne_id_in = lv_road_group_id)
           ;
      --
      IF lt_retval.count = 0
       THEN
          raise no_data_found;
      END IF;
      --
      FOR i IN 1..lt_retval.count LOOP
        --
        lv_str := lv_str||'<Section_Id>'||TO_CHAR(lt_retval(i))||'</Section_Id>';
        --
        IF length(lv_str) > lv_max_size
         THEN
            lv_clob := lv_clob||lv_str;
            lv_str := NULL;
        END IF;
        --
      END LOOP;
      --
      lv_clob := lv_clob||lv_str||'</Road_Group_Sections></GetRoadGroupSectionIDsResponse>';
      --
      lv_retval := xmltype(lv_clob);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetRoadGroupSectionIDsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_road_group_section_ids;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_order_priorities
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(hco_code        hig_codes.hco_code%TYPE
                           ,hco_meaning     hig_codes.hco_meaning%TYPE
                           ,hco_start_date  hig_codes.hco_start_date%TYPE
                           ,hco_end_date    hig_codes.hco_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetWorkOrderPrioritiesResponse'||c_xmlns||'><Work_Order_Priorities>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT hco_code
        ,NVL(wpr_name,hco_meaning) meaning
        ,hco_start_date
        ,hco_end_date
    BULK COLLECT
    INTO lt_retval
    FROM work_order_priorities
        ,hig_codes
   WHERE hco_domain = 'WOR_PRIORITY'
     AND hco_code = wpr_id(+)
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Work_Order_Priority>'
                      ||'<Work_Order_Priority_Code>'||escape_xml(lt_retval(i).hco_code)||'</Work_Order_Priority_Code>'
                      ||'<Description>'||escape_xml(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).hco_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).hco_end_date)||'</Enddate>'
                    ||'</Work_Order_Priority>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Work_Order_Priorities></GetWorkOrderPrioritiesResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetWorkOrderPrioritiesResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_work_order_priorities;
--
-----------------------------------------------------------------------------
--
FUNCTION get_cost_centres
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(coc_org_id      cost_centres.coc_org_id%TYPE
                           ,coc_cost_centre cost_centres.coc_cost_centre%TYPE
                           ,coc_start_date  cost_centres.coc_start_date%TYPE
                           ,coc_end_date    cost_centres.coc_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetCostCentresResponse'||c_xmlns||'><Cost_Centres>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT coc_org_id
        ,coc_cost_centre
        ,coc_start_date
        ,coc_end_date
    BULK COLLECT
    INTO lt_retval
    FROM cost_centres
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Cost_Centre>'
                      ||'<Cost_Centre_Code>'||escape_xml(lt_retval(i).coc_cost_centre)||'</Cost_Centre_Code>'
                      ||'<Admin_Unit_Id>'||TO_CHAR(lt_retval(i).coc_org_id)||'</Admin_Unit_Id>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).coc_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).coc_end_date)||'</Enddate>'
                    ||'</Cost_Centre>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Cost_Centres></GetCostCentresResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetCostCentresResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_cost_centres;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_road_groups
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(rse_he_id          road_groups.rse_he_id%TYPE
                           ,rse_unique         road_groups.rse_unique%TYPE
                           ,rse_gty_group_type road_groups.rse_gty_group_type%TYPE
                           ,rse_sys_flag       road_sections.rse_sys_flag%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<GetDefaultRoadGroupsResponse'||c_xmlns||'><DefaultRoadGroups>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  SELECT rse_he_id
        ,rse_unique
        ,rse_gty_group_type
        ,rse_sys_flag
    BULK COLLECT
    INTO lt_retval
    FROM road_groups
   WHERE rse_gty_group_type = hig.get_sysopt('GISGRPTYP')
     AND rse_unique IN(hig.get_sysopt('GISGRPL'),hig.get_sysopt('GISGRPD'))
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<DefaultRoadGroup>'
                      ||'<Road_Group_Id>'||TO_CHAR(lt_retval(i).rse_he_id)||'</Road_Group_Id>'
                      ||'<Road_Group_Unique>'||escape_xml(lt_retval(i).rse_unique)||'</Road_Group_Unique>'
                      ||'<Road_Group_Type>'||escape_xml(lt_retval(i).rse_gty_group_type)||'</Road_Group_Type>'
                      ||'<Sys_Flag>'||lt_retval(i).rse_sys_flag||'</Sys_Flag>'
                    ||'</DefaultRoadGroup>'
                    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</DefaultRoadGroups></GetDefaultRoadGroupsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetDefaultRoadGroupsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_default_road_groups;
--
-----------------------------------------------------------------------------
--
FUNCTION create_adhoc_defect(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_defect(cp_xml         IN XMLTYPE
                   ,cp_root        IN VARCHAR2
                   ,cp_xmlns       IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)              user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Easting',cp_xmlns)              easting
        ,EXTRACTVALUE(cp_xml,cp_root||'Northing',cp_xmlns)             northing
        ,EXTRACTVALUE(cp_xml,cp_root||'Section_Id',cp_xmlns)           section_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Chainage',cp_xmlns)             chainage
        ,EXTRACTVALUE(cp_xml,cp_root||'Asset_Type_Code',cp_xmlns)      asset_type
        ,EXTRACTVALUE(cp_xml,cp_root||'Asset_Id',cp_xmlns)             asset_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Datetime',cp_xmlns)      defect_datetime
        ,EXTRACTVALUE(cp_xml,cp_root||'Initiation_Code',cp_xmlns)      initiation_code
        ,EXTRACTVALUE(cp_xml,cp_root||'Safety_Detailed_Flag',cp_xmlns) safety_detailed_flag
        ,EXTRACTVALUE(cp_xml,cp_root||'Activity_Code',cp_xmlns)        activity_code
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Code',cp_xmlns)          defect_code
        ,EXTRACTVALUE(cp_xml,cp_root||'Siss_Id',cp_xmlns)              siss_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Location_Description',cp_xmlns) location_description
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Description',cp_xmlns)   defect_description
        ,EXTRACTVALUE(cp_xml,cp_root||'Special_Instructions',cp_xmlns) special_instructions
        ,EXTRACTVALUE(cp_xml,cp_root||'Priority_Code',cp_xmlns)        priority_code
        ,EXTRACTVALUE(cp_xml,cp_root||'Notify_Org',cp_xmlns)           notify_org
        ,EXTRACTVALUE(cp_xml,cp_root||'Recharge_Org',cp_xmlns)         recharge_org
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Attribute1',cp_xmlns)    attribute1
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Attribute2',cp_xmlns)    attribute2
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Attribute3',cp_xmlns)    attribute3
        ,EXTRACTVALUE(cp_xml,cp_root||'Defect_Attribute4',cp_xmlns)    attribute4
        ,EXTRACT(cp_xml,cp_root||'Repair',cp_xmlns)                    repair_xml
   FROM dual
      ;
  --
  CURSOR get_repairs(cp_xml   IN XMLTYPE
                    ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'Repair/Repair_Type_Code',cp_xmlns)   repair_type
        ,EXTRACTVALUE(VALUE(x),'Repair/Treatment_Code',cp_xmlns)     treatment_code
        ,EXTRACTVALUE(VALUE(x),'Repair/Repair_Description',cp_xmlns) repair_description
        ,EXTRACT(VALUE(x),'/Repair/Boq',cp_xmlns)                    boq_xml
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/Repair',cp_xmlns))) x
      ;
  --
  CURSOR get_boqs(cp_xml   IN XMLTYPE
                 ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'Boq/Item_Code',cp_xmlns)  item_code
        ,EXTRACTVALUE(VALUE(x),'Boq/Dimension1',cp_xmlns) dimension1
        ,EXTRACTVALUE(VALUE(x),'Boq/Dimension2',cp_xmlns) dimension2
        ,EXTRACTVALUE(VALUE(x),'Boq/Dimension3',cp_xmlns) dimension3
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/Boq',cp_xmlns))) x
      ;
  --
  lr_get_defect  get_defect%ROWTYPE;
  TYPE get_repairs_tab IS TABLE OF get_repairs%ROWTYPE;
  lt_get_repairs get_repairs_tab;
  TYPE get_boqs_tab IS TABLE OF get_boqs%ROWTYPE;
  lt_get_boqs get_boqs_tab;
  --
  lv_defect_id  defects.def_defect_id%TYPE :=0;
  lv_response   CLOB;
  lv_retval     XMLTYPE;
  --
  lr_insp       activities_report%ROWTYPE;
  lr_defect     defects%ROWTYPE;
  lt_def_attr   mai_api.def_attr_tab;
  lt_repairs    mai_api.rep_tab;
  lr_rse        road_sections%ROWTYPE;
  lt_boqs       mai_api.boq_tab;
  --
  rep_ind       PLS_INTEGER := 0;
  boq_ind       PLS_INTEGER := 0;
  --
  FUNCTION get_org_id(pi_org_code VARCHAR2)
    RETURN org_units.oun_org_id%TYPE IS
    --
    lv_retval org_units.oun_org_id%TYPE;
    --
  BEGIN
    SELECT oun_org_id
      INTO lv_retval
      FROM org_units
     WHERE oun_unit_code = pi_org_code
         ;
    RETURN lv_retval;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20043,'Invalid Organisation Specified.');
    WHEN others
     THEN
        RAISE;
  END get_org_id;
  --
  FUNCTION get_user_id(pi_user_id VARCHAR2)
    RETURN NUMBER IS
    --
    lv_retval NUMBER;
    --
  BEGIN
    lv_retval := to_number(pi_user_id);
    RETURN lv_retval;
  EXCEPTION
    WHEN others
     THEN
        raise_application_error(-20010,'Invalid User Id Specified For Inspector.');
  END get_user_id;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  --
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting Insp and Defect params');
      OPEN  get_defect(pi_xml
                      ,'/CreateAdhocDefect/Adhoc_Defect/'
                      ,c_xmlns);
      FETCH get_defect
       INTO lr_get_defect;
      CLOSE get_defect;
      --
      nm_debug.debug('Assigning Insp params');
      lr_insp.are_peo_person_id_actioned := TO_NUMBER(lr_get_defect.user_id);--get_user_id(pi_params.defect.inspector);
      lr_insp.are_created_date           := varchar_to_datetime(lr_get_defect.defect_datetime);
      lr_insp.are_last_updated_date      := lr_insp.are_created_date;
      lr_insp.are_maint_insp_flag        := lr_get_defect.safety_detailed_flag;
      lr_insp.are_date_work_done         := TRUNC(lr_insp.are_created_date);
      lr_insp.are_initiation_type        := lr_get_defect.initiation_code;
      lr_insp.are_rse_he_id              := lr_get_defect.section_id;
      --
      nm_debug.debug('Assigning Defect params');
      lr_defect.def_easting            := lr_get_defect.easting;
      lr_defect.def_northing           := lr_get_defect.northing;
      lr_defect.def_rse_he_id          := lr_get_defect.section_id;
      lr_defect.def_st_chain           := lr_get_defect.chainage;
      IF lr_get_defect.asset_type IS NOT NULL
       THEN
          lr_defect.def_ity_inv_code       := mai.translate_nm_inv_type(p_inv_type => lr_get_defect.asset_type);
      END IF;
      lr_defect.def_iit_item_id        := lr_get_defect.asset_id;
      lr_defect.def_siss_id            := lr_get_defect.siss_id;
      lr_defect.def_atv_acty_area_code := lr_get_defect.activity_code;
      lr_defect.def_defect_code        := lr_get_defect.defect_code;
      lr_defect.def_created_date       := TRUNC(lr_insp.are_created_date);
      lr_defect.def_last_updated_date  := TRUNC(lr_insp.are_created_date);
      lr_defect.def_time_hrs           := TO_CHAR(lr_insp.are_created_date,'HH24');
      lr_defect.def_time_mins          := TO_CHAR(lr_insp.are_created_date,'MI');
      lr_defect.def_priority           := lr_get_defect.priority_code;
      lr_defect.def_orig_priority      := lr_get_defect.priority_code;
      lr_defect.def_locn_descr         := lr_get_defect.location_description;
      lr_defect.def_defect_descr       := lr_get_defect.defect_description;
      lr_defect.def_special_instr      := lr_get_defect.special_instructions;
      IF lr_get_defect.notify_org IS NOT NULL
       THEN
          lr_defect.def_notify_org_id      := get_org_id(lr_get_defect.notify_org);
      END IF;
      IF lr_get_defect.recharge_org IS NOT NULL
       THEN
          lr_defect.def_rechar_org_id      := get_org_id(lr_get_defect.recharge_org);
      END IF;
      /*
      || Set Defect Attributes.
      */
      lt_def_attr(1) := lr_get_defect.attribute1;
      lt_def_attr(2) := lr_get_defect.attribute2;
      lt_def_attr(3) := lr_get_defect.attribute3;
      lt_def_attr(4) := lr_get_defect.attribute4;
      --
      nm_debug.debug('Getting Repair params for :'||lr_get_defect.repair_xml.getstringval);
      OPEN  get_repairs(lr_get_defect.repair_xml
                       ,c_xmlns);
      FETCH get_repairs
       BULK COLLECT
       INTO lt_get_repairs;
      CLOSE get_repairs;
      --
      FOR i IN 1..lt_get_repairs.count LOOP
        --
        rep_ind := rep_ind+1;
        --
        nm_debug.debug('Assigning Repair params');
        lt_repairs(rep_ind).rep_rse_he_id          := lr_defect.def_rse_he_id;
        lt_repairs(rep_ind).rep_action_cat         := lt_get_repairs(i).repair_type;
        lt_repairs(rep_ind).rep_atv_acty_area_code := lr_defect.def_atv_acty_area_code;
        lt_repairs(rep_ind).rep_tre_treat_code     := lt_get_repairs(i).treatment_code;
        lt_repairs(rep_ind).rep_descr              := lt_get_repairs(i).repair_description;
        --
        nm_debug.debug('Getting BOQ params for :'||CASE WHEN lt_get_repairs(i).boq_xml IS NOT NULL THEN lt_get_repairs(i).boq_xml.getstringval ELSE NULL END);
        OPEN  get_boqs(lt_get_repairs(i).boq_xml
                      ,c_xmlns);
        FETCH get_boqs
         BULK COLLECT
         INTO lt_get_boqs;
        CLOSE get_boqs;
        --
        FOR j IN 1..lt_get_boqs.count LOOP
          --
          boq_ind := boq_ind+1;
          --
          nm_debug.debug('Assigning BOQ params');
          lt_boqs(boq_ind).boq_rep_action_cat := lt_repairs(rep_ind).rep_action_cat;
          lt_boqs(boq_ind).boq_sta_item_code  := lt_get_boqs(j).item_code;
          lt_boqs(boq_ind).boq_est_dim1       := lt_get_boqs(j).dimension1;
          lt_boqs(boq_ind).boq_est_dim2       := lt_get_boqs(j).dimension2;
          lt_boqs(boq_ind).boq_est_dim3       := lt_get_boqs(j).dimension3;
          --
        END LOOP;
        --
      END LOOP;
      nm_debug.debug('All input params Assigned');
      --
      lv_defect_id := mai_api.create_defect(pi_insp_rec     => lr_insp
                                           ,pi_defect_rec   => lr_defect
                                           ,pi_def_attr_tab => lt_def_attr
                                           ,pi_repair_tab   => lt_repairs
                                           ,pi_boq_tab      => lt_boqs
                                           ,pi_commit       => 'Y');
      --
      nm_debug.debug('Building Output XML');
      lv_response := '<CreateAdhocDefectResponse'||c_xmlns||'><Defect_Created>'
                     ||'<Defect_ID>'||TO_CHAR(lv_defect_id)||'</Defect_ID>'
                   ||'</Defect_Created></CreateAdhocDefectResponse>'
                 ;
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'CreateAdhocDefectResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'CreateAdhocDefectResponse'
                            ,pi_sqlerrm => SQLERRM);
END create_adhoc_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION get_available_defects
  RETURN xmltype IS
  --
  lv_def_available  hig_status_codes.hsc_status_code%TYPE;
  --
  TYPE retval_rec IS RECORD(def_defect_id           defects.def_defect_id%TYPE
                           ,def_ity_sys_flag        defects.def_ity_sys_flag%TYPE
                           ,def_rse_he_id           defects.def_rse_he_id%TYPE
                           ,def_ity_inv_code        defects.def_ity_inv_code%TYPE
                           ,def_iit_item_id         defects.def_iit_item_id%TYPE
                           ,def_defect_descr        defects.def_defect_descr%TYPE
                           ,def_defect_code         defects.def_defect_code%TYPE
                           ,def_priority            defects.def_priority%TYPE
                           ,def_atv_acty_area_code  defects.def_atv_acty_area_code%TYPE
                           ,rep_action_cat          repairs.rep_action_cat%TYPE
                           ,rep_descr               repairs.rep_descr%TYPE
                           ,rep_tre_treat_code      repairs.rep_tre_treat_code%TYPE
                           ,rep_date_due            repairs.rep_date_due%TYPE
                           ,rep_est_cost            NUMBER);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLTYPE;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetAvailableDefectsResponse'||c_xmlns||'><Available_Defects>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 3000;
  --
  PROCEDURE get_def_available
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_def_available
      FROM hig_status_codes
     WHERE hsc_domain_code = 'DEFECTS'
       AND hsc_allow_feature2 = 'Y'
       AND SYSDATE BETWEEN NVL(hsc_start_date,SYSDATE)
                       AND NVL(hsc_end_date  ,SYSDATE)
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20056,'Too Many Values Defined For Defect AVAILABLE Status');
    WHEN no_data_found
     THEN
        raise_application_error(-20052,'Cannot Obtain Value For Defect AVAILABLE Status');
    WHEN others
     THEN
        RAISE;
  END get_def_available;
  --
  FUNCTION get_boqs(pi_defect_id   defects.def_defect_id%TYPE
                   ,pi_repair_type repairs.rep_action_cat%TYPE)
    RETURN varchar2 IS
    --
    lv_retval nm3type.max_varchar2;
    --
    TYPE boq_tab IS TABLE OF boq_items%ROWTYPE;
    lt_boqs boq_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_boqs
      FROM boq_items
     WHERE boq_defect_id = pi_defect_id
       AND boq_rep_action_cat = pi_repair_type
         ;
    --
    IF lt_boqs.count > 0
     THEN
        --
        FOR j IN 1..lt_boqs.count LOOP
          --
          lv_retval := lv_retval||'<BoqItem>'
                                  ||gen_tags(0,'Boq_Id',TO_CHAR(lt_boqs(j).boq_id),'N')
                                  ||gen_tags(0,'Item_Code',escape_xml(lt_boqs(j).boq_sta_item_code),'N')
                                  ||gen_tags(0,'Dimension1',TO_CHAR(lt_boqs(j).boq_est_dim1),'N')
                                  ||gen_tags(0,'Dimension2',TO_CHAR(lt_boqs(j).boq_est_dim2),'N')
                                  ||gen_tags(0,'Dimension3',TO_CHAR(lt_boqs(j).boq_est_dim3),'N')
                                ||'</BoqItem>'
                  ;
          --
        END LOOP;
        --
    END IF;
    --
    RETURN lv_retval;
    --
  END get_boqs;
BEGIN
  /*
  ||Get The Available Defect Status Code.
  */
  get_def_available;
  /*
  ||Get the available Defects.
  */
  SELECT def_defect_id
        ,def_ity_sys_flag
        ,def_rse_he_id
        ,def_ity_inv_code
        ,def_iit_item_id
        ,def_defect_descr
        ,def_defect_code
        ,def_priority
        ,def_atv_acty_area_code
        ,rep_action_cat
        ,rep_descr
        ,rep_tre_treat_code
        ,rep_date_due
        ,SUM(NVL(boq_est_cost,0)) rep_est_cost
    BULK COLLECT
    INTO lt_retval
    FROM boq_items
        ,repairs
        ,defects
   WHERE def_status_code = lv_def_available
     AND def_date_compl IS NULL
     AND NVL(def_superseded_flag,'N') != 'Y'
     AND def_defect_id = rep_def_defect_id
     AND rep_date_completed IS NULL
     AND NVL(rep_superseded_flag,'N') != 'Y'
     AND rep_def_defect_id = boq_defect_id(+)
     AND rep_action_cat = boq_rep_action_cat(+)
   GROUP
      BY def_defect_id
        ,def_ity_sys_flag
        ,def_rse_he_id
        ,def_ity_inv_code
        ,def_iit_item_id
        ,def_defect_descr
        ,def_defect_code
        ,def_priority
        ,def_atv_acty_area_code
        ,rep_action_cat
        ,rep_descr
        ,rep_tre_treat_code
        ,rep_date_due
   ORDER
      BY def_defect_id
        ,rep_action_cat desc
       ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Available_Defect>'
                    ||gen_tags(0,'Defect_ID',TO_CHAR(lt_retval(i).def_defect_id),'N')
                    ||gen_tags(0,'Sys_Flag',lt_retval(i).def_ity_sys_flag,'N')
                    ||gen_tags(0,'Section_Id',TO_CHAR(lt_retval(i).def_rse_he_id),'N')
                    ||gen_tags(0,'Asset_Type_Code',lt_retval(i).def_ity_inv_code,'N')
                    ||gen_tags(0,'Asset_Id',TO_CHAR(lt_retval(i).def_iit_item_id),'N')
                    ||gen_tags(0,'Defect_Code',lt_retval(i).def_defect_code,'N')
                    ||gen_tags(0,'Priority_Code',lt_retval(i).def_priority,'N')
                    ||gen_tags(0,'Activity_Code',lt_retval(i).def_atv_acty_area_code,'N')
                    ||gen_tags(0,'Defect_Description',lt_retval(i).def_defect_descr,'N')
                    ||gen_tags(0,'Repair_Type_Code',lt_retval(i).rep_action_cat,'N')
                    ||gen_tags(0,'Treatment_Code',lt_retval(i).rep_tre_treat_code,'N')
                    ||gen_tags(0,'Repair_Description',lt_retval(i).rep_descr,'N')
                    ||gen_tags(0,'Repair_Date_Due',datetime_to_varchar(lt_retval(i).rep_date_due),'N')
                    ||gen_tags(0,'Repair_Est_Cost',TO_CHAR(lt_retval(i).rep_est_cost),'N')
                    ||get_boqs(pi_defect_id   => lt_retval(i).def_defect_id
                              ,pi_repair_type => lt_retval(i).rep_action_cat)
                    ||'</Available_Defect>'
    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Available_Defects></GetAvailableDefectsResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetAvailableDefectsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_available_defects;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect_work_order(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml   IN XMLTYPE
                   ,cp_root  IN VARCHAR2
                   ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)                user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Description',cp_xmlns) wo_descr
        ,EXTRACTVALUE(cp_xml,cp_root||'Scheme_Type_Code',cp_xmlns)       scheme_type
        ,EXTRACTVALUE(cp_xml,cp_root||'Contract_Id',cp_xmlns)            con_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Interim_Payment',cp_xmlns)        interim_payment
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Priority_Code',cp_xmlns)    work_order_priority
        ,EXTRACTVALUE(cp_xml,cp_root||'Cost_Centre_Code',cp_xmlns)       cost_centre
        ,EXTRACTVALUE(cp_xml,cp_root||'TMA_Register_Flag',cp_xmlns)      tma_register_flag
        ,EXTRACTVALUE(cp_xml,cp_root||'Contact',cp_xmlns)                contact
        ,EXTRACTVALUE(cp_xml,cp_root||'Job_Number',cp_xmlns)             job_number
        ,EXTRACTVALUE(cp_xml,cp_root||'Rechargeable',cp_xmlns)           rechargeable
        ,EXTRACTVALUE(cp_xml,cp_root||'Road_Group_id',cp_xmlns)          road_group
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Raised',cp_xmlns)            date_raised
        ,EXTRACTVALUE(cp_xml,cp_root||'Target_Date',cp_xmlns)            target_date
        ,EXTRACT(cp_xml,cp_root||'Selected_Defect_Repairs',cp_xmlns)     defects_in_xml
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  CURSOR get_defect_list(cp_xml   IN XMLTYPE
                        ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'Selected_Defect_Repair/Defect_ID',cp_xmlns)        defect_id
        ,EXTRACTVALUE(VALUE(x),'Selected_Defect_Repair/Repair_Type_Code',cp_xmlns) rep_action_cat
        ,EXTRACTVALUE(VALUE(x),'Selected_Defect_Repair/Budget_Id',cp_xmlns)        budget_id
        ,EXTRACT(VALUE(x),'/Selected_Defect_Repair/BoqItem',cp_xmlns)              defect_boqs_xml
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/Selected_Defect_Repairs/Selected_Defect_Repair',cp_xmlns))) x
      ;
  --
  CURSOR get_defect_boqs(cp_xml   IN XMLTYPE
                        ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'BoqItem/Boq_Id',cp_xmlns)     boq_id
        ,EXTRACTVALUE(VALUE(x),'BoqItem/Item_Code',cp_xmlns)  item_code
        ,EXTRACTVALUE(VALUE(x),'BoqItem/Dimension1',cp_xmlns) dimension1
        ,EXTRACTVALUE(VALUE(x),'BoqItem/Dimension2',cp_xmlns) dimension2
        ,EXTRACTVALUE(VALUE(x),'BoqItem/Dimension3',cp_xmlns) dimension3
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/BoqItem',cp_xmlns))) x
       ;
  --
  TYPE get_defect_list_tab IS TABLE OF get_defect_list%ROWTYPE;
  lt_get_defect_list get_defect_list_tab;
  TYPE get_defect_boqs_tab IS TABLE OF get_defect_boqs%ROWTYPE;
  lt_get_defect_boqs get_defect_boqs_tab;
  --
  lv_user_id           hig_users.hus_user_id%TYPE;
  lv_wo_descr          work_orders.wor_descr%TYPE;
  lv_scheme_type       work_orders.wor_scheme_type%TYPE;
  lv_con_id            contracts.con_id%TYPE;
  lv_bud_id            budgets.bud_id%TYPE;
  lv_interim_payment   work_orders.wor_interim_payment_flag%TYPE;
  lv_priority          work_orders.wor_priority%TYPE;
  lv_cost_centre       work_orders.wor_coc_cost_centre%TYPE;
  lv_road_group        nm_elements_all.ne_id%TYPE;
  lv_tma_register_flag work_orders.wor_register_flag%TYPE;
  lv_contact           work_orders.wor_contact%TYPE;
  lv_job_number        work_orders.wor_job_number%TYPE;
  lv_rechargeable      work_orders.wor_rechargeable%TYPE;
  lv_date_raised       DATE;
  lv_target_date       DATE;
  lv_commit            VARCHAR2(1) := 'Y';
  --
  lt_defects_in   mai_api.def_rep_list_in_tab;
  lt_defect_boqs  mai_api.boq_tab;
  def_ind         PLS_INTEGER := 0;
  boq_ind         PLS_INTEGER := 0;
  --
  lv_work_order_no      work_orders.wor_works_order_no%TYPE;
  lt_defects_on_wo      mai_api.def_rep_list_on_wo_tab;
  lt_defects_not_on_wo  mai_api.def_rep_list_not_on_wo_tab;
  --
  lv_error_xml VARCHAR2(100);
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  lv_str       nm3type.max_varchar2;
  lv_max_size  PLS_INTEGER := nm3type.c_max_varchar2_size - 1000;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  --
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/CreateDefectWorkOrder/Defect_Work_Order/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id           := lr_params.user_id;
      lv_wo_descr          := lr_params.wo_descr;
      lv_scheme_type       := lr_params.scheme_type;
      lv_con_id            := lr_params.con_id;
      lv_interim_payment   := lr_params.interim_payment;
      lv_priority          := lr_params.work_order_priority;
      lv_cost_centre       := lr_params.cost_centre;
      lv_contact           := lr_params.contact;
      lv_road_group        := lr_params.road_group;
      lv_tma_register_flag := lr_params.tma_register_flag;
      lv_job_number        := lr_params.job_number;
      lv_rechargeable      := lr_params.rechargeable;
      IF lr_params.date_raised IS NOT NULL
       THEN
          lv_date_raised := varchar_to_date(lr_params.date_raised);
      END IF;
      IF lr_params.target_date IS NOT NULL
       THEN
          lv_target_date := varchar_to_date(lr_params.target_date);
      END IF;
      --
      nm_debug.debug('Getting Defect List :'||lr_params.defects_in_xml.getstringval);
      /*
      ||Transform The List Of Defects.
      */
      OPEN  get_defect_list(lr_params.defects_in_xml
                           ,c_xmlns);
      FETCH get_defect_list
       BULK COLLECT
       INTO lt_get_defect_list;
      CLOSE get_defect_list;
      --
      FOR i IN 1..lt_get_defect_list.count LOOP
        --
        nm_debug.debug('Assigning Defect/Repair params');
        lt_defects_in(i).dlt_defect_id      := lt_get_defect_list(i).defect_id;
        lt_defects_in(i).dlt_rep_action_cat := lt_get_defect_list(i).rep_action_cat;
        lt_defects_in(i).dlt_budget_id      := lt_get_defect_list(i).budget_id;
        --
        nm_debug.debug('boq xml: '||CASE WHEN lt_get_defect_list(i).defect_boqs_xml IS NOT NULL THEN lt_get_defect_list(i).defect_boqs_xml.getstringval ELSE NULL END);
        OPEN  get_defect_boqs(lt_get_defect_list(i).defect_boqs_xml
                             ,c_xmlns);
        FETCH get_defect_boqs
         BULK COLLECT
         INTO lt_get_defect_boqs;
        CLOSE get_defect_boqs;
        --
        nm_debug.debug('Number Of BOQs extracted: '||to_char(lt_get_defect_boqs.count));
        FOR j IN 1..lt_get_defect_boqs.count LOOP
          --
          nm_debug.debug('Assigning Defect/Repair BOQ params');
          lt_defect_boqs(lt_defect_boqs.count+1).boq_defect_id      := lt_defects_in(i).dlt_defect_id;
          lt_defect_boqs(lt_defect_boqs.count).boq_rep_action_cat := lt_defects_in(i).dlt_rep_action_cat;
          lt_defect_boqs(lt_defect_boqs.count).boq_id             := lt_get_defect_boqs(j).boq_id;
          lt_defect_boqs(lt_defect_boqs.count).boq_sta_item_code  := lt_get_defect_boqs(j).item_code;
          lt_defect_boqs(lt_defect_boqs.count).boq_est_dim1       := lt_get_defect_boqs(j).dimension1;
          lt_defect_boqs(lt_defect_boqs.count).boq_est_dim2       := lt_get_defect_boqs(j).dimension2;
          lt_defect_boqs(lt_defect_boqs.count).boq_est_dim3       := lt_get_defect_boqs(j).dimension3;
          --
        END LOOP;
        --
      END LOOP;
      nm_debug.debug('All input params Assigned');
      /*
      ||Call The API To Create The Work Order.
      */
      mai_api.create_defect_work_order(pi_user_id           => lv_user_id
                                      ,pi_wo_descr          => lv_wo_descr
                                      ,pi_scheme_type       => lv_scheme_type
                                      ,pi_con_id            => lv_con_id
                                      ,pi_interim_payment   => lv_interim_payment
                                      ,pi_priority          => lv_priority
                                      ,pi_cost_centre       => lv_cost_centre
                                      ,pi_road_group_id     => lv_road_group
                                      ,pi_tma_register_flag => lv_tma_register_flag
                                      ,pi_contact           => lv_contact
                                      ,pi_job_number        => lv_job_number
                                      ,pi_rechargeable      => lv_rechargeable
                                      ,pi_date_raised       => lv_date_raised
                                      ,pi_target_date       => lv_target_date
                                      ,pi_defects           => lt_defects_in
                                      ,pi_defect_boqs       => lt_defect_boqs
                                      ,pi_commit            => lv_commit
                                      ,po_work_order_no     => lv_work_order_no
                                      ,po_defects_on_wo     => lt_defects_on_wo
                                      ,po_defects_not_on_wo => lt_defects_not_on_wo);
      /*
      ||If No Defects Were Added To The Work Order So Build
      ||An Error Element And Add It To The Response.
      */
      IF lt_defects_on_wo.count = 0
       THEN
          lv_error_xml := build_error_xml(pi_wrapper => NULL
                                         ,pi_sqlerrm => 'ORA-20046: No Defects Added To The Work Order.').getStringVal;
      END IF;
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<CreateDefectWorkOrderResponse'||c_xmlns||'><Defect_Work_Order_Created>';
      --
      IF lv_work_order_no IS NOT NULL
       THEN
          lv_response := lv_response||'<Work_Order_No>'||lv_work_order_no||'</Work_Order_No>';
      END IF;
      /*
      ||Add The List Of Defects On The Work Order.
      */
      IF lt_defects_on_wo.count > 0
       THEN
          --
          lv_str := '<Defect_Repairs_Included>';
          --
          FOR i IN 1..lt_defects_on_wo.count LOOP
            --
            lv_str := lv_str||'<Defect_Repair_Included>'
                              ||'<Defect_ID>'||TO_CHAR(lt_defects_on_wo(i).defect_id)||'</Defect_ID>'
                              ||'<Repair_Type_Code>'||lt_defects_on_wo(i).rep_action_cat||'</Repair_Type_Code>'
                            ||'</Defect_Repair_Included>'
                 ;
            --
            IF length(lv_str) > lv_max_size
             THEN
                lv_response := lv_response||lv_str;
                lv_str := NULL;
            END IF;
            --
          END LOOP;
          --
          lv_response := lv_response||lv_str||'</Defect_Repairs_Included>';
          --
      END IF;
      --
      lv_str := NULL;
      /*
      ||Add The List Of Defects Not On The Work Order.
      */
      IF lt_defects_not_on_wo.count > 0
       THEN
          lv_str := '<Defect_Repairs_Excluded>';
          --
          FOR i IN 1..lt_defects_not_on_wo.count LOOP
            --
            lv_str := lv_str||'<Defect_Repair_Excluded>'
                              ||'<Defect_ID>'||TO_CHAR(lt_defects_not_on_wo(i).defect_id)||'</Defect_ID>'
                              ||'<Repair_Type_Code>'||lt_defects_not_on_wo(i).rep_action_cat||'</Repair_Type_Code>'
                              ||'<Reason>'||escape_xml(lt_defects_not_on_wo(i).reason)||'</Reason>'
                            ||'</Defect_Repair_Excluded>'
                 ;
            --
            IF length(lv_str) > lv_max_size
             THEN
                lv_response := lv_response||lv_str;
                lv_str := NULL;
            END IF;
            --
          END LOOP;
          --
          lv_response := lv_response||lv_str||'</Defect_Repairs_Excluded>';
          --
      END IF;
      /*
      ||Close The Root Element.
      */
      lv_response := lv_response||'</Defect_Work_Order_Created>'||lv_error_xml||'</CreateDefectWorkOrderResponse>';
      --
      lv_retval := xmltype(lv_response);
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'CreateDefectWorkOrderResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'CreateDefectWorkOrderResponse'
                            ,pi_sqlerrm => SQLERRM);
END create_defect_work_order;
--
-----------------------------------------------------------------------------
--
FUNCTION get_instructable_work_orders
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(wor_works_order_no work_orders.wor_works_order_no%TYPE
                           ,wor_descr          work_orders.wor_descr%TYPE
                           ,wor_con_id         work_orders.wor_con_id%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLTYPE;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetInstructableWorkOrdersResponse'||c_xmlns||'><Instructable_Work_Orders>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 500;
  --
BEGIN
  /*
  ||Get the Work Orders that are available to be Instructed.
  */
  SELECT wor_works_order_no
        ,wor_descr
        ,wor_con_id
    BULK COLLECT
    INTO lt_retval
    FROM work_orders
   WHERE wor_flag != 'M'
     AND wor_date_confirmed IS NULL
     AND wor_date_closed IS NULL
     AND wor_con_id IS NOT NULL
     AND NOT EXISTS(SELECT 1
                      FROM work_order_lines
                     WHERE wol_works_order_no = wor_works_order_no
                       AND wol_est_cost IS NULL)
   ORDER
      BY wor_date_raised
           ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Instructable_Work_Order>'
                    ||'<Work_Order_No>'||escape_xml(lt_retval(i).wor_works_order_no)||'</Work_Order_No>'
                    ||'<Work_Order_Description>'||escape_xml(lt_retval(i).wor_descr)||'</Work_Order_Description>'
                    ||'<Contract_Id>'||lt_retval(i).wor_con_id||'</Contract_Id>'
                    ||'</Instructable_Work_Order>'
    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Instructable_Work_Orders></GetInstructableWorkOrdersResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetInstructableWorkOrdersResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_instructable_work_orders;
--
-----------------------------------------------------------------------------
--
FUNCTION instruct_work_order(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)         user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_No',cp_xmlns)   wo_no
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Instructed',cp_xmlns) date_instructed
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  lv_user_id         hig_users.hus_user_id%TYPE;
  lv_works_order_no  work_orders.wor_works_order_no%TYPE;
  lv_date_confirmed  work_orders.wor_date_confirmed%TYPE;
  lv_commit          VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/InstructWorkOrder/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id        := lr_params.user_id;
      lv_works_order_no := lr_params.wo_no;
      lv_date_confirmed := lr_params.date_instructed;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling instruct_work_order');
      mai_api.instruct_work_order(pi_user_id         => lv_user_id
                                 ,pi_works_order_no  => lv_works_order_no
                                 ,pi_date_instructed => NVL(lv_date_confirmed,TRUNC(SYSDATE))
                                 ,pi_commit          => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<InstructWorkOrderResponse'||c_xmlns||'><Work_Order_Instructed>'
                     ||'<Work_Order_No>'||lv_works_order_no||'</Work_Order_No>'
                   ||'</Work_Order_Instructed></InstructWorkOrderResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'InstructWorkOrderResponse'
                            ,pi_sqlerrm => SQLERRM);
END instruct_work_order;
--
-----------------------------------------------------------------------------
--
FUNCTION get_instructed_work_orders
  RETURN xmltype IS
  --
  TYPE retval_rec IS RECORD(wor_works_order_no work_orders.wor_works_order_no%TYPE
                           ,wor_descr          work_orders.wor_descr%TYPE
                           ,wor_con_id         work_orders.wor_con_id%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLTYPE;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetInstructedWorkOrdersResponse'||c_xmlns||'><Instructed_Work_Orders>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 500;
  --
BEGIN
  /*
  ||Get the Work Orders that are available to be Instructed.
  */
  SELECT wor_works_order_no
        ,wor_descr
        ,wor_con_id
    BULK COLLECT
    INTO lt_retval
    FROM work_orders
   WHERE wor_flag != 'M'
     AND wor_date_confirmed IS NOT NULL
     AND wor_date_closed IS NULL
     AND wor_con_id IS NOT NULL
   ORDER
      BY wor_date_raised
           ;
  --
  IF lt_retval.count = 0
   THEN
      raise no_data_found;
  END IF;
  --
  FOR i IN 1..lt_retval.count LOOP
    --
    lv_str := lv_str||'<Instructed_Work_Order>'
                    ||'<Work_Order_No>'||escape_xml(lt_retval(i).wor_works_order_no)||'</Work_Order_No>'
                    ||'<Work_Order_Description>'||escape_xml(lt_retval(i).wor_descr)||'</Work_Order_Description>'
                    ||'<Contract_Id>'||lt_retval(i).wor_con_id||'</Contract_Id>'
                    ||'</Instructed_Work_Order>'
    ;
    --
    IF length(lv_str) > lv_max_size
     THEN
        lv_clob := lv_clob||lv_str;
        lv_str := NULL;
    END IF;
    --
  END LOOP;
  --
  lv_clob := lv_clob||lv_str||'</Instructed_Work_Orders></GetInstructedWorkOrdersResponse>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetInstructedWorkOrdersResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_instructed_work_orders;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_order_details(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'Work_Order_No',cp_xmlns) wo_no
    FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  TYPE work_order_rec IS RECORD(works_order_no     work_orders.wor_works_order_no%TYPE
                               ,road_group_id      work_orders.wor_rse_he_id_group%TYPE
                               ,road_group_type    nm_elements.ne_gty_group_type%TYPE
                               ,road_group_unique  nm_elements.ne_unique%TYPE
                               ,con_id             work_orders.wor_con_id%TYPE
                               ,date_confirmed     work_orders.wor_date_confirmed%TYPE
                               ,date_closed        work_orders.wor_date_closed%TYPE
                               ,actual_cost        NUMBER
                               ,wor_status         VARCHAR2(20)
                               ,received           VARCHAR2(1));
  lr_work_order work_order_rec;
  --
  lv_works_order_no work_orders.wor_works_order_no%TYPE;
  --
  lv_retval XMLTYPE;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<GetWorkOrderDetailsResponse'||c_xmlns||'><Work_Order>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 500;
  --
  FUNCTION get_boqs(pi_wol_id IN work_order_lines.wol_id%TYPE)
    RETURN CLOB IS
    --
    lv_retval CLOB;
    lv_str    nm3type.max_varchar2;
    --
    TYPE boq_tab IS TABLE OF boq_items%ROWTYPE;
    lt_boqs boq_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_boqs
      FROM boq_items
     WHERE boq_wol_id = pi_wol_id
         ;
    --
    IF lt_boqs.count > 0
     THEN
        --
        FOR j IN 1..lt_boqs.count LOOP
          --
          lv_str := '<Boq_Item>'
                    ||gen_tags(0,'Boq_Id',TO_CHAR(lt_boqs(j).boq_id),'N')
                    ||gen_tags(0,'Parent_Boq_Id',TO_CHAR(lt_boqs(j).boq_id),'N')
                    ||gen_tags(0,'Item_Code',escape_xml(lt_boqs(j).boq_sta_item_code),'N')
                    ||gen_tags(0,'EstimatedDimension1',TO_CHAR(lt_boqs(j).boq_est_dim1),'N')
                    ||gen_tags(0,'EstimatedDimension2',TO_CHAR(lt_boqs(j).boq_est_dim2),'N')
                    ||gen_tags(0,'EstimatedDimension3',TO_CHAR(lt_boqs(j).boq_est_dim3),'N')
                    ||gen_tags(0,'EstimatedQuantity',TO_CHAR(lt_boqs(j).boq_est_quantity),'N')
                    ||gen_tags(0,'EstimatedRate',TO_CHAR(lt_boqs(j).boq_est_rate),'N')
                    ||gen_tags(0,'EstimatedCost',TO_CHAR(lt_boqs(j).boq_est_cost),'N')
                    ||gen_tags(0,'ActualDimension1',TO_CHAR(lt_boqs(j).boq_act_dim1),'N')
                    ||gen_tags(0,'ActualDimension2',TO_CHAR(lt_boqs(j).boq_act_dim2),'N')
                    ||gen_tags(0,'ActualDimension3',TO_CHAR(lt_boqs(j).boq_act_dim3),'N')
                    ||gen_tags(0,'ActualQuantity',TO_CHAR(lt_boqs(j).boq_act_quantity),'N')
                    ||gen_tags(0,'ActualRate',TO_CHAR(lt_boqs(j).boq_act_rate),'N')
                    ||gen_tags(0,'ActualCost',TO_CHAR(lt_boqs(j).boq_act_cost),'N')
                  ||'</Boq_Item>'
                  ;
          --
          lv_retval := lv_retval||lv_str;
          --
        END LOOP;
        --
    END IF;
    --
    RETURN lv_retval;
    --
  END get_boqs;
  --
  FUNCTION get_wols(pi_work_order_no IN work_orders.wor_works_order_no%TYPE)
    RETURN CLOB IS
    --
    lv_retval CLOB;
    lv_str    nm3type.max_varchar2;
    --
    TYPE wol_tab IS TABLE OF work_order_lines%ROWTYPE;
    lt_wols wol_tab;
    --
    lv_defect_code defects.def_defect_code%TYPE;
    lv_priority    defects.def_priority%TYPE;
    lv_treatment   repairs.rep_tre_treat_code%TYPE;
    --
    PROCEDURE get_defect_repair(pi_defect_id  IN defects.def_defect_id%TYPE
                               ,pi_action_cat IN repairs.rep_action_cat%TYPE)
      IS
    BEGIN
      SELECT def_defect_code
            ,def_priority
            ,rep_tre_treat_code
        INTO lv_defect_code
            ,lv_priority
            ,lv_treatment
        FROM repairs
            ,defects
       WHERE def_defect_id = pi_defect_id
         AND def_defect_id = rep_def_defect_id
         AND rep_action_cat = pi_action_cat
           ;
    EXCEPTION
      WHEN no_data_found
       THEN
          lv_defect_code := NULL;
          lv_priority    := NULL;
          lv_treatment   := NULL;
      WHEN others
       THEN
          RAISE;
    END get_defect_repair;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_wols
      FROM work_order_lines
     WHERE wol_works_order_no = pi_work_order_no
         ;
    --
    IF lt_wols.count > 0
     THEN
        --
        FOR i IN 1..lt_wols.count LOOP
          --
          get_defect_repair(pi_defect_id  => lt_wols(i).wol_def_defect_id
                           ,pi_action_cat => lt_wols(i).wol_rep_action_cat);
          --
          lv_str := lv_str||'<Work_Order_Line>'
                          ||gen_tags(0,'Work_Order_Line_Id',TO_CHAR(lt_wols(i).wol_id),'N')
                          ||gen_tags(0,'Defect_ID',TO_CHAR(lt_wols(i).wol_def_defect_id),'N')
                          ||gen_tags(0,'Section_Id',TO_CHAR(lt_wols(i).wol_rse_he_id),'N')
                          ||gen_tags(0,'Section_Unique',nm3get.get_ne(pi_ne_id => lt_wols(i).wol_rse_he_id).ne_unique,'N')
                          ||gen_tags(0,'Work_Order_Line_Status',lt_wols(i).wol_status_code,'N')
                          ||gen_tags(0,'Defect_Code',lv_defect_code,'N')
                          ||gen_tags(0,'Priority_Code',lv_priority,'N')
                          ||gen_tags(0,'Date_Complete',datetime_to_varchar(lt_wols(i).wol_date_complete),'N')
                          ||gen_tags(0,'Treatment_Code',lv_treatment,'N')
                          ||gen_tags(0,'EstimatedCost',TO_CHAR(lt_wols(i).wol_est_cost),'N')
                          ||gen_tags(0,'ActualCost',TO_CHAR(lt_wols(i).wol_act_cost),'N')
                  ;
          --
          lv_retval := lv_retval||lv_str;
          lv_retval := lv_retval||get_boqs(pi_wol_id => lt_wols(i).wol_id)||'</Work_Order_Line>';
          lv_str := NULL;
          --
        END LOOP;
        --
    END IF;
    --
    RETURN lv_retval;
    --
  END get_wols;
  --
BEGIN
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/GetWorkOrderDetails/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_works_order_no := lr_params.wo_no;
      /*
      ||Get the Work Order Details.
      */
      SELECT wor.wor_works_order_no
            ,wor.wor_rse_he_id_group
            ,ne.ne_gty_group_type
            ,ne.ne_unique
            ,wor.wor_con_id
            ,wor.wor_date_confirmed
            ,wor.wor_date_closed
            ,wor.wor_act_cost + wor_act_balancing_sum actual_cost
            ,wos.wor_status
            ,DECODE(wor.wor_date_received,NULL,'N','Y') received
        INTO lr_work_order
        FROM nm_elements ne
            ,work_orders wor
            ,(SELECT wol_works_order_no
                    ,CASE WHEN paid = wols
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature4 = 'Y'
                                    AND hsc_allow_feature9 != 'Y'
                                    AND rownum = 1) -- PAID 
                          WHEN paid > 0
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature4 = 'Y'
                                    AND hsc_allow_feature9 = 'Y'
                                    AND rownum = 1) --PART PAID 
                          WHEN completed = wols
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature3 = 'Y'
                                    AND rownum = 1) --COMPLETED 
                          WHEN completed > 0
                            OR part_complete > 0
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature6 = 'Y'
                                    AND rownum = 1)  --PART COMPL 
                          WHEN instructed = wols
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature1 = 'Y'
                                    AND rownum = 1) --INSTRUCTED 
                          WHEN actioned > 0
                           THEN (SELECT hsc_status_code
                                   FROM hig_status_codes
                                  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                                    AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                                                           AND NVL(hsc_end_date,TRUNC(SYSDATE))
                                    AND hsc_allow_feature7 = 'Y'
                                    AND rownum = 1) --ACTIONED 
                          ELSE 'UNKNOWN'
                     END wor_status
                FROM (SELECT wol_works_order_no
                            ,COUNT(wol_id) wols
                            ,SUM(DECODE(hsc_allow_feature1, 'Y', 1, 0)) instructed
                            ,SUM(DECODE(hsc_allow_feature2, 'Y', 1, 0)) + SUM(DECODE(hsc_allow_feature3, 'Y', 1, 0)) completed
                            ,SUM(DECODE(hsc_allow_feature4, 'Y', DECODE(hsc_allow_feature9, 'Y', 0, 1), 0)) paid
                            ,SUM(DECODE(hsc_allow_feature8, 'Y', 1, 0)) + SUM(DECODE(hsc_allow_feature9, 'Y', 1,0)) part_complete
                            ,SUM(DECODE(hsc_allow_feature7, 'Y', 1,0)) actioned
                        FROM work_order_lines
                            ,hig_status_codes
                       WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                         AND hsc_allow_feature5 != 'Y'
                         AND hsc_status_code = wol_status_code 
                       GROUP
                          BY wol_works_order_no)) wos
      WHERE wos.wol_works_order_no = wor.wor_works_order_no
        AND wor.wor_works_order_no = lr_params.wo_no
        AND wor.wor_rse_he_id_group = ne.ne_id
          ;
      --
      IF lr_work_order.works_order_no IS NULL
       THEN
          raise no_data_found;
      END IF;
      --
      lv_str := lv_str||gen_tags(0,'Work_Order_No',lr_work_order.works_order_no,'N')
                      ||gen_tags(0,'Contract_Id',TO_CHAR(lr_work_order.con_id),'N') 
                      ||gen_tags(0,'Road_Group_Id',TO_CHAR(lr_work_order.road_group_id),'N') 
                      ||gen_tags(0,'Road_Group_Type',lr_work_order.road_group_type,'N') 
                      ||gen_tags(0,'Road_Group_Unique',lr_work_order.road_group_unique,'N') 
                      ||gen_tags(0,'Date_Instructed',date_to_varchar(lr_work_order.date_confirmed),'N') 
                      ||gen_tags(0,'Date_Complete',date_to_varchar(lr_work_order.date_closed),'N') 
                      ||gen_tags(0,'ActualCost',TO_CHAR(lr_work_order.actual_cost),'N') 
                      ||gen_tags(0,'Work_Order_Status',lr_work_order.wor_status,'N') 
                      ||gen_tags(0,'Received',lr_work_order.received,'N') 
        ;
      --
      lv_clob := lv_clob||lv_str;
      --
      lv_clob := lv_clob||get_wols(pi_work_order_no => lr_params.wo_no)||'</Work_Order></GetWorkOrderDetailsResponse>';
      --
      lv_retval := xmltype(lv_clob);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'GetWorkOrderDetailsResponse'
                            ,pi_sqlerrm => SQLERRM);
END get_work_order_details;
--
-----------------------------------------------------------------------------
--
FUNCTION receive_work_order(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)       user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_No',cp_xmlns) wo_no
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Received',cp_xmlns) date_received
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  lv_user_id         hig_users.hus_user_id%TYPE;
  lv_works_order_no  work_orders.wor_works_order_no%TYPE;
  lv_date_received   work_orders.wor_date_received%TYPE;
  lv_commit          VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/SetWorkOrderReceived/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id        := lr_params.user_id;
      lv_works_order_no := lr_params.wo_no;
      IF lr_params.date_received IS NOT NULL
       THEN
          lv_date_received  := varchar_to_datetime(lr_params.date_received);
      END IF;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling receive_work_order');
      mai_api.receive_work_order(pi_user_id        => lv_user_id
                                ,pi_works_order_no => lv_works_order_no
                                ,pi_date_received  => NVL(lv_date_received,SYSDATE)
                                ,pi_commit         => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<SetWorkOrderReceivedResponse'||c_xmlns||'><Work_Order_Received>'
                     ||'<Work_Order_No>'||lv_works_order_no||'</Work_Order_No>'
                   ||'</Work_Order_Received></SetWorkOrderReceivedResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'SetWorkOrderReceivedResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'SetWorkOrderReceivedResponse'
                            ,pi_sqlerrm => SQLERRM);
END receive_work_order;
--
-----------------------------------------------------------------------------
--
FUNCTION set_work_order_line_held(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)            user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Line_Id',cp_xmlns) wol_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Held',cp_xmlns)          date_held
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  lv_user_id    hig_users.hus_user_id%TYPE;
  lv_wol_id     work_order_lines.wol_id%TYPE;
  lv_date_held  work_order_lines.wol_date_complete%TYPE;
  lv_commit     VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/SetWorkOrderLineHeld/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id   := lr_params.user_id;
      lv_wol_id    := lr_params.wol_id;
      IF lr_params.date_held IS NOT NULL
       THEN
          lv_date_held := varchar_to_datetime(lr_params.date_held);
      END IF;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling set_wol_held');
      mai_api.set_wol_held(pi_user_id       => lv_user_id
                          ,pi_wol_id        => lv_wol_id
                          ,pi_date_complete => lv_date_held
                          ,pi_commit        => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<SetWorkOrderLineHeldResponse'||c_xmlns||'><WorkOrderLineHeld>'
                     ||'<Work_Order_Line_Id>'||lv_wol_id||'</Work_Order_Line_Id>'
                   ||'</WorkOrderLineHeld></SetWorkOrderLineHeldResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'SetWorkOrderLineHeldResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'SetWorkOrderLineHeldResponse'
                            ,pi_sqlerrm => SQLERRM);
END set_work_order_line_held;
--
-----------------------------------------------------------------------------
--
FUNCTION set_work_order_line_not_done(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)            user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Line_Id',cp_xmlns) wol_id
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  lv_user_id  hig_users.hus_user_id%TYPE;
  lv_wol_id   work_order_lines.wol_id%TYPE;
  lv_commit   VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/SetWorkOrderLineNotDone/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id := lr_params.user_id;
      lv_wol_id  := lr_params.wol_id;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling set_wol_not_done');
      mai_api.set_wol_not_done(pi_user_id => lv_user_id
                              ,pi_wol_id  => lv_wol_id
                              ,pi_commit  => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<SetWorkOrderLineNotDoneResponse'||c_xmlns||'><WorkOrderLineNotDone>'
                     ||'<Work_Order_Line_Id>'||lv_wol_id||'</Work_Order_Line_Id>'
                   ||'</WorkOrderLineNotDone></SetWorkOrderLineNotDoneResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'SetWorkOrderLineNotDoneResponse'
                            ,pi_sqlerrm => SQLERRM);
END set_work_order_line_not_done;
--
-----------------------------------------------------------------------------
--
FUNCTION create_interim_payment(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)            user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Line_Id',cp_xmlns) wol_id
        ,EXTRACT(cp_xml,cp_root||'ActualBoqs',cp_xmlns)              boqs_in_xml
    FROM dual
       ;
  --
  lr_params get_params%ROWTYPE;
  --
  CURSOR get_boq_list(cp_xml   IN XMLTYPE
                     ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'ActualBoq/Boq_Id',cp_xmlns)            boq_id
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Item_Code',cp_xmlns)         item_code
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension1',cp_xmlns)        dim1
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension2',cp_xmlns)        dim2
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension3',cp_xmlns)        dim3
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Add_Percent_Item',cp_xmlns)  add_percent
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Percent_Item_Code',cp_xmlns) perc_item_code
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/ActualBoqs/ActualBoq',cp_xmlns))) x
      ;
  --
  TYPE get_boq_list_tab IS TABLE OF get_boq_list%ROWTYPE;
  lt_get_boq_list get_boq_list_tab;
  --
  lv_user_id  hig_users.hus_user_id%TYPE;
  lv_wol_id   work_order_lines.wol_id%TYPE;
  lt_boq_tab  mai_api.act_boq_tab;
  lv_commit   VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/CreateInterimPayment/InterimPayment/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id := lr_params.user_id;
      lv_wol_id  := lr_params.wol_id;
      /*
      ||Transform The List Of Defects.
      */
      OPEN  get_boq_list(lr_params.boqs_in_xml
                        ,c_xmlns);
      FETCH get_boq_list
       BULK COLLECT
       INTO lt_get_boq_list;
      CLOSE get_boq_list;
      --
      FOR i IN 1..lt_get_boq_list.count LOOP
        --
        nm_debug.debug('Assigning BOQ params');
        lt_boq_tab(i).boq_id            := lt_get_boq_list(i).boq_id;
        lt_boq_tab(i).boq_sta_item_code := lt_get_boq_list(i).item_code;
        lt_boq_tab(i).boq_act_dim1      := lt_get_boq_list(i).dim1;
        lt_boq_tab(i).boq_act_dim2      := lt_get_boq_list(i).dim2;
        lt_boq_tab(i).boq_act_dim3      := lt_get_boq_list(i).dim3;
        lt_boq_tab(i).add_percent_item  := lt_get_boq_list(i).add_percent;
        lt_boq_tab(i).percent_item_code := lt_get_boq_list(i).perc_item_code;
        --
      END LOOP;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling create_interim_payment');
      mai_api.create_interim_payment(pi_user_id => lv_user_id
                                    ,pi_wol_id  => lv_wol_id
                                    ,pi_boq_tab => lt_boq_tab
                                    ,pi_commit  => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<CreateInterimPaymentResponse'||c_xmlns||'><InterimPaymentCreated>'
                     ||'<Work_Order_Line_Id>'||lv_wol_id||'</Work_Order_Line_Id>'
                   ||'</InterimPaymentCreated></CreateInterimPaymentResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'CreateInterimPaymentResponse'
                            ,pi_sqlerrm => SQLERRM);
END create_interim_payment;
--
-----------------------------------------------------------------------------
--
FUNCTION complete_work_order_line(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)            user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_Line_Id',cp_xmlns) wol_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Complete',cp_xmlns)      date_complete
        ,EXTRACT(cp_xml,cp_root||'ActualBoqs',cp_xmlns)              boqs_in_xml
    FROM dual
       ;
  --
  lr_params get_params%ROWTYPE;
  --
  CURSOR get_boq_list(cp_xml   IN XMLTYPE
                     ,cp_xmlns IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(VALUE(x),'ActualBoq/Boq_Id',cp_xmlns)            boq_id
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Item_Code',cp_xmlns)         item_code
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension1',cp_xmlns)        dim1
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension2',cp_xmlns)        dim2
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Dimension3',cp_xmlns)        dim3
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Add_Percent_Item',cp_xmlns)  add_percent
        ,EXTRACTVALUE(VALUE(x),'ActualBoq/Percent_Item_Code',cp_xmlns) perc_item_code
    FROM TABLE(xmlsequence(EXTRACT(cp_xml,'/ActualBoqs/ActualBoq',cp_xmlns))) x
      ;
  --
  TYPE get_boq_list_tab IS TABLE OF get_boq_list%ROWTYPE;
  lt_get_boq_list get_boq_list_tab;
  --
  lv_user_id        hig_users.hus_user_id%TYPE;
  lv_wol_id         work_order_lines.wol_id%TYPE;
  lv_date_complete  work_order_lines.wol_date_complete%TYPE;
  lt_boq_tab        mai_api.act_boq_tab;
  lv_commit         VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/CompleteWorkOrderLine/WorkOrderLineToComplete/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id       := lr_params.user_id;
      lv_wol_id        := lr_params.wol_id;
      IF lr_params.date_complete IS NOT NULL
       THEN
          lv_date_complete := varchar_to_datetime(lr_params.date_complete);
      END IF;
      /*
      ||Transform The List Of BOQs.
      */
      OPEN  get_boq_list(lr_params.boqs_in_xml
                        ,c_xmlns);
      FETCH get_boq_list
       BULK COLLECT
       INTO lt_get_boq_list;
      CLOSE get_boq_list;
      --
      FOR i IN 1..lt_get_boq_list.count LOOP
        --
        nm_debug.debug('Assigning BOQ params');
        lt_boq_tab(i).boq_id            := lt_get_boq_list(i).boq_id;
        lt_boq_tab(i).boq_sta_item_code := lt_get_boq_list(i).item_code;
        lt_boq_tab(i).boq_act_dim1      := lt_get_boq_list(i).dim1;
        lt_boq_tab(i).boq_act_dim2      := lt_get_boq_list(i).dim2;
        lt_boq_tab(i).boq_act_dim3      := lt_get_boq_list(i).dim3;
        lt_boq_tab(i).add_percent_item  := lt_get_boq_list(i).add_percent;
        lt_boq_tab(i).percent_item_code := lt_get_boq_list(i).perc_item_code;
        --
      END LOOP;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling complete_wol');
      mai_api.complete_wol(pi_user_id       => lv_user_id
                          ,pi_wol_id        => lv_wol_id
                          ,pi_date_complete => lv_date_complete
                          ,pi_boq_tab       => lt_boq_tab
                          ,pi_commit        => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<CompleteWorkOrderLineResponse'||c_xmlns||'><WorkOrderLineCompleted>'
                     ||'<Work_Order_Line_Id>'||lv_wol_id||'</Work_Order_Line_Id>'
                   ||'</WorkOrderLineCompleted></CompleteWorkOrderLineResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  --
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'CompleteWorkOrderLineResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'CompleteWorkOrderLineResponse'
                            ,pi_sqlerrm => SQLERRM);
END complete_work_order_line;
--
-----------------------------------------------------------------------------
--
FUNCTION complete_work_order(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_params(cp_xml    IN XMLTYPE
                   ,cp_root   IN VARCHAR2
                   ,cp_xmlns  IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,cp_root||'User_Id',cp_xmlns)       user_id
        ,EXTRACTVALUE(cp_xml,cp_root||'Work_Order_No',cp_xmlns) wo_no
        ,EXTRACTVALUE(cp_xml,cp_root||'Date_Complete',cp_xmlns) date_complete
   FROM dual
      ;
  --
  lr_params get_params%ROWTYPE;
  --
  lv_user_id         hig_users.hus_user_id%TYPE;
  lv_works_order_no  work_orders.wor_works_order_no%TYPE;
  lv_date_complete   work_order_lines.wol_date_complete%TYPE;
  lv_commit          VARCHAR2(1) := 'Y';
  --
  lv_response  CLOB;
  lv_retval    XMLTYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('XML : '||pi_xml.getstringval);
  IF valid_xml(pi_xml     => pi_xml
              ,pi_xsd_uri => c_xsd_uri)
   THEN
      nm_debug.debug('Getting params');
      /*
      ||Transform The Input XML
      */
      OPEN  get_params(pi_xml
                      ,'/CompleteWorkOrder/'
                      ,c_xmlns);
      FETCH get_params
       INTO lr_params;
      CLOSE get_params;
      --
      lv_user_id        := lr_params.user_id;
      lv_works_order_no := lr_params.wo_no;
      IF lr_params.date_complete IS NOT NULL
       THEN
          lv_date_complete  := varchar_to_datetime(lr_params.date_complete);
      END IF;
      /*
      ||Call The API To Create The Work Order.
      */
      nm_debug.debug('Calling complete_wor');
      mai_api.complete_wor(pi_user_id        => lv_user_id
                          ,pi_works_order_no => lv_works_order_no
                          ,pi_date_complete  => NVL(lv_date_complete,SYSDATE)
                          ,pi_commit         => lv_commit);
      /*
      ||Build The Output XML.
      */
      nm_debug.debug('Building Output XML');
      /*
      ||Add The Root Element And The Work Order Number.
      */
      lv_response := '<CompleteWorkOrderResponse'||c_xmlns||'><Work_Order_Completed>'
                     ||'<Work_Order_No>'||lv_works_order_no||'</Work_Order_No>'
                   ||'</Work_Order_Completed></CompleteWorkOrderResponse>';
      --
      lv_retval := xmltype(lv_response);
      --
  ELSE
      /*
      ||Invalid XML error.
      */
      raise_application_error(-20000,'Invalid input XML supplied.');
      --
  END IF;
  /*
  ||Return The Output XML.
  */
  nm_debug.debug_off;
  RETURN lv_retval;
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml(pi_wrapper => 'CompleteWorkOrderResponse'
                            ,pi_sqlerrm => 'Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(pi_wrapper => 'CompleteWorkOrderResponse'
                            ,pi_sqlerrm => SQLERRM);
END complete_work_order;
--
-----------------------------------------------------------------------------
--
END mai_web_service;
/