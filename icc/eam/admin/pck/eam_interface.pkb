create or replace package body eam_interface as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/admin/pck/eam_interface.pkb-arc   1.0   Nov 28 2008 11:01:18   mhuitson  $
--       Module Name      : $Workfile:   eam_interface.pkb  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:01:18  $
--       Date fetched Out : $Modtime:   Nov 28 2008 10:37:38  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   eam_interface body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
-- Private package variables
  g_body_sccsid       constant varchar2(2000) := '"%W% %G%"';
  g_package_name      constant varchar2(30)   := 'eam_interface';
  --
  g_eamuser         hig_option_values.hov_value%TYPE := hig.get_sysopt('EAMUSER');
  g_eamorgcode      hig_option_values.hov_value%TYPE := hig.get_sysopt('EAMORGCODE');
  g_eamidattr       hig_option_values.hov_value%TYPE := hig.get_sysopt('EAMIDATTR');
  g_organization_id number;
  --
  g_api_version        CONSTANT NUMBER         := 1.0;
  g_init_msg_list      VARCHAR2 (50)           := fnd_api_exor.get_g_true;
  g_commit             VARCHAR2 (50)           := fnd_api_exor.get_g_true;
  g_validation_level   NUMBER                  := fnd_api_exor.get_g_valid_level_full;
  g_success            VARCHAR2(1)             := fnd_api_exor.get_g_ret_sts_success;
/*
|| Application Errors Raised In This Package.
*/
-- 20001 'EAM Organization Not Found'
-- 20002 'EAM Department Not Found'
-- 20003 'EAM Asset Group Not Found'
-- 20004 < Error Msg Returned From eam_linear_locations_pub.create_asset >
-- 20005 < Exceptions Raised By create_asset >
-- 20006 'Defect Not Found'
-- 20007 'Repair Not Found For Defect'
-- 20008 'Cannot Create A Work Request For A Defect With No Associated Asset'
-- 20009 < Error Msg Returned From eam_linear_locations_pub.create_work_request >
-- 20010 < Exceptions Raised By create_work_request >
--
-----------------------------------------------------------------------------
--
function get_version return varchar2 is
begin
  return g_sccsid;
end get_version;
--
-----------------------------------------------------------------------------
--
function get_body_version return varchar2 is
begin
  return g_body_sccsid;
end get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_service_request_no(pi_service_request_no IN     VARCHAR2
                                     ,po_description        IN OUT VARCHAR2
                                     ,po_target_date        IN OUT VARCHAR2) IS
  --
BEGIN
  /*
  || Get The Description And Target Date
  || From The Work Request.
  */
  SELECT substr(tl.summary,1,240)
        ,to_char(b.expected_resolution_date,'DD-MON-YYYY HH24:MI:SS')
    INTO po_description
        ,po_target_date
    FROM cs_incidents_all_b b
        ,cs_incidents_all_tl tl
   WHERE tl.incident_id = b.incident_id
     AND b.incident_number = pi_service_request_no
       ;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20072,'Invalid Service Request No.');
  WHEN others
   THEN
      RAISE;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_group_id(p_org_id   NUMBER
                           ,p_inv_type VARCHAR2) RETURN NUMBER IS
  --
  l_retval NUMBER;
  --
BEGIN
  /*
  || Get The EAM Asset Group Id
  */
  SELECT msikfv.inventory_item_id
    INTO l_retval
    FROM mtl_system_items_b_kfv msikfv
   WHERE organization_id = p_org_id
     AND concatenated_segments = p_inv_type
       ;
  --
  RETURN l_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      hig.raise_ner(pi_appl               => 'EAM'
                   ,pi_id                 => 3
                   ,pi_supplementary_info => ' ['||p_inv_type||']');
  WHEN others
   THEN
      RAISE;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_organization_id(p_org_code VARCHAR2) RETURN NUMBER IS
  --
  l_retval               number;
  l_organizations_table  eam_linear_locations_pub.org_access_table;
  --
