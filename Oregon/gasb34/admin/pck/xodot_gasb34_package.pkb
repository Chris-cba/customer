CREATE OR REPLACE PACKAGE BODY xodot_gasb34_package as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/gasb34/admin/pck/xodot_gasb34_package.pkb-arc   3.1   Sep 16 2010 08:42:42   ian.turnbull  $
--       Module Name      : $Workfile:   xodot_gasb34_package.pkb  $
--       Date into PVCS   : $Date:   Sep 16 2010 08:42:42  $
--       Date fetched Out : $Modtime:   Sep 15 2010 18:13:40  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--
--   Author : PStanton
--
--   xodot_gasb34_package body
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

  g_package_name CONSTANT varchar2(30) := 'xodot_gasb34_package';
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
PROCEDURE clear_table IS

BEGIN
  
  xodot_gasb34_package.newRows := xodot_gasb34_package.empty;
  
END;											 

PROCEDURE pop_table( p_NE_VERSION_NO nm_elements.NE_VERSION_NO%TYPE,
			         p_NE_NSG_REF nm_elements.NE_NSG_REF%TYPE,
			         p_ne_id nm_elements.NE_ID%TYPE) IS  
  
  CURSOR get_members IS 
  select nm_ne_id_of from nm_members
  where nm_ne_id_in = p_ne_id;
  
  l_count number;
BEGIN

  l_count := 0;
  
  FOR i in get_members LOOP
  
    l_count := l_count+1;
	
    xodot_gasb34_package.newRows(l_count).ne_version_no := p_NE_VERSION_NO; 
    xodot_gasb34_package.newRows(l_count).NE_NSG_REF := p_NE_NSG_REF; 
    xodot_gasb34_package.newRows(l_count).ne_id := i.nm_ne_id_of; 
 
   END LOOP;
  
END pop_table;

PROCEDURE update_elements IS


BEGIN

   for i IN 1..xodot_gasb34_package.newRows.count loop
                
      UPDATE nm_elements_all
	  SET NE_NAME_2 = xodot_gasb34_package.newRows(i).NE_VERSION_NO,
      NE_GROUP  = xodot_gasb34_package.newRows(i).NE_NSG_REF
	  WHERE ne_id = xodot_gasb34_package.newRows(i).ne_id;
   
   end loop; 

   
  
END update_elements;


PROCEDURE refresh_gasb34 IS
--
-------
--
CURSOR get_trnf_groups IS
SELECT * FROM nm_elements_all
WHERE ne_nt_type = 'TRNF';
--
-------
--
CURSOR get_trnf_membs (p_ne_id nm_elements.ne_id%TYPE) IS 
select * from nm_elements_all
where ne_id in (select nm_ne_id_in  from nm_members_all
               where nm_ne_id_of in (select ne_id from nm_elements_all
                                     where ne_id in (select nm_ne_id_of from nm_members_all
                                                     where nm_ne_id_in = p_ne_id )))
and ne_nt_type = 'HWY';
--
-------
--
CURSOR get_rows IS
SELECT * from xodot_gasb34
WHERE official_transfer_date IS NOT NULL;
--
--------
--
CURSOR prev_add_mil (p_ne_unique nm_elements.ne_unique%TYPE,
                     p_date date) IS  
select sum(nm3net.get_ne_length(iit_ne_id)) l_sum from nm_inv_items_all b
where iit_ne_id in (select nm_ne_id_in from nm_members_all
                    where nm_ne_id_of in (select ne_id from nm_elements_all 
                                          where ne_id in (select nm_ne_id_of from nm_members_all
                                                          where nm_ne_id_in = (select ne_id from nm_elements_all 
                                                                               where ne_unique = p_ne_unique)))
                and to_date(nm_start_date) < to_date(p_date)
and nm_obj_type = 'RDGM')
and iit_x_sect in ('LN1I','LN2I','LN3I','LN4I','LN5I','LN6I');
--
--------
--
CURSOR post_add_mil (p_ne_unique nm_elements.ne_unique%TYPE,
                     p_date date) IS  
select sum(nm3net.get_ne_length(iit_ne_id)) l_sum from nm_inv_items_all b
where iit_ne_id in (select nm_ne_id_in from nm_members_all
                    where nm_ne_id_of in (select ne_id from nm_elements_all 
                                          where ne_id in (select nm_ne_id_of from nm_members_all
                                                          where nm_ne_id_in = (select ne_id from nm_elements_all 
                                                                               where ne_unique = p_ne_unique)))
                and to_date(nm_start_date) > to_date(p_date)
and nm_obj_type = 'RDGM')
and iit_x_sect in ('LN1I','LN2I','LN3I','LN4I','LN5I','LN6I');
--
---------
--
CURSOR prev_non_add_mil (p_ne_unique nm_elements.ne_unique%TYPE,
                         p_date date) IS  
