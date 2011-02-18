create or replace
package body intren_ws as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/pck/intren_ws.pkb-arc   3.1   Feb 18 2011 13:22:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_ws.pkb  $
--       Date into PVCS   : $Date:   Feb 18 2011 13:22:26  $
--       Date fetched Out : $Modtime:   Feb 18 2011 13:22:06  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--
--   Author : ITurnbull
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  G_BODY_SCCSID  CONSTANT varchar2(2000) :='"$Revision:   3.1  $"';

  g_package_name constant varchar2(30) := 'intren_ws';

  type MARKER_ARRAY_TYPE is table of V_NM_INTR%ROWTYPE index by BINARY_INTEGER;
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
function marker_exists(pi_marker_id varchar2)
return nm_inv_items.iit_ne_id%type
is
   rtrn nm_inv_items.iit_ne_id%type;
begin 
   rtrn := null;
   for vrec in ( select iit_ne_id from v_nm_intr where marker_id = upper(pi_marker_id))
     loop
       rtrn := vrec.iit_ne_id;
   end loop;
   return rtrn;
end marker_exists;
--
-----------------------------------------------------------------------------
--
function create_responce_rec( pi_message varchar2 default 'OK'
                        )
return intren_responce_rec
is
  l_rec intren_responce_rec;
begin 
   l_rec := new intren_responce_rec( to_char(sysdate,'DD-MON-YYYY hh24:mi:ss')
                                    ,pi_message
                                    ,get_version ||' ' || get_body_version
                                    , '0');
   return l_rec;                                   
end create_responce_rec;   
--
-----------------------------------------------------------------------------
--
function create_resp_marker_rec( pi_marker intren_marker_rec
                                ,pi_responce intren_responce_rec
                               )
return intren_resp_marker_rec
is
begin 
   return new intren_resp_marker_rec(pi_marker, pi_responce);
end create_resp_marker_rec;
--
-----------------------------------------------------------------------------
--
function create_resp_marker_list( pi_marker_list intren_marker_rec_list
                                 ,pi_responce intren_responce_rec
                               )
return intren_resp_marker_list
is
begin
   return new intren_resp_marker_list( pi_marker_list, pi_responce );
end create_resp_marker_list;
--
-----------------------------------------------------------------------------
--
function create_image_list(pi_marker_id varchar2)
return intren_image_list
is
 l_images intren_image_list;
  l_image intren_image_rec;
  i number;
begin
  l_image := new intren_image_rec(null,null,null);
  l_images := new intren_image_list(l_image);

  i := 1;
  for crec in (select name, blob_content
                from nm_upload_files
                    ,doc_assocs
                    ,docs
                    ,v_nm_intr
                where marker_id=  pi_marker_id
                and iit_ne_id = das_rec_id
                and das_doc_id = doc_id
                and doc_file = name)
  loop
    l_image := new intren_image_rec(crec.name,crec.blob_content,nm3clob.len(nm3clob.blob_to_clob(crec.blob_content)));
    l_images.extend;
    l_images(i) := l_image;
    i:= i + 1;
  end loop;
  
  return l_images;
end create_image_list;
--
-----------------------------------------------------------------------------
--

function create_marker_rec(
                           pi_marker_id varchar
                          ,pi_easting   varchar2
                          ,pi_northing  varchar2
                          ,pi_date_installed varchar2
                          ,pi_date_decomissioned varchar2
                          ,pi_contractor_organisation varchar2
                          ,pi_street_name varchar2
                          ,pi_nature_of_asset varchar2
                          ,pi_material varchar2
                          ,pi_domain_owner varchar2
                          ,pi_job_reference               varchar2
                          ,pi_job_type                    varchar2
                          ,pi_town                        varchar2
                          ,pi_depth                       varchar2
                          ,pi_kerb_offset                 varchar2
                          ,pi_shape_of_asset              varchar2
                          ,pi_dim_of_asset                varchar2
                          ,pi_fitting_type                varchar2
                          ,pi_construction_type           varchar2
                          ,pi_ubo_in_trench               varchar2
                          ,pi_ubo_asset_type              varchar2
                          ,pi_photo_type                  varchar2
                          ,pi_previuos_marker             varchar2
                          ,pi_geographic_location         varchar2
                          ,pi_survey_job_no               varchar2
                          ,pi_survey_method               varchar2
                           )