BEGIN
  /*
  || Get the list of organizations for the current user.
  */
  eam_linear_locations_pub.return_organizations(p_user_name           => NVL(g_eamuser,USER)
                                               ,x_organizations_table => l_organizations_table);
  /*
  || Get the id of the relevant organization
  || (there does not appear to be an API to get this id directly, without using a table)
  */
  FOR i IN 1..l_organizations_table.count LOOP
    IF l_organizations_table(i).organization_code = p_org_code
     THEN
        l_retval := l_organizations_table(i).organization_id;
        exit;
    END IF;
  END LOOP;
  --
  IF l_retval IS NULL
   THEN
      raise_application_error(-20001,'EAM Organization Not Found ['||p_org_code||']');
  END IF;
  --
  RETURN l_retval;
  --
END get_organization_id;
--
-----------------------------------------------------------------------------
--
-- This function returns the EAM department id for a given EAM department code.
--
FUNCTION get_department_id(p_org_id    NUMBER
                          ,p_dept_code VARCHAR2) RETURN NUMBER IS
  --
  l_retval number;
  --
BEGIN
  /*
  || Get The EAM Department Id.
  */
  l_retval := eam_common_utilities_pvt.get_dept_id(p_org_code  => null
                                                  ,p_org_id    => p_org_id
                                                  ,p_dept_code => p_dept_code
                                                  ,p_dept_id   => null);
  --
  IF l_retval IS NULL
   THEN
      raise_application_error(-20002,'EAM Department Not Found ['||p_dept_code||']');
  END IF;
  --
  RETURN l_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20002,'EAM Department Not Found ['||p_dept_code||']');
  WHEN others
   THEN
      RAISE;
END get_department_id;
--
-----------------------------------------------------------------------------
--
FUNCTION create_work_request(p_defect_id          IN defects.def_defect_id%TYPE
                            ,p_service_request_no IN VARCHAR2) RETURN NUMBER IS
  --
  l_def_row           defects%rowtype;
  l_rep_row           repairs%rowtype;
  l_nit_row           nm_inv_types_all%ROWTYPE;
  l_work_request_rec  wip_eam_work_requests%rowtype;
  l_description       wip_eam_work_requests.description%TYPE;
  --
  l_organization_id  NUMBER;
  l_department_id    NUMBER;
  l_asset_group_id   NUMBER;
  l_asset_number     VARCHAR2(30);
  l_user_id number;
  --
  l_work_request_id  NUMBER;
  l_return_status    VARCHAR2(255);
  l_msg_count        NUMBER;
  l_msg_data         VARCHAR2(255);
  --
  lr_edo  eam_defect_objects%ROWTYPE;
  --
  l_step  VARCHAR2(50);
  --
  l_refcur  nm3type.ref_cursor;
  l_sql     nm3type.max_varchar2;
  --
  PROCEDURE get_defect IS
  BEGIN
    --
    SELECT *
      INTO l_def_row
      FROM defects
     WHERE def_defect_id = p_defect_id
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20006,'Defect Not Found ['||p_defect_id||']');
    WHEN others
     THEN
        RAISE;
  END get_defect;
  --
  PROCEDURE get_repair IS
  BEGIN
    --
    SELECT *
      INTO l_rep_row
      FROM repairs
     WHERE rep_def_defect_id = p_defect_id
       AND rep_action_cat    = 'P'
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20007,'Repair Not Found For Defect ['||p_defect_id||']');
    WHEN others
     THEN
        RAISE;
  END get_repair;
  --
