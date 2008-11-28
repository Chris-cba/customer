create or replace package body fnd_api_exor as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/admin/pck/fnd_api_exor.pkb-arc   1.0   Nov 28 2008 11:01:20   mhuitson  $
--       Module Name      : $Workfile:   fnd_api_exor.pkb  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:01:20  $
--       Date fetched Out : $Modtime:   Nov 28 2008 10:37:02  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   fnd_api_exor body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
-- Private package variables
  g_body_sccsid       constant varchar2(2000) := '"%W% %G%"';
  g_package_name      constant varchar2(30)   := 'fnd_api_exor';
  --
  g_api_version        CONSTANT NUMBER         := 1.0;
  g_init_msg_list      VARCHAR2 (50)           := fnd_api.g_true;
  g_commit             VARCHAR2 (50)           := fnd_api.g_true;
  g_validation_level   NUMBER                  := fnd_api.g_valid_level_full;
  g_success            VARCHAR2(1)             := fnd_api.g_ret_sts_success;
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
FUNCTION get_g_true RETURN VARCHAR2 IS
BEGIN
  RETURN fnd_api.g_true;
END get_g_true;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_false RETURN VARCHAR2 IS
BEGIN
  RETURN fnd_api.g_false;
END get_g_false;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_valid_level_full RETURN NUMBER IS
BEGIN
  RETURN fnd_api.g_valid_level_full;
END get_g_valid_level_full;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_ret_sts_success RETURN VARCHAR2 IS
BEGIN
  RETURN fnd_api.g_ret_sts_success;
END get_g_ret_sts_success;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_opr_create RETURN NUMBER IS
BEGIN
  RETURN eam_process_wo_pvt.g_opr_create;
END get_g_opr_create;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wip_constants_unreleased RETURN NUMBER IS
BEGIN
  RETURN wip_constants.unreleased;
END get_wip_constants_unreleased;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wip_constants_draft RETURN NUMBER IS
BEGIN
  RETURN wip_constants.draft;
END get_wip_constants_draft;
--
-----------------------------------------------------------------------------
--
FUNCTION get_asset_group (p_org_id   NUMBER
                         ,p_inv_type VARCHAR2) RETURN NUMBER IS
  --
  l_retval         NUMBER;
  l_return_status  VARCHAR2(1000);
  l_msg_count      NUMBER;
  l_msg_data       VARCHAR2(1000);
  l_false          VARCHAR2(1000);
  --
BEGIN
  --
  l_false := fnd_api_exor.get_g_false;
  --
  eam_common_utilities_pvt.get_item_id
    (p_api_version           => g_api_version
    ,p_organization_id       => p_org_id
    ,p_concatenated_segments => p_inv_type
    ,x_inventory_item_id     => l_retval
    ,x_return_status         => l_return_status
    ,x_msg_count             => l_msg_count
    ,x_msg_data              => l_msg_data);
  --
  IF l_return_status != g_success
   OR l_retval IS NULL
   THEN
      raise_application_error(-20003,'EAM Asset Group Not Found ['||p_inv_type||']');
  END IF;
  --
  RETURN l_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20003,'EAM Asset Group Not Found ['||p_inv_type||']');
  WHEN others
   THEN
      RAISE;
END get_asset_group;
--
-----------------------------------------------------------------------------
--
PROCEDURE work_request_import(p_api_version      IN  NUMBER := 1.0
                             ,p_mode             IN  VARCHAR2
                             ,p_work_request_rec IN  WIP_EAM_WORK_REQUESTS%ROWTYPE
                             ,p_request_log      IN  VARCHAR2
                             ,p_user_id          IN  NUMBER
                             ,x_work_request_id  OUT NUMBER
                             ,x_return_status    OUT VARCHAR2
                             ,x_msg_count        OUT NUMBER
                             ,x_msg_data         OUT VARCHAR2) IS
  PRAGMA autonomous_transaction;
  --
	l_user_id number;
	l_resp_id number := 111;
	l_resp_appl_id number := 426;
  --
