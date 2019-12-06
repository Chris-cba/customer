CREATE OR REPLACE PACKAGE BODY nm3mcp_int AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/tfl/Defect 1068830/nm3mcp_int.pkb-arc   1.0   Dec 06 2019 14:27:24   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3mcp_int.pkb  $
--       Date into SCCS   : $Date:   Dec 06 2019 14:27:24  $
--       Date fetched Out : $Modtime:   Dec 06 2019 14:18:34  $
--       SCCS Version     : $Revision:   1.0  $
--
--
--   Author : Darren Cope
--
--   MapCapture File Loader
--
--   AE : Re-written for TFL
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   1.0  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mcp_int';
--
--
   g_mapcapture_holding_table CONSTANT varchar2(30) := 'NM_MCP_LOAD_TEMP';
   -- a flag to indicate if errors have occurred
   g_success                           boolean DEFAULT TRUE;
--

   TYPE rec_errors IS RECORD
       (appl      hig_errors.her_appl%TYPE
       ,error_no  hig_errors.her_no%TYPE
       ,supp_info varchar2(2000)
       ,batch_no  nm_load_batch_lock.nlbl_batch_id%TYPE
       ,in_prc    varchar2(50)
       );

   TYPE tab_errors IS TABLE OF rec_errors INDEX BY binary_integer;

   g_errors tab_errors;
   ex_external_job_down            EXCEPTION;
   PRAGMA                          EXCEPTION_INIT (ex_external_job_down,-27370);
--
--ORA-27369: job of type EXECUTABLE failed with exit code: Incorrect function.
--
   ex_sde_service_down             EXCEPTION;
   PRAGMA                          EXCEPTION_INIT (ex_sde_service_down,-27369);
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
procedure set_survey_attributes( pi_inv_type in nm_inv_types.nit_inv_type%type ) is

  type ita_vc           is varray(2) of varchar2(30);
  type ita_data_type    is varray(2) of varchar2(30);  

  l_ita_attrib_name    ita_vc;
  l_data_type          ita_data_type;
  l_ita_format_mask    ita_vc;

  begin

    select ita.ita_attrib_name, data_type, ita_format_mask
    bulk collect into l_ita_attrib_name, l_data_type, l_ita_format_mask
    from nm_inv_type_attribs ita, all_tab_columns
    where owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
    and   table_name = 'NM_INV_ITEMS_ALL'
    and ita_attrib_name = column_name
    and ita_inv_type = pi_inv_type
    and ita_view_attri in ('SURVEY_DATE', 'SURVEY_TIME')
--  and ita_mandatory = 'Y'
    and ita_inspectable = 'N' 
    order by ita_view_attri;     
--
    if l_ita_attrib_name.count != 2 then
      raise_application_error( -20110, 'Mismatching attribute map for survery date and time' );
    end if;
    
    g_survey_date_col  := l_ita_attrib_name(1);
    g_survey_data_type := l_data_type(1);
    g_survey_date_mask := l_ita_format_mask(1);
    g_survey_time_col  := l_ita_attrib_name(2);
                
  end;
 
-----------------------------------------------------------------------------
PROCEDURE get_survey_date_and_time( pi_iit_ne_id     in  nm_inv_items.iit_ne_id%type,
--                                    pi_iit_inv_type  in  nm_inv_items.iit_inv_type%type,
--                                    po_date_attrib   out nm_inv_type_attribs.ita_attrib_name%type,
--                                    po_time_attrib   out nm_inv_type_attribs.ita_attrib_name%type,                                     
                                    po_survey_date out date, 
                                    po_survey_time out varchar2 ) is
  
--  type ita_vc           is varray(2) of varchar2(30);
--  type ita_data_type    is varray(2) of varchar2(30);  
--
--  l_ita_attrib_name    ita_vc;
--  l_data_type          ita_data_type;
--  l_ita_format_mask    ita_vc;

  begin
--
--    select ita.ita_attrib_name, data_type, ita_format_mask
--    bulk collect into l_ita_attrib_name, l_data_type, l_ita_format_mask
--    from nm_inv_type_attribs ita, all_tab_columns
--    where owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
--    and   table_name = 'NM_INV_ITEMS_ALL'
--    and ita_attrib_name = column_name
--    and ita_inv_type = pi_iit_inv_type
--    and ita_view_attri in ('SURVEY_DATE', 'SURVEY_TIME')
----  and ita_mandatory = 'Y'
--    and ita_inspectable = 'N' 
--    order by ita_view_attri; 
--    
--
--    if l_ita_attrib_name.count != 2 then
--      raise_application_error( -20110, 'Mismatching attribute map for survery date and time' );
--    end if;
    
    if g_survey_data_type = 'DATE' then
    
      execute immediate 'select  '||g_survey_date_col||', '||g_survey_time_col||' from nm_inv_items_all where iit_ne_id = :b_iit_ne_id ' 
                        into po_survey_date, po_survey_time using pi_iit_ne_id;
      
    elsif g_survey_data_type = 'VARCHAR2' and g_survey_date_mask is not null then
    
      execute immediate 'select to_date('||g_survey_date_col||', '||NM3FLX.STRING(g_survey_date_mask)||'), '||g_survey_time_col||' from nm_inv_items_all where iit_ne_id = :b_iit_ne_id '
                        into po_survey_date, po_survey_time using pi_iit_ne_id;

    else
      raise_application_error( -20110, 'Mismatching attribute map for survery date and time' );
    end if;
    
--    po_date_attrib := l_ita_attrib_name(1);
--    po_time_attrib := l_ita_attrib_name(2);
--    
--    g_survey_date_col := l_ita_attrib_name(1);
--    g_survey_time_col := l_ita_attrib_name(2);
--    
            
  end;
--
FUNCTION get_mapcap_email_recipients RETURN nm3mail.tab_recipient IS
l_recip nm3mail.tab_recipient;
BEGIN
  -- construct the recipients of the email
  l_recip(1).rcpt_id   := hig.get_sysopt('MAPCAP_EML');
  l_recip(1).rcpt_type := nm3mail.c_group;

  RETURN l_recip;
END get_mapcap_email_recipients;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_email(p_body    IN nm3type.tab_varchar32767
                    ,p_subject IN varchar2) IS
   PRAGMA AUTONOMOUS_TRANSACTION;

l_to      nm3mail.tab_recipient;
l_cc      nm3mail.tab_recipient;
l_bcc     nm3mail.tab_recipient;
BEGIN
  l_to := get_mapcap_email_recipients;
  -- now put it in the queue
  nm3mail.write_mail_complete(p_from_user        => nm3mail.get_default_nmu_id
                             ,p_subject          => p_subject
                             ,p_html_mail        => FALSE
                             ,p_tab_to           => l_to
                             ,p_tab_cc           => l_cc
                             ,p_tab_bcc          => l_bcc
                             ,p_tab_message_text => p_body);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    COMMIT;
END send_email;
--
-----------------------------------------------------------------------------
--
FUNCTION batch_has_no_errors (pi_batch_no IN nm_load_batches.nlb_batch_no%TYPE )
RETURN BOOLEAN
IS
  CURSOR c1 (cp_batch_no IN nm_load_batches.nlb_batch_no%TYPE )
  IS
    SELECT COUNT(*) FROM nm_load_batch_status
     WHERE nlbs_nlb_batch_no = cp_batch_no
       AND nlbs_status = 'E';
  l_count NUMBER;
BEGIN
  OPEN c1 (pi_batch_no);
  FETCH c1 INTO l_count;
  CLOSE c1;
  IF l_count > 0 THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END batch_has_no_errors;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_email(p_body    IN varchar2
                    ,p_subject IN varchar2) IS
l_tab_vc nm3type.tab_varchar32767;
BEGIN
  l_tab_vc(1) := p_body;
  send_email(l_tab_vc
            ,p_subject);
END send_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_errors IS
BEGIN
  g_errors.DELETE;
  g_success := TRUE;
END clear_errors;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_error_email(pi_batch IN varchar2 DEFAULT NULL) IS

l_subject        nm_mail_message.nmm_subject%TYPE := 'MapCapture Error log';
l_error_msg_body nm3type.tab_varchar32767;
l_line           nm3type.max_varchar2;
--
PROCEDURE nl IS
BEGIN
  l_error_msg_body(l_error_msg_body.COUNT+1) := nm3type.c_newline;
