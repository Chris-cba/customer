CREATE OR REPLACE package body wag_twis_load

AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/WAG/TWIS_Interface/WAG_TWIS_LOAD.pkb-arc   3.1   Oct 13 2009 10:08:38   Ian Turnbull  $
--       Module Name      : $Workfile:   WAG_TWIS_LOAD.pkb  $
--       Date into PVCS   : $Date:   Oct 13 2009 10:08:38  $
--       Date fetched Out : $Modtime:   Oct 13 2009 10:08:12  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--
--   Author : %USERNAME%
--
--   WAG_TWIS_LOAD body
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
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   3.1  $"';

  g_package_name CONSTANT varchar2(30) := 'wag_twis_load.pkb';
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
-----------------------------------------------------------------------------
--

procedure load_twis(p_twis_rec v_wag_twis%rowtype)
is
l_road_group varchar(255) default null;
l_scheme_type hig_codes.hco_code%type default null;
l_exists number default 0;
--
begin
  begin
    select ne_id into l_road_group from nm_elements_all where ne_type = 'G' and upper(ne_unique) = upper(p_twis_rec.til_route_number);
  exception when no_data_found then
    raise_application_error(-20001,'Road Group Does Not Exist');
  end;
  --
  begin
    select hco_code into l_scheme_type from hig_codes where hco_domain = 'SCHEME_TYPES' and hco_end_date is null and upper(hco_meaning) = upper(p_twis_rec.til_scheme_type);
  exception when no_data_found then
    raise_application_error(-20001,'Scheme Type Does Not Exist');
  end;
  --
  begin
    select least(count(*),1)  into l_exists from budgets where p_twis_rec.til_scheme_number = bud_add_cost_code
    					  and p_twis_rec.til_agency = bud_agency;
  exception when no_data_found then
    null;
  end;
  --
  if l_exists = 1
    then
      update budgets
      set bud_value = p_twis_rec.til_approved_code,
          bud_comment = 'Updated by TWIS interface on '||to_char(sysdate,'DD-MON-YYYY HH24:MI:SS')
      where bud_add_cost_code=p_twis_rec.til_scheme_number
        and bud_agency = p_twis_rec.til_agency;
    else
      insert into item_code_breakdowns
      ( icb_id,
        icb_work_code,
        icb_item_code,
        icb_sub_item_code,
        icb_sub_sub_item_code,
        icb_dtp_flag,
        icb_work_category_name,
        icb_type_of_scheme,
        icb_required_type,
        icb_rse_road_environment,
        icb_agency_code
      )
      VALUES
      ( icb_id_seq.nextval,                         --icb_id
        substr(p_twis_rec.til_scheme_number,3,6),   --icb_work_code
        substr(p_twis_rec.til_scheme_number,3,2),   --icb_item_code
        substr(p_twis_rec.til_scheme_number,5,2),   --icb_sub_item_code
        substr(p_twis_rec.til_scheme_number,7,2),   --icb_sub_sub_item_code
        'D',                                        --icb_dtp_flag
        p_twis_rec.til_description,                 --icb_work_category_name
        l_scheme_type,                              --icb_type_of_scheme
        null,                                       --icb_required_type
        null,                                       --icb_rse_road_environment
        p_twis_rec.til_agency		            --icb_agency_code
      );
      --
      insert into ihms_conversions
      ( ihc_icb_id,
        ihc_atv_acty_area_code
      )
      select icb_id_seq.currval,
             atv_acty_area_code
      from   activities
      where  atv_end_date is null;
      --
      insert into budgets
      ( bud_sys_flag,
        bud_agency,
        bud_rse_he_id,
        bud_job_code,
        bud_icb_item_code,
        bud_icb_sub_item_code,
        bud_icb_sub_sub_item_code,
        bud_fyr_id,
        bud_value,
        bud_add_cost_code,
        bud_id,
        bud_committed,
        bud_actual,
        bud_comment
      )
      VALUES
      ( 'D',
        p_twis_rec.til_agency,
        l_road_group,
        '0',
        substr(p_twis_rec.til_scheme_number,3,2),
        substr(p_twis_rec.til_scheme_number,5,2),
        substr(p_twis_rec.til_scheme_number,7,2),
        '20'||substr(p_twis_rec.til_scheme_number,1,2),
        p_twis_rec.til_approved_code,
        p_twis_rec.til_scheme_number,
        bud_id_seq.nextval,
        0,
        0,
        'Created by TWIS interface on '||to_char(sysdate,'DD-MON-YYYY HH24:MI:SS')
      );
  end if;
end;
end;
/

