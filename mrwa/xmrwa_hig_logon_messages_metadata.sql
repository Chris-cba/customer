--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_hig_logon_messages_metadata.sql	1.1 03/15/05
--       Module Name      : xmrwa_hig_logon_messages_metadata.sql
--       Date into SCCS   : 05/03/15 00:45:34
--       Date fetched Out : 07/06/06 14:38:20
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
insert into nm_au_types
      (NAT_ADMIN_TYPE
      ,NAT_DESCR
      )
SELECT 'MAIL'
      ,'Admin Type for mail'
 FROM  DUAL
WHERE NOT EXISTS (SELECT 1 FROM nm_au_types WHERE NAT_ADMIN_TYPE = 'MAIL')
/

INSERT INTO nm_admin_units
      (NAU_ADMIN_UNIT
      ,NAU_UNIT_CODE
      ,NAU_LEVEL
      ,NAU_NAME
      ,NAU_START_DATE
      ,NAU_ADMIN_TYPE
      )
SELECT nm3seq.next_nau_admin_unit_seq
      ,'MAIL'
      ,1
      ,'Mail Admin Unit'
      ,TO_DATE('01012000','DDMMYYYY')
      ,'MAIL'
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_admin_units
                   WHERE  NAU_UNIT_CODE = 'MAIL'
                    AND   NAU_UNIT_CODE = NAU_ADMIN_TYPE
                  )
/

INSERT INTO nm_admin_groups
(NAG_PARENT_ADMIN_UNIT, NAG_CHILD_ADMIN_UNIT, NAG_DIRECT_LINK)
SELECT nau_admin_unit
      ,nau_admin_unit
      ,'N'
 FROM nm_admin_units
WHERE NAU_UNIT_CODE = 'MAIL'
                    AND   NAU_UNIT_CODE = NAU_ADMIN_TYPE
 AND NOT EXISTS (SELECT 1
                  FROM  nm_admin_groups
                 WHERE  NAG_PARENT_ADMIN_UNIT = nau_admin_unit
                  AND   NAG_CHILD_ADMIN_UNIT  = nau_admin_unit
                )
/

INSERT INTO nm_user_aus
      (NUA_USER_ID
      ,NUA_ADMIN_UNIT
      ,NUA_START_DATE
      ,NUA_END_DATE
      ,NUA_MODE
      )
SELECT hus_user_id
      ,nau_admin_unit
      ,hus_start_date
      ,hus_end_date
      ,'NORMAL'
 FROM  hig_users
      ,nm_admin_units
WHERE  NAU_UNIT_CODE = 'MAIL'
                    AND   NAU_UNIT_CODE = NAU_ADMIN_TYPE
AND NOT EXISTS (SELECT 1
                 FROM  nm_user_aus_all
                WHERE  nua_user_id = hus_user_id
                 AND   nua_admin_unit = nau_admin_unit
               )
/



INSERT INTO nm_inv_domains
      (ID_DOMAIN
      ,ID_TITLE
      ,ID_START_DATE
      ,ID_END_DATE
      ,ID_DATATYPE
      )
SELECT 'NM_MAIL_GROUPS'
      ,'Trigger maintained copy of NM_MAIL_GROUPS'
      ,TO_DATE('01012000','DDMMYYYY')
      ,Null
      ,'NUMBER'
 FROM  dual
WHERE  NOT EXISTS (SELECT *
                    FROM  nm_inv_domains
                   WHERE  ID_DOMAIN = 'NM_MAIL_GROUPS'
                  )
/

INSERT INTO nm_inv_attri_lookup_all
      (IAL_DOMAIN
      ,IAL_VALUE
      ,IAL_MEANING
      ,IAL_START_DATE
      ,IAL_SEQ
      )
SELECT 'NM_MAIL_GROUPS'
      ,nmg_id
      ,nmg_name
      ,TO_DATE('01012000','DDMMYYYY')
      ,nmg_id
 FROM  nm_mail_groups
WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_inv_attri_lookup_all
                   WHERE  IAL_DOMAIN = 'NM_MAIL_GROUPS'
                    AND   IAL_VALUE  = nmg_id
                  )
/

DECLARE
   l_rec_nit nm_inv_types%ROWTYPE;
   l_rec_itr nm_inv_type_roles%ROWTYPE;
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
BEGIN
   l_rec_nit.nit_inv_type          := 'MAIL';
   DELETE FROM nm_inv_type_roles
   WHERE itr_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_type_attribs
   WHERE ita_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_item_groupings
   WHERE iig_parent_id IN (SELECT iit_ne_id
                            FROM  nm_inv_items
                           WHERE  iit_inv_type = l_rec_nit.nit_inv_type
                          );
   DELETE FROM nm_inv_items
   WHERE iit_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_type_groupings
   WHERE itg_parent_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_types
   WHERE nit_inv_type = l_rec_nit.nit_inv_type;
   l_rec_nit.nit_pnt_or_cont       := 'P';
   l_rec_nit.nit_x_sect_allow_flag := 'N';
   l_rec_nit.nit_elec_drain_carr   := 'C';
   l_rec_nit.nit_contiguous        := 'N';
   l_rec_nit.nit_replaceable       := 'Y';
   l_rec_nit.nit_exclusive         := 'Y';
   l_rec_nit.nit_category          := 'I';
   l_rec_nit.nit_descr             := 'System Mail Announcements';
   l_rec_nit.nit_linear            := 'N';
   l_rec_nit.nit_use_xy            := 'N';
   l_rec_nit.nit_multiple_allowed  := 'N';
   l_rec_nit.nit_end_loc_only      := 'N';
   l_rec_nit.nit_screen_seq        := 999;
   l_rec_nit.nit_view_name         := nm3inv_view.derive_inv_type_view_name(l_rec_nit.nit_inv_type);
   l_rec_nit.nit_start_date        := TO_DATE('01012000','DDMMYYYY');
   l_rec_nit.nit_end_date          := Null;
   l_rec_nit.nit_short_descr       := Null;
   l_rec_nit.nit_flex_item_flag    := 'N';
   l_rec_nit.nit_table_name        := Null;
   l_rec_nit.nit_lr_ne_column_name := Null;
   l_rec_nit.nit_lr_st_chain       := Null;
   l_rec_nit.nit_lr_end_chain      := Null;
   l_rec_nit.nit_admin_type        := 'MAIL';
   l_rec_nit.nit_icon_name         := Null;
   l_rec_nit.nit_top               := 'Y';
   l_rec_nit.nit_foreign_pk_column := Null;
   l_rec_nit.nit_update_allowed    := 'Y';
   nm3ins.ins_nit (l_rec_nit);
   --
   l_rec_ita.ita_inv_type          := l_rec_nit.nit_inv_type;
   l_rec_ita.ita_attrib_name       := 'IIT_PRIMARY_KEY';
   l_rec_ita.ita_dynamic_attrib    := 'N';
   l_rec_ita.ita_disp_seq_no       := 1;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_format            := nm3type.c_varchar;
   l_rec_ita.ita_fld_length        := 50;
   l_rec_ita.ita_dec_places        := Null;
   l_rec_ita.ita_scrn_text         := 'Subject';
   l_rec_ita.ita_id_domain         := Null;
   l_rec_ita.ita_validate_yn       := 'N';
   l_rec_ita.ita_dtp_code          := Null;
   l_rec_ita.ita_max               := Null;
   l_rec_ita.ita_min               := Null;
   l_rec_ita.ita_view_attri        := 'IIT_SUBJECT';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   l_rec_ita.ita_start_date        := l_rec_nit.nit_start_date;
   l_rec_ita.ita_end_date          := Null;
   l_rec_ita.ita_queryable         := 'Y';
   l_rec_ita.ita_ukpms_param_no    := Null;
   l_rec_ita.ita_units             := Null;
   l_rec_ita.ita_format_mask       := Null;
   l_rec_ita.ita_exclusive         := 'N';
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_CHR_ATTRIB56';
   l_rec_ita.ita_disp_seq_no       := 2;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 80;
   l_rec_ita.ita_scrn_text         := 'File Name';
   l_rec_ita.ita_view_attri        := 'IIT_FILE_NAME';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_CHR_ATTRIB57';
   l_rec_ita.ita_disp_seq_no       := 3;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 100;
   l_rec_ita.ita_scrn_text         := 'Server File Path';
   l_rec_ita.ita_view_attri        := 'IIT_FILE_PATH';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_CHR_ATTRIB26';
   l_rec_ita.ita_disp_seq_no       := 4;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 1;
   l_rec_ita.ita_scrn_text         := 'HTML';
   l_rec_ita.ita_id_domain         := 'YES_NO';
   l_rec_ita.ita_view_attri        := 'IIT_HTML';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_CHR_ATTRIB27';
   l_rec_ita.ita_disp_seq_no       := 6;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 1;
   l_rec_ita.ita_scrn_text         := 'Send Once Only';
   l_rec_ita.ita_id_domain         := 'YES_NO';
   l_rec_ita.ita_view_attri        := 'IIT_ONCE_ONLY';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_NUM_ATTRIB16';
   l_rec_ita.ita_disp_seq_no       := 5;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_format            := nm3type.c_number;
   l_rec_ita.ita_fld_length        := 10;
   l_rec_ita.ita_dec_places        := 0;
   l_rec_ita.ita_scrn_text         := 'Mail Group';
   l_rec_ita.ita_id_domain         := 'NM_MAIL_GROUPS';
   l_rec_ita.ita_view_attri        := 'IIT_NMG_ID';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   --
   l_rec_itr.itr_inv_type          := l_rec_nit.nit_inv_type;
   l_rec_itr.itr_hro_role          := 'HIG_USER';
   l_rec_itr.itr_mode              := nm3type.c_readonly;
   nm3ins.ins_itr (l_rec_itr);
   l_rec_itr.itr_hro_role          := 'HIG_ADMIN';
   l_rec_itr.itr_mode              := nm3type.c_normal;
   nm3ins.ins_itr (l_rec_itr);
   --
   nm3inv_view.create_view (l_rec_nit.nit_inv_type);
   --
   COMMIT;