END nl;
--
PROCEDURE add_line(p_to_add IN varchar2
                  ,p_add_cr IN boolean DEFAULT TRUE) IS
BEGIN
  l_error_msg_body(l_error_msg_body.COUNT+1) := p_to_add;
  IF p_add_cr THEN
    nl;
  END IF;
END add_line;
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'send_error_email');

  nm_debug.debug(g_errors.COUNT||' errors on stack');

  IF pi_batch IS NOT NULL THEN
    l_subject := l_subject || ' for batch '||pi_batch;
  END IF;

  FOR I IN 1..g_errors.COUNT LOOP

    add_line(hig.raise_and_catch_ner(pi_appl => g_errors(i).appl
                                    ,pi_id   => g_errors(i).error_no
                                    ,pi_supplementary_info => NULL));

    IF g_errors(i).batch_no IS NOT NULL THEN
      add_line(' found during processing of batch '||g_errors(i).batch_no);
    END IF;

    IF g_errors(i).in_prc IS NOT NULL THEN
      add_line(' caught in '||g_errors(i).in_prc);
    END IF;


    IF g_errors(i).supp_info IS NOT NULL THEN
      add_line('Supporting details: '||g_errors(i).supp_info);

    END IF;

    nl;
    nl;
    nl;
  END LOOP;

  IF g_errors.COUNT > 0 THEN
    send_email(p_body    => l_error_msg_body
              ,p_subject => l_subject);
  END IF;

  -- clear the errors
  clear_errors;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'send_error_email');
END send_error_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE catch_error(p_appl    IN hig_errors.her_appl%TYPE DEFAULT nm3type.c_hig
                     ,p_error   IN hig_errors.her_no%TYPE   DEFAULT 207
                     ,p_supp    IN varchar2 DEFAULT NULL
                     ,p_batch   IN varchar2 DEFAULT NULL
                     ,p_in_prc  IN varchar2 DEFAULT NULL) IS

l_new_error_no pls_integer DEFAULT g_errors.COUNT +1;
BEGIN

  nm_debug.debug('Error caught in '||p_in_prc||' is '||p_supp);

  g_success := FALSE;

  g_errors(l_new_error_no).appl      := p_appl;
  g_errors(l_new_error_no).error_no  := p_error;
  g_errors(l_new_error_no).supp_info := p_supp;
  g_errors(l_new_error_no).batch_no  := p_batch;
  g_errors(l_new_error_no).in_prc    := p_in_prc;

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_who_trigger IS
CURSOR check_for_trigger IS
SELECT trigger_name
FROM   user_triggers
WHERE  table_name = g_mapcapture_holding_table
AND    trigger_name LIKE '%WHO';

BEGIN
  FOR i IN check_for_trigger LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER '||i.trigger_name;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => NULL
               ,p_in_prc => 'clear_who_trigger');
END clear_who_trigger;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_the_batch_for_loading(pi_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE) RETURN boolean IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  -- check if the batch has already been loaded
  -- if so return FALSE
--  INSERT INTO nm_load_batch_lock_mcp
  INSERT INTO nm_load_batch_lock
  (nlbl_batch_id)
  VALUES
  (pi_nlb_batch_no);

  COMMIT;


  RETURN TRUE;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    RETURN FALSE;
  WHEN OTHERS THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => pi_nlb_batch_no
               ,p_in_prc => 'lock_the_batch_for_loading');
    ROLLBACK;
    RETURN FALSE;
END lock_the_batch_for_loading;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_batch_active (pi_batch IN varchar2) IS

CURSOR c_lock_batch (p_batch nm_load_batch_lock.nlbl_batch_id%TYPE) IS
SELECT 1
--FROM   nm_load_batch_lock_mcp
FROM   nm_load_batch_lock
WHERE  nlbl_batch_id = p_batch
FOR UPDATE NOWAIT;