return intren_marker_rec
is
  l_mr intren_marker_rec;
  l_images intren_image_list;
 begin 
  
  l_images := create_image_list(pi_marker_id => pi_marker_id);
  l_mr := new intren_marker_rec( pi_marker_id 
                                ,pi_easting   
                                ,pi_northing  
                                ,pi_date_installed 
                                ,pi_date_decomissioned 
                                ,pi_contractor_organisation 
                                ,pi_street_name 
                                ,pi_nature_of_asset 
                                ,pi_material 
                                ,pi_domain_owner 
                                ,pi_job_reference 
                                ,pi_job_type      
                                ,pi_town          
                                ,pi_depth         
                                ,pi_kerb_offset   
                                ,pi_shape_of_asset
                                ,pi_dim_of_asset  
                                ,pi_fitting_type  
                                ,pi_construction_type
                                ,pi_ubo_in_trench    
                                ,pi_ubo_asset_type   
                                ,pi_photo_type       
                                ,pi_previuos_marker  
                                ,pi_geographic_location
                                ,pi_survey_job_no      
                                ,pi_survey_method      
                                ,l_images
                               );
                               
  return l_mr;
end create_marker_rec;
--
-----------------------------------------------------------------------------
--
function create_list_of_markers(pi_markers marker_array_type)
return intren_marker_rec_list
is
  l_marker_array marker_array_type;
  l_mr intren_marker_rec;
  l_mrl intren_marker_rec_list := intren_marker_rec_list();
begin 
  l_marker_array := pi_markers;
  for i in 1..l_marker_array.COUNT
    LOOP
    
     l_mr := create_marker_rec( pi_marker_id => l_marker_array(i).marker_id
                               ,pi_easting => l_marker_array(i).x_coord
                               ,pi_northing => l_marker_array(i).y_coord
                               ,pi_date_installed => l_marker_array(i).install_date
                               ,pi_date_decomissioned => l_marker_array(i).decommission_date
                               ,pi_contractor_organisation => l_marker_array(i).contractor_org
                               ,pi_street_name => l_marker_array(i).street_name
                               ,pi_nature_of_asset => l_marker_array(i).nature
                               ,pi_material => l_marker_array(i).material
                               ,pi_domain_owner => l_marker_array(i).domain_owner
                               ,pi_job_reference => l_marker_array(i).job_reference 
                                ,pi_job_type => l_marker_array(i).job_type      
                                ,pi_town => l_marker_array(i).town          
                                ,pi_depth => l_marker_array(i).depth         
                                ,pi_kerb_offset => l_marker_array(i).kerb_offset   
                                ,pi_shape_of_asset => l_marker_array(i).shape_of_asset
                                ,pi_dim_of_asset => l_marker_array(i).dim_of_asset  
                                ,pi_fitting_type => l_marker_array(i).fitting_type  
                                ,pi_construction_type => l_marker_array(i).construction_type
                                ,pi_ubo_in_trench => l_marker_array(i).ubo_in_trench    
                                ,pi_ubo_asset_type => l_marker_array(i).ubo_asset_type   
                                ,pi_photo_type => l_marker_array(i).photo_type       
                                ,pi_previuos_marker => l_marker_array(i).previuos_marker  
                                ,pi_geographic_location => l_marker_array(i).geographic_location
                                ,pi_survey_job_no => l_marker_array(i).survey_job_no      
                                ,pi_survey_method => l_marker_array(i).survey_method
                              );
    L_MRL.extend;
    l_mrl(i) := l_mr;
  end loop;
  return l_mrl;
  exception when others then 
  raise;
  return l_mrl;
  
end create_list_of_markers;
--
-----------------------------------------------------------------------------
--

function get_list_of_markers
return INTREN_resp_MARKER_LIST
is
   l_marker_array marker_array_type;
   l_resp intren_responce_rec;
   l_mrl intren_marker_rec_list;
begin 
   select *
   bulk collect into   l_marker_array        
   from V_NM_INTR ;
  
  l_resp := create_responce_rec(l_marker_array.count || ' markers retreived'); 
  l_mrl := create_list_of_markers(pi_markers => l_marker_array);  
  return create_resp_marker_list(l_mrl, l_resp);
  exception when others 
   then 
     l_resp := create_responce_rec(dbms_utility.format_error_stack);
     return create_resp_marker_list(l_mrl, l_resp);
end get_list_of_markers;
--
-----------------------------------------------------------------------------
--
function delete_marker(pi_marker_id intren_marker_id_type)
return intren_responce_rec
is
  l_resp intren_responce_rec;
  l_iit_ne_id number;
