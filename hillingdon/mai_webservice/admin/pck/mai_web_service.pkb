set define off
CREATE OR REPLACE PACKAGE BODY mai_web_service AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/pck/pck/mai_web_service.pkb-arc   1.3   Sep 01 2008 18:41:52   mhuitson  $
--       Module Name      : $Workfile:   mai_web_service.pkb  $
--       Date into PVCS   : $Date:   Sep 01 2008 18:41:52  $
--       Date fetched Out : $Modtime:   Sep 01 2008 18:27:46  $
--       PVCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_body_sccsid   CONSTANT  varchar2(2000) := '$Revision:   1.3  $';
  g_package_name  CONSTANT  varchar2(30)   := 'mai_web_service';
  c_date_format   CONSTANT  varchar2(20)   := 'DD-MON-YYYY';
  c_xmlns         CONSTANT  varchar2(50)   := ' xmlns="http://exor_mai_ws/exor_mai_ws"';
  --
  date_format_error EXCEPTION;
/*
|| Errors Raised.
||
||-20010,'Invalid User Id Specified For Inspector.'
||-20043,'Invalid Organisation Specified.'
*/
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
FUNCTION build_error_xml(pi_sqlerrm IN VARCHAR2)
  RETURN xmltype IS
BEGIN
  RETURN xmltype('<error>'||dbms_xmlgen.convert(pi_sqlerrm)||'</error>');
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
                 ,pi_data       IN VARCHAR2)
  RETURN varchar2 IS
  --
  lv_retval  nm3type.max_varchar2;
  lv_indent  nm3type.max_varchar2;
  --