dummy NUMBER;
BEGIN
  -- lock the lock to ensure that no-one else can delete it
  OPEN c_lock_batch(pi_batch);
  FETCH c_lock_batch INTO dummy;
  CLOSE c_lock_batch;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_lock (pi_batch IN varchar2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

  -- clear the lock
--  DELETE FROM nm_load_batch_lock_mcp
  DELETE FROM nm_load_batch_lock
  WHERE nlbl_batch_id = pi_batch;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END clear_lock;

--
-----------------------------------------------------------------------------
--
PROCEDURE mcp_doc_upload ( pi_batch_no  IN nm_load_batches.nlb_batch_no%TYPE
                         , pi_record_no IN nm_mcp_load_temp.record_no%TYPE
                         , pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE)
IS

  l_nit_type         nm_inv_types.nit_inv_type%TYPE;
  l_nit              nm_inv_types%ROWTYPE;
  l_table_name       VARCHAR2(30);
--  l_tab_doc_id       Nm3type.tab_number;
--  l_tab_iit_ne_id    Nm3type.tab_number;
--  l_tab_doc_file     Nm3type.tab_varchar2000;
  l_doc_id           docs.doc_id%TYPE;
  l_iit_ne_id        nm_inv_items.iit_ne_id%TYPE;
  l_doc_file         VARCHAR2(2000);
  l_rec_dlo          doc_locations%ROWTYPE;
--
BEGIN
--
--  nm_debug.debug_on;
  SELECT UNIQUE iit_inv_type
    INTO l_nit_type
    FROM NM_MCP_LOAD_TEMP
   WHERE batch_no = pi_batch_no;
--
  l_nit := nm3get.get_nit(l_nit_type);
--
  l_table_name := l_nit.nit_table_name;
--

  IF l_table_name IS NULL THEN
    l_table_name := 'NM_INV_ITEMS';
  END IF;
--

  DECLARE
    l_rec_dgs doc_gate_syns%ROWTYPE;
  BEGIN
    SELECT * INTO l_rec_dgs FROM doc_gate_syns
      WHERE dgs_table_syn = l_table_name;
    IF l_rec_dgs.dgs_dgt_table_name IS NOT NULL
    THEN
      l_table_name := l_rec_dgs.dgs_dgt_table_name ;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN NULL;
  END;
--
 -- Only called when nmlt_photo is not null, so no need to check here for photo
  SELECT doc_id_seq.NEXTVAL, iit_ne_id, nmlt_photo
    --BULK COLLECT INTO l_tab_doc_id, l_tab_iit_ne_id, l_tab_doc_file
    INTO l_doc_id, l_iit_ne_id, l_doc_file
    FROM NM_MCP_LOAD_TEMP
   WHERE batch_no = pi_batch_no
     AND record_no = pi_record_no;
--
  IF l_iit_ne_id = -1 -- new
  THEN
    l_iit_ne_id := pi_iit_ne_id;
  END IF;
--

  SELECT * INTO l_rec_dlo
    FROM doc_locations
   WHERE dlc_name = hig.get_user_or_sys_opt('MCPDLC');
--

--
  nm_debug.debug ('Creating DOC - '||l_doc_id);
  nm_debug.debug ('DLC id = '||l_rec_dlo.dlc_id);
  nm_debug.debug('DMD id = '|| l_rec_dlo.dlc_dmd_id);
  --
  INSERT INTO DOCS
    ( doc_id,
      doc_title,
      doc_dtp_code,
      doc_date_issued,
      doc_file,
      doc_dlc_dmd_id,
      doc_dlc_id,
      doc_reference_code,
      doc_descr )
  VALUES (
      l_doc_id,
      'Image of '||l_nit_type||' '||TO_CHAR(l_iit_ne_id)||' from MCP Batch '||TO_CHAR(pi_batch_no),
      'PHOT',
      SYSDATE,
      l_doc_file,
      l_rec_dlo.dlc_dmd_id,--3, --location for photos
      l_rec_dlo.dlc_id,--1, --media
      l_doc_file,
      'Image of '||l_nit_type||' '||TO_CHAR(l_iit_ne_id)||' from MCP Batch '||TO_CHAR(pi_batch_no)
      );
--
  nm_debug.debug('Inserted DOC');
  INSERT INTO DOC_ASSOCS
    ( das_table_name, das_rec_id, das_doc_id)
  VALUES
    ( l_table_name, l_iit_ne_id, l_doc_id);
  nm_debug.debug('Inserted DOCASSOC');
--
EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END mcp_doc_upload;
--
-----------------------------------------------------------------------------
--
FUNCTION is_user_allowed_to_load_record (pi_username  IN hig_users.hus_username%TYPE
                                        ,pi_inspector IN nm_admin_units.nau_unit_code%TYPE)
  RETURN BOOLEAN
IS
  l_unit_code          nm_admin_units.nau_unit_code%TYPE;
  l_loading_unit_code  nm_admin_units.nau_unit_code%TYPE;
  l_level              NUMBER;
BEGIN
--
  SELECT nau_unit_code, nau_level INTO l_unit_code, l_level
    FROM hig_users, nm_admin_units
   WHERE hus_admin_unit = nau_admin_unit
     AND hus_username = pi_username;
--
  SELECT nau_unit_code INTO l_loading_unit_code
    FROM hig_users, nm_admin_units
   WHERE hus_admin_unit = nau_admin_unit
     AND hus_initials = pi_inspector;
--
  IF l_level != 1
  THEN 
    IF l_unit_code != l_loading_unit_code
    THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  ELSE
    RETURN TRUE;
  END IF;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN FALSE;
END is_user_allowed_to_load_record;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_holding_table(pi_nlb_batch_no      nm_load_batches_mcp.nlb_batch_no%TYPE) IS
--
 CURSOR cs_rowid (c_batch_no nm_load_batches_mcp.nlb_batch_no%TYPE) IS
   SELECT tab.ROWID  tab_rowid
         ,nlbs.ROWID nlbs_rowid
     FROM nm_mcp_load_temp tab
  --       ,nm_load_batch_status_mcp nlbs
         ,nm_load_batch_status nlbs
    WHERE tab.batch_no           = c_batch_no
      AND nlbs.nlbs_nlb_batch_no = tab.batch_no
      AND nlbs.nlbs_record_no    = tab.record_no
      AND nlbs.nlbs_status       = 'H'
      AND tab.nmlt_editmode IS NOT NULL
    ORDER BY tab.batch_no, tab.record_no;
--
  CURSOR cs_load (c_tab_rowid ROWID) IS
    SELECT tab.* FROM nm_mcp_load_temp tab
     WHERE tab.ROWID  = c_tab_rowid;
--
  CURSOR get_theme_for_asset_type (cp_asset_Type IN nm_inv_types.nit_inv_type%TYPE)
     IS
       SELECT * FROM nm_themes_all
        WHERE nth_base_table_theme IS NULL
          AND (nth_feature_table  NOT LIKE '%_MAPCAPTURE_%'
               AND nth_feature_table NOT LIKE '%_MCP_%')
          AND EXISTS
          (SELECT 1 FROM nm_inv_themes
            WHERE nth_theme_id = nith_nth_theme_id
              AND nith_nit_id = cp_asset_type);
--
  l_tab_rowid                   nm3type.tab_rowid;
  l_tab_nlbs_rowid              nm3type.tab_rowid;
  l_error                       VARCHAR2(5000);
  l_error_text                  VARCHAR2(5000);
--l_rec                         cs_load%ROWTYPE;
  c_commit_threshold   CONSTANT NUMBER := nm3load.get_commit_threshold;
  l_rec_nth                     nm_themes_all%ROWTYPE;
  l_out_iit_ne_id               nm_inv_items.iit_ne_id%TYPE;
  l_theme_gtypes                nm3type.tab_number;
  b_gtype_match_found           BOOLEAN;
  
  l_inv_type                    NM_INV_TYPES.NIT_INV_TYPE%TYPE;
  l_theme_srid                  user_sdo_geom_metadata.srid%type;
  
  l_rec_date_attrib             NM_INV_TYPE_ATTRIBS.ITA_ATTRIB_NAME%TYPE;
  l_rec_time_attrib             NM_INV_TYPE_ATTRIBS.ITA_ATTRIB_NAME%TYPE;

  l_rec_survey_date             DATE;
  l_rec_survey_time             VARCHAR2(8);
  
  l_xy_inventory                BOOLEAN := FALSE;
  
  l_use_primary_key             VARCHAR2(1) := 'N';
--
  ex_invalid_editmode           EXCEPTION;
  ex_no_shape                   EXCEPTION;
  ex_no_survey_date             EXCEPTION;
  ex_no_survey_time             EXCEPTION;
  ex_old_rec_newer_than_file    EXCEPTION;
  ex_geom_has_no_srid           EXCEPTION;
  ex_geom_has_wrong_srid        EXCEPTION;
  ex_geom_has_invalid_gtype     EXCEPTION;
  ex_no_asset_type              EXCEPTION;
  ex_invalid_gtype_for_layer    EXCEPTION;
  ex_migrating_das              EXCEPTION;
  ex_too_many_themes            EXCEPTION;
  ex_not_allowed_to_load        EXCEPTION;
  ex_generic_theme              EXCEPTION;
  ex_no_themes                  EXCEPTION;
  ex_already_loaded             EXCEPTION;
  ex_invalid_insert_mode        EXCEPTION;
  ex_no_xy_from_shape           EXCEPTION;
  ex_insert_API_failure         EXCEPTION;
  ex_trigger_fail               EXCEPTION; 
--  
  l_errm    varchar2(4000);

--
-------------------------------------------------------
  PROCEDURE update_status (pi_rowid ROWID
                          ,pi_status VARCHAR2
                          ,pi_text   VARCHAR2) IS
    PRAGMA autonomous_transaction;
  BEGIN
--    UPDATE nm_load_batch_status_mcp
    UPDATE nm_load_batch_status
     SET   nlbs_status       = pi_status
          ,nlbs_text         = SUBSTR(pi_text,1,4000)
    WHERE  rowid = pi_rowid;

    COMMIT;
  END update_status;
-------------------------------------------------------
  PROCEDURE get_inv_type_from_batch
             ( pi_batch_no         IN nm_load_batches_mcp.nlb_batch_no%TYPE, 
               po_nit_inv_type    OUT nm_inv_types.nit_inv_type%TYPE,
               po_use_primary_key OUT varchar2 ) IS
  BEGIN 
 -- 
     select mub_asset_type
     into   po_nit_inv_type
     from mcp_upload_batches_nit n, 
          nm_load_batches_mcp l
     where l.nlb_filename = mub_filename
     and  nlb_batch_no = pi_batch_no
     and rownum = 1;        

     begin
       select nvl(ita_inspectable,'N')
       into   po_use_primary_key
       from nm_inv_type_attribs
       where ita_inv_type  = po_nit_inv_type
       and ita_attrib_name = 'IIT_PRIMARY_KEY';
     exception
       when no_data_found
       then 
         po_use_primary_key := 'N';
       when others then
         po_use_primary_key := 'N';
     end;     
--
  END;
--
  FUNCTION get_theme_from_batch_no
             ( pi_batch_no IN nm_load_batches_mcp.nlb_batch_no%TYPE )
  RETURN nm_themes_all%ROWTYPE IS
    l_retval nm_themes_all%ROWTYPE;
  BEGIN
    SELECT * INTO l_retval FROM nm_themes_all
     WHERE EXISTS
       (SELECT 1 FROM nm_mcp_load_temp, nm_inv_themes
         WHERE batch_no = pi_batch_no
           AND iit_inv_type = nith_nit_id
           AND nth_theme_id = nith_nth_theme_id
           AND (nth_feature_table  NOT LIKE '%_MAPCAPTURE_%'
             AND nth_feature_table NOT LIKE '%_MCP_%'))
        AND nth_base_table_theme IS NULL;
--      AND EXISTS
--        (SELECT 1 FROM gis_themes
--          WHERE gt_theme_id = nth_theme_id);
    RETURN l_retval;
  END get_theme_from_batch_no;
--
-------------------------------------------------------
--
   FUNCTION get_theme_gtypes (pi_asset_type IN nm_inv_types.nit_inv_type%TYPE)
   RETURN nm3type.tab_number
   IS
     l_rec_nth nm_themes_all%ROWTYPE;
     retval    nm3type.tab_number;
   BEGIN
     OPEN get_theme_for_asset_type( pi_asset_Type );
     FETCH get_theme_for_asset_type INTO l_rec_nth;
     CLOSE get_theme_for_asset_type;
   --
     IF l_rec_nth.nth_feature_table IS NOT NULL
     AND l_rec_nth.nth_feature_shape_column IS NOT NULL
     THEN
       EXECUTE IMMEDIATE 'select distinct a.'||l_rec_nth.nth_feature_shape_column
                       ||'.sdo_gtype from '||l_rec_nth.nth_feature_table||' a'
       BULK COLLECT INTO retval;
     END IF;
     RETURN retval;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN RETURN retval;
   END get_theme_gtypes;
 --
   FUNCTION get_theme_srid (pi_asset_type IN nm_inv_types.nit_inv_type%TYPE)
   RETURN NUMBER
   IS
     l_rec_nth nm_themes_all%ROWTYPE;
     retval    NUMBER;
   BEGIN
     OPEN get_theme_for_asset_type( pi_asset_Type );
     FETCH get_theme_for_asset_type INTO l_rec_nth;
     CLOSE get_theme_for_asset_type;
   --
     IF l_rec_nth.nth_feature_table IS NOT NULL
     AND l_rec_nth.nth_feature_shape_column IS NOT NULL
     THEN
       EXECUTE IMMEDIATE 'SELECT srid FROM user_sdo_geom_metadata' ||
                         ' WHERE table_name = '||nm3flx.string(l_rec_nth.nth_feature_table)||
                           ' AND column_name = '||nm3flx.string(l_rec_nth.nth_feature_shape_column)
       INTO retval;
     END IF;
     RETURN retval;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN RETURN retval;
   END get_theme_srid;
--
---------------------------------------------------------
--
  PROCEDURE migrate_doc_assocs ( pi_old_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                               , pi_new_iit_ne_id nm_inv_items.iit_ne_id%TYPE )
  IS
    TYPE tab_docassocs IS TABLE OF doc_assocs%ROWTYPE INDEX BY BINARY_INTEGER;
    l_tab_das          tab_docassocs;
  BEGIN
  --
    SELECT * BULK COLLECT INTO l_tab_das FROM doc_assocs
     WHERE das_table_name IN ( SELECT 'NM_INV_ITEMS'     FROM dual                               UNION
                               SELECT 'NM_INV_ITEMS_ALL' FROM dual                               UNION
                               SELECT 'INV_ITEMS_ALL'    FROM dual                               UNION
                               SELECT 'INV_ITEMS'        FROM dual                               UNION
                               SELECT dgs_table_syn      FROM doc_gate_syns
                               WHERE dgs_dgt_table_name IN ('NM_INV_ITEMS','NM_INV_ITEMS_ALL'))
       AND das_rec_id = to_char(pi_old_iit_ne_id);
  --
    IF l_tab_das.COUNT > 0
    THEN
      FOR i IN l_tab_das.FIRST .. l_tab_das.LAST
      LOOP
        --nm_Debug.debug_on;
        nm_debug.debug ('Inserting - '||l_tab_das(i).das_table_name||
                        ' - '||pi_new_iit_ne_id|| ' - '|| l_tab_das(i).das_doc_id);
        INSERT INTO doc_assocs (das_table_name, das_rec_id, das_doc_id)
        SELECT   l_tab_das(i).das_table_name
               , to_char(pi_new_iit_ne_id)
               , l_tab_das(i).das_doc_id
          FROM dual
          WHERE NOT EXISTS
            (SELECT 1 FROM doc_assocs
              WHERE das_table_name = l_tab_das(i).das_table_name
                AND das_rec_id     = to_char(pi_new_iit_ne_id)
                AND das_doc_id     = l_tab_das(i).das_doc_id);
      END LOOP;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END migrate_doc_assocs;
--
----------------------------------------------------------
--
  PROCEDURE migrate_defects_to_new_asset (pi_old_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE
                                         ,pi_new_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE
                                         ,pi_asset_type    IN nm_inv_items.iit_inv_type%TYPE)
  IS
  BEGIN
    IF hig.is_product_licensed (nm3type.c_mai)
    THEN
      EXECUTE IMMEDIATE
        'UPDATE DEFECTS SET def_iit_item_id = :pi_new_iit '||
         'WHERE def_iit_item_id = :pi_old_iit '||
         ' AND def_ity_inv_code = mai.translate_nm_inv_type('||nm3flx.string(pi_asset_type)||')'
      USING IN pi_new_iit_ne_id
          , IN pi_old_iit_ne_id;
    END IF;
  END migrate_defects_to_new_asset;

--

  FUNCTION is_XY_asset( pi_theme_id   IN nm_themes_all.nth_theme_id%TYPE ) return BOOLEAN is
  retval   BOOLEAN := FALSE;
  l_dummy  INT;
  
  BEGIN
     
    BEGIN
      select 1 into l_dummy
      from dual
        where exists (
          select nth_theme_id, nth_feature_table from nm_themes_all, nm_inv_themes, nm_inv_types
          where nit_inv_type = nith_nit_id
          and nith_nth_theme_id = nth_theme_id
          and nit_use_xy = 'Y'
          and exists ( select 1 from nm_inv_type_attribs
                       where ita_inv_type = nit_inv_type
                       and ita_attrib_name = 'IIT_X'
                       and ita_inspectable = 'N' ) 
          and exists ( select 1 from nm_inv_type_attribs
                       where ita_inv_type = nit_inv_type
                       and ita_attrib_name = 'IIT_Y'
                       and ita_inspectable = 'N' ) 
          and nth_x_column = 'IIT_X'
          and nth_y_column = 'IIT_Y'
          and nth_theme_id = pi_theme_id
          );

      retval := TRUE;

    EXCEPTION
      when no_data_found then
        retval := FALSE;
      when others then
        retval := FALSE;
    END;
    
    return retval;
    
  END;              
----------------------------------------------------------
--
BEGIN
-- 
  nm_debug.debug_on;
  nm_debug.debug('in mcpint');
  OPEN  cs_rowid (pi_nlb_batch_no);
  FETCH cs_rowid
  BULK COLLECT
  INTO l_tab_rowid
      ,l_tab_nlbs_rowid;
--
  BEGIN
    nm_debug.debug('Batch NO = '||pi_nlb_batch_no);
    l_rec_nth := get_theme_from_batch_no ( pi_nlb_batch_no );
    get_inv_type_from_batch(pi_nlb_batch_no, l_inv_type, l_use_primary_key );
    l_theme_srid := get_theme_srid (l_inv_type);
    set_survey_attributes(l_inv_type);
  EXCEPTION
    WHEN TOO_MANY_ROWS
    THEN
      RAISE ex_too_many_themes;
    WHEN NO_DATA_FOUND
    THEN
      nm_debug.debug('No themes found for '||pi_nlb_batch_no);
      RAISE ex_no_themes;
    WHEN OTHERS THEN
      RAISE ex_generic_theme;
  END;
--

--nm_debug.debug_on;
  nm_debug.debug('Test for XY inventory');

  l_xy_inventory := is_XY_asset(l_rec_nth.nth_theme_id );
  
  if l_xy_inventory then
    nm_debug.debug('Using XY');
  else
    nm_debug.debug('Not using XY');
  end if;
    
  nm_debug.debug('In NM3MCP_INT process_from_holding');
--
  FOR i IN 1..l_tab_rowid.COUNT
  LOOP
  --
    nm_debug.debug('In the main loop');
    FOR j_rec IN cs_load(l_tab_rowid(i)) LOOP
    --
      g_rec := j_rec;
      
      BEGIN
      --
        SAVEPOINT top_of_loop;
      --
        nm_debug.debug('In NM3MCP_INT process_from_holding - 1');
        IF g_rec.nmlt_editmode NOT IN ('I','N','D','M','C')
        THEN
          IF g_rec.nlm_error_status is NULL
          THEN
            RAISE ex_invalid_editmode;
          ELSE 
            l_errm := g_rec.nmlt_editmode; 
            RAISE ex_trigger_fail;
          END IF;
        END IF;
      --
        --
        -- Edit mode set to Insert or New, but the inv id isn't -1
        --
        /*IF (g_rec.nmlt_editmode IN ( 'I', 'N' )
            AND ( g_rec.iit_ne_id != -1
             OR ( l_use_primary_key = 'Y' AND
                  ( g_rec.iit_primary_key = '-1' or g_rec.iit_primary_key is null )
                ) 
             OR ( l_use_primary_key = 'N' AND
                  ( g_rec.iit_primary_key != '-1' and g_rec.iit_primary_key is not null )             
                ) 
           )     
        -- Edit mode set to Delete, Mod or Correct and iit_ne_id is -1
        --
        OR (g_rec.nmlt_editmode IN ( 'D', 'M', 'C' )
            AND g_rec.iit_ne_id = -1))
        THEN
          RAISE ex_invalid_insert_mode;
        END IF;*/
      --
        ----------------------
        -- Validation
        ----------------------
        nm_debug.debug('In NM3MCP_INT process_from_holding - 2');
        IF NOT is_user_allowed_to_load_record (pi_username  => user
                                              ,pi_inspector => g_rec.nmlt_owner)
        THEN
          RAISE ex_not_allowed_to_load;
        END IF;
     --
        IF g_rec.iit_inv_type IS NULL
        THEN
          RAISE ex_no_asset_type;
        END IF;

        -- No null geometries
        IF g_rec.nmlt_geometry IS NULL
        THEN
          RAISE ex_no_shape;
        END IF;

        -- Make sure SRID is supplied
        IF g_rec.nmlt_geometry.sdo_srid IS NULL
        THEN
          RAISE ex_geom_has_no_srid;
        END IF;

        -- Makes sure SRID matches the layer
        IF g_rec.nmlt_geometry.sdo_srid != l_theme_srid --get_theme_srid (g_rec.iit_inv_type)
        THEN
          RAISE ex_geom_has_wrong_srid;
        END IF;

        -- Make sure the Gtype is valid for the layer
        -- Gets all gtypes in the layer
--        l_theme_gtypes := get_theme_gtypes ( l_rec.iit_inv_type );
--        nm_debug.debug('In NM3MCP_INT process_from_holding - 3');
--        IF l_theme_gtypes.COUNT > 0
--        THEN
--          b_gtype_match_found := FALSE;
--          FOR i IN l_theme_gtypes.FIRST .. l_theme_gtypes.LAST
--          LOOP
--            IF l_theme_gtypes(i) = l_rec.nmlt_geometry.sdo_gtype
--            THEN
--              b_gtype_match_found := TRUE;
--            END IF;
--          END LOOP;
--          IF NOT b_gtype_match_found
--          THEN
--            RAISE ex_invalid_gtype_for_layer;
--          END IF;
--        END IF;
        nm_debug.debug('In NM3MCP_INT process_from_holding - 4');
        --
        -- Ensure specific survey date/time fields are pop'd on shapefile
        --
        IF g_rec.nmlt_survey_date IS NULL
        THEN
          RAISE ex_no_survey_date;
        END IF;
        --
        IF g_rec.nmlt_survey_time IS NULL
        THEN
          RAISE ex_no_survey_time;
        END IF;
      --

--        get_survey_date_and_time( pi_iit_ne_id    => g_rec.iit_ne_id,
--                                  pi_iit_inv_type => g_rec.iit_inv_type,
--                                  po_date_attrib  => l_rec_date_attrib, 
--                                  po_time_attrib  => l_rec_time_attrib, 
--                                  po_survey_date  => l_rec_survey_date, 
--                                  po_survey_time  => l_rec_survey_time );
--                                  
--        nm_debug.debug('Survey-date and time '||l_rec_survey_date||','||l_rec_survey_time );                             
             
        -- Validate record - make sure we haven't loaded it before, or its
        -- and older version - only applies to Mods/Corrections
        IF g_rec.iit_ne_id != -1
        THEN
        --
          nm_debug.debug('In NM3MCP_INT process_from_holding - 5');
        --
          DECLARE
          --
            old_iit nm_inv_items_all%ROWTYPE := nm3get.get_iit_all(pi_iit_ne_id=>g_rec.iit_ne_id);
            TYPE tab_iit IS TABLE OF nm_inv_items_all%ROWTYPE INDEX BY BINARY_INTEGER;
            l_pk_iit_tab tab_iit;
          --
            l_count        NUMBER ;
            l_date_attrib  NM_INV_TYPE_ATTRIBS.ITA_ATTRIB_NAME%TYPE;
            l_time_attrib  NM_INV_TYPE_ATTRIBS.ITA_ATTRIB_NAME%TYPE;
            l_survey_date  DATE;
            l_survey_time  VARCHAR2(8);
          --
          BEGIN
            nm_debug.debug('In NM3MCP_INT process_from_holding - 5a');
             -- Log MCI Issue 3
             SELECT * BULK COLLECT INTO l_pk_iit_tab FROM nm_inv_items_all
              WHERE iit_primary_key = g_rec.iit_primary_key
                AND iit_inv_type    = g_rec.iit_inv_type
                AND iit_start_date >= g_rec.nmlt_survey_date
--              CANNOT CONSIDER START DATE DUE TO A BUG IN nm3inv_val package!!!
                AND iit_end_date    IS NULL
                AND iit_ne_id      != g_rec.iit_ne_id;
            nm_debug.debug('In NM3MCP_INT process_from_holding - 5b');
             IF l_pk_iit_tab.COUNT > 0
             THEN
               nm_debug.debug('In NM3MCP_INT process_from_holding - already loaded');
               RAISE ex_already_loaded;
             END IF;
             nm_debug.debug('issue 3 check done');
             
             get_survey_date_and_time( pi_iit_ne_id    => old_iit.iit_ne_id,
--                                       pi_iit_inv_type => old_iit.iit_inv_type,
--                                       po_date_attrib  => l_date_attrib,
--                                       po_time_attrib  => l_time_attrib, 
                                       po_survey_date  => l_survey_date, 
                                       po_survey_time  => l_survey_time );

nm_debug.debug( 'survey_date&time - old '||l_survey_date||','||l_survey_time );
nm_debug.debug( 'survey_date&time - new '||g_rec.nmlt_survey_date||','||g_rec.nmlt_survey_time );

             IF l_survey_date IS NOT NULL
             THEN

               -- IF old record has later survey date

               IF l_survey_date > g_rec.nmlt_survey_date
               THEN

                 nm_debug.debug('raise based on date');
                 RAISE ex_old_rec_newer_than_file;

               -- If old record has same survey date, then check the time
               ELSIF l_survey_date = g_rec.nmlt_survey_date
               THEN

                 IF  TO_CHAR(TO_DATE(l_survey_time,'HH24:MI:SS'),'HH24:MI:SS') 
                    >= TO_CHAR(TO_DATE(g_rec.nmlt_survey_time,'HH24:MI:SS'),'HH24:MI:SS') 
                 THEN
                   nm_debug.debug('raise based on time');
                   RAISE ex_old_rec_newer_than_file;
                 END IF;

               END IF;

             END IF;

          END;

          nm_debug.debug('In NM3MCP_INT process_from_holding - 6');
        --

        END IF;

      --
        IF g_rec.iit_inv_type = g_enq_asset_type
        THEN
      -- Create / update PEMs
          --insert_update_pem( l_rec, l_error, l_error_text, l_out_iit_ne_id );
          NULL;

        --
      --
        ELSE
      --`
        -- Asset insert / update
          g_rec.iit_start_date := g_rec.nmlt_survey_date;

          IF g_rec.iit_end_date IS NOT NULL
          THEN
            g_rec.iit_end_date := g_rec.nmlt_survey_date;
          END IF;

          nm_debug.debug_on;
          nm_debug.debug('set the survey date columns ' );
          
          nm_debug.debug( 'date_col = '||g_survey_date_col||', type = '||g_survey_data_type||', mask = '||g_survey_date_mask||', time = '||g_survey_time_col);

          if g_survey_data_type = 'DATE' then

            execute immediate 'BEGIN  '||g_package_name||'.g_rec.'||g_survey_date_col||' := '||g_package_name||'.g_rec.nmlt_survey_date; end; ';

          elsif g_survey_data_type = 'VARCHAR2' and g_survey_date_mask is not null then
          
            execute immediate 'BEGIN  '||g_package_name||'.g_rec.'||g_survey_date_col||' := to_char('||g_package_name||'.g_rec.nmlt_survey_date,'||''''||g_survey_date_mask||''''||'); end; ';
          
          else

            raise_application_error( -20110, 'Mismatching attribute map for survery date and time' );

          end if;          
          
          execute immediate 'BEGIN  '||g_package_name||'.g_rec.'||g_survey_time_col||' := '||g_package_name||'.g_rec.nmlt_survey_time; end; ';
         
--        g_rec.iit_date_attrib95 := g_rec.nmlt_survey_date;
--        g_rec.iit_chr_attrib75  := g_rec.nmlt_survey_time;
          
		  IF l_rec_nth.nth_dependency = 'I' AND l_xy_inventory
          THEN
		     -- ignore the geometry on the file, just set the XY columns as long as the theme is configured correctly.
            BEGIN
               if g_rec.nmlt_geometry.sdo_gtype in (2001, 3001) then
    		     BEGIN
            	   select t.x, t.y
                   into g_rec.iit_x, g_rec.iit_y
	     	       from table( sdo_util.getvertices(g_rec.nmlt_geometry)) t;
                 EXCEPTION
                   when others
                  THEN
                   RAISE ex_no_xy_from_shape;
                 END;
               else
                   RAISE ex_no_xy_from_shape;
               end if;              
		    END;

		  END IF;

          nm_debug.debug('Ins_inv call');
          begin
             nm3mcp_ins_inv.ins_inv(p_inv_rec    => g_rec
                                   ,po_iit_ne_id => l_out_iit_ne_id);
          exception
            when others then
              l_errm := sqlerrm;
              raise ex_insert_API_failure;
          end;

          nm_debug.debug('Ins_inv call done');
        --
        END IF;
      --
        ------------------------------------------
        -- Migrate old docasscs to new iit_ne_id
        ------------------------------------------
      --
        IF g_rec.iit_ne_id != l_out_iit_ne_id
        THEN
          BEGIN
            migrate_doc_assocs ( pi_old_iit_ne_id => g_rec.iit_ne_id
                               , pi_new_iit_ne_id => l_out_iit_ne_id);
          END;
        END IF;
      --
        ----------------------------------------------
        -- Migrate defects to new iit_ne_id
        ----------------------------------------------
      --
        IF g_rec.iit_ne_id != l_out_iit_ne_id
        THEN
          migrate_defects_to_new_asset (pi_old_iit_ne_id => g_rec.iit_ne_id
                                       ,pi_new_iit_ne_id => l_out_iit_ne_id
                                       ,pi_asset_type    => g_rec.iit_inv_type);
        END IF;

      ----------------------------------------------
      -- Create assocaited Photo das record
      ----------------------------------------------
        IF g_rec.nmlt_photo IS NOT NULL
        THEN
          mcp_doc_upload ( pi_batch_no  => pi_nlb_batch_no
                         , pi_iit_ne_id => l_out_iit_ne_id
                         , pi_record_no => g_rec.record_no);
        END IF;


      ------------------------------------------------------------------------
      -- AE  -  Process shape
      --
      --   If asset type is Dynsegged then we can rely on the members
      --   spatial trigger processing the new shape from the members,
      --   regardless of the shape supplied on the row.
      --
      --   If asset type is UseXY=Y  then we rely on the new XY values from
      --   Mapcapture to ammend the geometry
      --
      --   Only if the layer is network independant, and doesn't use XY
      --   we call the nm3sdo_edit API
      --
      -- MCP statuses
      --
      --    M   = modify with history
      --    C   = correction without history
      --    I   = insert new record
      --
      ------------------------------------------------------------------------
--        nm_debug.debug('Dependency = '||l_rec_nth.nth_dependency);
--        nm_debug.debug('Use XY = '||nm3get.get_nit (l_rec.iit_inv_type).nit_use_xy);

        BEGIN

          -- Only process if Independant Theme and not using XY
          IF l_rec_nth.nth_dependency = 'I'
          AND nm3get.get_nit (g_rec.iit_inv_type).nit_use_xy = 'N'
          THEN
          --
            --
            --  CORRECTION mode
            --

            IF g_rec.nmlt_editmode = 'C'
            AND g_rec.iit_ne_id != -1
            THEN
--              nm_debug.debug('C correction - reshape');
              IF g_rec.iit_end_date IS NOT NULL
              THEN
                -- end date the geometry
 --                nm_Debug.debug('End dating - '||l_rec.iit_ne_id);
                 nm3sdo_edit.end_date_shape( pi_nth_id => l_rec_nth.nth_theme_id
                                           , pi_pk     => g_rec.iit_ne_id
                                           , pi_date   => g_rec.nmlt_survey_date);
              ELSE
                -- reshape just updates geom without history
                nm3sdo_edit.reshape
                   ( pi_nth_id => l_rec_nth.nth_theme_id
                   , pi_pk     => g_rec.iit_ne_id
                   , pi_shape  => g_rec.nmlt_geometry);
              END IF;

            --
            --  MODIFICATION mode
            --

            ELSIF g_rec.nmlt_editmode = 'M'
            AND g_rec.iit_ne_id != -1
            THEN

--              nm_debug.debug('M modification - move reshape');
              -- move reshape uses history

              IF g_rec.iit_end_date IS NOT NULL
              THEN
  --                 nm_Debug.debug('End dating - '||l_rec.iit_ne_id);
                 nm3sdo_edit.end_date_shape( pi_nth_id => l_rec_nth.nth_theme_id
                                           , pi_pk     => g_rec.iit_ne_id
                                           , pi_date   => g_rec.nmlt_survey_date);
              ELSE

                -- If the asset hasn't changed, then update the shape using standard method
                IF g_rec.iit_ne_id = l_out_iit_ne_id
                THEN
--                   nm_debug.debug('No change to asset record');
                  nm3sdo_edit.move_reshape
                  ( pi_nth_id => l_rec_nth.nth_theme_id
                  , pi_pk     => g_rec.iit_ne_id
                  , pi_shape  => g_rec.nmlt_geometry
                  , pi_date   => g_rec.nmlt_survey_date);

                ELSIF g_rec.iit_ne_id != l_out_iit_ne_id
                THEN
--                   nm_Debug.debug('Asset changed - End date old and insert new shape for new iit - '||l_rec.iit_ne_id);
                  nm3sdo_edit.end_date_shape( pi_nth_id => l_rec_nth.nth_theme_id
                                            , pi_pk     => g_rec.iit_ne_id
                                            , pi_date   => g_rec.nmlt_survey_date);
--
--                   nm_Debug.debug('Creating shape - '||l_out_iit_ne_id);
                  nm3sdo_edit.add_shape( pi_nth_id   => l_rec_nth.nth_theme_id
                                       , pi_pk       => l_out_iit_ne_id
                                       , pi_fk       => NULL
                                       , pi_shape    => g_rec.nmlt_geometry
                                       , pi_start_dt => g_rec.nmlt_survey_date);
                END IF;

              END IF;

            --
            --  INSERT mode
            --

            ELSIF g_rec.nmlt_editmode IN ('I','N')
            AND g_rec.iit_ne_id = -1
            THEN


--              nm_debug.debug('I - new record');
              -- Insert new record
              nm3sdo_edit.add_shape( pi_nth_id   => l_rec_nth.nth_theme_id
                                   , pi_pk       => l_out_iit_ne_id
                                   , pi_fk       => NULL
                                   , pi_shape    => g_rec.nmlt_geometry
                                   , pi_start_dt => g_rec.nmlt_survey_date);

            END IF;
          --
          END IF;  --prevent operation on dynamic segmentation
		  
--        EXCEPTION
          -- error in shape edit
--          WHEN OTHERS THEN nm_debug.debug(SQLERRM);
        END;
      --
        IF MOD (i,c_commit_threshold) = 0 THEN
          COMMIT;
          SAVEPOINT top_of_loop;
        END IF;
      --
        update_status(pi_rowid  => l_tab_nlbs_rowid(i)
                     ,pi_status => 'I'
                     ,pi_text   => Null);
      --
      EXCEPTION
      --
        WHEN ex_no_shape THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20010 - No geometry supplied in shapefile');

        WHEN ex_no_survey_date THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20011 - No Survey Date specified');

        WHEN ex_no_survey_time THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20012 - No Survey Time specified');

        WHEN ex_old_rec_newer_than_file THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20013 - Asset '||g_rec.iit_ne_id||' has'||
                                      ' the same or later Survey Date/Time than supplied on shapefile'||
                                      ' - '||g_rec.nmlt_survey_date||' '
                                           ||g_rec.nmlt_survey_time);
        WHEN ex_geom_has_no_srid THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20014 - No SRID supplied on the geometry');

        WHEN ex_no_asset_type THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20015 - No asset type specified');

        WHEN ex_no_xy_from_shape THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20016 - No point X an Y derived for Asset columns ');

--        WHEN ex_invalid_gtype_for_layer THEN
--          ROLLBACK TO top_of_loop;
--          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
--                       ,pi_status  => 'E'
--                       ,pi_text    => 'ORA-20016 - Geometry type is invalid for layer - '||
--                                      l_rec.nmlt_geometry.sdo_gtype);

        WHEN ex_geom_has_wrong_srid THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20017 - SRID '||g_rec.nmlt_geometry.sdo_srid||
                                       ' does match layer SRID '||get_theme_srid (g_rec.iit_inv_type));

        WHEN ex_migrating_das THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20018 - Error migrating old doc_assocs to new asset - '||sqlerrm);

        WHEN ex_too_many_themes THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20019 - Cannot derive base table theme for '||g_rec.iit_inv_type);

        WHEN ex_not_allowed_to_load THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20020 - You are not authorised to load this record - '||g_rec.nmlt_owner||' is not in the same Admin Area as loading user');

        WHEN ex_invalid_editmode THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20021 - Invalid Editmode - '||g_rec.nmlt_editmode);

        WHEN ex_already_loaded THEN
          ROLLBACK TO top_of_loop;
          nm_debug.debug('Raise ex_already_loaded');
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20022 - Asset has already been loaded with a later start date than on this file '); 
                                     --||l_rec.iit_primary_key||' - '||l_rec.iit_start_date);
        WHEN ex_invalid_insert_mode THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    => 'ORA-20023 - Edit Mode ['||g_rec.nmlt_editmode||'] is invalid for Asset ID ' 
                                       ||g_rec.iit_ne_id||' - '||g_rec.iit_primary_key);
        WHEN ex_insert_API_failure  THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    =>  l_errm);                       
--RC - strip extraneous data to give a better parsed error					   
--                     ,pi_text    =>  'ORA-20024 - Error executing the insert API on '||g_rec.iit_primary_key||' - '||l_errm);                       
        WHEN ex_trigger_fail THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid   => l_tab_nlbs_rowid(i)
                       ,pi_status  => 'E'
                       ,pi_text    =>  l_errm);
        WHEN OTHERS THEN
          ROLLBACK TO top_of_loop;
          update_status(pi_rowid  => l_tab_nlbs_rowid(i)
                       ,pi_status => 'E'
                       ,pi_text   => sqlerrm);
      END;
    --
    END LOOP; -- l_rec IN cs_load(l_tab_rowid(i))
  --
  END LOOP; -- i IN 1..l_tab_rowid.COUNT
--
  nm_debug.debug('In NM3MCP_INT process_from_holding - commited');
  COMMIT;
--
EXCEPTION
  WHEN ex_too_many_themes
  THEN
    nm_debug.debug('ex_too_many_themes');
  --  nm3web.FAILURE('ORA-20099 - Too many base themes');
    RAISE_APPLICATION_ERROR(-20099,'Too Many Base Themes');
  WHEN ex_no_themes
  THEN
    nm_debug.debug('ex_no_themes');
    --nm3web.FAILURE('ORA-20097 - No Theme Found');
    RAISE_APPLICATION_ERROR(-20097,'No Theme Found');
  WHEN ex_generic_theme
  THEN
   -- nm3web.FAILURE('ORA-20098 - Theme error: '||SQLERRM);
   RAISE;
END process_holding_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_from_holding(pi_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE) 
IS
BEGIN
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_from_holding');

  IF lock_the_batch_for_loading(pi_nlb_batch_no) 
  THEN
  --
    nm_debug.debug('lfh1');
  --
    set_batch_active(pi_nlb_batch_no);
  --
    nm_debug.debug('lfh2');
  --
--
--
-- GJ do not call the routine in NM3LOAD that processes the holding table in a generic way
-- but instead call our own local routine that does it non-generically i.e. simpler
--
    --nm3load.validate_and_load(p_batch_no      => pi_nlb_batch_no
    --                         ,p_validate_only => FALSE);

    process_holding_table(pi_nlb_batch_no => pi_nlb_batch_no);

    nm_debug.debug('lfh3');

--    nm3load.produce_log_email(p_nlb_batch_no   => pi_nlb_batch_no
--                             ,p_produce_as_htp => FALSE
--                             ,p_send_to        => get_mapcap_email_recipients);

    clear_lock(pi_batch => pi_nlb_batch_no);

    nm_debug.debug('lfh4');
    nm_debug.debug('Second stage Complete');

  ELSE

    nm_debug.debug('lfhxx');
    nm_debug.debug('Cannot obtain batch lock for'||pi_nlb_batch_no);
  END IF;
--
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_from_holding');
--
END load_from_holding;
--
-----------------------------------------------------------------------------
--
FUNCTION load_shapefile_into_temp_table(pi_asset_type  IN  VARCHAR2
                                      , pi_shapefile   IN  VARCHAR2
                                      , pi_batchfile   IN  VARCHAR2 DEFAULT NULL
                                      , pi_progress_id IN  nm_progress.prg_progress_id%TYPE DEFAULT NULL
                                      , pi_stage       IN  nm_progress.prg_current_stage%TYPE DEFAULT NULL
                                      , pi_username    IN  VARCHAR2   DEFAULT NULL
                                      , pi_password    IN  VARCHAR2   DEFAULT NULL
) RETURN nm_load_batches_mcp.nlb_batch_no%TYPE IS
--
  l_retval nm_load_batches_mcp.nlb_batch_no%TYPE := NULL;
--
  PROCEDURE pop_load_tables 
  IS
  BEGIN
  --
  --   move data from nm_load_batches_mcp into nm_load_batches and populate nm_load_batch_status
  --
    INSERT INTO nm_load_batches(nlb_batch_no
                             ,nlb_nlf_id
                             ,nlb_filename
                             ,nlb_record_count)
     SELECT  nlb_batch_no
            ,nlb_nlf_id
            ,nlb_filename
            ,nlb_record_count
       FROM nm_load_batches_mcp
      WHERE nlb_batch_no = l_retval;
  --
     COMMIT;
  --
  -- Create load batch status record
  --
    INSERT INTO nm_load_batch_status
      (nlbs_nlb_batch_no
      ,nlbs_record_no
      ,nlbs_status
      ,nlbs_text
      ,nlbs_input_line)
    SELECT batch_no
         , record_no
         , 'H'
         , NULL
         , NULL
      FROM nm_mcp_load_temp
     WHERE batch_no = l_retval;
  --
    COMMIT;
  --
  END pop_load_tables;
--
BEGIN
--
-- populates
--   nm_mcp_load_temp    -- temp loading table
--   nm_load_batches_mcp
--
  IF pi_progress_id IS NOT NULL
  AND pi_stage IS NOT NULL
  THEN
    nm3progress.record_progress
      ( pi_progress_id      => pi_progress_id
       ,pi_force            => TRUE
       ,pi_current_stage    => pi_stage
       ,pi_operation        => 'Uploading Asset : ['||pi_shapefile||'] - '
                                               ||'['||pi_asset_type||'] - '
                               ||nm3get.get_nit(pi_asset_type).nit_descr
                               ||' - Running SHP2SDE'
       ,pi_total_count      => nm3mcp0200.get_total_ops
       ,pi_current_position => 1);
  END IF;
--
  nm_Debug.debug('Do shapefile load');
--
  nm3mcp_sde.do_shp2sde(pi_asset_type  => pi_asset_type
                       ,pi_shapefile   => pi_shapefile
                       ,pi_batchfile   => pi_batchfile
                       ,pi_username    => pi_username
                       ,pi_password    => pi_password
                       ,po_batch_no    => l_retval);
--
  nm_Debug.debug('Do shapefile load - done');
--

  COMMIT;

--
  IF pi_progress_id IS NOT NULL
  AND pi_stage IS NOT NULL
  THEN
    nm3progress.record_progress
      ( pi_progress_id      => pi_progress_id
       ,pi_force            => TRUE
       ,pi_current_stage    => pi_stage
       ,pi_operation        => 'Uploading Asset : ['||pi_shapefile||'] - '
                                               ||'['||pi_asset_type||'] - '
                               ||nm3get.get_nit(pi_asset_type).nit_descr
                               ||' - Populating Asset Loader holding tables'
       ,pi_total_count      => nm3mcp0200.get_total_ops
       ,pi_current_position => 2);
  END IF;
--
  nm_Debug.debug('done 1');
--
  pop_load_tables;
--
  nm_Debug.debug('done 2');
--
  RETURN (l_retval);
--
EXCEPTION
--
  WHEN ex_sde_service_down
    THEN
      catch_error(p_appl   => nm3type.c_hig
                 ,p_error  => 207
                 ,p_supp   => sqlerrm
                 ,p_batch  => Null
                 ,p_in_prc => 'load_shapefile_into_temp_table');
      nm3progress.end_progress (pi_progress_id        => pi_progress_id
                              , pi_completion_message => 'Error Encountered'
                              , pi_error_message      => 'Esri SDE Service is down - please contact your database administrator');
                              --, pi_error_message      => nm3flx.parse_error_message(sqlerrm));
    --
      hig_process_api.log_it  ( pi_message_type  => 'E'
                              , pi_message       => 'Error Encountered: Esri SDE Service is down - please contact your database administrator');
    --
      hig_process_api.process_execution_end
                              ( pi_success_flag  => 'N');
  WHEN ex_external_job_down
  THEN
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => Null
               ,p_in_prc => 'load_shapefile_into_temp_table');
 --
    --
      hig_process_api.log_it  ( pi_message_type  => 'E'
                              , pi_message       => 'Error Encountered: Oracle External Job Scheduler is down - please contact your database administrator');
    --
      hig_process_api.process_execution_end
                              ( pi_success_flag  => 'N');
    --
      nm3progress.end_progress(pi_progress_id         => pi_progress_id
                              ,pi_completion_message  => 'Error occurred - shapefile could not be loaded'
                              ,pi_error_message       => 'Oracle External Job Scheduler is down - please contact your database administrator');
      RAISE;
    --
  WHEN OTHERS 
  THEN
 -- RAISE;
    catch_error(p_appl   => nm3type.c_hig
               ,p_error  => 207
               ,p_supp   => sqlerrm
               ,p_batch  => Null
               ,p_in_prc => 'load_shapefile_into_temp_table');
 --
    hig_process_api.log_it( pi_message      => 'Error occurred : Loading shapefile - '||nm3flx.parse_error_message(sqlerrm)
                          , pi_message_type => 'E');
    RETURN l_retval;
--
END load_shapefile_into_temp_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise IS

 BEGIN

  IF Sys_Context('NM3CORE','APPLICATION_OWNER') IS NULL
  THEN
    nm3context.initialise_context;
  END IF;

  clear_errors;
  -- who triggers cannot exist on the holding table cos we want to preserve
  -- the date modified provided by MapCapture
  clear_who_trigger;
--
--  nm_debug.delete_debug(TRUE);
--  nm_debug.debug_on;
--  nm_debug.set_level(p_level => 4);

END initialise;
--
-----------------------------------------------------------------------------
--
FUNCTION  batch_loader (pi_asset_type  IN  VARCHAR2
                      , pi_shapefile   IN  VARCHAR2
                      , pi_batchfile   IN  VARCHAR2                           DEFAULT NULL
                      , pi_progress_id IN  nm_progress.prg_progress_id%TYPE   DEFAULT NULL
                      , pi_stage       IN  nm_progress.prg_current_stage%TYPE DEFAULT NULL
                      , pi_username    IN  VARCHAR2                           DEFAULT NULL
                      , pi_password    IN  VARCHAR2                           DEFAULT NULL) 

  RETURN nm_load_batches.nlb_batch_no%TYPE IS

  l_nlb_batch_no  nm_load_batches_mcp.nlb_batch_no%TYPE;

BEGIN
--nm_debug.debug_on;
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'batch_loader');
--
  nm_debug.debug('initialise');
--
  initialise;
--
  nm_debug.debug('load into temp table');
--
  l_nlb_batch_no := load_shapefile_into_temp_table(pi_asset_type  => pi_asset_type
                                                 , pi_shapefile   => pi_shapefile
                                                 , pi_batchfile   => pi_batchfile
                                                 , pi_progress_id => pi_progress_id
                                                 , pi_stage       => pi_stage
                                                 , pi_username    => pi_username
                                                 , pi_password    => pi_password);
--

-- Archive the shapefiles
--
  IF l_nlb_batch_no IS NOT NULL
  THEN
  --
    COMMIT;
  --
    nm_debug.debug('load from holding table');
  --
    IF pi_progress_id IS NOT NULL
    AND pi_stage IS NOT NULL
    THEN
      nm3progress.record_progress
        ( pi_progress_id      => pi_progress_id
         ,pi_force            => TRUE
         ,pi_current_stage    => pi_stage
         ,pi_operation        => 'Uploading Asset : ['||pi_shapefile||'] - '
                                                 ||'['||pi_asset_type||'] - '
                                 ||nm3get.get_nit(pi_asset_type).nit_descr
                                 ||' - Running Asset Loader'
         ,pi_total_count      => nm3mcp0200.get_total_ops
         ,pi_current_position => 3);
    END IF;
  --
    nm_debug.debug('progress done');
  --
    IF l_nlb_batch_no IS NOT NULL
    THEN
      nm_debug.debug('Loading '||l_nlb_batch_no);
      load_from_holding(pi_nlb_batch_no => l_nlb_batch_no);
    END IF;
  --
    nm_debug.debug('done');
--

--
    IF pi_progress_id IS NOT NULL
      AND pi_stage IS NOT NULL
      THEN
        nm3progress.record_progress
          ( pi_progress_id      => pi_progress_id
           ,pi_force            => TRUE
           ,pi_current_stage    => pi_stage
           ,pi_operation        => 'Uploading Asset : ['||pi_shapefile||'] - '
                                                   ||'['||pi_asset_type||'] - '
                                   ||nm3get.get_nit(pi_asset_type).nit_descr
                                   ||' - Archiving Shapefile'
           ,pi_total_count      => nm3mcp0200.get_total_ops
           ,pi_current_position => 4);
    END IF;

    IF hig.get_user_or_sys_opt('DOMCPFTP') ='Y'
    THEN
      nm3mcp_ftp.archive_in_shapefiles (pi_shapefile => pi_shapefile);
  END IF;
--
  nm_debug.debug('FTP Done');
--
  ELSE
    -- No batch ID returned - fail!
    --
     --
     --
      hig_process_api.log_it  ( pi_message_type  => 'E'
                              , pi_message       => 'Error Encountered: File could not be loaded');
    --
      hig_process_api.process_execution_end
                              ( pi_success_flag  => 'N');
    --
  --
  END IF;
  RETURN(l_nlb_batch_no);
--
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'batch_loader');
--
END batch_loader;
--
-----------------------------------------------------------------------------
--
PROCEDURE batch_loader (pi_asset_type  IN  VARCHAR2
                      , pi_shapefile   IN  VARCHAR2
                      , pi_batchfile   IN  VARCHAR2   DEFAULT NULL
                      , pi_progress_id IN  NUMBER     DEFAULT NULL
                      , pi_stage       IN  NUMBER     DEFAULT NULL
                      , pi_username    IN  VARCHAR2   DEFAULT NULL
                      , pi_password    IN  VARCHAR2   DEFAULT NULL) IS

 l_nlb_batch_no  nm_load_batches_mcp.nlb_batch_no%TYPE;

BEGIN
 l_nlb_batch_no := batch_loader (pi_asset_type  => pi_asset_type
                               , pi_shapefile   => pi_shapefile
                               , pi_batchfile   => pi_batchfile
                               , pi_progress_id => pi_progress_id
                               , pi_stage       => pi_stage
                               , pi_username    => pi_username
                               , pi_password    => pi_password);

END batch_loader;
--
-----------------------------------------------------------------------------
--
PROCEDURE resubmit_batch(pi_nlb_batch_no IN nm_load_batches.nlb_batch_no%TYPE) IS

 PROCEDURE reset_batch_status_etc IS

 BEGIN

  UPDATE nm_load_batch_status
  SET    nlbs_Status = 'H'
        ,nlbs_text   = Null
  WHERE  nlbs_nlb_batch_no = pi_nlb_batch_no
    AND  nlbs_status != 'I';

  COMMIT;

 END reset_batch_status_etc;

BEGIN

  initialise;

  reset_batch_status_etc;

  load_from_holding(pi_nlb_batch_no => pi_nlb_batch_no);

END resubmit_batch;
--
-----------------------------------------------------------------------------
--
END nm3mcp_int;
/