BEGIN
  /*
  || validate and set the user context
  */
  l_user_id := p_user_id;
  --
  if(l_user_id <> -1)
   then
      fnd_global.apps_initialize(user_id      => l_user_id
                                ,resp_id      => l_resp_id
                                ,resp_appl_id => l_resp_appl_id);
  else
      raise_application_error(-20000,'Error Occured Validating User');
  end if;
  /*
  || Create The Work Request.
  */
  wip_eam_workrequest_pub.work_request_import
    (p_api_version      => g_api_version
    ,p_mode             => p_mode
    ,p_work_request_rec => p_work_request_rec
    ,p_request_log      => p_request_log
    ,p_user_id          => p_user_id
    ,x_work_request_id  => x_work_request_id
    ,x_return_status    => x_return_status
    ,x_msg_count        => x_msg_count
    ,x_msg_data         => x_msg_data
    );
  --
  COMMIT;
  --
END work_request_import;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_wo(p_api_version        IN  NUMBER := 1.0
                    ,p_gen_object_id      IN  NUMBER
                    ,p_asset_group_id     IN  NUMBER
                    ,p_asset_number       IN  VARCHAR2
                    ,p_org_id             IN  NUMBER
                    ,p_dept_id            IN  NUMBER
                    ,p_defect_id          IN  NUMBER
                    ,p_descr              IN  VARCHAR2
                    ,p_priority           IN  VARCHAR2
                    ,p_target_date        IN  DATE
                    ,p_service_request_no IN VARCHAR2
                    ,p_user_id            IN  NUMBER
                    ,x_wip_entity_name    OUT VARCHAR2
                    ,x_wip_entity_id      OUT NUMBER
                    ,x_return_status      OUT VARCHAR2
                    ,x_msg_count          OUT NUMBER
                    ,x_msg_data           OUT VARCHAR2) IS
  PRAGMA autonomous_transaction;
  --
  l_bo_identifier           VARCHAR2(50) := 'EAM';
  l_api_version             NUMBER       := 1.0;
  l_commit                  VARCHAR2(50) := fnd_api_exor.get_g_true;
  l_x_wip_entity_id         NUMBER;
  l_x_msg_data              VARCHAR2(32000);
  l_eam_wo_rec              eam_process_wo_pub.eam_wo_rec_type;
  l_eam_op_tbl              eam_process_wo_pub.eam_op_tbl_type;
  l_eam_op_network_tbl      eam_process_wo_pub.eam_op_network_tbl_type;
  l_eam_res_tbl             eam_process_wo_pub.eam_res_tbl_type;
  l_eam_res_inst_tbl        eam_process_wo_pub.eam_res_inst_tbl_type;
  l_eam_sub_res_tbl         eam_process_wo_pub.eam_sub_res_tbl_type;
  l_eam_res_usage_tbl       eam_process_wo_pub.eam_res_usage_tbl_type;
  l_eam_mat_req_tbl         eam_process_wo_pub.eam_mat_req_tbl_type;
  l_eam_direct_items_tbl    eam_process_wo_pub.eam_direct_items_tbl_type;
  l_x_eam_wo_rec            eam_process_wo_pub.eam_wo_rec_type;
  l_x_eam_op_tbl            eam_process_wo_pub.eam_op_tbl_type;
  l_x_eam_op_network_tbl    eam_process_wo_pub.eam_op_network_tbl_type;
  l_x_eam_res_tbl           eam_process_wo_pub.eam_res_tbl_type;
  l_x_eam_res_inst_tbl      eam_process_wo_pub.eam_res_inst_tbl_type;
  l_x_eam_sub_res_tbl       eam_process_wo_pub.eam_sub_res_tbl_type;
  l_x_eam_res_usage_tbl     eam_process_wo_pub.eam_res_usage_tbl_type;
  l_x_eam_mat_req_tbl       eam_process_wo_pub.eam_mat_req_tbl_type;
  l_x_eam_direct_items_tbl  eam_process_wo_pub.eam_direct_items_tbl_type;
  l_x_return_status         VARCHAR2(255);
  l_x_msg_count             NUMBER;
  l_debug                   VARCHAR2(50) := fnd_api_exor.get_g_false;
  l_output_dir              VARCHAR2(50) := NULL;
  l_debug_filename          VARCHAR2(50) := 'EAM_WO_DEBUG.log';
  l_debug_file_mode         VARCHAR2(50) := 'w';
  --
  l_user_id      NUMBER;
  l_resp_id      NUMBER := 111;
  l_resp_appl_id NUMBER := 426;
  --
  l_wo_resp_id   NUMBER;
  --
  PROCEDURE get_resp_id IS
  BEGIN
    --
    SELECT responsibility_id
      INTO l_wo_resp_id
      FROM fnd_responsibility
     WHERE application_id = l_resp_appl_id
       AND responsibility_key = 'EAM_ASSET_MANAGEMENT'
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot Find Resposibility Id For Responsibility Key EAM_ASSET_MANAGEMENT');
    WHEN others
     THEN
        RAISE;
  END get_resp_id;
  --
