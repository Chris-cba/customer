--service delivered solution to overcome the mismatch between the server COR which only generates CSV defintions
--for MapCap v3 metadata.  For v4 mapcap installations use this functionality.
--it is based on nm3inv_view. create_mapcapture_csv_metadata PVCS Version     	: $Revision:   3.1  $

CREATE OR REPLACE package body x_mapcap_csv_metadata is
--<PACKAGE>
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/General Scripts/mapcap/admin/pck/X_MAPCAP_CSV_METADATA.pkb-arc   3.1   Jun 16 2010 11:06:32   iturnbull  $
--       Module Name      : $Workfile:   X_MAPCAP_CSV_METADATA.pkb  $
--       Date into SCCS   : $Date:   Jun 16 2010 11:06:32  $
--       Date fetched Out : $Modtime:   Jun 16 2010 11:04:04  $
--       SCCS Version     : $Revision:   3.1  $
--       Based on SCCS Version     : 1.7
--
--
--   Author :
--
--   DOCUMENTS application generic utilities package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--</PACKAGE>
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  G_BODY_SCCSID  CONSTANT varchar2(2000) :='"$Revision:   3.1  $"';

  G_PACKAGE_NAME CONSTANT varchar2(30) := 'X_MAPCAP_CSV_METADATA';

--
-----------------------------------------------------------------------------
--
FUNCTION GET_VERSION RETURN varchar2 IS
BEGIN
   RETURN G_SCCSID;
END GET_VERSION;
--
-----------------------------------------------------------------------------
--
FUNCTION GET_BODY_VERSION RETURN varchar2 IS
BEGIN
   RETURN G_BODY_SCCSID;
END GET_BODY_VERSION;
--
-----------------------------------------------------------------------------
--
--this procedure creates metadata for all inventory with nit_category='I'
procedure create_all_mapcap_csv_metadata is
begin
  for c1rec in
    (select nit_inv_type
    from nm_inv_types
    where nit_category='I')
  loop
    create_mapcap_csv_metadata(pi_inv_type=>c1rec.nit_inv_Type);  
  end loop;  
end create_all_mapcap_csv_metadata ;

-- this procedure creates metadata for the specified inventory type.
procedure create_mapcap_csv_metadata(pi_inv_type    varchar2) is
  PRAGMA autonomous_transaction;
   g_mapcapture_holding_table  CONSTANT varchar2(30) := 'NM_LD_MC_ALL_INV_TMP';
   g_mapcapture_installed      CONSTANT boolean      := (NVL(hig.get_sysopt('MAPCAPTURE'),'N')='Y');