select sum(nm3net.get_ne_length(iit_ne_id)) l_sum from nm_inv_items_all b
where iit_ne_id in (select nm_ne_id_in from nm_members_all
                    where nm_ne_id_of in (select ne_id from nm_elements_all 
                                          where ne_id in (select nm_ne_id_of from nm_members_all
                                                          where nm_ne_id_in = (select ne_id from nm_elements_all 
                                                                               where ne_unique = p_ne_unique)))
                and to_date(nm_start_date) < to_date(p_date)
and nm_obj_type = 'RDGM')
and iit_x_sect in ('LN1D','LN2D','LN3D','LN4D','LN5D','LN6D');
--
---------
--
CURSOR post_non_add_mil (p_ne_unique nm_elements.ne_unique%TYPE,
                     p_date date) IS  
select sum(nm3net.get_ne_length(iit_ne_id)) l_sum from nm_inv_items_all b
where iit_ne_id in (select nm_ne_id_in from nm_members_all
                    where nm_ne_id_of in (select ne_id from nm_elements_all 
                                          where ne_id in (select nm_ne_id_of from nm_members_all
                                                          where nm_ne_id_in = (select ne_id from nm_elements_all 
                                                                               where ne_unique = p_ne_unique)))
                and to_date(nm_start_date) > to_date(p_date)
and nm_obj_type = 'RDGM')
and iit_x_sect in ('LN1D','LN2D','LN3D','LN4D','LN5D','LN6D');
--
---------
--
CURSOR get_comment(p_ne_id nm_elements_all.ne_id%TYPE) IS
select IIT_CHR_ATTRIB58,IIT_CHR_ATTRIB28 FROM NM_NW_AD_LINK_ALL, nm_inv_items_all
where nad_ne_id = p_ne_id
and nad_nt_type = 'TRNF'
and iit_ne_id = nad_iit_ne_id;
--
---------
--

BEGIN

delete from xodot_gasb34;


   FOR i IN get_trnf_groups LOOP
   
      FOR i2 IN get_trnf_membs(i.ne_id) LOOP
	  
	     INSERT INTO xodot_gasb34 
         (
		  TRANS_UNIQUE
		 ,hwy_unique
		 ,highway_number
		 ,suffix
		 ,roadway_id
		 ,mileage_type
		 ,overlap_mileage_code
		 ,road_direction
		 ,road_type
		 ,official_transfer_date
		 ,official_transfer_id
		 ,official_transfer_type
		 ,transfer_to
		 )
	      VALUES
	     (
		  i.ne_unique
		 ,i2.ne_unique
		 ,i2.ne_owner
		 ,i2.ne_sub_type
		 ,i2.ne_prefix
		 ,i2.ne_name_1
		 ,i2.ne_name_2
		 ,i2.ne_number
		 ,i2.ne_group
		 ,to_char(to_date(i.ne_name_2),'MM/DD/YYYY') 
		 ,i.ne_nsg_ref
		 ,i.ne_number
		 ,i.ne_name_1
		 );
      
	  END LOOP;
	  
	  
   END LOOP;
commit;

   FOR i in get_trnf_groups LOOP
      FOR i2 IN  get_comment(i.ne_id)  LOOP
	     UPDATE xodot_gasb34
	     SET agreement_transfer_comment = i2.IIT_CHR_ATTRIB58
		    ,transfer_from = i2.IIT_CHR_ATTRIB28
	     WHERE TRANS_UNIQUE = i.ne_unique;
      END LOOP;
   END LOOP;	  
   
FOR i IN get_rows LOOP
   
    FOR i2 IN prev_add_mil (p_ne_unique => i.trans_unique,
                            p_date => to_date(i.official_transfer_date,'DD/MM/YYYY') ) LOOP

       UPDATE xodot_gasb34
	   SET PREVIOUS_INCR_MILEAGE = i2.l_sum
	   WHERE TRANS_UNIQUE = i.trans_unique;
	   
	END LOOP;
	
	
	FOR i2 IN post_add_mil (p_ne_unique => i.trans_unique,
                            p_date => to_date(i.official_transfer_date,'DD/MM/YYYY')) LOOP

       UPDATE xodot_gasb34
	   SET POST_INCR_MILEAGE = i2.l_sum
	   WHERE TRANS_UNIQUE = i.trans_unique;
	   
	END LOOP;
	
	
	FOR i2 IN prev_non_add_mil (p_ne_unique => i.trans_unique,
                                p_date => to_date(i.official_transfer_date,'DD/MM/YYYY')) LOOP

       UPDATE xodot_gasb34
	   SET PREVIOUS_DECR_MILEAGE = i2.l_sum
	   WHERE TRANS_UNIQUE = i.trans_unique;
	   
	END LOOP;
	
	
	FOR i2 IN post_non_add_mil (p_ne_unique => i.trans_unique,
                                p_date => to_date(i.official_transfer_date,'DD/MM/YYYY')) LOOP

       UPDATE xodot_gasb34
	   SET POST_DECR_MILEAGE  = i2.l_sum
	   WHERE TRANS_UNIQUE = i.trans_unique;
	   
	END LOOP;
	
	
END LOOP;
commit;

  
END refresh_gasb34;

end xodot_gasb34_package; 
/ 