END;
/

DECLARE
   l_rec_nit nm_inv_types%ROWTYPE;
   l_rec_itr nm_inv_type_roles%ROWTYPE;
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
   l_rec_itg nm_inv_type_groupings%ROWTYPE;
BEGIN
   l_rec_nit.nit_inv_type          := 'MAIS';
   DELETE FROM nm_inv_type_roles
   WHERE itr_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_type_attribs
   WHERE ita_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_items
   WHERE iit_inv_type = l_rec_nit.nit_inv_type;
   DELETE FROM nm_inv_types
   WHERE nit_inv_type = l_rec_nit.nit_inv_type;
   l_rec_nit.nit_pnt_or_cont       := 'P';
   l_rec_nit.nit_x_sect_allow_flag := 'N';
   l_rec_nit.nit_elec_drain_carr   := 'C';
   l_rec_nit.nit_contiguous        := 'N';
   l_rec_nit.nit_replaceable       := 'Y';
   l_rec_nit.nit_exclusive         := 'Y';
   l_rec_nit.nit_category          := 'I';
   l_rec_nit.nit_descr             := 'Sent System Mail Announcements';
   l_rec_nit.nit_linear            := 'N';
   l_rec_nit.nit_use_xy            := 'N';
   l_rec_nit.nit_multiple_allowed  := 'N';
   l_rec_nit.nit_end_loc_only      := 'N';
   l_rec_nit.nit_screen_seq        := 999;
   l_rec_nit.nit_view_name         := nm3inv_view.derive_inv_type_view_name(l_rec_nit.nit_inv_type);
   l_rec_nit.nit_start_date        := TO_DATE('01012000','DDMMYYYY');
   l_rec_nit.nit_end_date          := Null;
   l_rec_nit.nit_short_descr       := Null;
   l_rec_nit.nit_flex_item_flag    := 'N';
   l_rec_nit.nit_table_name        := Null;
   l_rec_nit.nit_lr_ne_column_name := Null;
   l_rec_nit.nit_lr_st_chain       := Null;
   l_rec_nit.nit_lr_end_chain      := Null;
   l_rec_nit.nit_admin_type        := 'MAIL';
   l_rec_nit.nit_icon_name         := Null;
   l_rec_nit.nit_top               := 'N';
   l_rec_nit.nit_foreign_pk_column := Null;
   l_rec_nit.nit_update_allowed    := 'N';
   nm3ins.ins_nit (l_rec_nit);