begin 
  l_iit_ne_id := marker_exists(pi_marker_id.marker_id);
  
  if l_iit_ne_id is not null
   then 
    delete nm_inv_items_all
    where iit_ne_id = l_iit_ne_id;
    l_resp := create_responce_rec('Marker deleted :'||pi_marker_id.marker_id);
  else  
    l_resp := create_responce_rec('Marker does not exist :'||pi_marker_id.marker_id);
  end if;

  
  return l_resp;
  exception when others 
   then 
     l_resp := create_responce_rec(dbms_utility.format_error_stack);
  return l_resp;
end delete_marker;
--
-----------------------------------------------------------------------------
--
function get_marker(pi_marker_id intren_marker_id_type)
return INTREN_resp_MARKER_REC
is
   l_marker_array marker_array_type;
   l_mr intren_marker_rec;
   l_resp intren_responce_rec;
begin 
   select *
   bulk collect into   l_marker_array        
   from v_nm_intr 
   where marker_id = pi_marker_id.marker_id;
   
  for i in 1..l_marker_array.COUNT
    LOOP
     l_mr := create_marker_rec( pi_marker_id => l_marker_array(i).marker_id
                               ,pi_easting => l_marker_array(i).x_coord
                               ,pi_northing => l_marker_array(i).y_coord
                               ,pi_date_installed => l_marker_array(i).install_date
                               ,pi_date_decomissioned => l_marker_array(i).decommission_date
                               ,pi_contractor_organisation => l_marker_array(i).contractor_org
                               ,pi_street_name => l_marker_array(i).street_name
                               ,pi_nature_of_asset => l_marker_array(i).nature
                               ,pi_material => l_marker_array(i).material
                               ,pi_domain_owner => l_marker_array(i).domain_owner
                               ,pi_job_reference => l_marker_array(i).job_reference 
                                ,pi_job_type => l_marker_array(i).job_type      
                                ,pi_town => l_marker_array(i).town          
                                ,pi_depth => l_marker_array(i).depth         
                                ,pi_kerb_offset => l_marker_array(i).kerb_offset   
                                ,pi_shape_of_asset => l_marker_array(i).shape_of_asset
                                ,pi_dim_of_asset => l_marker_array(i).dim_of_asset  
                                ,pi_fitting_type => l_marker_array(i).fitting_type  
                                ,pi_construction_type => l_marker_array(i).construction_type
                                ,pi_ubo_in_trench => l_marker_array(i).ubo_in_trench    
                                ,pi_ubo_asset_type => l_marker_array(i).ubo_asset_type   
                                ,pi_photo_type => l_marker_array(i).photo_type       
                                ,pi_previuos_marker => l_marker_array(i).previuos_marker  
                                ,pi_geographic_location => l_marker_array(i).geographic_location
                                ,pi_survey_job_no => l_marker_array(i).survey_job_no      
                                ,pi_survey_method => l_marker_array(i).survey_method
                              );   
  end loop;
  l_resp := create_responce_rec();
  return create_resp_marker_rec(l_mr, l_resp);
  exception when others 
   then 
     l_resp := create_responce_rec(dbms_utility.format_error_stack);
  return create_resp_marker_rec(l_mr, l_resp);
end get_marker;
--
-----------------------------------------------------------------------------
--
function intr_rec_from_marker_rec(pi_marker intren_marker_rec
                                ,pi_iit_ne_id nm_inv_items.iit_ne_id%type default null
                                )
return v_nm_intr%rowtype
is
  l_intr_rec V_NM_INTR%ROWTYPE;
begin 
  l_intr_rec.iit_ne_id := pi_iit_ne_id;
  if pi_iit_ne_id is null
   then 
    l_intr_rec.iit_ne_id := nm3net.get_next_ne_id ; 
  end if;
  l_intr_rec.iit_inv_type := 'INTR' ; 
  l_intr_rec.iit_primary_key := null ; 
  l_intr_rec.iit_start_date := trunc(sysdate); 
  --l_intr_rec.iit_date_created ; 
  --l_intr_rec.iit_date_modified ; 
  --l_intr_rec.iit_created_by ; 
  --l_intr_rec.iit_modified_by ; 
  l_intr_rec.iit_admin_unit := 1; 
  l_intr_rec.iit_descr := upper(pi_marker.marker_id) ; 
  l_intr_rec.iit_note := null; 
  l_intr_rec.iit_peo_invent_by_id := null; 
  l_intr_rec.nau_unit_code := 1 ; 
  l_intr_rec.iit_end_date := null; 

  l_intr_rec.marker_id := upper(pi_marker.marker_id) ;
  l_intr_rec.x_coord := upper(pi_marker.northing) ; 
  l_intr_rec.y_coord := upper(pi_marker.easting) ; 
  l_intr_rec.install_date := upper(pi_marker.date_installed) ; 
  l_intr_rec.decommission_date := upper(pi_marker.date_decomissioned);
  l_intr_rec.contractor_org := upper(pi_marker.contractor_organisation) ; 
  l_intr_rec.street_name := upper(pi_marker.street_name) ; 
  l_intr_rec.nature := upper(pi_marker.nature_of_asset) ; 
  l_intr_rec.material := upper(pi_marker.material) ;
  l_intr_rec.domain_owner := upper(pi_marker.domain_owner) ; 
  
