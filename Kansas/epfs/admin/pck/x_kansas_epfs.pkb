CREATE OR REPLACE PACKAGE BODY x_kansas_epfs
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Kanzas/epfs/admin/pck/x_kansas_epfs.pkb-arc   2.1   Jul 19 2007 08:34:56   Ian Turnbull  $
--       Module Name      : $Workfile:   x_kansas_epfs.pkb  $
--       Date into SCCS   : $Date:   Jul 19 2007 08:34:56  $
--       Date fetched Out : $Modtime:   Jul 19 2007 08:28:58  $
--       SCCS Version     : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"%W% %G%"';

  g_package_name CONSTANT varchar2(30) := 'x_kansas_epfs';


  g_assessment_param constant varchar2(20) := 'ASSESMENT_ID';
  g_county_param constant varchar2(20) := 'COUNTY_NUMBER';
  g_THRESHOLD_param constant varchar2(20) := 'THRESHOLD';

  cursor c_map ( c_module x_kansas_epfs_maps.kem_module_id%type)
  is
  select '"'||kem_map_location||'"'
  from x_kansas_epfs_maps
  where kem_module_id = c_module;
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
function ins_gri_parameters( pi_module varchar2
                            ,pi_param_name varchar2
                            ,pi_value      varchar2
                            ,pi_job_id number default null
                            )
return number
is
   l_job_id number;
   pragma autonomous_transaction;
begin
   l_job_id := pi_job_id;
   if l_job_id is null
    then
      higgri.get_params( p_module => pi_module
                        ,p_job_id => l_job_id); -- populate gri_run_parameters
   end if;

   -- set the parameters values
   higgri.set_param( pi_job_id => l_job_id
                    ,pi_param  => pi_param_name
                    ,pi_value  => pi_value);

   commit;

   return l_job_id;

end ins_gri_parameters;
--
-----------------------------------------------------------------------------
--
function ins_gri_parameters( pi_pv_rec pv_rec_type)
return number
is
   l_job_id number;
begin
   l_job_id := null;
   l_job_id := ins_gri_parameters( pi_module => pi_pv_rec.module
                                  ,pi_param_name => pi_pv_rec.param_name
                                  ,pi_value => pi_pv_rec.value
                                  ,pi_job_id => l_job_id);

   return l_job_id;

end ins_gri_parameters;
--
-----------------------------------------------------------------------------
--
function ins_gri_parameters( pi_pv_tab pv_tab_type)
return number
is
   l_job_id number;
begin

   l_job_id := null;
   for i in 1..pi_pv_tab.count
    loop
      l_job_id := ins_gri_parameters( pi_module => pi_pv_tab(i).module
                                     ,pi_param_name => pi_pv_tab(i).param_name
                                     ,pi_value => pi_pv_tab(i).value
                                     ,pi_job_id => l_job_id);
   end loop;
   return l_job_id;

end ins_gri_parameters;
--
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
procedure set_tolerence(pi_tolerence number default 0)
is
begin
   p_tolerence := pi_tolerence;
end set_tolerence;
--
-----------------------------------------------------------------------------
--
function get_tolerence return number
is
begin
   return p_tolerence;
end get_tolerence;
--
-----------------------------------------------------------------------------
--
function get_noninter_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS01';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_noninter_cmd;
--
-----------------------------------------------------------------------------
--
function get_noninter_hp_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county number
                          ,pi_threshold NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS02';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;

   l_tab(3).module := l_module;
   l_tab(3).param_name  :=  g_THRESHOLD_param;
   l_tab(3).value  := pi_threshold;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_noninter_hp_cmd;
--
-----------------------------------------------------------------------------
--
function get_inter_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS03';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_inter_cmd;
--
-----------------------------------------------------------------------------
--
function get_inter_hp_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county number
                          ,pi_threshold NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS04';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;

   l_tab(3).module := l_module;
   l_tab(3).param_name  :=  g_THRESHOLD_param;
   l_tab(3).value  := pi_threshold;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_inter_hp_cmd;
--
-----------------------------------------------------------------------------
--
function get_bridge_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS05';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_bridge_cmd;
--
-----------------------------------------------------------------------------
--
function get_bridge_hp_cmd( pi_username varchar2
                          ,pi_password varchar2
                          ,pi_instance varchar2
                          ,pi_assessment_id number
                          ,pi_county number
                          ,pi_threshold NUMBER
                          ,pi_arcmap_exe VARCHAR2
                         )
return varchar2
is


   l_job_id number;
   l_sm_path hig_option_values.hov_value%type;

   l_module varchar2(12) := 'XEPFS06';

   L_TAB X_KANsAS_EPFS.pv_tab_type;
   l_map_name varchar2(250);

   rtrn varchar2(250);
begin

   l_tab(1).module := l_module;
   l_tab(1).param_name  :=  g_assessment_param;
   l_tab(1).value  := pi_assessment_id;

   l_tab(2).module := l_module;
   l_tab(2).param_name  :=  g_county_param;
   l_tab(2).value  := pi_county;

   l_tab(3).module := l_module;
   l_tab(3).param_name  :=  g_THRESHOLD_param;
   l_tab(3).value  := pi_threshold;


   l_job_id := x_kansas_epfs.ins_gri_parameters( pi_pv_tab => l_tab );

   l_sm_path := pi_arcmap_exe;
   IF l_sm_path IS NULL
    THEN
	   l_sm_path := hig.get_user_or_sys_opt('SMPATH');
	END IF;

	open c_map(l_module);
	fetch c_map into l_map_name;
	close c_map;

	rtrn :=   l_sm_path || ' '
	       || l_map_name || ' '
	       || '/USR='||pi_username  || ' '
	       || '/PWD='||pi_password  || ' '
	       || '/DB_ALIAS='||pi_instance || ' '
	       || '/REQUESTID='||l_job_id;

   return rtrn;
end get_bridge_hp_cmd;

END x_kansas_epfs;
/

