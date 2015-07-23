create or replace
PACKAGE BODY         XBC_CREATE_SECURING_INV AS
--
---------------------
--
--all global package variables here
--
-- PVCS Identifiers :-
--
-- sccsid : $Header:   //new_vm_latest/archives/customer/bc/admin/pck/xbc_create_securing_inv.pkb-arc   1.2   Jul 23 2015 10:30:30   Sarah.Williams  $
-- Module Name : $Workfile:   XBC_CREATE_SECURING_INV.pkb  $
-- Date into PVCS : $Date:   Jul 23 2015 10:30:30  $
-- Date fetched Out : $Modtime:   Jul 23 2015 10:29:38  $
-- PVCS Version     : $Revision:   1.2  $

-- g_body_sccsid constant varchar2(30) :='"$Revision:   1.2  $"';
 g_body_sccsid constant varchar2(30) :='"$Revision:   1.2  $"';
-- dh corrected fatal error on closing a route group and its datum  - Jun 30 2015
-- dh corrected end date on closed assets - Jun 30 2015
-- g_package_name CONSTANT varchar2(30) := 'xkytc_create_securing_inv';
 g_package_name CONSTANT varchar2(30) := 'xbc_create_securing_inv';
--
-----------------------------------------------------------------------------
--
 g_count PLS_INTEGER := 0;
 g_tab_ne_id nm3type.tab_number;

 g_tab_ca_iit_ne_id_count PLS_INTEGER := 0;
 g_tab_ca_iit_ne_id nm3type.tab_number;
--
 g_block nm3type.max_varchar2;
--
 g_nothing_to_do EXCEPTION;
--
    g_count_enddate             PLS_INTEGER    := 0;
    g_tab_ne_id_enddate        NM3TYPE.TAB_NUMBER;
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
PROCEDURE clear_globals_enddate IS
BEGIN
--
 nm_debug.proc_start(g_package_name,'clear_globals_enddate');
--
    g_count_enddate     := 0;
    g_tab_ne_id_enddate.DELETE;

--
 nm_debug.proc_end(g_package_name,'clear_globals_enddate');
--
END clear_globals_enddate;
--
PROCEDURE append_to_g_tab_ca_iit_ne_id (p_ne_id IN nm_elements_all.ne_id%TYPE
 ,p_ne_nt_type IN nm_elements_all.ne_nt_type%TYPE
 ) IS
-- this procedure collects up the iit_ne_ids on the datum before it get's processed by a network opperation.
--
BEGIN
--
 nm_debug.proc_start(g_package_name,'append_to_g_tab_ca_iit_ne_id');


 for iit_ne_id in (select nm_ne_id_in from nm_members where nm_ne_id_of = p_ne_id and nm_obj_type in ('CA','PINV') and nm_type='I' )
 loop

        g_tab_ca_iit_ne_id_count := g_tab_ca_iit_ne_id_count + 1;
        g_tab_ca_iit_ne_id(g_count) := iit_ne_id.nm_ne_id_in;

        DBMS_OUTPUT.PUT_LINE  ('count = ' || g_tab_ca_iit_ne_id_count || ' iit_ne_id = ' || iit_ne_id.nm_ne_id_in );

  end loop;
--
 nm_debug.proc_end(g_package_name,'append_to_g_tab_ca_iit_ne_id');
--
END append_to_g_tab_ca_iit_ne_id;

PROCEDURE append_to_globals (p_ne_id IN nm_elements_all.ne_id%TYPE
 ,p_ne_nt_type IN nm_elements_all.ne_nt_type%TYPE
 ) IS
--
--
BEGIN
--
--
nm_debug.proc_start(g_package_name,'append_to_globals');
 g_count := g_count + 1;
 g_tab_ne_id(g_count) := p_ne_id;
--
 nm_debug.proc_end(g_package_name,'append_to_globals');
--
END append_to_globals;
--
--
PROCEDURE append_to_globals_enddate (p_ne_id IN nm_elements_all.ne_id%TYPE
 ,p_ne_nt_type IN nm_elements_all.ne_nt_type%TYPE
 ) IS
--
--
BEGIN
--
    nm_debug.proc_start(g_package_name,'append_to_globals_enddate');
nm3dbg.putln('g_count_enddate: ' || g_count_enddate || ' - ' || p_ne_id);
--
    g_count_enddate := g_count_enddate + 1;
    g_tab_ne_id_enddate(g_count_enddate) := p_ne_id;
--
    nm_debug.proc_end(g_package_name,'append_to_globals_enddate');
