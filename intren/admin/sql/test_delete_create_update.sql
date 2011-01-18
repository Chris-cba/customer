set serveroutput on

DECLARE
  PI_MARKER_ID SWM.INTREN_MARKER_ID_TYPE;
  v_Return SWM.INTREN_RESPONCE_REC;
BEGIN
  -- Modify the code to initialize the variable
  PI_MARKER_ID := new INTREN_MARKER_ID_TYPE('PMTEST1');

  v_Return := INTREN_WS.DELETE_MARKER(
    PI_MARKER_ID => PI_MARKER_ID
  );
  -- Modify the code to output the variable
  dbms_output.put_line('v_Return = ' || v_return.message);
  commit;
end;
/

DECLARE
  PI_MARKER INTREN_MARKER_REC;
  v_Return INTREN_RESPONCE_REC;
BEGIN
  -- Modify the code to initialize the variable
  pi_marker := new intren_marker_rec(marker_id => 'IANTST1'
      ,easting   => '123456'
      ,northing  => '123456'
      ,date_installed => '01-AUG-2010'
      ,date_decomissioned => ''
      ,contractor_organisation => 'TELECOMMS'
      ,street_name => 'my street'
      ,nature_of_asset => 'PIPE'
      ,material => 'PLASTIC'
      ,domain_owner => ''
      ,job_reference => ''
      ,job_type     => ''
      ,town         => ''
      ,depth        => ''
      ,kerb_offset  => ''
      ,shape_of_asset=> ''
      ,dim_of_asset  => ''
      ,fitting_type  => ''
      ,construction_type => ''
      ,ubo_in_trench    => ''
      ,ubo_asset_type   => ''
      ,photo_type       => ''
      ,previuos_marker  => ''
      ,geographic_location=> ''
      ,survey_job_no      => ''
      ,survey_method => '' );

  v_Return := INTREN_WS.CREATE_NEW_MARKER( PI_MARKER => PI_MARKER );

  -- Modify the code to output the variable
  dbms_output.put_line('v_Return = ' || v_return.message);
  commit;
end;
/

DECLARE
  PI_MARKER SWM.INTREN_MARKER_REC;
  v_Return SWM.INTREN_RESPONCE_REC;
BEGIN
  -- Modify the code to initialize the variable
   pi_marker := new intren_marker_rec(marker_id => 'IANTST1'
      ,easting   => '222222'
      ,northing  => '123456'
      ,date_installed => '01-AUG-2010'
      ,date_decomissioned => ''
      ,contractor_organisation => 'TELECOMMS'
      ,street_name => 'my street'
      ,nature_of_asset => 'PIPE'
      ,material => 'PLASTIC'
      ,domain_owner => ''
      ,job_reference => ''
      ,job_type     => ''
      ,town         => ''
      ,depth        => '20'
      ,kerb_offset  => ''
      ,shape_of_asset=> ''
      ,dim_of_asset  => ''
      ,fitting_type  => ''
      ,construction_type => ''
      ,ubo_in_trench    => ''
      ,ubo_asset_type   => ''
      ,photo_type       => ''
      ,previuos_marker  => ''
      ,geographic_location=> ''
      ,survey_job_no      => ''
      ,survey_method => '' );

  v_Return := INTREN_WS.UPDATE_MARKER(
    PI_MARKER => PI_MARKER
  );
  -- Modify the code to output the variable
  DBMS_OUTPUT.PUT_LINE('v_Return = ' || v_Return.message);
end;
/