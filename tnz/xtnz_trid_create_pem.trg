CREATE OR REPLACE TRIGGER xtnz_trid_create_pem
   BEFORE INSERT
   ON nm_inv_items_all
   FOR EACH ROW
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_create_pem.trg	1.1 03/15/05
--       Module Name      : xtnz_trid_create_pem.trg
--       Date into SCCS   : 05/03/15 03:46:17
--       Date fetched Out : 07/06/06 14:40:37
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   xtnz_trid.g_rec_iit.iit_ne_id                 := :NEW.iit_ne_id;
   xtnz_trid.g_rec_iit.iit_inv_type              := :NEW.iit_inv_type;
   xtnz_trid.g_rec_iit.iit_primary_key           := :NEW.iit_primary_key;
   xtnz_trid.g_rec_iit.iit_start_date            := :NEW.iit_start_date;
   xtnz_trid.g_rec_iit.iit_date_created          := :NEW.iit_date_created;
   xtnz_trid.g_rec_iit.iit_date_modified         := :NEW.iit_date_modified;
   xtnz_trid.g_rec_iit.iit_created_by            := :NEW.iit_created_by;
   xtnz_trid.g_rec_iit.iit_modified_by           := :NEW.iit_modified_by;
   xtnz_trid.g_rec_iit.iit_admin_unit            := :NEW.iit_admin_unit;
   xtnz_trid.g_rec_iit.iit_descr                 := :NEW.iit_descr;
   xtnz_trid.g_rec_iit.iit_end_date              := :NEW.iit_end_date;
   xtnz_trid.g_rec_iit.iit_foreign_key           := :NEW.iit_foreign_key;
   xtnz_trid.g_rec_iit.iit_located_by            := :NEW.iit_located_by;
   xtnz_trid.g_rec_iit.iit_position              := :NEW.iit_position;
   xtnz_trid.g_rec_iit.iit_x_coord               := :NEW.iit_x_coord;
   xtnz_trid.g_rec_iit.iit_y_coord               := :NEW.iit_y_coord;
   xtnz_trid.g_rec_iit.iit_num_attrib16          := :NEW.iit_num_attrib16;
   xtnz_trid.g_rec_iit.iit_num_attrib17          := :NEW.iit_num_attrib17;
   xtnz_trid.g_rec_iit.iit_num_attrib18          := :NEW.iit_num_attrib18;
   xtnz_trid.g_rec_iit.iit_num_attrib19          := :NEW.iit_num_attrib19;
   xtnz_trid.g_rec_iit.iit_num_attrib20          := :NEW.iit_num_attrib20;
   xtnz_trid.g_rec_iit.iit_num_attrib21          := :NEW.iit_num_attrib21;
   xtnz_trid.g_rec_iit.iit_num_attrib22          := :NEW.iit_num_attrib22;
   xtnz_trid.g_rec_iit.iit_num_attrib23          := :NEW.iit_num_attrib23;
   xtnz_trid.g_rec_iit.iit_num_attrib24          := :NEW.iit_num_attrib24;
   xtnz_trid.g_rec_iit.iit_num_attrib25          := :NEW.iit_num_attrib25;
   xtnz_trid.g_rec_iit.iit_chr_attrib26          := :NEW.iit_chr_attrib26;
   xtnz_trid.g_rec_iit.iit_chr_attrib27          := :NEW.iit_chr_attrib27;
   xtnz_trid.g_rec_iit.iit_chr_attrib28          := :NEW.iit_chr_attrib28;
   xtnz_trid.g_rec_iit.iit_chr_attrib29          := :NEW.iit_chr_attrib29;
   xtnz_trid.g_rec_iit.iit_chr_attrib30          := :NEW.iit_chr_attrib30;
   xtnz_trid.g_rec_iit.iit_chr_attrib31          := :NEW.iit_chr_attrib31;
   xtnz_trid.g_rec_iit.iit_chr_attrib32          := :NEW.iit_chr_attrib32;
   xtnz_trid.g_rec_iit.iit_chr_attrib33          := :NEW.iit_chr_attrib33;
   xtnz_trid.g_rec_iit.iit_chr_attrib34          := :NEW.iit_chr_attrib34;
   xtnz_trid.g_rec_iit.iit_chr_attrib35          := :NEW.iit_chr_attrib35;
   xtnz_trid.g_rec_iit.iit_chr_attrib36          := :NEW.iit_chr_attrib36;
   xtnz_trid.g_rec_iit.iit_chr_attrib37          := :NEW.iit_chr_attrib37;
   xtnz_trid.g_rec_iit.iit_chr_attrib38          := :NEW.iit_chr_attrib38;
   xtnz_trid.g_rec_iit.iit_chr_attrib39          := :NEW.iit_chr_attrib39;
   xtnz_trid.g_rec_iit.iit_chr_attrib40          := :NEW.iit_chr_attrib40;
   xtnz_trid.g_rec_iit.iit_chr_attrib41          := :NEW.iit_chr_attrib41;
   xtnz_trid.g_rec_iit.iit_chr_attrib42          := :NEW.iit_chr_attrib42;
   xtnz_trid.g_rec_iit.iit_chr_attrib43          := :NEW.iit_chr_attrib43;
   xtnz_trid.g_rec_iit.iit_chr_attrib44          := :NEW.iit_chr_attrib44;
   xtnz_trid.g_rec_iit.iit_chr_attrib45          := :NEW.iit_chr_attrib45;
   xtnz_trid.g_rec_iit.iit_chr_attrib46          := :NEW.iit_chr_attrib46;
   xtnz_trid.g_rec_iit.iit_chr_attrib47          := :NEW.iit_chr_attrib47;
   xtnz_trid.g_rec_iit.iit_chr_attrib48          := :NEW.iit_chr_attrib48;
   xtnz_trid.g_rec_iit.iit_chr_attrib49          := :NEW.iit_chr_attrib49;
   xtnz_trid.g_rec_iit.iit_chr_attrib50          := :NEW.iit_chr_attrib50;
   xtnz_trid.g_rec_iit.iit_chr_attrib51          := :NEW.iit_chr_attrib51;
   xtnz_trid.g_rec_iit.iit_chr_attrib52          := :NEW.iit_chr_attrib52;
   xtnz_trid.g_rec_iit.iit_chr_attrib53          := :NEW.iit_chr_attrib53;
   xtnz_trid.g_rec_iit.iit_chr_attrib54          := :NEW.iit_chr_attrib54;
   xtnz_trid.g_rec_iit.iit_chr_attrib55          := :NEW.iit_chr_attrib55;
   xtnz_trid.g_rec_iit.iit_chr_attrib56          := :NEW.iit_chr_attrib56;
   xtnz_trid.g_rec_iit.iit_chr_attrib57          := :NEW.iit_chr_attrib57;
   xtnz_trid.g_rec_iit.iit_chr_attrib58          := :NEW.iit_chr_attrib58;
   xtnz_trid.g_rec_iit.iit_chr_attrib59          := :NEW.iit_chr_attrib59;
   xtnz_trid.g_rec_iit.iit_chr_attrib60          := :NEW.iit_chr_attrib60;
   xtnz_trid.g_rec_iit.iit_chr_attrib61          := :NEW.iit_chr_attrib61;
   xtnz_trid.g_rec_iit.iit_chr_attrib62          := :NEW.iit_chr_attrib62;
   xtnz_trid.g_rec_iit.iit_chr_attrib63          := :NEW.iit_chr_attrib63;
   xtnz_trid.g_rec_iit.iit_chr_attrib64          := :NEW.iit_chr_attrib64;
   xtnz_trid.g_rec_iit.iit_chr_attrib65          := :NEW.iit_chr_attrib65;
   xtnz_trid.g_rec_iit.iit_chr_attrib66          := :NEW.iit_chr_attrib66;
   xtnz_trid.g_rec_iit.iit_chr_attrib67          := :NEW.iit_chr_attrib67;
   xtnz_trid.g_rec_iit.iit_chr_attrib68          := :NEW.iit_chr_attrib68;
   xtnz_trid.g_rec_iit.iit_chr_attrib69          := :NEW.iit_chr_attrib69;
   xtnz_trid.g_rec_iit.iit_chr_attrib70          := :NEW.iit_chr_attrib70;
   xtnz_trid.g_rec_iit.iit_chr_attrib71          := :NEW.iit_chr_attrib71;
   xtnz_trid.g_rec_iit.iit_chr_attrib72          := :NEW.iit_chr_attrib72;
   xtnz_trid.g_rec_iit.iit_chr_attrib73          := :NEW.iit_chr_attrib73;
   xtnz_trid.g_rec_iit.iit_chr_attrib74          := :NEW.iit_chr_attrib74;
   xtnz_trid.g_rec_iit.iit_chr_attrib75          := :NEW.iit_chr_attrib75;
   xtnz_trid.g_rec_iit.iit_num_attrib76          := :NEW.iit_num_attrib76;
   xtnz_trid.g_rec_iit.iit_num_attrib77          := :NEW.iit_num_attrib77;
   xtnz_trid.g_rec_iit.iit_num_attrib78          := :NEW.iit_num_attrib78;
   xtnz_trid.g_rec_iit.iit_num_attrib79          := :NEW.iit_num_attrib79;
   xtnz_trid.g_rec_iit.iit_num_attrib80          := :NEW.iit_num_attrib80;
   xtnz_trid.g_rec_iit.iit_num_attrib81          := :NEW.iit_num_attrib81;
   xtnz_trid.g_rec_iit.iit_num_attrib82          := :NEW.iit_num_attrib82;
   xtnz_trid.g_rec_iit.iit_num_attrib83          := :NEW.iit_num_attrib83;
   xtnz_trid.g_rec_iit.iit_num_attrib84          := :NEW.iit_num_attrib84;
   xtnz_trid.g_rec_iit.iit_num_attrib85          := :NEW.iit_num_attrib85;
   xtnz_trid.g_rec_iit.iit_date_attrib86         := :NEW.iit_date_attrib86;
   xtnz_trid.g_rec_iit.iit_date_attrib87         := :NEW.iit_date_attrib87;
   xtnz_trid.g_rec_iit.iit_date_attrib88         := :NEW.iit_date_attrib88;
   xtnz_trid.g_rec_iit.iit_date_attrib89         := :NEW.iit_date_attrib89;
   xtnz_trid.g_rec_iit.iit_date_attrib90         := :NEW.iit_date_attrib90;
   xtnz_trid.g_rec_iit.iit_date_attrib91         := :NEW.iit_date_attrib91;
   xtnz_trid.g_rec_iit.iit_date_attrib92         := :NEW.iit_date_attrib92;
   xtnz_trid.g_rec_iit.iit_date_attrib93         := :NEW.iit_date_attrib93;
   xtnz_trid.g_rec_iit.iit_date_attrib94         := :NEW.iit_date_attrib94;
   xtnz_trid.g_rec_iit.iit_date_attrib95         := :NEW.iit_date_attrib95;
   xtnz_trid.g_rec_iit.iit_angle                 := :NEW.iit_angle;
   xtnz_trid.g_rec_iit.iit_angle_txt             := :NEW.iit_angle_txt;
   xtnz_trid.g_rec_iit.iit_class                 := :NEW.iit_class;
   xtnz_trid.g_rec_iit.iit_class_txt             := :NEW.iit_class_txt;
   xtnz_trid.g_rec_iit.iit_colour                := :NEW.iit_colour;
   xtnz_trid.g_rec_iit.iit_colour_txt            := :NEW.iit_colour_txt;
   xtnz_trid.g_rec_iit.iit_coord_flag            := :NEW.iit_coord_flag;
   xtnz_trid.g_rec_iit.iit_description           := :NEW.iit_description;
   xtnz_trid.g_rec_iit.iit_diagram               := :NEW.iit_diagram;
   xtnz_trid.g_rec_iit.iit_distance              := :NEW.iit_distance;
   xtnz_trid.g_rec_iit.iit_end_chain             := :NEW.iit_end_chain;
   xtnz_trid.g_rec_iit.iit_gap                   := :NEW.iit_gap;
   xtnz_trid.g_rec_iit.iit_height                := :NEW.iit_height;
   xtnz_trid.g_rec_iit.iit_height_2              := :NEW.iit_height_2;
   xtnz_trid.g_rec_iit.iit_id_code               := :NEW.iit_id_code;
   xtnz_trid.g_rec_iit.iit_instal_date           := :NEW.iit_instal_date;
   xtnz_trid.g_rec_iit.iit_invent_date           := :NEW.iit_invent_date;
   xtnz_trid.g_rec_iit.iit_inv_ownership         := :NEW.iit_inv_ownership;
   xtnz_trid.g_rec_iit.iit_itemcode              := :NEW.iit_itemcode;
   xtnz_trid.g_rec_iit.iit_lco_lamp_config_id    := :NEW.iit_lco_lamp_config_id;
   xtnz_trid.g_rec_iit.iit_length                := :NEW.iit_length;
   xtnz_trid.g_rec_iit.iit_material              := :NEW.iit_material;
   xtnz_trid.g_rec_iit.iit_material_txt          := :NEW.iit_material_txt;
   xtnz_trid.g_rec_iit.iit_method                := :NEW.iit_method;
   xtnz_trid.g_rec_iit.iit_method_txt            := :NEW.iit_method_txt;
   xtnz_trid.g_rec_iit.iit_note                  := :NEW.iit_note;
   xtnz_trid.g_rec_iit.iit_no_of_units           := :NEW.iit_no_of_units;
   xtnz_trid.g_rec_iit.iit_options               := :NEW.iit_options;
   xtnz_trid.g_rec_iit.iit_options_txt           := :NEW.iit_options_txt;
   xtnz_trid.g_rec_iit.iit_oun_org_id_elec_board := :NEW.iit_oun_org_id_elec_board;
   xtnz_trid.g_rec_iit.iit_owner                 := :NEW.iit_owner;
   xtnz_trid.g_rec_iit.iit_owner_txt             := :NEW.iit_owner_txt;
   xtnz_trid.g_rec_iit.iit_peo_invent_by_id      := :NEW.iit_peo_invent_by_id;
   xtnz_trid.g_rec_iit.iit_photo                 := :NEW.iit_photo;
   xtnz_trid.g_rec_iit.iit_power                 := :NEW.iit_power;
   xtnz_trid.g_rec_iit.iit_prov_flag             := :NEW.iit_prov_flag;
   xtnz_trid.g_rec_iit.iit_rev_by                := :NEW.iit_rev_by;
   xtnz_trid.g_rec_iit.iit_rev_date              := :NEW.iit_rev_date;
   xtnz_trid.g_rec_iit.iit_type                  := :NEW.iit_type;
   xtnz_trid.g_rec_iit.iit_type_txt              := :NEW.iit_type_txt;
   xtnz_trid.g_rec_iit.iit_width                 := :NEW.iit_width;
   xtnz_trid.g_rec_iit.iit_xtra_char_1           := :NEW.iit_xtra_char_1;
   xtnz_trid.g_rec_iit.iit_xtra_date_1           := :NEW.iit_xtra_date_1;
   xtnz_trid.g_rec_iit.iit_xtra_domain_1         := :NEW.iit_xtra_domain_1;
   xtnz_trid.g_rec_iit.iit_xtra_domain_txt_1     := :NEW.iit_xtra_domain_txt_1;
   xtnz_trid.g_rec_iit.iit_xtra_number_1         := :NEW.iit_xtra_number_1;
   xtnz_trid.g_rec_iit.iit_x_sect                := :NEW.iit_x_sect;
   xtnz_trid.g_rec_iit.iit_det_xsp               := :NEW.iit_det_xsp;
   xtnz_trid.g_rec_iit.iit_offset                := :NEW.iit_offset;
   xtnz_trid.g_rec_iit.iit_x                     := :NEW.iit_x;
   xtnz_trid.g_rec_iit.iit_y                     := :NEW.iit_y;
   xtnz_trid.g_rec_iit.iit_z                     := :NEW.iit_z;
   xtnz_trid.g_rec_iit.iit_num_attrib96          := :NEW.iit_num_attrib96;
   xtnz_trid.g_rec_iit.iit_num_attrib97          := :NEW.iit_num_attrib97;
   xtnz_trid.g_rec_iit.iit_num_attrib98          := :NEW.iit_num_attrib98;
   xtnz_trid.g_rec_iit.iit_num_attrib99          := :NEW.iit_num_attrib99;
   xtnz_trid.g_rec_iit.iit_num_attrib100         := :NEW.iit_num_attrib100;
   xtnz_trid.g_rec_iit.iit_num_attrib101         := :NEW.iit_num_attrib101;
   xtnz_trid.g_rec_iit.iit_num_attrib102         := :NEW.iit_num_attrib102;
   xtnz_trid.g_rec_iit.iit_num_attrib103         := :NEW.iit_num_attrib103;
   xtnz_trid.g_rec_iit.iit_num_attrib104         := :NEW.iit_num_attrib104;
   xtnz_trid.g_rec_iit.iit_num_attrib105         := :NEW.iit_num_attrib105;
   xtnz_trid.g_rec_iit.iit_num_attrib106         := :NEW.iit_num_attrib106;
   xtnz_trid.g_rec_iit.iit_num_attrib107         := :NEW.iit_num_attrib107;
   xtnz_trid.g_rec_iit.iit_num_attrib108         := :NEW.iit_num_attrib108;
   xtnz_trid.g_rec_iit.iit_num_attrib109         := :NEW.iit_num_attrib109;
   xtnz_trid.g_rec_iit.iit_num_attrib110         := :NEW.iit_num_attrib110;
   xtnz_trid.g_rec_iit.iit_num_attrib111         := :NEW.iit_num_attrib111;
   xtnz_trid.g_rec_iit.iit_num_attrib112         := :NEW.iit_num_attrib112;
   xtnz_trid.g_rec_iit.iit_num_attrib113         := :NEW.iit_num_attrib113;
   xtnz_trid.g_rec_iit.iit_num_attrib114         := :NEW.iit_num_attrib114;
   xtnz_trid.g_rec_iit.iit_num_attrib115         := :NEW.iit_num_attrib115;
--
   xtnz_trid.create_pem;
--
   -- Don't do that! it causes forms to throw a wobbly! - JM 02/02/2004
--   -- Move the stored DOC_ID back into the :NEW record
--   :NEW.iit_num_attrib115                        := xtnz_trid.g_rec_iit.iit_num_attrib115;
--
END xtnz_trid_create_pem;
/