BEGIN
  /*
  || Get The Responsibility Id.
  */
  get_resp_id;
  /*
  || validate and set the user context
  */
  l_user_id := p_user_id;
  --
  if(l_user_id <> -1)
   then
      fnd_global.apps_initialize(user_id      => l_user_id
                                ,resp_id      => l_resp_id
                                ,resp_appl_id => l_resp_appl_id);
  else
      raise_application_error(-20000,'Error Occured Validating User');
  end if;
  /*
  || Initialise The WO Record.
  */
  l_eam_wo_rec:= null;
  /*
  || Populate The WO Record.
  */
  l_eam_wo_rec.transaction_type          := fnd_api_exor.get_g_opr_create;
  l_eam_wo_rec.organization_id           := p_org_id;
  l_eam_wo_rec.asset_group_id            := p_asset_group_id;
  l_eam_wo_rec.asset_number              := p_asset_number;
  l_eam_wo_rec.owning_department         := p_dept_id;
  l_eam_wo_rec.description               := p_descr;
  l_eam_wo_rec.priority                  := p_priority;
  l_eam_wo_rec.class_code                := 'MAINT';
  l_eam_wo_rec.status_type               := fnd_api_exor.get_wip_constants_draft;
  l_eam_wo_rec.firm_planned_flag         := 2;
  l_eam_wo_rec.scheduled_completion_date := p_target_date;
  --
  l_eam_wo_rec.maintenance_object_source := 1;
  l_eam_wo_rec.maintenance_object_type   := 1;
  l_eam_wo_rec.maintenance_object_id     := p_gen_object_id;
  l_eam_wo_rec.attribute14               := p_service_request_no;
  l_eam_wo_rec.attribute15               := to_char(p_defect_id);
  l_eam_wo_rec.requested_start_date      := p_target_date;
  l_eam_wo_rec.scheduled_start_date      := p_target_date;
  l_eam_wo_rec.user_id                   := p_user_id;
  l_eam_wo_rec.responsibility_id         := l_wo_resp_id;
  --
  --l_eam_wo_rec.date_released             := sysdate;
  --l_eam_wo_rec.material_issue_by_mo      := 'N';
  --l_eam_wo_rec.issue_zero_cost_flag      := 'Y';
  --l_eam_wo_rec.po_creation_time          := 1;
  --l_eam_wo_rec.job_quantity              := 1;
  --l_eam_wo_rec.notification_required     := 'N';
  --
  eam_process_wo_pub.process_wo(p_bo_identifier        =>  l_bo_identifier
                               ,p_api_version_number   =>  l_api_version
                               ,p_commit               =>  l_commit
                               ,p_eam_wo_rec           =>  l_eam_wo_rec
                               ,p_eam_op_tbl           =>  l_eam_op_tbl
                               ,p_eam_op_network_tbl   =>  l_eam_op_network_tbl
                               ,p_eam_res_tbl          =>  l_eam_res_tbl
                               ,p_eam_res_inst_tbl     =>  l_eam_res_inst_tbl
                               ,p_eam_sub_res_tbl      =>  l_eam_sub_res_tbl
                               ,p_eam_res_usage_tbl    =>  l_eam_res_usage_tbl
                               ,p_eam_mat_req_tbl      =>  l_eam_mat_req_tbl
                               ,p_eam_direct_items_tbl =>  l_eam_direct_items_tbl
                               ,x_eam_wo_rec           =>  l_x_eam_wo_rec
                               ,x_eam_op_tbl           =>  l_x_eam_op_tbl
                               ,x_eam_op_network_tbl   =>  l_x_eam_op_network_tbl
                               ,x_eam_res_tbl          =>  l_x_eam_res_tbl
                               ,x_eam_res_inst_tbl     =>  l_x_eam_res_inst_tbl
                               ,x_eam_sub_res_tbl      =>  l_x_eam_sub_res_tbl
                               ,x_eam_res_usage_tbl    =>  l_x_eam_res_usage_tbl
                               ,x_eam_mat_req_tbl      =>  l_x_eam_mat_req_tbl
                               ,x_eam_direct_items_tbl =>  l_x_eam_direct_items_tbl
                               ,x_return_status        =>  l_x_return_status
                               ,x_msg_count            =>  l_x_msg_count
                               ,p_debug                =>  l_debug
                               ,p_output_dir           =>  l_output_dir
                               ,p_debug_filename       =>  l_debug_filename
                               ,p_debug_file_mode      =>  l_debug_file_mode
                               );
  --
  IF l_x_return_status <> 'S'
   AND l_x_msg_count > 0
   THEN
      fnd_msg_pub.get(p_msg_index     => FND_MSG_PUB.G_NEXT
                     ,p_encoded       => 'F'
                     ,p_data          => l_x_msg_data
                     ,p_msg_index_out => l_x_msg_count);
  END IF;
  --
  x_wip_entity_name := l_x_eam_wo_rec.wip_entity_name;
  x_wip_entity_id   := l_x_eam_wo_rec.wip_entity_id;
  x_return_status   := l_x_return_status;
  x_msg_count       := l_x_msg_count;
  x_msg_data        := l_x_msg_data;
  --
  COMMIT;
  --
