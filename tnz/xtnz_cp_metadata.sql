DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_cp_metadata.sql	1.1 03/15/05
--       Module Name      : xtnz_cp_metadata.sql
--       Date into SCCS   : 05/03/15 03:45:56
--       Date fetched Out : 07/06/06 14:40:19
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   --
   c_nlf_unique CONSTANT nm_load_files.nlf_unique%TYPE := 'CP';
   c_start_date CONSTANT VARCHAR2(40) := 'TO_DATE('||nm3flx.string('01/01/1900')||','||nm3flx.string('DD/MM/YYYY')||')';
   --
   l_rec_nlf  nm_load_files%ROWTYPE;
   l_rec_nlfc nm_load_file_cols%ROWTYPE;
   l_rec_nlfd nm_load_file_destinations%ROWTYPE;
   --
   PROCEDURE add_nlfc (p_nlfc_holding_col  nm_load_file_cols.nlfc_holding_col%TYPE
                      ,p_nlfc_datatype     nm_load_file_cols.nlfc_datatype%TYPE
                      ,p_nlfc_varchar_size nm_load_file_cols.nlfc_varchar_size%TYPE
                      ,p_nlfc_mandatory    nm_load_file_cols.nlfc_mandatory%TYPE
                      ) IS
   BEGIN
      l_rec_nlfc.nlfc_seq_no        := l_rec_nlfc.nlfc_seq_no + 1;
      l_rec_nlfc.nlfc_holding_col   := p_nlfc_holding_col;
      l_rec_nlfc.nlfc_datatype      := p_nlfc_datatype;
      l_rec_nlfc.nlfc_varchar_size  := p_nlfc_varchar_size;
      l_rec_nlfc.nlfc_mandatory     := p_nlfc_mandatory;
      nm3ins.ins_nlfc (l_rec_nlfc);
   END add_nlfc;
   --
   PROCEDURE upd_nlcd (p_nlcd_dest_col   VARCHAR2
                      ,p_nlcd_source_col VARCHAR2
                      ) IS
   BEGIN
      UPDATE nm_load_file_col_destinations
       SET   nlcd_source_col = p_nlcd_source_col
      WHERE  nlcd_nlf_id     = l_rec_nlf.nlf_id
       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id
       AND   nlcd_dest_col   = p_nlcd_dest_col;
   END upd_nlcd;
   --