BEGIN
  /*
  || Get The EAM User ID
  */
  l_step := 'Fetching EAM User Id';
  l_user_id := eam_interface.return_eam_user_id(NVL(g_eamuser,USER));
  /*
  || Get Details Of The Exor Defect.
  */
  l_step := 'Fetching Defect';
  get_defect;
  /*
  || Get Details Of The Exor Repair.
  */
  l_step := 'Fetching Repair';
  get_repair;
  /*
  || Get Details Of The Exor Asset.
  */
  l_step := 'Fetching Asset';
  IF l_def_row.def_iit_item_id IS NOT NULL
   THEN
      /*
      || Get The Asset Details From The FT View.
      */
      l_nit_row := nm3get.get_nit(mai.translate_mai_inv_type(l_def_row.def_ity_inv_code));
      l_sql := 'SELECT ft.asset_group_id'
             ||' ,ft.asset_number'
             ||' ,ft.asset_org_id'
             ||' ,ft.asset_dept_id'
             ||' FROM '||l_nit_row.nit_table_name||' ft'
             ||' WHERE ft.gen_object_id = '||to_char(l_def_row.def_iit_item_id);
      --
      OPEN  l_refcur FOR l_sql;
      FETCH l_refcur
       INTO l_asset_group_id
           ,l_asset_number
           ,l_organization_id
           ,l_department_id;
      CLOSE l_refcur;
      --  
  ELSE
      raise_application_error(-20008,'Cannot Create A Work Request For A Defect With No Associated Asset');
  END IF;
  /*
  || Populate The Work Request Record.
  */
  l_step := 'Building Work Request Record';
  l_work_request_rec.organization_id          := l_organization_id;
  l_work_request_rec.asset_group              := l_asset_group_id;
  l_work_request_rec.work_request_id          := null;
  l_work_request_rec.asset_number             := l_asset_number;
  l_work_request_rec.work_request_priority_id := l_def_row.def_priority;
  l_work_request_rec.expected_resolution_date := l_rep_row.rep_date_due;
  l_work_request_rec.work_request_owning_dept := l_department_id;
  l_work_request_rec.work_request_type_id     := null;
  l_work_request_rec.attribute1               := p_service_request_no;
  l_work_request_rec.attribute2               := p_defect_id;
  --
  l_description := substr(l_def_row.def_defect_descr,1,240);
  /*
  || Create A New Work Request In EAM.
  */
  l_step := 'Creating EAM Work Request';
  fnd_api_exor.work_request_import
    (p_api_version      => g_api_version
    ,p_mode             => 'CREATE'
    ,p_work_request_rec => l_work_request_rec
    ,p_request_log      => l_description
    ,p_user_id          => l_user_id
    ,x_work_request_id  => l_work_request_id
    ,x_return_status    => l_return_status
    ,x_msg_count        => l_msg_count
    ,x_msg_data         => l_msg_data
    );
  /*
  || Check The Return Status.
  */
  IF l_return_status != g_success
   THEN
      /*
      || Populate The Exor Log Table.
      */
      lr_edo.edo_def_defect_id      := p_defect_id;
      lr_edo.edo_error              := l_msg_data;
      lr_edo.edo_service_request_no := p_service_request_no;
      ins_edo(p_edo_rec => lr_edo);
      /*
      || Raise The Error.
      */
      raise_application_error(-20009,l_msg_data);
      --
  END IF;
  /*
  || Populate The Exor Log Table.
  */
  l_step := 'Populating Exor Log Table';
  lr_edo.edo_def_defect_id      := p_defect_id;
  lr_edo.edo_work_request_id    := l_work_request_id;
  lr_edo.edo_service_request_no := p_service_request_no;
  ins_edo(p_edo_rec => lr_edo);
  --
  RETURN l_work_request_id;
  --
EXCEPTION
  WHEN others
   THEN
      raise_application_error(-20010,'An Error Occured In create_work_request While '
                                     ||l_step||chr(10)||SQLERRM);
END create_work_request;
--
-----------------------------------------------------------------------------
--
FUNCTION return_eam_user_id(p_user_name in VARCHAR2) RETURN NUMBER IS
  --
  l_user_id number;
  --
BEGIN
  /*
  || Get The EAM User Id.
  */
  SELECT user_id
    INTO l_user_id
    FROM fnd_user
   WHERE user_name = p_user_name;
  --
  RETURN l_user_id;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      hig.raise_ner(pi_appl               => 'EAM'
                   ,pi_id                 => 4
                   ,pi_supplementary_info => 'Cannot Find EAM USER ID');
  WHEN others
   THEN
      RAISE;   