l_intr_rec.job_reference  := upper(pi_marker.job_reference) ; 
l_intr_rec.job_type       := upper(pi_marker.job_type) ; 
l_intr_rec.town           := upper(pi_marker.town) ; 
l_intr_rec.depth          := upper(pi_marker.depth) ; 
l_intr_rec.kerb_offset    := upper(pi_marker.kerb_offset) ; 
l_intr_rec.shape_of_asset := upper(pi_marker.shape_of_asset) ; 
l_intr_rec.dim_of_asset   := upper(pi_marker.dim_of_asset) ; 
l_intr_rec.fitting_type   := upper(pi_marker.fitting_type) ; 
l_intr_rec.construction_type := upper(pi_marker.construction_type) ; 
l_intr_rec.ubo_in_trench     := upper(pi_marker.ubo_in_trench) ; 
l_intr_rec.ubo_asset_type    := upper(pi_marker.ubo_asset_type) ; 
l_intr_rec.photo_type        := upper(pi_marker.photo_type) ; 
l_intr_rec.previuos_marker   := upper(pi_marker.previuos_marker) ; 
l_intr_rec.geographic_location := upper(pi_marker.geographic_location) ; 
l_intr_rec.survey_job_no       := upper(pi_marker.survey_job_no) ; 
l_intr_rec.survey_method := upper(pi_marker.survey_method) ; 

  return l_intr_rec;

end intr_rec_from_marker_rec;
--
-----------------------------------------------------------------------------
--
function decode_base64(pi_source in blob)
return blob 
is
  l_source clob;
  LCLOB CLOB;
  l_offset             pls_integer := 1;
  C_CLOB_LEN           PLS_INTEGER ;
  l_varchar            varchar2(32767);
  L_DECODE             VARCHAR2(32767); 
  C_VC_LENGTH CONSTANT PLS_INTEGER := 100;
  l_row_count          pls_integer := 0;
begin 
   nm3clob.create_clob(l_source);
   NM3CLOB.CREATE_CLOB(LCLOB);
   
   l_source := nm3clob.blob_to_clob(pi_source);
   
   c_clob_len := nm3clob.len(l_source);  
   
   l_offset := 1;    
   
   WHILE l_offset <= c_clob_len
    LOOP
      --
      l_varchar   := nm3clob.lob_substr(l_source, l_offset, c_vc_length);
      --
      l_row_count := l_row_count + 1;
      l_offset    := l_offset    + c_vc_length;
      --
      l_decode := utl_raw.cast_to_varchar2( UTL_ENCODE.BASE64_DECODE(utl_raw.cast_to_raw(l_varchar)));      
      --
      nm3clob.append(p_clob => LCLOB, p_append => l_decode);
   end loop;     
  return nm3clob.clob_to_blob(LCLOB);
end decode_base64;
--
-----------------------------------------------------------------------------
--
function encode_base64(pi_source in blob)
return blob 
is
  l_source clob;
  LCLOB CLOB;
  l_offset             pls_integer := 1;
  C_CLOB_LEN           PLS_INTEGER ;
  l_varchar            varchar2(32767);
  L_enCODE             VARCHAR2(32767); 
  C_VC_LENGTH CONSTANT PLS_INTEGER := 100;
  l_row_count          pls_integer := 0;
begin 
   nm3clob.create_clob(l_source);
   NM3CLOB.CREATE_CLOB(LCLOB);
   
   l_source := nm3clob.blob_to_clob(pi_source);
   
   c_clob_len := nm3clob.len(l_source);  
   
   l_offset := 1;    
   WHILE l_offset <= c_clob_len
    LOOP
      --
      l_varchar   := nm3clob.lob_substr(l_source, l_offset, c_vc_length);
      --
      l_row_count := l_row_count + 1;
      l_offset    := l_offset    + c_vc_length;
      --
      l_encode := utl_raw.cast_to_varchar2( utl_encode.base64_encode(utl_raw.cast_to_raw(l_varchar)));    
      --
      nm3clob.append(p_clob => LCLOB, p_append => l_encode);
   end loop;     
  return nm3clob.clob_to_blob(lclob);
  
