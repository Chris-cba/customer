CREATE OR REPLACE package body xodot_z_mileage
AS

--<PACKAGE>
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/zmiles/admin/pck/xodot_zmile.pkb-arc   1.0   Oct 12 2010 11:52:08   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_zmile.pkb  $
--       Date into PVCS   : $Date:   Oct 12 2010 11:52:08  $
--       Date fetched Out : $Modtime:   Oct 12 2010 11:51:08  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : H.Buckley
--
--    packagebody
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  G_SCCSID CONSTANT VARCHAR2(2000):='"$Revision:   1.0  $"';

--</GLOBVAR>
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
Procedure Maintain_Z_Mileage
is
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           :
--       Module Name      :
--       Date into SCCS   :
--       Date fetched Out :
--       SCCS Version     :
--
--
--   Author : Harry Buckley
--
--   TRIGGER xodot_z_mileage
--      BEFORE INSERT , UPDATE , DELETE
--      ON nm_inv_items_all
--      FOR EACH ROW
--
-- Descr : This trigger needs to fire when asset details are
--         changed.
--         The trigger needs only to fire for linear asset
--         types.
--         The trigger needs only to fire IF there are 'Z'
--         mileage elements for the related asset route.
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
hwy_ne_id nm_elements_all.ne_id%type;
nm3_rec nm_members_all%rowtype;
-- Here we need to define a pl/sql table to hold all of the elements
-- for the Route,Zmileage element and the located ASset

pragma autonomous_transaction;

type member_rec is record
( NM_NE_ID_IN       NUMBER(9)
, NM_NE_ID_OF       NUMBER(9)
, NM_TYPE           VARCHAR2(4)
, NM_OBJ_TYPE       VARCHAR2(4)
, NM_BEGIN_MP       NUMBER
, NM_START_DATE     DATE
, NM_END_DATE       DATE
, NM_END_MP         NUMBER
, NM_SLK            NUMBER
, NM_CARDINALITY    NUMBER(38)
, NM_ADMIN_UNIT     NUMBER(9)
, NM_DATE_CREATED   DATE
, NM_DATE_MODIFIED  DATE
, NM_MODIFIED_BY    VARCHAR2(30)
, NM_CREATED_BY     VARCHAR2(30)
, NM_SEQ_NO         NUMBER(38)       
, NM_SEG_NO         NUMBER(9)
, NM_TRUE           NUMBER
, NM_END_SLK        NUMBER
, NM_END_TRUE       NUMBER
);

type v_tab is table of member_rec index by binary_integer;

r_tab v_tab; -- pl/sql table to hold route     elements 
z_tab v_tab; -- pl/sql table to hold z mileage elements 
i_tab v_tab; -- pl/sql table to hold asset     elements 
i_rec nm_members_all%rowtype;

clear_tab v_tab;

r_seq integer:=0;    -- r_tab record counter
z_seq integer:=0;    -- z_tab record counter
i_seq integer:=0;    -- i_tab record counter
i     integer;       -- general counter 
now   date:=trunc(sysdate);
dbg   boolean:=true;
--
hwy_route      nm_elements_all.ne_id%type;
start_location number;
end_location   number;
asset_located_to_z_mileage boolean:=false;
--
--
-- ********************************************************************
-- Obtain all transient assets 
-- ********************************************************************
Cursor get_transient_assets
is select *
   from   xodot_zmile_transient
   order by nm_ne_id_in;          
--
-- ********************************************************************************
-- Here we need to obtain the member records and they need to be in the order that
-- they appear in the route. We need to compare the retrieved array against that
-- listed in the group form for the route element. Here the order is important as
-- it will be key to the logic used.
-- ********************************************************************************
cursor get_element_members(ne_in nm_elements_all.ne_id%type)
is select *
   from   nm_members
   where  nm_ne_id_in = ne_in
   order by nm_seq_no;
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
-- ********************************************************************
-- For the specified Z mileage element.Obtain all Z mileage memebers 
-- ********************************************************************
cursor get_z_mileage_locations( z_ne_id in nm_elements_all.ne_id%type)
is select *
   from   nm_members
   where  nm_ne_id_in=z_ne_id; 
