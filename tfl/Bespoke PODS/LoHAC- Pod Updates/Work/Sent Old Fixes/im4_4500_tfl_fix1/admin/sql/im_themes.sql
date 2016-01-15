SET DEFINE OFF;

delete USER_SDO_THEMES where NAME like 'IM%';

Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_DEFECTS', 'DEFECTS', 'VW_MAI_DEFECTS_SDO', 'SHAPE', '<?xml version="1.0" standalone="yes"?>
<styling_rules caching="NONE">
  <rule column="DEF_STATUS_CODE">
    <features style="M.GOOGLE_MARKER"> def_defect_id = :1 </features>
  </rule>
</styling_rules>');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_ENQUIRIES', 'EXOR THEME ENQUIRIES BY STATUS', 'V_ENQ_BY_STATUS_XY_SDO', 'GEOLOC', '<?xml version="1.0" standalone="yes"?><styling_rules key_column="OBJECTID">   <hidden_info>     <field column="DOC_ENQUIRY_ID" name="doc_id"/>   </hidden_info>   <rule column="DOC_STATUS">     <features style="M.GOOGLE_MARKER"> (doc_enquiry_id = nvl(to_number(:1),doc_enquiry_id) and nvl(:2,nvl(DOC_RESPONSIBILITY_OF,''1'')) = nvl(DOC_RESPONSIBILITY_OF,''1'') and (:3 is null or doc_enquiry_id in (select dec_doc_id from doc_enquiry_contacts, hig_contacts, hig_contact_address, hig_address where    hct_id = dec_hct_id    and    hct_id = hca_hct_id    and hca_had_id = had_id    and had_postcode = :4)) and (:5 is null or doc_enquiry_id in (select dec_doc_id from doc_enquiry_contacts, hig_contacts where    hct_id = dec_hct_id    and    hct_id = :6)) ) </features>   </rule> </styling_rules> ');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_MAP_ITEM', 'ENQUIRIES', 'X_V_TFL_ENQUIRIES', 'GEOLOC', '<?xml version="1.0" standalone="yes"?><styling_rules key_column="DOC_ID" caching="NONE"> <rule column="DOC_STATUS_CODE"> <features style="V.ENQUIRY"> </features> </rule> </styling_rules>');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_NETWORK', 'CHALIST', 'CHALIST_TABLE', 'SHAPE', '<?xml version="1.0" standalone="yes"?> <styling_rules>   <hidden_info>     <field column="NE_ID" name="ne_id"/>   </hidden_info>   <rule>     <features style="L.MAJOR STREET"> (rse_he_id in    (SELECT               nm_ne_id_of data               FROM               nm_members              WHERE                nm3net.get_ne_gty( nm_ne_id_of ) IS                 NULL CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in               AND                nm3net.get_ne_gty( nm_ne_id_of ) IS NULL                START              WITH nm_ne_id_in                     = nm3net.get_ne_id(:1)            )) </features>     <label column="NE_UNIQUE" style="T.CITY NAME"> 1 </label>   </rule> </styling_rules> ');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_TYPE_1_AND_2_STREETS', 'V_NM_NAT_NSGN_OFFN_SDO_DT', 'V_NM_NAT_NSGN_OFFN_SDO_DT', 'GEOLOC', '<?xml version="1.0" standalone="yes"?><styling_rules key_column="OBJECTID">  <hidden_info>    <field column="NE_ID" name="ne_id"/>  </hidden_info>  <rule>    <features style="L.EXOR.TYPE 1 AND 2 STREETS"> ( nsg_reference =:1) </features>    <label column="NE_DESCR" style="T.EXOR.ROAD NAME"> 1 </label>  </rule></styling_rules>');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_WORK_ORDER_LINES', 'work order lines', 'V_WORK_ORDER_LINES_SDO', 'GEOLOC', '<?xml version="1.0" standalone="yes"?>
<styling_rules>
  <hidden_info>
    <field column="WOL_ID" name="work_order_lines"/>
  </hidden_info>
  <rule>
    <features asis="true" style="L.RED"> (wol_id = decode(:1,''~'',wol_id,:2)
  and wol_works_order_no = :3) </features>
    <label column="WOL_WORKS_ORDER_NO" style="T.STATE NAME"> 1 </label>
  </rule>
</styling_rules>');
Insert into USER_SDO_THEMES
   (NAME, DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('IM_WO_DEFECTS', 'DEFECTS BY STATUS XY', 'VW_MAI_DEFECTS_SDO', 'SHAPE', '<?xml version="1.0" standalone="yes"?>
<styling_rules highlight_style="AVAILABLE_1">
  <hidden_info>
    <field column="DEF_DEFECT_ID" name="IM_WO_DEFECTS"/>
  </hidden_info>
  <rule>
    <features style="V.DEFECT_STATUS"> def_works_order_no = :1 </features>
  </rule>
</styling_rules>');
COMMIT;