end encode_base64;
--
-----------------------------------------------------------------------------
--

function create_new_marker(pi_marker intren_marker_rec)
return intren_responce_rec
is 
  l_intr_rec v_nm_intr%rowtype;
  l_resp intren_responce_rec;
  l_iit_ne_id nm_inv_items.iit_ne_id%type;
  e_marker_exists exception;
  
  
  l_images intren_image_list;
  l_filesize number;
  d number;
  ev number;
  ET VARCHAR2(1000);
begin 
 
  l_resp := create_responce_rec();
  l_intr_rec := intr_rec_from_marker_rec(pi_marker => pi_marker);
  
  nm3api_inv_intr.validate_rowtype ( p_rec_intr => l_intr_rec);
  
  l_iit_ne_id := marker_exists(pi_marker.marker_id);
  
  if l_iit_ne_id is not null
   then
      nm3api_inv_intr.upd_attr (
                                  p_iit_ne_id                    => l_iit_ne_id
                                  --,p_effective_date               => 
                                  ,pf_marker_id                   => l_intr_rec.marker_id
                                  ,pf_x_coord                     => l_intr_rec.x_coord
                                  ,pf_y_coord                     => l_intr_rec.y_coord
                                  ,pf_install_date                => l_intr_rec.install_date
                                  ,pf_decommission_date           => l_intr_rec.decommission_date
                                  ,pf_contractor_org              => trim(l_intr_rec.contractor_org)
                                  ,pf_street_name                 => l_intr_rec.street_name
                                  ,pf_nature                      => l_intr_rec.nature
                                  ,pf_material                    => l_intr_rec.material
                                  ,pf_domain_owner                => trim(l_intr_rec.domain_owner)
                                  ,pf_job_reference => l_intr_rec.job_reference 
                                  ,pf_job_type => l_intr_rec.job_type      
                                  ,pf_town => l_intr_rec.town          
                                  ,pf_depth => l_intr_rec.depth         
                                  ,pf_kerb_offset => l_intr_rec.kerb_offset   
                                  ,pf_shape_of_asset => l_intr_rec.shape_of_asset
                                  ,pf_dim_of_asset => l_intr_rec.dim_of_asset  
                                  ,pf_fitting_type => l_intr_rec.fitting_type  
                                  ,pf_construction_type => l_intr_rec.construction_type
                                  ,pf_ubo_in_trench => l_intr_rec.ubo_in_trench    
                                  ,pf_ubo_asset_type => l_intr_rec.ubo_asset_type   
                                  ,pf_photo_type => l_intr_rec.photo_type       
                                  ,pf_previuos_marker => l_intr_rec.previuos_marker  
                                  ,pf_geographic_location => l_intr_rec.geographic_location
                                  ,pf_survey_job_no => l_intr_rec.survey_job_no      
                                  ,pf_survey_method => l_intr_rec.survey_method);   
  else
    NM3API_INV_INTR.INSERT_ROWTYPE ( P_REC_INTR => L_INTR_REC);
    l_iit_ne_id := L_INTR_REC.iit_ne_id;
  end if;
  
  l_images := new intren_image_list(new intren_image_rec(null,null,null));
  l_images := pi_marker.images;
  for i in 1..l_images.count
   loop
   if l_images(i).filename is not null then 
       
       -- check the supplied image size is the same as the actual file size
       l_filesize := nm3clob.len(nm3clob.blob_to_clob(l_images(i).filecontents));
       if l_images(i).filesize != l_filesize
        then 
          l_resp := create_responce_rec('Image Error Marker: ' ||pi_marker.marker_id || ' : size does not match ('|| l_images(i).filesize ||'!='|| l_filesize||')');
       end if;
       
       delete nm_upload_files
       where name = l_images(i).filename;
       
       insert into nm_upload_files
         (name, mime_type, doc_size, dad_charset, last_updated, content_type, blob_content)
        values
          (l_images(i).filename,'image/pjpeg',l_filesize,'ascii',sysdate, 'BLOB',decode_base64(l_images(i).filecontents));
       -- create doc_assocs
       d := null;
       DOC_API.CREATE_DOCUMENT( CE_REFERENCE_NO => l_images(i).filename --pi_marker.marker_id --l_iit_ne_id
                              , ce_title        => l_images(i).filename
                              , ce_descr        => l_images(i).filename
                              , CE_DLC_ID       => 5
                              , ce_file_name    => l_images(i).filename
                              , ce_doc_type     => 'UKNW'
                              , ce_doc_id       => d
                              , error_value     => ev
                              , error_text      => et
                              ) ;
      -- insert into ian_doc_assoc_err values(sysdate, 'doc',ev, et);                              
       doc_api.create_doc_assoc ( ce_doc_id     => d
                                , ce_table_name => 'NM_INV_ITEMS'
                                , ce_unique_id  => l_iit_ne_id
                                , error_value   => ev
                                , error_text    => et
                               );
      -- insert into ian_doc_assoc_err values(sysdate, 'assoc',ev, et|| ' : ' || l_iit_ne_id);                               
                              
   end if;   
  end loop;  
  return l_resp;
  
  exception 
  when e_marker_exists then 
     l_resp := create_responce_rec('this marker already exists: ' ||pi_marker.marker_id);
     return l_resp;
  when others 
   then 
     l_resp := create_responce_rec(dbms_utility.format_error_stack);
     return l_resp;
