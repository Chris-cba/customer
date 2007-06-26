DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_695596_create_doc_gateways.sql	1.1 03/15/05
--       Module Name      : xmrwa_695596_create_doc_gateways.sql
--       Date into SCCS   : 05/03/15 00:45:19
--       Date fetched Out : 07/06/06 14:38:08
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   l_rec_dgt            doc_gateways%ROWTYPE;
   c_app_owner CONSTANT VARCHAR2(30) := hig.get_application_owner;
BEGIN
--
   l_rec_dgt.dgt_lov_join_condition   := Null;
   l_rec_dgt.dgt_expand_module        := Null;
   l_rec_dgt.dgt_start_date           := Null;
   l_rec_dgt.dgt_end_date             := Null;
--
   FOR cs_rec IN (SELECT gt_table_name
                        ,nit_descr
                        ,nit_x_sect_allow_flag
                        ,nm3inv_view.derive_inv_type_view_name(nit_inv_type) inv_view_name
                   FROM  gis_themes
                        ,nm_inv_types
                  WHERE  gt_table_name = c_app_owner||'.'||nm3inv_view.derive_nw_inv_type_view_name(nit_inv_type)
                   AND   nit_table_name IS NULL
                 )
    LOOP
      l_rec_dgt.dgt_table_name        := cs_rec.gt_table_name;
      l_rec_dgt.dgt_table_descr       := SUBSTR(cs_rec.nit_descr,1,30);
      l_rec_dgt.dgt_pk_col_name       := 'IIT_NE_ID';
      l_rec_dgt.dgt_lov_descr_list    := Null;
      IF cs_rec.nit_x_sect_allow_flag = 'Y'
       THEN
         l_rec_dgt.dgt_lov_descr_list := 'IIT_X_SECT||'||nm3flx.string('-')||'||';
      END IF;
      l_rec_dgt.dgt_lov_descr_list    := l_rec_dgt.dgt_lov_descr_list||'IIT_PRIMARY_KEY';
      l_rec_dgt.dgt_lov_from_list     := cs_rec.inv_view_name;
      --
      IF   nm3get.get_dgt (pi_dgt_table_name  => l_rec_dgt.dgt_table_name
                          ,pi_raise_not_found => FALSE
                          ).dgt_table_name IS NULL
       AND nm3get.get_dgt (pi_dgt_table_descr => l_rec_dgt.dgt_table_descr
                          ,pi_raise_not_found => FALSE
                          ).dgt_table_name IS NULL
       THEN
         nm3ins.ins_dgt (l_rec_dgt);
      END IF;
      --
   END LOOP;
--
END;
/