--  pi_inv_type nm_inv_types_all.nit_inv_type%TYPE := pi_inv_type;
  TYPE tab_atc IS TABLE OF NM_INV_TYPE_ATTRIBS%ROWTYPE INDEX BY BINARY_INTEGER;
  l_mc_descr  CONSTANT nm_load_files.nlf_descr%TYPE := 'MapCapture load file definition for inventory type ';

  l_load_file_name nm_load_files.nlf_unique%TYPE;
  l_nlf_rec        nm_load_files%ROWTYPE;
  l_nlfc_rec       nm_load_file_cols%ROWTYPE;
  l_nld_rec        nm_load_destinations%ROWTYPE;
  l_nlfd_rec       nm_load_file_destinations%ROWTYPE;
  l_mc_cols        tab_atc;
  l_std_cols       nm3type.tab_varchar30;
  
  p_nlf_id nm_load_files.nlf_id%TYPE;
  l_st_rec nm_load_file_cols%ROWTYPE;
    
  FUNCTION get_all_columns_for_asset (pi_asset NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                                     ) RETURN tab_atc IS
  --
     CURSOR cs_cols (c_asset  NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                    ) IS
   SELECT *
    FROM  nm_inv_type_attribs
    WHERE ita_inv_type = c_asset
    ORDER BY ita_disp_seq_no;
  --
     l_tab_atc tab_atc;
  --
  BEGIN
  --
     --Nm_Debug.proc_start(g_package_name,'get_all_columns_for_asset');
  --
     FOR cs_rec IN cs_cols (pi_asset)
      LOOP
        l_tab_atc (cs_cols%rowcount) := cs_rec;
     END LOOP;
  --
     --Nm_Debug.proc_end(g_package_name,'get_all_columns_for_asset');
  --
     RETURN l_tab_atc;
  --
  END get_all_columns_for_asset;
  --
 FUNCTION get_common_columns RETURN nm3type.tab_varchar30 IS
  l_std_cols nm3type.tab_varchar30;
 BEGIN

   l_std_cols(l_std_cols.COUNT+1) := 'IIT_NE_ID';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_DESCR';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_X_SECT';
   --l_std_cols(l_std_cols.COUNT+1) := 'IIT_OWNER';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_START_DATE';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_END_DATE';
   l_std_cols(l_std_cols.COUNT+1) := 'NM_START';
   l_std_cols(l_std_cols.COUNT+1) := 'EDITMODE';
   l_std_cols(l_std_cols.COUNT+1) := 'FEATUREID';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_INV_TYPE';
   l_std_cols(l_std_cols.COUNT+1) := 'IIT_NOTE';
   l_std_cols(l_std_cols.COUNT+1) := 'NM_END';
   l_std_cols(l_std_cols.COUNT+1) := 'NE_ID';
   l_std_cols(l_std_cols.COUNT+1) := 'NE_UNIQUE';
   l_std_cols(l_std_cols.COUNT+1) := 'EXPORTED';
   l_std_cols(l_std_cols.COUNT+1) := 'REFNAME';
   l_std_cols(l_std_cols.COUNT+1) := 'REFTYPE';
   l_std_cols(l_std_cols.COUNT+1) := 'REFID';
   l_std_cols(l_std_cols.COUNT+1) := 'REF_ASS';
   l_std_cols(l_std_cols.COUNT+1) := 'PHOTO';
   l_std_cols(l_std_cols.COUNT+1) := 'SUR_DATE';
   l_std_cols(l_std_cols.COUNT+1) := 'SUR_TIME';
   
   RETURN l_std_cols;
  END get_common_columns;
  --
  FUNCTION column_already_defined(pi_nlf_id IN nm_load_files.nlf_id%TYPE
                                 ,pio_col   IN OUT varchar2) RETURN boolean IS
  CURSOR get_col(p_nlf_id IN nm_load_files.nlf_id%TYPE
                ,p_col    IN nm_load_file_cols.nlfc_holding_col%TYPE) IS
  SELECT 1
  FROM   nm_load_file_cols nlfc
  WHERE  nlfc.nlfc_nlf_id = p_nlf_id
  AND    nlfc.nlfc_holding_col = p_col;

  dummy   pls_integer;
  l_found boolean;
  BEGIN
    OPEN get_col(pi_nlf_id
                ,pio_col);
    FETCH get_col INTO dummy;
    l_found := get_col%FOUND;
    CLOSE get_col;
    IF l_found THEN
       IF pio_col = 'IIT_PRIMARY_KEY' THEN
         -- the primary key is allowed as an attribute
         -- so if it already exists as a holding column assign it to another column
         pio_col := 'NLM_PRIMARY_KEY';
         RETURN FALSE;
       ELSE
         RETURN TRUE;
       END IF;
    ELSE
       RETURN FALSE;
    END IF;
  END column_already_defined;
  --
  FUNCTION get_column_name (pi_column IN varchar2
                           ,pi_nlf_id IN nm_load_files.nlf_id%TYPE) RETURN varchar2 IS

  l_col varchar2(30) := UPPER(pi_column);
  BEGIN
    -- if the column name is one of the route columns then
    -- do not try to get the attribute
    l_std_cols := get_common_columns;
    IF l_col IN ('NE_ID', 'NM_START', 'NM_END', 'IIT_X_SECT', 'IIT_END_DATE', 'NAU_UNIT_CODE') THEN
      RETURN l_col;
    END IF;

    FOR i IN 1..l_std_cols.COUNT LOOP
      IF UPPER(l_std_cols(i)) = l_col THEN
        -- its a standard column so no need to get the column name from the attrbute table
        RETURN l_col;
      END IF;
    END LOOP;

   -- otherwise it is not a common column so we need to look up the actual
   -- inventory column in the attribs table
    l_col := UPPER(nm3inv.get_ita_by_view_col(pi_inv_type      => pi_inv_type
                                             ,pi_view_col_name => l_col).ita_attrib_name);

    RETURN l_col;
  END get_column_name;
  --
  FUNCTION get_mapcapture_load_dest (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
  BEGIN
  --
     RETURN 'NM_LD_MC_ALL_INV_TMP';
  --
  END get_mapcapture_load_dest;
  --
  FUNCTION get_next_seq_no (p_nlf_id IN nm_load_files.nlf_id%TYPE) RETURN pls_integer IS
    CURSOR get_seq (p_nlf_id IN nm_load_files.nlf_id%TYPE) IS
    SELECT NVL(MAX(nlfc_seq_no),0)
    FROM   nm_load_file_cols
    WHERE  nlfc_nlf_id = p_nlf_id;

    l_retval pls_integer;
  BEGIN
    OPEN get_seq(p_nlf_id);
    FETCH get_seq INTO l_retval;
    CLOSE get_seq;

    RETURN l_retval +1;
  END get_next_seq_no;
  --
BEGIN

  --nm_debug.proc_start(g_package_name,'create_mapcapture_csv_metadata');

  l_load_file_name := nm3inv_view.get_mapcapture_csv_unique_ref(pi_inv_type);

  -- first check that the mapcap_dir is set
  IF hig.get_sysopt('MAPCAP_DIR') IS NULL THEN
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 163
                 ,pi_supplementary_info => 'MAPCAP_DIR');
  END IF;

  -- delete previous definition first
  nm3del.del_nlf(pi_nlf_unique => l_load_file_name
                ,pi_raise_not_found => FALSE);

  -- check that the view exists