BEGIN
   --
   nm3del.del_nlf (pi_nlf_unique      => c_nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
   --
   l_rec_nlf.nlf_id               := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_unique           := c_nlf_unique;
   l_rec_nlf.nlf_descr            := nm3get.get_nit (pi_nit_inv_type => c_nlf_unique).nit_descr;
   l_rec_nlf.nlf_path             := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter        := '|';
   l_rec_nlf.nlf_date_format_mask := 'DD/MM/YYYY';
   nm3ins.ins_nlf (l_rec_nlf);
   --
   l_rec_nlfc.nlfc_nlf_id  := l_rec_nlf.nlf_id;
   l_rec_nlfc.nlfc_seq_no  := 0;
   --
   add_nlfc ('ACTIVITIES_ON_PROPERTY',nm3type.c_varchar,500,'N'); -- Activities On Property
   add_nlfc ('CROSSING_PLACE_NUMBER',nm3type.c_varchar,500,'Y'); -- Crossing Place Number
   add_nlfc ('LAR_SECTION',nm3type.c_varchar,500,'Y'); -- LAR Section Name
   add_nlfc ('PROPERTY_OWNER',nm3type.c_varchar,500,'N'); -- Property Owner
   add_nlfc ('LAND_OWNER_ADDRESS',nm3type.c_varchar,500,'N'); -- Land Owner Address
   add_nlfc ('LAND_OWNER_SUBURB',nm3type.c_varchar,500,'N'); -- Land Owner Suburb
   add_nlfc ('LAND_OWNER_CITY',nm3type.c_varchar,500,'N'); -- Land Owner City
   add_nlfc ('STAMPED_CP_NOTICE',nm3type.c_date,Null,'N'); -- Stamped CP notice
   add_nlfc ('DATE_ISSUED',nm3type.c_date,Null,'N'); -- Date Issued
   add_nlfc ('DATE_ALLOCATED',nm3type.c_date,Null,'N'); -- Date allocated
   add_nlfc ('DATE_CANCELLED',nm3type.c_date,Null,'N'); -- Date Cancelled
   add_nlfc ('DATE_VARIATION_ISSSUED',nm3type.c_date,Null,'N'); -- Date Variation Issued
   add_nlfc ('ADDTIONAL_ISSUE',nm3type.c_date,Null,'N'); -- Addtional Issue
   add_nlfc ('STATUS',nm3type.c_varchar,20,'Y'); -- Status
   add_nlfc ('LEGAL_DESCRIPTION',nm3type.c_varchar,500,'N'); -- Legal Description
   add_nlfc ('TYPE_OF_USE',nm3type.c_varchar,500,'N'); -- Type of Use
   add_nlfc ('DRAINAGE',nm3type.c_varchar,500,'N'); -- Drainage
   add_nlfc ('LOT_SIZE',nm3type.c_number,Null,'N'); -- Lot Size
   add_nlfc ('MAXIMUM_WIDTH',nm3type.c_number,Null,'N'); -- Maximum Width
   add_nlfc ('GPS_EASTING',nm3type.c_number,Null,'N'); -- GPS Easting
   add_nlfc ('GPS_NORTHING',nm3type.c_number,Null,'N'); -- GPS Northing
   add_nlfc ('SURFACE',nm3type.c_varchar,500,'N'); -- Surface
   add_nlfc ('CP_LOCATION',nm3type.c_varchar,500,'N'); -- Location
   add_nlfc ('COMPASS_POINT',nm3type.c_varchar,500,'N'); -- Compass Point
   add_nlfc ('ADDTIONAL_PROP',nm3type.c_varchar,200,'N'); -- Addtional Properties
   add_nlfc ('CANCEL_REASON',nm3type.c_varchar,200,'N'); -- Cancel Reason
   add_nlfc ('SECTION_93_REQUEST',nm3type.c_varchar,4,'N'); -- Section 93 request
   add_nlfc ('SECTION_93_STATUS',nm3type.c_varchar,10,'N'); -- Section 93 Status
--
   add_nlfc ('SIDE_OF_ROAD',nm3type.c_varchar,1,'N');
   add_nlfc ('STATE_HIGHWAY',nm3type.c_varchar,3,'N');
   add_nlfc ('START_RS',nm3type.c_varchar,4,'N');
   add_nlfc ('START_MP',nm3type.c_number,Null,'N');
   add_nlfc ('START_CARRIAGEWAY',nm3type.c_varchar,1,'N');
--
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'NM_INV_ITEMS').nld_id;
   l_rec_nlfd.nlfd_seq    := 1;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('IIT_INV_TYPE',nm3flx.string(c_nlf_unique));
   upd_nlcd ('IIT_START_DATE',c_start_date); -- Effective Date
   upd_nlcd ('IIT_ADMIN_UNIT','xtnz_load_inv.get_la_au(xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAR_SECTION'||'))'); -- AU
   --
   upd_nlcd ('IIT_CHR_ATTRIB55','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.SIDE_OF_ROAD)');
   upd_nlcd ('IIT_CHR_ATTRIB30','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.ACTIVITIES_ON_PROPERTY'||')');
   upd_nlcd ('IIT_CHR_ATTRIB37','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.CROSSING_PLACE_NUMBER'||')');
   upd_nlcd ('IIT_FOREIGN_KEY','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAR_SECTION'||')');
   upd_nlcd ('IIT_CHR_ATTRIB40','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.PROPERTY_OWNER'||')');
   upd_nlcd ('IIT_CHR_ATTRIB43','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAND_OWNER_ADDRESS'||')');
   upd_nlcd ('IIT_CHR_ATTRIB44','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAND_OWNER_SUBURB'||')');
   upd_nlcd ('IIT_CHR_ATTRIB45','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LAND_OWNER_CITY'||')');
   upd_nlcd ('IIT_DATE_ATTRIB86',l_rec_nlf.nlf_unique||'.STAMPED_CP_NOTICE');
   upd_nlcd ('IIT_DATE_ATTRIB88',l_rec_nlf.nlf_unique||'.DATE_ISSUED');
   upd_nlcd ('IIT_DATE_ATTRIB87',l_rec_nlf.nlf_unique||'.DATE_ALLOCATED');
   upd_nlcd ('IIT_DATE_ATTRIB89',l_rec_nlf.nlf_unique||'.DATE_CANCELLED');
   upd_nlcd ('IIT_DATE_ATTRIB95',l_rec_nlf.nlf_unique||'.DATE_VARIATION_ISSSUED');
   upd_nlcd ('IIT_DATE_ATTRIB92',l_rec_nlf.nlf_unique||'.ADDTIONAL_ISSUE');
   upd_nlcd ('IIT_CHR_ATTRIB32','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.STATUS'||')');
   upd_nlcd ('IIT_CHR_ATTRIB31','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.LEGAL_DESCRIPTION'||')');
   upd_nlcd ('IIT_CHR_ATTRIB29','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.TYPE_OF_USE'||')');
   upd_nlcd ('IIT_CHR_ATTRIB28','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.DRAINAGE'||')');
   upd_nlcd ('IIT_NUM_ATTRIB101',l_rec_nlf.nlf_unique||'.LOT_SIZE');
   upd_nlcd ('IIT_NUM_ATTRIB100',l_rec_nlf.nlf_unique||'.MAXIMUM_WIDTH');
   upd_nlcd ('IIT_X_COORD',l_rec_nlf.nlf_unique||'.GPS_EASTING');
   upd_nlcd ('IIT_Y_COORD',l_rec_nlf.nlf_unique||'.GPS_NORTHING');
   upd_nlcd ('IIT_CHR_ATTRIB27','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.SURFACE'||')');
   upd_nlcd ('IIT_CHR_ATTRIB75','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.CP_LOCATION'||')');
   upd_nlcd ('IIT_CHR_ATTRIB57','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.COMPASS_POINT'||')');
   upd_nlcd ('IIT_CHR_ATTRIB64','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.ADDTIONAL_PROP'||')');
   upd_nlcd ('IIT_CHR_ATTRIB56','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.CANCEL_REASON'||')');
   upd_nlcd ('IIT_CHR_ATTRIB34','NVL(xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.SECTION_93_REQUEST'||'),'||nm3flx.string('NO')||')');
   upd_nlcd ('IIT_CHR_ATTRIB35','xtnz_load_inv.remove_excess_spaces('||l_rec_nlf.nlf_unique||'.SECTION_93_STATUS'||')');
   --
   l_rec_nlfd.nlfd_nlf_id := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id := nm3get.get_nld (pi_nld_table_name => 'XTNZ_LOAD_INV_ON_ROUTE').nld_id;
   l_rec_nlfd.nlfd_seq    := 2;
   nm3ins.ins_nlfd (l_rec_nlfd);
   --
   upd_nlcd ('STATE_HWY','LPAD('||l_rec_nlf.nlf_unique||'.STATE_HIGHWAY,3,'||nm3flx.string('0')||')');
   upd_nlcd ('START_RS','LPAD('||l_rec_nlf.nlf_unique||'.START_RS,4,'||nm3flx.string('0')||')');
   upd_nlcd ('START_MP',l_rec_nlf.nlf_unique||'.START_MP');
   upd_nlcd ('START_CWY',l_rec_nlf.nlf_unique||'.START_CARRIAGEWAY');
   upd_nlcd ('IIT_NE_ID','IIT.IIT_NE_ID');
   upd_nlcd ('IIT_INV_TYPE','IIT.IIT_INV_TYPE');
   upd_nlcd ('NM_START_DATE','IIT.IIT_START_DATE');
   --
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
   --
END;
/