--   
-- ********************************************************************
-- Obtain all Z mileage elements for a route 
-- ******************************************************************** 
Cursor get_zmileage_elements( v_ne_id in nm_elements_all.ne_id%type)
is select b.ne_id ne_id
   from nm_elements a
      , nm_elements b
   where a.ne_owner    = b.ne_owner
   and   a.ne_sub_type = b.ne_sub_type
   and   a.ne_prefix   = b.ne_prefix
   and   a.ne_id       = v_ne_id 
   and   b.ne_name_1   = 'Z';
--
-- *********************************************************************
-- Obtain the asset related member records.
-- *********************************************************************
cursor get_route_asset_membs(ne_id in nm_inv_items_all.iit_ne_id%type)
is select *
   from   nm_members
   where  nm_ne_id_in=ne_id;
   
-- *********************************************************************
-- Populate the z-mileage member records into an pl/sql array
-- *********************************************************************
                   
procedure pop_z_mileage_hwy_array( asset_id       in nm_members_all.nm_ne_id_in%type
                                ,  asset_location in nm_members_all.nm_ne_id_of%type
                                ,  r_rec in out   integer
                                ,  r_tab in out   v_tab)
is

   cursor get_hwy_membs(asset_id       in nm_members_all.nm_ne_id_in%type
                     ,  asset_location in nm_members_all.nm_ne_id_of%type)
   is select a.nm_ne_id_in  hwy_element
           , a.nm_ne_id_of  hwy_location
      from   nm_members a
      where  a.nm_obj_type='HWY'
      and    a.nm_ne_id_in in ( select nm_ne_id_in
                                from   nm_members
                                where  nm_ne_id_in=asset_id
                                and    nm_ne_id_of=asset_location);
located boolean:=false;
j integer;

begin
   for i in get_hwy_membs(asset_id,asset_location)
   loop
      r_rec:=r_tab.count;
      if   r_rec=0
      then r_rec:=r_tab.count+1;
           r_tab(r_rec).nm_ne_id_in:=i.hwy_element;
           r_tab(r_rec).nm_ne_id_of:=i.hwy_location;
      else for j in 1..r_tab.count
           loop if  r_tab(j).nm_ne_id_in=i.hwy_element
                and r_tab(j).nm_ne_id_of=i.hwy_location
                then located:=true;
                end if;
            end loop;
            if not located 
            then r_rec:=r_tab.count+1;
                 r_tab(r_rec).nm_ne_id_in:=i.hwy_element;
                 r_tab(r_rec).nm_ne_id_of:=i.hwy_location;
            end if;
      end if;                        
   end loop;
end;                   
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


Function f$MemberExists(nm_in in nm_members_all.nm_ne_id_in%type
                       ,nm_of in nm_members_all.nm_ne_id_of%type )
return boolean
is
    cursor c1( nm_in in nm_members_all.nm_ne_id_in%type
            ,  nm_of in nm_members_all.nm_ne_id_of%type)
    is select 1
       from nm_members_all
       where nm_ne_id_in=nm_in
       and   nm_ne_id_of=nm_of
       and   nm_end_date is null;

v_ok     integer;
v_exists boolean:=false;

begin
  open c1(nm_in,nm_of);
  fetch c1 into v_ok;
  if c1%found
  then v_exists:=true;
  end if;
  close c1;
  return v_exists;
end f$MemberExists;
--
Procedure p$Get_asset_location(asset_location in nm_inv_items_all.iit_ne_id%type
                           ,   st_location in out number
                           ,   ed_location in out number )
is

     cursor c1
     is select nm_slk
             , nm_end_slk
        from   nm_members_all
        where  nm_obj_type='HWY'
        and    nm_ne_id_of = asset_location;
begin

    open  c1;
    fetch c1 into st_location,ed_location;
    if c1%notfound
    then st_location:=0;
         ed_location:=0;
         close c1;
    else close c1;
    end if;                                         