end create_new_marker;
--
-----------------------------------------------------------------------------
--



function update_marker(pi_marker intren_marker_rec)
return intren_responce_rec
is 
  l_intr_rec v_nm_intr%rowtype;
  l_resp intren_responce_rec;
  l_iit_ne_id nm_inv_items.iit_ne_id%type;
begin 
  l_resp := create_responce_rec();
  l_iit_ne_id := marker_exists(pi_marker.marker_id);
  
  if l_iit_ne_id is not null
   then 
    l_intr_rec := intr_rec_from_marker_rec(pi_marker => pi_marker, pi_iit_ne_id => l_iit_ne_id);
        
    --nm3api_inv_intr.date_track_upd_attr (p_iit_ne_id                    => l_iit_ne_id
    nm3api_inv_intr.upd_attr (
                              p_iit_ne_id                    => l_iit_ne_id
                              --,p_effective_date               => 
                              ,pf_marker_id                   => l_intr_rec.marker_id
                              ,pf_x_coord                     => l_intr_rec.x_coord
                              ,pf_y_coord                     => l_intr_rec.y_coord
                              ,pf_install_date                => l_intr_rec.install_date
                              ,pf_decommission_date           => l_intr_rec.decommission_date
                              ,pf_contractor_org              => trim(l_intr_rec.contractor_org)
                              ,pf_street_name                 => l_intr_rec.street_name
                              ,pf_nature                      => l_intr_rec.nature
                              ,pf_material                    => l_intr_rec.material
                              ,pf_domain_owner                => l_intr_rec.domain_owner
                              ,pf_job_reference => l_intr_rec.job_reference 
                              ,pf_job_type => l_intr_rec.job_type      
                              ,pf_town => l_intr_rec.town          
                              ,pf_depth => l_intr_rec.depth         
                              ,pf_kerb_offset => l_intr_rec.kerb_offset   
                              ,pf_shape_of_asset => l_intr_rec.shape_of_asset
                              ,pf_dim_of_asset => l_intr_rec.dim_of_asset  
                              ,pf_fitting_type => l_intr_rec.fitting_type  
                              ,pf_construction_type => l_intr_rec.construction_type
                              ,pf_ubo_in_trench => l_intr_rec.ubo_in_trench    
                              ,pf_ubo_asset_type => l_intr_rec.ubo_asset_type   
                              ,pf_photo_type => l_intr_rec.photo_type       
                              ,pf_previuos_marker => l_intr_rec.previuos_marker  
                              ,pf_geographic_location => l_intr_rec.geographic_location
                              ,pf_survey_job_no => l_intr_rec.survey_job_no      
                              ,pf_survey_method => l_intr_rec.survey_method);    
  else 
    l_resp := create_responce_rec(pi_marker.marker_id || ' does not exist');
  end if;  
  return l_resp;
  
  exception when others 
   then 
     l_resp := create_responce_rec(dbms_utility.format_error_stack);
     return l_resp;
end update_marker;
--
-----------------------------------------------------------------------------
--
function ping
return intren_responce_rec
is
  l_resp intren_responce_rec;
begin 
  l_resp := create_responce_rec('Service available');
  return l_resp;
end ping;
--
-----------------------------------------------------------------------------
--
end intren_ws;