BEGIN
  --
  IF pi_data IS NOT NULL
   THEN
      --
      FOR i IN 1..pi_indent LOOP
        lv_indent := lv_indent||' ';
      END LOOP;
      --
      lv_retval := CHR(10)||lv_indent||'<'||pi_element||'>'||dbms_xmlgen.convert(pi_data)||'</'||pi_element||'>';
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
--FUNCTION get_auto_defect_priority(section_id    IN NUMBER
--                                 ,sys_flag      IN VARCHAR2
--                                 ,activity      IN VARCHAR2
--                                 ,defect_code   IN VARCHAR2)
--  RETURN get_auto_def_priority_out IS
--  --
--  lv_defautopri hig_option_values.hov_value%TYPE
--                := hig.get_user_or_sys_opt('DEFAUTOPRI');
--  lv_priority   defects.def_priority%TYPE;
--  --
--  po_params  get_auto_def_priority_out
--             := get_auto_def_priority_out(NULL,error_out(NULL));
--  --
--BEGIN
--  --
--  IF lv_defautopri IN ('A','B')
--   THEN
--      lv_priority := mai.get_auto_def_priority(p_rse_he_id     => section_id
--                                              ,p_network_type  => sys_flag
--                                              ,p_activity_code => activity
--                                              ,p_defect_code   => defect_code);
--      --
--      po_params.priority := lv_priority;
--      --
--  ELSE
--      --
--      po_params.error := error_out('Automatic Defect Priority Is Not In Use.');
--      --
--  END IF;
--  --
--  RETURN po_params;
--  --
--EXCEPTION
--  WHEN others
--   THEN
--      po_params.error := error_out(SQLERRM);
--      RETURN po_params;
--END get_auto_defect_priority;
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
  lv_str := '<SD_Flags'||c_xmlns||'>'
          ||'<SD_Flag>'
          ||'<Safety_Detailed_Flag>S</Safety_Detailed_Flag>'
          ||'<Description>Safety</Description>'
          ||'</SD_Flag>'
          ||'<SD_Flag>'
          ||'<Safety_Detailed_Flag>D</Safety_Detailed_Flag>'
          ||'<Description>Detailed</Description>'
          ||'</SD_Flag>'
          ||'</SD_Flags>'
          ;
  --
  lv_retval := xmltype(lv_str);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob     CLOB := '<Users'||c_xmlns||'>';
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
                      ||'<Initials>'||dbms_xmlgen.convert(lt_retval(i).hus_initials)||'</Initials>'
                      ||'<User_Name>'||dbms_xmlgen.convert(lt_retval(i).hus_name)||'</User_Name>'
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
  lv_clob := lv_clob||lv_str||'</Users>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob     CLOB := '<Admin_Units'||c_xmlns||'>';
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
                      ||'<Admin_Unit_Code>'||lt_retval(i).hau_unit_code||'</Admin_Unit_Code>'
                      ||'<Admin_Unit_Name>'||dbms_xmlgen.convert(lt_retval(i).hau_name)||'</Admin_Unit_Name>'
                      ||'<Authority_Code>'||lt_retval(i).hau_authority_code||'</Authority_Code>'
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
  lv_clob := lv_clob||lv_str||'</Admin_Units>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob     CLOB := '<Admin_Groups'||c_xmlns||'>';
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
                      ||'<Direct_Link>'||lt_retval(i).hag_direct_link||'</Direct_Link>'
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
  lv_clob := lv_clob||lv_str||'</Admin_Groups>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob     CLOB := '<Road_Sections'||c_xmlns||'>';
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
                      ||'<Section_Unique>'||lt_retval(i).rse_unique||'</Section_Unique>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).rse_descr)||'</Description>'
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
  lv_clob := lv_clob||lv_str||'</Road_Sections>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Asset_Types'||c_xmlns||'>';
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
                      ||'<Asset_Type_Code>'||lt_retval(i).nit_inv_type||'</Asset_Type_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).nit_descr)||'</Description>'
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
  lv_clob := lv_clob||'</Asset_Types>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Asset_Attributes'||c_xmlns||'>';
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
                      ||'<Asset_Type_Code>'||lt_retval(i).ita_inv_type||'</Asset_Type_Code>'
                      ||'<Attribute_Name>'||dbms_xmlgen.convert(lt_retval(i).ita_scrn_text)||'</Attribute_Name>'
                      ||'<Asset_Column>'||lt_retval(i).ita_attrib_name||'</Asset_Column>'
                      ||'<Datatype>'||lt_retval(i).ita_format||'</Datatype>'
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
  lv_clob := lv_clob||'</Asset_Attributes>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_asset_type_attribs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_ids(pi_asset_type IN nm_inv_types_all.nit_inv_type%TYPE)
  RETURN xmltype IS
  --
  TYPE retval_tab IS TABLE OF nm_inv_items_all.iit_ne_id%TYPE;
  lt_retval retval_tab;
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<Assets'||c_xmlns||'>';
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 50;
  --
BEGIN
  --
  SELECT iit_ne_id
    BULK COLLECT
    INTO lt_retval
    FROM nm_inv_items_all
   WHERE iit_inv_type = pi_asset_type
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
  lv_clob := lv_clob||lv_str||'</Assets>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_asset_ids;
--
-----------------------------------------------------------------------------
--
FUNCTION get_modified_asset_ids(pi_asset_type    IN nm_inv_types_all.nit_inv_type%TYPE
                               ,pi_modified_date IN VARCHAR2)
  RETURN xmltype IS
  --
  TYPE retval_tab IS TABLE OF nm_inv_items_all.iit_ne_id%TYPE;
  --
  lt_retval   retval_tab;
  lv_retval   XMLType;
  lv_str      nm3type.max_varchar2;
  lv_clob     CLOB := '<Assets'||c_xmlns||'>';
  lv_mod_date DATE;
  lv_max_size PLS_INTEGER := nm3type.c_max_varchar2_size - 50;
  --
BEGIN
  --
  lv_mod_date := varchar_to_date(pi_modified_date);
  --
  SELECT iit_ne_id
    BULK COLLECT
    INTO lt_retval
    FROM nm_inv_items_all
   WHERE iit_inv_type = pi_asset_type
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
  lv_clob := lv_clob||lv_str||'</Assets>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_modified_asset_ids;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_details(pi_asset_id IN nm_inv_items_all.iit_ne_id%TYPE)
  RETURN xmltype IS
  --
  lr_retval nm_inv_items_all%ROWTYPE;
  lv_str    CLOB;
  lv_retval XMLType;
  --