--
   l_rec_ita.ita_inv_type          := l_rec_nit.nit_inv_type;
   l_rec_ita.ita_attrib_name       := 'IIT_FOREIGN_KEY';
   l_rec_ita.ita_dynamic_attrib    := 'N';
   l_rec_ita.ita_disp_seq_no       := 1;
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_format            := nm3type.c_varchar;
   l_rec_ita.ita_fld_length        := 50;
   l_rec_ita.ita_dec_places        := Null;
   l_rec_ita.ita_scrn_text         := 'Subject';
   l_rec_ita.ita_id_domain         := Null;
   l_rec_ita.ita_validate_yn       := 'N';
   l_rec_ita.ita_dtp_code          := Null;
   l_rec_ita.ita_max               := Null;
   l_rec_ita.ita_min               := Null;
   l_rec_ita.ita_view_attri        := 'IIT_SUBJECT';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   l_rec_ita.ita_start_date        := l_rec_nit.nit_start_date;
   l_rec_ita.ita_end_date          := Null;
   l_rec_ita.ita_queryable         := 'Y';
   l_rec_ita.ita_ukpms_param_no    := Null;
   l_rec_ita.ita_units             := Null;
   l_rec_ita.ita_format_mask       := Null;
   l_rec_ita.ita_exclusive         := 'N';
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_DATE_ATTRIB86';
   l_rec_ita.ita_disp_seq_no       := 2;
   l_rec_ita.ita_format            := nm3type.c_date;
   l_rec_ita.ita_format_mask       := 'DD/MM/YYYY';
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 10;
   l_rec_ita.ita_scrn_text         := 'Date Mail Submitted';
   l_rec_ita.ita_view_attri        := 'IIT_DATE_MAIL_SUBMITTED';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);
   l_rec_ita.ita_attrib_name       := 'IIT_DATE_ATTRIB87';
   l_rec_ita.ita_disp_seq_no       := 3;
   l_rec_ita.ita_format            := nm3type.c_date;
   l_rec_ita.ita_format_mask       := 'HH24:MI';
   l_rec_ita.ita_mandatory_yn      := 'Y';
   l_rec_ita.ita_fld_length        := 5;
   l_rec_ita.ita_scrn_text         := 'Time Mail Submitted';
   l_rec_ita.ita_view_attri        := 'IIT_TIME_MAIL_SUBMITTED';
   l_rec_ita.ita_view_col_name     := l_rec_ita.ita_view_attri;
   nm3ins.ins_ita (l_rec_ita);

   --
   l_rec_itr.itr_inv_type          := l_rec_nit.nit_inv_type;
   l_rec_itr.itr_hro_role          := 'HIG_USER';
   l_rec_itr.itr_mode              := nm3type.c_normal;
   nm3ins.ins_itr (l_rec_itr);
   --
   l_rec_itg.itg_inv_type          := l_rec_nit.nit_inv_type;
   l_rec_itg.itg_parent_inv_type   := 'MAIL';
   l_rec_itg.itg_mandatory         := 'Y';
   l_rec_itg.itg_relation          := 'NONE';
   l_rec_itg.itg_start_date        := l_rec_nit.nit_start_date;
   l_rec_itg.itg_end_date          := Null;
   nm3ins.ins_itg (l_rec_itg);
   --
   nm3inv_view.create_view (l_rec_nit.nit_inv_type);
   --
   COMMIT;
END;
/
