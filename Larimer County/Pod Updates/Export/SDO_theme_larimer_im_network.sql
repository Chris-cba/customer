update user_sdo_themes
set styling_rules = 
'<?xml version="1.0" standalone="yes"?> '||
'<styling_rules> '||
'  <hidden_info> '||
'    <field column="ROAD_NETWORK_SDO_ID" name="IM_NETWORK"/> '||
'  </hidden_info> '||
'  <rule> '||
'    <features style="L.MAJOR STREET"> ( '||
'road_network_sdo_id IN ( SELECT NE_ID FROM NM_ELEMENTS WHERE NE_ID = NM3NET.GET_NE_ID(:1) AND ne_type = ''S'') '||
'OR '||
'( '||
'road_network_sdo_id in '||
'  (SELECT '||
'              nm_ne_id_of data '||
'              FROM '||
'              nm_members '||
'             WHERE  '||
'              nm3net.get_ne_gty( nm_ne_id_of ) IS   '||
'              NULL CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in  '||
'             AND  '||
'              nm3net.get_ne_gty( nm_ne_id_of ) IS NULL   '||
'             START '||
'             WITH NM_NE_ID_IN                     = NM3NET.GET_NE_ID(:2) '||
'           ))) </features> '||
'    <label column="NE_UNIQUE_IM_LABEL" style="T.CITY NAME"> 1 </label> '||
'  </rule> '||
'</styling_rules>'
where name = 'IM_NETWORK';