BEGIN
  --
  SELECT *
    INTO lr_retval
    FROM nm_inv_items_all
   WHERE iit_ne_id = pi_asset_id
       ;
  --
  lv_str := lv_str||'  <AssetDetails'||c_xmlns||'>'
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
                  ||CHR(10)||'  </AssetDetails>';
  --
  lv_retval := xmltype(lv_str);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Initiation_Types'||c_xmlns||'>';
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
                      ||'<Initiation_Code>'||lt_retval(i).hco_code||'</Initiation_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).hco_meaning)||'</Description>'
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
  lv_clob := lv_clob||'</Initiation_Types>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Repair_Types'||c_xmlns||'>';
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
                      ||'<Repair_Type_Code>'||lt_retval(i).hco_code||'</Repair_Type_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).hco_meaning)||'</Description>'
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
  lv_clob := lv_clob||'</Repair_Types>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<NWActivities'||c_xmlns||'>';
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
                      ||'<Activity_Code>'||lt_retval(i).atv_acty_area_code||'</Activity_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).atv_descr)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).atv_dtp_flag||'</Sys_Flag>'
                      ||'<Safety_Detailed_Flag>'||lt_retval(i).atv_maint_insp_flag||'</Safety_Detailed_Flag>'
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
  lv_clob := lv_clob||'</NWActivities>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<AssetActivities'||c_xmlns||'>';
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
                      ||'<Activity_Code>'||lt_retval(i).mia_atv_acty_area_code||'</Activity_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).atv_descr)||'</Description>'
                      ||'<Asset_Type_Code>'||lt_retval(i).mia_nit_inv_type||'</Asset_Type_Code>'
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
  lv_clob := lv_clob||'</AssetActivities>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Priorities'||c_xmlns||'>';
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
                      ||'<Priority_Code>'||lt_retval(i).dpr_priority||'</Priority_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).hco_meaning)||'</Description>'
                      ||'<Activity_Code>'||lt_retval(i).dpr_atv_acty_area_code||'</Activity_Code>'
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
  lv_clob := lv_clob||'</Priorities>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Treatments'||c_xmlns||'>';
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
                      ||'<Treatment_Code>'||lt_retval(i).tre_treat_code||'</Treatment_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).tre_descr)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).dtr_sys_flag ||'</Sys_Flag>'
                      ||'<Activity_Code>'||lt_retval(i).dtr_dty_acty_area_code||'</Activity_Code>'
                      ||'<Defect_Code>'||lt_retval(i).dtr_dty_defect_code||'</Defect_Code>'
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
  lv_clob := lv_clob||'</Treatments>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Defect_Types'||c_xmlns||'>';
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
                      ||'<Defect_Code>'||lt_retval(i).dty_defect_code||'</Defect_Code>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).dty_descr1)||'</Description>'
                      ||'<Sys_Flag>'||lt_retval(i).dty_dtp_flag||'</Sys_Flag>'
                      ||'<Activity_Code>'||lt_retval(i).dty_atv_acty_area_code||'</Activity_Code>'
                      ||'<Attribute1>'||lt_retval(i).dty_hh_attri_text_1||'</Attribute1>'
                      ||'<Attribute1_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_1)||'</Attribute1_Datatype>'
                      ||'<Attribute1_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_1)||'</Attribute1_Length>'
                      ||'<Attribute1_Format>'||get_attr_format(lt_retval(i).dty_hh_attribute_1)||'</Attribute1_Format>'
                      ||'<Attribute2>'||lt_retval(i).dty_hh_attri_text_2||'</Attribute2>'
                      ||'<Attribute2_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_2)||'</Attribute2_Datatype>'
                      ||'<Attribute2_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_2)||'</Attribute2_Length>'
                      ||'<Attribute2_Format>'||get_attr_format(lt_retval(i).dty_hh_attribute_2)||'</Attribute2_Format>'
                      ||'<Attribute3>'||lt_retval(i).dty_hh_attri_text_3||'</Attribute3>'
                      ||'<Attribute3_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_3)||'</Attribute3_Datatype>'
                      ||'<Attribute3_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_3)||'</Attribute3_Length>'
                      ||'<Attribute3_Format>'||get_attr_format(lt_retval(i).dty_hh_attribute_3)||'</Attribute3_Format>'
                      ||'<Attribute4>'||lt_retval(i).dty_hh_attri_text_4||'</Attribute4>'
                      ||'<Attribute4_Datatype>'||get_attr_datatype(lt_retval(i).dty_hh_attribute_4)||'</Attribute4_Datatype>'
                      ||'<Attribute4_Length>'||get_attr_length(lt_retval(i).dty_hh_attribute_4)||'</Attribute4_Length>'
                      ||'<Attribute4_Format>'||get_attr_format(lt_retval(i).dty_hh_attribute_4)||'</Attribute4_Format>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).dty_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).dty_end_date)||'</Enddate>'
                    ||'</Defect_Type>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Defect_Types>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Siss_Codes'||c_xmlns||'>';
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
                      ||'<Siss_Id>'||lt_retval(i).siss_id||'</Siss_Id>'
                      ||'<Description>'||dbms_xmlgen.convert(lt_retval(i).siss_name)||'</Description>'
                      ||'<Startdate>'||date_to_varchar(lt_retval(i).siss_start_date)||'</Startdate>'
                      ||'<Enddate>'||date_to_varchar(lt_retval(i).siss_end_date)||'</Enddate>'
                    ||'</Siss_Code>';
    lv_str := lv_str;
    --
    lv_clob := lv_clob||lv_str;
    --
  END LOOP;
  --
  lv_clob := lv_clob||'</Siss_Codes>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_siss_codes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_items
  RETURN xmltype IS
  --
  lv_perc_item  hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  --
  TYPE retval_rec IS RECORD(sta_item_code    standard_items.sta_item_code%TYPE
                           ,sta_item_name    standard_items.sta_item_name%TYPE
                           ,sta_unit         standard_items.sta_unit%TYPE
                           ,sta_rate         standard_items.sta_rate%TYPE
                           ,sta_labour_units standard_items.sta_labour_units%TYPE
                           ,sta_max_quantity standard_items.sta_max_quantity%TYPE
                           ,sta_min_quantity standard_items.sta_min_quantity%TYPE
                           ,sta_dim1_text    standard_items.sta_dim1_text%TYPE
                           ,sta_dim2_text    standard_items.sta_dim2_text%TYPE
                           ,sta_dim3_text    standard_items.sta_dim3_text%TYPE
                           ,sta_start_date   standard_items.sta_start_date%TYPE
                           ,sta_end_date     standard_items.sta_end_date%TYPE);
  TYPE retval_tab IS TABLE OF retval_rec;
  lt_retval retval_tab;
  --
  lv_retval XMLType;
  lv_str    nm3type.max_varchar2;
  lv_clob   CLOB := '<Standard_Items'||c_xmlns||'>';
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
                      ||'<Item_Code>'||lt_retval(i).sta_item_code||'</Item_Code>'
                      ||'<Item_Name>'||dbms_xmlgen.convert(lt_retval(i).sta_item_name)||'</Item_Name>'
                      ||'<Unit>'||lt_retval(i).sta_unit||'</Unit>'
                      ||'<Rate>'||TO_CHAR(lt_retval(i).sta_rate)||'</Rate>'
                      ||'<Labour_Units>'||TO_CHAR(lt_retval(i).sta_labour_units)||'</Labour_Units>'
                      ||'<Max_Quantity>'||TO_CHAR(lt_retval(i).sta_max_quantity)||'</Max_Quantity>'
                      ||'<Min_Quantity>'||TO_CHAR(lt_retval(i).sta_min_quantity)||'</Min_Quantity>'
                      ||'<Dimension1_Name>'||dbms_xmlgen.convert(lt_retval(i).sta_dim1_text)||'</Dimension1_Name>'
                      ||'<Dimension2_Name>'||dbms_xmlgen.convert(lt_retval(i).sta_dim2_text)||'</Dimension2_Name>'
                      ||'<Dimension3_Name>'||dbms_xmlgen.convert(lt_retval(i).sta_dim3_text)||'</Dimension3_Name>'
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
  lv_clob := lv_clob||lv_str||'</Standard_Items>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_standard_items;
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
  lv_clob   CLOB := '<Notify_Orgs'||c_xmlns||'>';
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
                      ||'<Org_Code>'||lt_retval(i).oun_unit_code||'</Org_Code>'
                      ||'<Org_Name>'||dbms_xmlgen.convert(lt_retval(i).oun_name)||'</Org_Name>'
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
  lv_clob := lv_clob||lv_str||'</Notify_Orgs>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
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
  lv_clob   CLOB := '<Recharge_Orgs'||c_xmlns||'>';
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
                      ||'<Org_Code>'||lt_retval(i).oun_unit_code||'</Org_Code>'
                      ||'<Org_Name>'||dbms_xmlgen.convert(lt_retval(i).oun_name)||'</Org_Name>'
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
  lv_clob := lv_clob||lv_str||'</Recharge_Orgs>';
  --
  lv_retval := xmltype(lv_clob);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END get_recharge_orgs;
