CREATE OR REPLACE PACKAGE BODY XBC_CREATE_SECURING_INV AS
--
---------------------
--
--all global package variables here
--
-- PVCS Identifiers :-
--
-- sccsid : $Header:   //vm_latest/archives/customer/bc/admin/pck/xbc_create_securing_inv.pkb-arc   1.0   Mar 26 2009 09:58:26   smarshall  $
-- Module Name : $Workfile:   xbc_create_securing_inv.pkb  $
-- Date into PVCS : $Date:   Mar 26 2009 09:58:26  $
-- Date fetched Out : $Modtime:   Mar 26 2009 09:58:14  $
-- PVCS Version : $Revision:   1.0  $

 g_body_sccsid constant varchar2(30) :='"$Revision:   1.0  $"';

--
 g_package_name CONSTANT varchar2(30) := 'xkytc_create_securing_inv';
--
-----------------------------------------------------------------------------
--
 g_count PLS_INTEGER := 0;
 g_tab_ne_id nm3type.tab_number;
--
 g_block nm3type.max_varchar2;
--
 g_nothing_to_do EXCEPTION;
--
-----------------------------------------------------------------
--
PROCEDURE clear_globals IS
BEGIN
--
 nm_debug.proc_start(g_package_name,'clear_globals');
--
 g_count := 0;
 g_tab_ne_id.DELETE;
--
 nm_debug.proc_end(g_package_name,'clear_globals');
--
END clear_globals;
--
-----------------------------------------------------------------
--
PROCEDURE append_to_globals (p_ne_id IN nm_elements_all.ne_id%TYPE
 ,p_ne_nt_type IN nm_elements_all.ne_nt_type%TYPE
 ) IS
--
--
BEGIN
--
 nm_debug.proc_start(g_package_name,'append_to_globals');
--
 g_count := g_count + 1;
 g_tab_ne_id(g_count) := p_ne_id;
--
 nm_debug.proc_end(g_package_name,'append_to_globals');
--
END append_to_globals;
--
-----------------------------------------------------------------
--
PROCEDURE process_globals IS
l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
l_pinv_admin_unit nm_admin_units.nau_admin_unit%type:=164;
BEGIN
--
 nm_debug.proc_start(g_package_name,'process_globals');
--
 BEGIN
 IF g_count > 0 and not nm3merge.is_nw_operation_in_progress
 THEN
 IF NOT nm3user.is_user_unrestricted
 THEN
 hig.raise_ner (pi_appl => nm3type.c_hig
 ,pi_id => 86
 );
 END IF;
 -- prepare_dynamic_block;
 FOR i IN 1..g_count
 LOOP
 g_rec_ne := nm3get.get_ne_all (pi_ne_id => g_tab_ne_id(i));
 -- nm3api_inv.end_date_item (g_tab_ne_id(i)
	 -- ,g_rec_ne.ne_start_date
 -- );
 --first close any existing CA or PINV items on this datum that may have been created as a result of a merge/split
 for c1rec in 
 (select nm_ne_id_in
 from nm_members
 where nm_type='I'
 and nm_obj_type in ('CA','PINV')
 and nm_ne_id_of=g_rec_ne.ne_id)
 loop 
 nm3api_inv.end_date_item(p_iit_ne_id =>c1rec.nm_ne_id_in
 ,p_effective_date=> g_rec_ne.ne_start_date);
 end loop;
 
 NM3API_INV_CA.ins (p_iit_ne_id => l_iit_ne_id
	 ,p_effective_date => g_rec_ne.ne_start_date
	 ,p_admin_unit => find_corresponding_au(g_rec_ne.ne_admin_unit,'DINV')
	 ,p_descr => g_rec_ne.ne_unique
	 ,p_note => g_rec_ne.ne_nt_type
	 ,p_element_ne_id => g_rec_ne.ne_id
 );
 
/* PINV admin unit is hard coded as there is only 1 value.
its value is returned by

select nau_admin_unit
 from nm_admin_units_all,nm_inv_types_all
where nau_admin_type=nit_admin_type 
and nit_inv_type='PINV'

*/ 
 NM3API_INV_PINV.ins (p_iit_ne_id => l_iit_ne_id
	 ,p_effective_date => g_rec_ne.ne_start_date
	 ,p_admin_unit => 164
	 ,p_descr => g_rec_ne.ne_unique
	 ,p_note => g_rec_ne.ne_nt_type
	 ,p_element_ne_id => g_rec_ne.ne_id
 ); 
 END LOOP;
 END IF;
 EXCEPTION
 WHEN others
 THEN
 Null;
 END;
--
 clear_globals;
--
 nm_debug.proc_end(g_package_name,'process_globals');
--
END process_globals;
--
-----------------------------------------------------------------
--
FUNCTION find_corresponding_au (p_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE
 ,p_nat_admin_type nm_au_types.nat_admin_type%TYPE
 ) RETURN nm_admin_units.nau_admin_unit%TYPE IS
--
 l_rec_nau_ele nm_admin_units_all%ROWTYPE;
 l_rec_nau_inv nm_admin_units_all%ROWTYPE;
--
BEGIN
--
 nm_debug.proc_start(g_package_name,'find_corresponding_au');
--
 l_rec_nau_ele := nm3get.get_nau_all (pi_nau_admin_unit => p_nau_admin_unit);
--
 IF p_nat_admin_type = l_rec_nau_ele.nau_admin_type
 THEN
 l_rec_nau_inv := l_rec_nau_ele;
 ELSE
 l_rec_nau_inv := nm3get.get_nau_all (pi_nau_unit_code => l_rec_nau_ele.nau_unit_code
 ,pi_nau_admin_type => p_nat_admin_type
 );
 END IF;
--
 nm_debug.proc_end(g_package_name,'find_corresponding_au');
--
 RETURN l_rec_nau_inv.nau_admin_unit;
--
END find_corresponding_au;
--
-----------------------------------------------------------------------------
--
 FUNCTION get_version RETURN VARCHAR2 IS
 BEGIN
 RETURN g_sccsid;
 END get_version;
--
-----------------------------------------------------------------------------
--
 FUNCTION get_body_version RETURN VARCHAR2 IS
 BEGIN
 RETURN g_body_sccsid;
 END get_body_version;
 --

END BC_APP_RIM.xbc_create_securing_inv; 
/