END return_eam_user_id;
--
-----------------------------------------------------------------------------
--
FUNCTION create_work_order(p_defect_id          IN defects.def_defect_id%TYPE
                          ,p_service_request_no IN VARCHAR2) RETURN VARCHAR2 IS
  --
  l_def_row  defects%rowtype;
  l_rep_row  repairs%rowtype;
  l_rep_date_due DATE;
  l_nit_row  nm_inv_types_all%ROWTYPE;
  --
  --
  l_organization_id  NUMBER;
  l_department_id    NUMBER;
  l_asset_group_id   NUMBER;
  l_asset_number     VARCHAR2(30);
  l_user_id number;
  --
  lr_edo  eam_defect_objects%ROWTYPE;
  --
  l_step  VARCHAR2(50);
  --
  l_refcur  nm3type.ref_cursor;
  l_sql     nm3type.max_varchar2;
  --
  l_retval           VARCHAR2(240);
  l_wip_entity_id    NUMBER;
  l_return_status    VARCHAR2(255);
  l_msg_count        NUMBER;
  l_msg_data         VARCHAR2(255);
  --
  PROCEDURE get_defect IS
  BEGIN
    --
    SELECT *
      INTO l_def_row
      FROM defects
     WHERE def_defect_id = p_defect_id
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20006,'Defect Not Found ['||p_defect_id||']');
    WHEN others
     THEN
        RAISE;
  END get_defect;
  --
  PROCEDURE get_repair IS
  BEGIN
    --
    SELECT to_date(to_char(rep_date_due,'DD-MON-YYYY HH24:MI:SS')
                                       ,'DD-MON-YYYY HH24:MI:SS')
      INTO l_rep_date_due
      FROM repairs
     WHERE rep_def_defect_id = p_defect_id
       AND rep_action_cat    = 'P'
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20007,'Repair Not Found For Defect ['||p_defect_id||']');
    WHEN others
     THEN
        RAISE;
  END get_repair;
  --
BEGIN
  /*
  || Get The EAM User ID
  */
  l_step := 'Fetching EAM User Id';
  l_user_id := eam_interface.return_eam_user_id(NVL(g_eamuser,USER));
  /*
  || Get Details Of The Exor Defect.
  */
  l_step := 'Fetching Defect';
  get_defect;
  /*
  || Get Details Of The Exor Repair.
  */
  l_step := 'Fetching Repair';
  get_repair;
  /*
  || Get Details Of The Exor Asset.
  */
  l_step := 'Fetching Asset';
  IF l_def_row.def_iit_item_id IS NOT NULL
   THEN
      /*
      || Get The Asset Details From The FT View.
      */
      l_nit_row := nm3get.get_nit(mai.translate_mai_inv_type(l_def_row.def_ity_inv_code));
      l_sql := 'SELECT ft.asset_group_id'
             ||' ,ft.asset_number'
             ||' ,ft.asset_org_id'
             ||' ,ft.asset_dept_id'
             ||' FROM '||l_nit_row.nit_table_name||' ft'
             ||' WHERE ft.gen_object_id = '||to_char(l_def_row.def_iit_item_id);
      --
      OPEN  l_refcur FOR l_sql;
      FETCH l_refcur
       INTO l_asset_group_id
           ,l_asset_number
           ,l_organization_id
           ,l_department_id;
      CLOSE l_refcur;
      --  
  ELSE
      raise_application_error(-20008,'Cannot Create A Work Order For A Defect With No Associated Asset');
  END IF;
  /*
  || Call Procedure To Create The Work Order.
  */
  l_step := 'Creating EAM Work Order';
  --
  fnd_api_exor.process_wo(p_api_version        => g_api_version
                         ,p_gen_object_id      => l_def_row.def_iit_item_id
                         ,p_asset_group_id     => l_asset_group_id
                         ,p_asset_number       => l_asset_number
                         ,p_org_id             => l_organization_id
                         ,p_dept_id            => l_department_id
                         ,p_defect_id          => l_def_row.def_defect_id
                         ,p_descr              => l_def_row.def_defect_descr
                         ,p_priority           => l_def_row.def_priority
                         ,p_target_date        => to_date(to_char(l_rep_date_due,'DD-MON-YYYY HH24:MI:SS')
                                                                                ,'DD-MON-YYYY HH24:MI:SS')
                         ,p_service_request_no => p_service_request_no
                         ,p_user_id            => l_user_id
                         ,x_wip_entity_name    => l_retval
                         ,x_wip_entity_id      => l_wip_entity_id
                         ,x_return_status      => l_return_status
                         ,x_msg_count          => l_msg_count
                         ,x_msg_data           => l_msg_data
                         );
  --
  IF l_return_status != g_success
   THEN
      /*
      || Populate The Exor Log Table.
      */
      lr_edo.edo_def_defect_id      := p_defect_id;
      lr_edo.edo_error              := l_msg_data;
      lr_edo.edo_service_request_no := p_service_request_no;
      ins_edo(p_edo_rec => lr_edo);
      /*
      || Raise The Error.
      */
      raise_application_error(-20009,l_msg_data);
      --
  END IF;
  --
  COMMIT;
  /*
  || Populate The Exor Log Table.
  */
  l_step := 'Populating Exor Log Table';
  lr_edo.edo_def_defect_id      := p_defect_id;
  lr_edo.edo_wip_entity_id      := l_wip_entity_id;
  lr_edo.edo_wip_entity_name    := l_retval;
  lr_edo.edo_service_request_no := p_service_request_no;
  ins_edo(p_edo_rec => lr_edo);
  --
  RETURN l_retval;
  --