--
-----------------------------------------------------------------------------
--
FUNCTION create_adhoc_defect(pi_xml IN xmltype)
  RETURN xmltype IS
  --
  CURSOR get_defect(cp_xml         IN XMLTYPE
                   ,cp_xmlns       IN VARCHAR2)
      IS
  SELECT EXTRACTVALUE(cp_xml,'/Adhoc_Defect/User_Id',cp_xmlns)              user_id
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Easting',cp_xmlns)              easting
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Northing',cp_xmlns)             northing
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Section_Id',cp_xmlns)           section_id
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Chainage',cp_xmlns)             chainage
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Asset_Type_Code',cp_xmlns)      asset_type
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Asset_Id',cp_xmlns)             asset_id
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Datetime',cp_xmlns)      defect_datetime
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Initiation_Code',cp_xmlns)      initiation_code
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Safety_Detailed_Flag',cp_xmlns) safety_detailed_flag
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Activity_Code',cp_xmlns)        activity_code
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Code',cp_xmlns)          defect_code
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Siss_Id',cp_xmlns)              siss_id
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Location_Description',cp_xmlns) location_description
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Description',cp_xmlns)   defect_description
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Special_Instructions',cp_xmlns) special_instructions
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Priority_Code',cp_xmlns)        priority_code
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Notify_Org',cp_xmlns)           notify_org
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Recharge_Org',cp_xmlns)         recharge_org
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Attribute1',cp_xmlns)    attribute1
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Attribute2',cp_xmlns)    attribute2
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Attribute3',cp_xmlns)    attribute3
        ,EXTRACTVALUE(cp_xml,'/Adhoc_Defect/Defect_Attribute4',cp_xmlns)    attribute4
        ,EXTRACT(cp_xml,'/Adhoc_Defect/Repair',cp_xmlns)                    repair_xml
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
  lv_retval     CLOB;
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
  nm_debug.debug('Getting Insp and Defect params');
  OPEN  get_defect(pi_xml
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
    nm_debug.debug('Getting BOQ params for :'||lt_get_repairs(i).boq_xml.getstringval);
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
  lv_retval := '<Defect_Created>'
               ||'<Defect_ID>'||TO_CHAR(lv_defect_id)||'</Defect_ID>'
             ||'</Defect_Created>'
             ;
  --
  nm_debug.debug_off;
  RETURN xmltype(lv_retval);
  --
EXCEPTION
  WHEN date_format_error
   THEN
      RETURN build_error_xml('Invalid Date Format');
  WHEN others
   THEN
      RETURN build_error_xml(SQLERRM);
END create_adhoc_defect;
--
-----------------------------------------------------------------------------
--
END mai_web_service;
/