END process_wo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_request_status(p_work_request_id IN NUMBER) RETURN VARCHAR2 IS
  --
  lv_retval               mfg_lookups.meaning%TYPE;
  lv_work_request_status  mfg_lookups.meaning%TYPE;
  lv_wip_entity_id        wip_eam_work_requests.wip_entity_id%TYPE;
  --
BEGIN
  --
  SELECT ml.meaning work_request_status
        ,wr.wip_entity_id
    INTO lv_work_request_status
        ,lv_wip_entity_id
    FROM mfg_lookups ml
        ,wip_eam_work_requests wr
   WHERE wr.work_request_id = p_work_request_id
     AND wr.work_request_status_id = ml.lookup_code(+)
     AND ml.lookup_type(+) = 'WIP_EAM_WORK_REQ_STATUS'
       ;
  --
  IF lv_wip_entity_id IS NULL
   THEN
      lv_retval := lv_work_request_status;
  ELSE
      lv_retval := get_work_order_status(lv_wip_entity_id);
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
END get_work_request_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_request_wo_name(p_work_request_id IN NUMBER) RETURN VARCHAR2 IS
  --
  lv_retval wip_entities.wip_entity_name%TYPE;
  --
BEGIN
  --
  SELECT we.wip_entity_name
    INTO lv_retval
    FROM wip_entities we
        ,wip_eam_work_requests wr
   WHERE wr.work_request_id = p_work_request_id
     AND wr.wip_entity_id = we.wip_entity_id
       ;
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
END get_work_request_wo_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_order_status(p_wip_entity_id IN NUMBER) RETURN VARCHAR2 IS
  --
  lv_retval mfg_lookups.meaning%TYPE;
  --
BEGIN
  --
  SELECT ml.meaning work_order_status
    INTO lv_retval
    FROM mfg_lookups ml
        ,wip_discrete_jobs wo
   WHERE wo.wip_entity_id = p_wip_entity_id
     AND wo.status_type = ml.lookup_code(+)
     AND ml.lookup_type(+) = 'WIP_JOB_STATUS'
       ;
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
END get_work_order_status;
--
-----------------------------------------------------------------------------
--
END fnd_api_exor;
/
