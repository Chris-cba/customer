create global temporary table xbcc_equip_attr_views_tt (
		esur_mem_nm_ne_id_in number(9),
       esur_mem_nm_obj_type varchar2(4),
       esur_SLK number,
       esur_END_SLK number,
       SURVEY_ID  number(9),
       Survey_Date date,
       Survey_Type varchar2(50)
);

create index XBCC_EQUIP_ATTR_VIEWS_ESUR_IDX on xbcc_equip_attr_views_tt(esur_mem_nm_ne_id_in);