--
END append_to_globals_enddate;
--
--
-----------------------------------------------------------------
--
PROCEDURE process_g_tab_ca_iit_ne_id IS
l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
l_pinv_admin_unit nm_admin_units.nau_admin_unit%type:=164;
BEGIN
--
 nm_debug.proc_start(g_package_name,'process_g_tab_ca_iit_ne_id');

 DBMS_OUTPUT.PUT_LINE   ( 'id count = ' || g_tab_ca_iit_ne_id.count);
 DBMS_OUTPUT.PUT_LINE   ( 'id = '  || g_tab_ca_iit_ne_id(1));

 FOR i IN 1..g_tab_ca_iit_ne_id_count
 LOOP

 DBMS_OUTPUT.PUT_LINE   ( 'id = '  || g_tab_ca_iit_ne_id(i));
   -- nm3api_inv.end_date_item (g_tab_ca_iit_ne_id(i));

 end loop;

 g_tab_ca_iit_ne_id_count := 0;
 g_tab_ca_iit_ne_id.DELETE;

 end  process_g_tab_ca_iit_ne_id ;


PROCEDURE process_globals IS
l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
l_pinv_admin_unit nm_admin_units.nau_admin_unit%type:=164;
BEGIN
--
 nm_debug.proc_start(g_package_name,'process_globals');
--
 BEGIN
 IF g_count > 0 -- and not nm3merge.is_nw_operation_in_progress
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
 /*for c1rec in
 (select nm_ne_id_in
 from nm_members
 where nm_type='I'
 and nm_obj_type in ('CA','PINV')
 and nm_ne_id_of=g_rec_ne.ne_id)
 loop
 nm3api_inv.end_date_item(p_iit_ne_id =>c1rec.nm_ne_id_in
 ,p_effective_date=> g_rec_ne.ne_start_date);
 end loop;
 */

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
PROCEDURE process_globals_enddate IS

t_count     NUMBER;
t_index     NUMBER;
t_today     DATE;
t_iit       NUMBER;
t_datum     NUMBER;
t_error     VARCHAR2(220);
t_exists    number;

CURSOR cur_ca(cp_neid IN NUMBER) IS
    SELECT nm_ne_id_in, nm_end_date 
    FROM nm_members_all
    WHERE nm_ne_id_of = cp_neid
        AND nm_obj_type IN ('CA','PINV');

BEGIN
nm_debug.proc_start(g_package_name,'start close assets');
nm3dbg.debug_on;

/* a fatal error was encountered when closing a route and the members
   checking for a NW operation and only proceeding 
       through the logic if true prevents the error
   NOTE:  the value of t_today is reset to value of the membership end date
   dh - June 30, 2015
*/
if nm3merge.is_nw_operation_in_progress then
    nm_debug.debug('NW OPERATION true');
		t_count		:=  g_tab_ne_id_enddate.COUNT;
		t_index		:= 0;
else
    nm_debug.debug('NW OPERATION FALSE .... ');
    t_count := 0;
end if;


		SELECT SYSDATE INTO t_today FROM DUAL;
		t_today		:= trunc(t_today);

		FOR t_index IN 1..t_count LOOP

	nm3dbg.putln('*********t_index1: ' || t_index );
            t_datum       := g_tab_ne_id_enddate(t_index);
	nm3dbg.putln('*********t_index2: ' || t_index );


            FOR c_ca IN cur_ca(t_datum) LOOP

                t_iit       := c_ca.nm_ne_id_in;
                t_today     := trunc(c_ca.nm_end_date);
nm3dbg.putln('Processing Datum: ' || t_datum || ', asset: ' || t_iit || ' t_index: ' || t_index || ' end date ' || t_today);
                -- need to check in case it's already been end dated


                select count(*) into t_exists from nm_inv_items where iit_ne_id = t_iit;

                if nvl(t_exists,0) > 0 then

                    nm3api_inv.end_date_item(p_iit_ne_id => t_iit, p_effective_date => t_today);
                    nm3dbg.putln('Asset end-dated: ' || t_iit);

                end if;


            END LOOP;

        END LOOP;
nm_debug.proc_end(g_package_name,'close assets');

EXCEPTION WHEN OTHERS THEN
    t_error := substr(sqlerrm,1,200);
    nm_debug.proc_start(g_package_name,'start');
    nm3dbg.debug_on;
    nm3dbg.putln('End date trigger failure: ' || t_error);
    nm_debug.proc_end(g_package_name,'start');
END;


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

END xbc_create_securing_inv;
/