EXCEPTION
  WHEN others
   THEN
      raise_application_error(-20010,'An Error Occured In create_work_order While '
                                     ||l_step||chr(10)||SQLERRM);
END create_work_order;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_id(p_seq_name IN VARCHAR2) RETURN NUMBER IS
  --
  l_query_string varchar2(1000) := 'select '||p_seq_name||'.nextval from dual';
  l_seq_no number;
  --
BEGIN
  /*
  || Get The Next Value For The Specified Sequence.
  */
  EXECUTE IMMEDIATE l_query_string INTO l_seq_no;
  RETURN l_seq_no;
  --
END get_next_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_edo(p_edo_rec IN eam_defect_objects%ROWTYPE) IS
  PRAGMA autonomous_transaction;
  --
  l_edo_rec eam_defect_objects%ROWTYPE;
  --
BEGIN
  /*
  || Populate The Record To Be Inserted.
  */
  l_edo_rec := p_edo_rec;
  IF l_edo_rec.edo_id IS NULL
   THEN
      l_edo_rec.edo_id := get_next_id('EDO_ID_SEQ');
  END IF;
  /*
  || Insert The Record.
  */
  INSERT
    INTO eam_defect_objects
  VALUES l_edo_rec;
  --
  COMMIT;
  --
END ins_edo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_eam_status(p_defect_id IN defects.def_defect_id%TYPE) RETURN VARCHAR2 IS
  --
  lv_retval VARCHAR2(240) := NULL;
  l_edo_rec eam_defect_objects%ROWTYPE;
  --
BEGIN
  /*
  || Get The Details From The Exor Log Table.
  */
  SELECT *
    INTO l_edo_rec
    FROM eam_defect_objects
   WHERE edo_def_defect_id = p_defect_id
       ;
  /*
  || Get The Work Request / Work Order Status.
  */
  IF l_edo_rec.edo_work_request_id IS NOT NULL
   THEN
      --
      lv_retval := fnd_api_exor.get_work_request_status(l_edo_rec.edo_work_request_id);
      --
  ELSIF l_edo_rec.edo_wip_entity_id IS NOT NULL
   THEN
      --
      lv_retval := fnd_api_exor.get_work_order_status(l_edo_rec.edo_wip_entity_id);
      --
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN NULL;
  WHEN others
   THEN
      RAISE;
END get_eam_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_order_no(p_defect_id IN defects.def_defect_id%TYPE) RETURN VARCHAR2 IS
  --
  lv_retval VARCHAR2(240) := NULL;
  l_edo_rec eam_defect_objects%ROWTYPE;
  --
BEGIN
  /*
  || Get The Details From The Exor Log Table.
  */
  SELECT *
    INTO l_edo_rec
    FROM eam_defect_objects
   WHERE edo_def_defect_id = p_defect_id
       ;
  /*
  || Get The Work Request / Work Order Status.
  */
  IF l_edo_rec.edo_wip_entity_name IS NOT NULL
   THEN
      --
      lv_retval := l_edo_rec.edo_wip_entity_name;
      --
  ELSIF l_edo_rec.edo_work_request_id IS NOT NULL
   THEN 
      --
      lv_retval := fnd_api_exor.get_work_request_wo_name(l_edo_rec.edo_work_request_id);
      --
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN NULL;
  WHEN others
   THEN
      RAISE;
END get_work_order_no;
--
-----------------------------------------------------------------------------
--
END eam_interface;
/
