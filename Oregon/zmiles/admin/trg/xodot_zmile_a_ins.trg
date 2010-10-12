CREATE OR REPLACE TRIGGER TRANSINFO.xodot_ins_A_zmile_nm
AFTER insert ON TRANSINFO.NM_MEMBERS_ALL referencing new as new old as old
for each row
declare

-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/zmiles/admin/trg/xodot_zmile_a_ins.trg-arc   1.0   Oct 12 2010 11:52:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_zmile_a_ins.trg  $
--       Date into PVCS   : $Date:   Oct 12 2010 11:52:28  $
--       Date fetched Out : $Modtime:   Oct 12 2010 11:51:14  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : H.Buckley
--
--   
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------


  i   integer:=xodot_zmile_state.newRows.count+1;
  --
  route_ne_id        nm_elements_all.ne_id%type;
  min_z_route_offset number;
  max_z_route_offset number;
  l_lref             nm_placement_array;
  l_plrec            nm_placement;
  z_rec              nm_members_all%rowtype;
  located            boolean:=false;
  pragma             autonomous_transaction;
--
-- ********************************************************************
-- For the specified route,. Obtain all Z mileage elements
-- ********************************************************************
cursor get_z_mileage_elements( hwy_ne_id in nm_elements_all.ne_id%type)
is select ne_id
   from   nm_elements_all    a
   where  a.ne_name_1='Z'
   and    exists ( select null
                   from   nm_elements_all b
                   where  b.ne_owner    = a.ne_owner
                   and    b.ne_sub_type = a.ne_sub_type
                   and    b.ne_prefix   = a.ne_prefix
                   and    b.ne_id       = hwy_ne_id);                           
-- 
-- *********************************************************************
-- Function to detrmine if the specified route has Z mileage
-- *********************************************************************
--
Function f$HasRouteZMileage( v_ne_id in nm_elements_all.ne_id%type) return boolean
is
  cursor c1( hwy_ne_id in nm_elements_all.ne_id%type)
  is select 1
     from   nm_elements_all    a
     where  a.ne_id = hwy_ne_id
     and    exists ( select null
                     from   nm_elements_all b
                     where  b.ne_owner    = a.ne_owner
                     and    b.ne_sub_type = a.ne_sub_type
                     and    b.ne_prefix   = a.ne_prefix
                     and    b.ne_name_1   = 'Z');

   vok  boolean:=false;
   vtot integer:=0;

  begin
    open c1(v_ne_id);
    fetch c1 into vtot;
    if c1%notfound
    then vtot:=0;
         close c1;
    else close c1;
    end if;
    if vtot<>0
    then return true;
    else return false;
    end if;
  end f$HasRouteZMileage;
--
-- *********************************************************
-- For a specified asset id , this cursor should return the
-- element whose network type is HWY.
-- ********************************************************
Function f$ObtainRelatedRoute(member_id in nm_elements_all.ne_id%type ) return integer
is
   cursor get_hwy(member_id in nm_elements_all.ne_id%type)
   is select a.nm_ne_id_in
      from   nm_members a
      where  a.nm_ne_id_of=member_id
      and    a.nm_obj_type='HWY';

v_ne_id   nm_elements_all.ne_id%type:=0;

begin
  open  get_hwy(member_id);
  fetch get_hwy into v_ne_id;
  close get_hwy;
  return v_ne_id;
end f$ObtainRelatedRoute;
--
Function f$transient_record_exists (ne_id_in in nm_members_all.nm_ne_id_in%type
                                   ,ne_id_of in nm_members_all.nm_ne_id_of%type)
return boolean is
    cursor c1
    is select 1
       from   xodot_zmile_transient
       where  nm_ne_id_in=ne_id_in
       and    nm_ne_id_of=ne_id_of;
vExists integer:=0;      
begin

   open  c1;
   fetch c1 into vExists;
   if c1%notfound
   then vExists:=0;
        close c1;
   else close c1;
   end if;
   if nvl(vExists,0)=0
   then return false;
   else return true;
   end if;
end f$transient_record_exists;
                                          
begin
   --
   -- ================================================================
   -- 1. Is the member of an asset
   -- 2. Is the asset continuous
   -- 3. Is the asset being located on a section with Z mileage
   --    (a) Obtain the assets relative route 
   --    (b) Check to see if the route has Z  mileage. 
   -- 4. If the route has Z mileage then for each element .
   --    If the location of the asset is at the start of the Z mileage
   --    element then the a    
   --
   -- ================================================================
   --    
   if :new.nm_type='I'
   and nm3inv.get_nit_pnt_or_cont(:new.nm_obj_type)='C'
   then route_ne_id:=f$obtainRelatedRoute(:new.nm_ne_id_of);
        if f$HasRouteZMileage(route_ne_id)
        then for j in get_z_mileage_elements(route_ne_id)
             loop if not f$transient_record_exists (:new.nm_ne_id_in
                                                   ,:new.nm_ne_id_of)
                  then insert into xodot_zmile_transient
                      (NM_NE_ID_IN            
                      ,NM_NE_ID_OF            
                      ,NM_TYPE                
                      ,NM_OBJ_TYPE            
                      ,NM_BEGIN_MP             
                      ,NM_START_DATE          
                      ,NM_END_DATE            
                      ,NM_END_MP              
                      ,NM_SLK                 
                      ,NM_CARDINALITY         
                      ,NM_ADMIN_UNIT          
                      ,NM_DATE_CREATED        
                      ,NM_DATE_MODIFIED
                      ,NM_MODIFIED_BY         
                      ,NM_CREATED_BY          
                      ,NM_SEQ_NO              
                      ,NM_SEG_NO              
                      ,NM_TRUE                
                      ,NM_END_SLK             
                      ,NM_END_TRUE            
                      ) values
                     ( :new.NM_NE_ID_IN            
                      ,:new.NM_NE_ID_OF            
                      ,:new.NM_TYPE                
                      ,:new.NM_OBJ_TYPE            
                      ,:new.NM_BEGIN_MP             
                      ,:new.NM_START_DATE          
                      ,:new.NM_END_DATE            
                      ,:new.NM_END_MP              
                      ,:new.NM_SLK                 
                      ,:new.NM_CARDINALITY         
                      ,:new.NM_ADMIN_UNIT          
                      ,:new.NM_DATE_CREATED        
                      ,:new.NM_DATE_MODIFIED
                      ,:new.NM_MODIFIED_BY         
                      ,:new.NM_CREATED_BY          
                      ,:new.NM_SEQ_NO              
                      ,:new.NM_SEG_NO              
                      ,:new.NM_TRUE                
                      ,:new.NM_END_SLK             
                      ,:new.NM_END_TRUE  
                    );
                  end if;                                                                                               
             end loop;
             commit;
        end if;
    end if;
end;
/