end;
--
begin      
    for i in get_transient_assets                                               -- for all assets 
    loop 
         p$Get_asset_location(i.nm_ne_id_of,start_location,end_location);       -- obtain the asset start/end 
         for j in get_zmileage_elements(f$ObtainRelatedRoute(i.nm_ne_id_of))    -- get each z mileage route 
               loop r_tab:=clear_tab;                                           -- clear the element table 
                    r_seq:=1;                                                   -- set the element sequence
                    asset_located_to_z_mileage:=false;                          -- set boolean location variable
                    for k in get_element_members(j.ne_id)                       -- obtain all route members 
                    loop r_tab(r_seq).nm_ne_id_in      := k.nm_ne_id_in;     
                         r_tab(r_seq).nm_ne_id_of      := k.nm_ne_id_of;    
                         r_tab(r_seq).nm_type          := k.nm_type;                       
                         r_tab(r_seq).nm_obj_type      := k.nm_obj_type;     
                         r_tab(r_seq).nm_begin_mp      := k.nm_begin_mp;    
                         r_tab(r_seq).nm_start_date    := k.nm_start_date;   
                         r_tab(r_seq).nm_end_date      := k.nm_end_date;     
                         r_tab(r_seq).nm_end_mp        := k.nm_end_mp;       
                         r_tab(r_seq).nm_slk           := k.nm_slk;
                         r_tab(r_seq).nm_cardinality   := k.nm_cardinality;   
                         r_tab(r_seq).nm_admin_unit    := k.nm_admin_unit;    
                         r_tab(r_seq).nm_date_created  := k.nm_date_created;   
                         r_tab(r_seq).nm_date_modified := k.nm_date_modified; 
                         r_tab(r_seq).nm_modified_by   := k.nm_modified_by;
                         r_tab(r_seq).nm_created_by    := k.nm_created_by;
                         r_tab(r_seq).nm_seq_no        := k.nm_seq_no;               
                         r_tab(r_seq).nm_seg_no        := k.nm_seg_no;         
                         r_tab(r_seq).nm_true          := k.nm_true;         
                         r_tab(r_seq).nm_end_slk       := k.nm_end_slk;      
                         r_tab(r_seq).nm_end_true      := k.nm_end_true;                                        
                         --
                         if  start_location <= r_tab(r_seq).nm_slk
                         and end_location    > r_tab(r_seq).nm_slk
                         then asset_located_to_z_mileage:=true;
                         end if;
                         --
                         r_seq:=r_seq+1;
                         --
                    end loop;
                    --
                    if asset_located_to_z_mileage
                    then for p in 1..r_tab.count
                         loop if not f$MemberExists(i.nm_ne_id_in,r_tab(p).nm_ne_id_of)
                              then  i_rec.nm_ne_id_in      := i.nm_ne_id_in;
                                    i_rec.nm_ne_id_of      := r_tab(p).nm_ne_id_of;
                                    i_rec.nm_type          := i.nm_type;
                                    i_rec.nm_obj_type      := i.nm_obj_type;
                                    i_rec.nm_begin_mp      := r_tab(p).nm_begin_mp;
                                    i_rec.nm_end_mp        := r_tab(p).nm_end_mp;
                                    i_rec.nm_admin_unit    := r_tab(p).nm_admin_unit;
                                    i_rec.nm_start_date    := trunc(sysdate);
                                    i_rec.nm_date_created  := trunc(sysdate);
                                    i_rec.nm_date_modified := trunc(sysdate);
                                    i_rec.nm_modified_by   := user;
                                    i_rec.nm_created_by    := user;      
                                    i_rec.nm_end_date      := r_tab(p).nm_end_date;
                                    i_rec.nm_slk           := r_tab(p).nm_slk;
                                    i_rec.nm_cardinality   := r_tab(p).nm_cardinality;
                                    i_rec.nm_seq_no        := r_tab(p).nm_seq_no;
                                    i_rec.nm_seg_no        := r_tab(p).nm_seg_no;
                                    i_rec.nm_true          := r_tab(p).nm_true;
                                    i_rec.nm_end_slk       := r_tab(p).nm_end_slk;
                                    i_rec.nm_end_true      := r_tab(p).nm_end_true;
                                    --
                                    nm3ins.ins_nm(i_rec);
                                    --
                                    -- *****************************************************                                    
                                    -- Once the member record has been inserted we require
                                    -- to delete any records of the asset from the transient
                                    -- table 
                                    -- ******************************************************
                                    --
                               end if; 
                         end loop; 
                    
                    end if;             
             end loop;
             --
             delete from xodot_zmile_transient
             where  nm_ne_id_in=i.nm_ne_id_in;
             commit; 
             -- 
       end loop;
end maintain_z_mileage;
--
end;
/