--  IF nm3ddl.does_object_exist(p_object_name => nm3inv_view.get_inv_on_route_view_name(pi_inv_type)
--                             ,p_object_type => 'VIEW') THEN
    l_nlf_rec.nlf_id     := nm3load.get_next_nlf_id;
    l_nlf_rec.nlf_unique := l_load_file_name;
    l_nlf_rec.nlf_descr  := l_mc_descr||pi_inv_type;
    l_nlf_rec.nlf_path   := hig.get_sysopt('MAPCAP_DIR');
    l_nlf_rec.nlf_delimiter := CHR(44);
    l_nlf_rec.nlf_date_format_mask := nm3mapcapture_int.c_date_format;
    l_nlf_rec.nlf_holding_table := g_mapcapture_holding_table;

    nm3ins.ins_nlf(p_rec_nlf => l_nlf_rec);

    -- now create the standard file columns
    
      p_nlf_id := l_nlf_rec.nlf_id;

      BEGIN
    
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_NE_ID';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_DESCR';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 200;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
    
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_X_SECT';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 4;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
          
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_OWNER';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 10;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_START_DATE';
          l_st_rec.nlfc_datatype         := 'DATE';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := nm3mapcapture_int.c_date_format;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
    
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_END_DATE';
          l_st_rec.nlfc_datatype         := 'DATE';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := nm3mapcapture_int.c_date_format;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
    
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'NM_START';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
          
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'EDITMODE';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 1;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);
          
          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'FEATUREID';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_INV_TYPE';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 4;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'IIT_NOTE';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 200;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'NM_END';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'NE_ID';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'NE_UNIQUE';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 30;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'EXPORTED';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 1;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'REFNAME';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 200;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'REFTYPE';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 200;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'REFID';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'REF_ASS';
          l_st_rec.nlfc_datatype         := 'NUMBER';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'PHOTO';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 500;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'SUR_DATE';
          l_st_rec.nlfc_datatype         := 'DATE';
          l_st_rec.nlfc_varchar_size     := NULL;
          l_st_rec.nlfc_date_format_mask := nm3mapcapture_int.c_date_format;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

          l_st_rec.nlfc_nlf_id           := p_nlf_id;
          l_st_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
          l_st_rec.nlfc_holding_col      := 'SUR_TIME';
          l_st_rec.nlfc_datatype         := 'VARCHAR2';
          l_st_rec.nlfc_varchar_size     := 20;
          l_st_rec.nlfc_date_format_mask := NULL;
          l_st_rec.nlfc_mandatory        := 'N';
    
          nm3ins.ins_nlfc(l_st_rec);

   END;

    -- now create the file columns based on the display sequence of
    -- the inv attribs.
    l_mc_cols := get_all_columns_for_asset(pi_inv_type);
    FOR i IN 1..l_mc_cols.COUNT LOOP

      l_nlfc_rec.nlfc_holding_col      := get_column_name(l_mc_cols(i).ita_view_col_name
                                                         ,l_nlf_rec.nlf_id);

      IF NOT column_already_defined(l_nlf_rec.nlf_id
                                   ,l_nlfc_rec.nlfc_holding_col) THEN

        l_nlfc_rec.nlfc_nlf_id           := l_nlf_rec.nlf_id;
        l_nlfc_rec.nlfc_seq_no           := get_next_seq_no(l_nlf_rec.nlf_id);
        l_nlfc_rec.nlfc_datatype         := l_mc_cols(i).ita_format;

        IF l_mc_cols(i).ita_format = 'VARCHAR2' THEN
          l_nlfc_rec.nlfc_varchar_size     := l_mc_cols(i).ita_fld_length;
          l_nlfc_rec.nlfc_date_format_mask := NULL;
        ELSIF l_mc_cols(i).ita_format = 'DATE' THEN
          l_nlfc_rec.nlfc_varchar_size := NULL;
          l_nlfc_rec.nlfc_date_format_mask := l_nlf_rec.nlf_date_format_mask;
        ELSE
          l_nlfc_rec.nlfc_varchar_size := NULL;
          l_nlfc_rec.nlfc_date_format_mask := NULL;
        END IF;

        IF l_mc_cols(i).ita_mandatory_yn = 'N' THEN
          l_nlfc_rec.nlfc_mandatory := 'Y';
        ELSE
          l_nlfc_rec.nlfc_mandatory := 'N';
        END IF;

        nm3ins.ins_nlfc(l_nlfc_rec);

      END IF;

    END LOOP;

    -- now create the file destination defnintions
    -- get the destination
    l_nld_rec := nm3get.get_nld(pi_nld_table_name => get_mapcapture_load_dest(pi_inv_type));

    l_nlfd_rec.nlfd_nlf_id := l_nlf_rec.nlf_id;
    l_nlfd_rec.nlfd_nld_id := l_nld_rec.nld_id;
    l_nlfd_rec.nlfd_seq    := 1;

    nm3ins.ins_nlfd(p_rec_nlfd => l_nlfd_rec);

    -- trigger on nm_load_file_destinations fires and creates a file_destination column for
    -- every column in the holding table.

    -- now add the destination columns
    -- to values supplied in the file

    UPDATE nm_load_file_col_destinations
    SET    nlcd_source_col = l_nlf_rec.nlf_unique||'.'||nlcd_dest_col
    WHERE  nlcd_nlf_id = l_nlf_rec.nlf_id
    AND    nlcd_nld_id = l_nld_rec.nld_id
    AND   (nlcd_dest_col IN (SELECT nlfc_holding_col
                             FROM nm_load_file_cols nlfc
                             WHERE nlfc_nlf_id = l_nlf_rec.nlf_id)
       OR  nlcd_dest_col IN ('BATCH_NO', 'RECORD_NO')); -- need to copy over the batch and record nu

--  END IF;

  COMMIT;
  --nm_debug.proc_end(g_package_name,'create_mapcapture_csv_metadata');
--END create_mapcapture_csv_metadata;

end create_mapcap_csv_metadata ;

end x_mapcap_csv_metadata ; 
/

