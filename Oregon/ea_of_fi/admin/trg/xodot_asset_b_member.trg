CREATE OR REPLACE TRIGGER XODOT_ASSET_B_MEMBER
BEFORE INSERT
ON NM_MEMBERS_ALL 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/ea_of_fi/admin/trg/xodot_asset_b_member.trg-arc   1.0   Oct 05 2010 12:02:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_asset_b_member.trg  $
--       Date into PVCS   : $Date:   Oct 05 2010 12:02:36  $
--       Date fetched Out : $Modtime:   Oct 05 2010 11:04:00  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : H.Buckley
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

/******************************************************************************
   NAME:       XDOT_ASSET_A_MEMBER
   PURPOSE:    Within the ODOT system there are Expenditure Accounts.
               A series of asset types have been defined ( 6 in total ) which
               relate to 'Count SEctions' and these have various attributes
               the first of which is the EA account. 

               The asset types are currently as follows:

               1) BRGS 2) ELCS 3) LDSS
               4) SGNS 5) STPS 6) SECS

               All EA values are also created as Road Groups and so each EA can
               be found in the network.
               This trigger should automatically maintain the child members of the
               EA groups based on changes made to the EA Asset types.
               The membership of the group should reflect the segments ( SEGM )
               that the assets of the related type are located on.    

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     XDOT_ASSET_A_MEMBER
      Sysdate:         5/21/2010
      Date and Time:   5/21/2010, 8:13:10 AM, and 5/21/2010 8:13:10 AMr
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      NM_MEMBERS_ALL (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
      
******************************************************************************/
   
 cursor get_ea_value_group( asset_id in nm_inv_items_all.iit_ne_id%type)
 is select ne_id
         , ne_gty_group_type
    from   nm_elements_all
         , nm_inv_items_all
    where  iit_ne_id = asset_id
    and    ne_unique = iit_itemcode;
    
 cursor get_ea_group_members( ne_id in nm_elements_all.ne_id%type 
                            , obj_type in nm_members_all.nm_obj_type%type
                            )
 is select *
    from   nm_members_all
    where  nm_ne_id_in = ne_id
    and    nm_obj_type = obj_type;
         
 ea_ne_id    nm_elements_all.ne_id%type;
 ea_obj_type nm_elements_all.ne_gty_group_type%type;
 memrec      nm_members_all%rowtype;
 i           integer:=xodot_members_state.newRows.count+1;

BEGIN
   if :new.nm_type='I' and :new.nm_obj_type=xodot_asset_type_functions.f$val_asset_type(:new.nm_obj_type,'EA_ASSET_GROUP_TYPES')
   then -- Obtain the group ne id for the unique that matches that 
        -- of the Expenditure Account for the selected asset  
        -- select any current members and save the details into the 
        memrec.nm_obj_type:=xodot_asset_type_functions.f$get_asset_group_type(:new.nm_obj_type,'EA_ASSET_GROUP_TYPES');     
        --
        -- Here it looks as though we need to implement a data notfound check
        -- with a handled eception should this group not be found.
        --   
        open  get_ea_value_group(:new.nm_ne_id_in);
        fetch get_ea_value_group into ea_ne_id,ea_obj_type;
        if get_ea_value_group%notfound
        then close get_ea_value_group;
              raise_application_error(-20902, 'Unable to locate Expenditure Account record');
        else close get_ea_value_group;
             --        
             memrec.nm_ne_id_in     := ea_ne_id;            
             memrec.nm_ne_id_of     := :new.nm_ne_id_of;            
             memrec.nm_type         := 'G';              
             memrec.nm_begin_mp     := :new.nm_begin_mp;            
             memrec.nm_start_date   := :new.nm_start_date;          
             memrec.nm_end_date     :=  null;            
             memrec.nm_end_mp       := :new.nm_end_mp;              
             memrec.nm_slk          := :new.nm_slk;                 
             memrec.nm_cardinality  := :new.nm_cardinality;         
             memrec.nm_admin_unit   := :new.nm_admin_unit;          
             memrec.nm_date_created := :new.nm_date_created;        
             memrec.nm_date_modified:= :new.nm_date_modified;       
             memrec.nm_modified_by  := :new.nm_modified_by;       
             memrec.nm_created_by   := :new.nm_created_by;          
             memrec.nm_seq_no       := null;                         
             memrec.nm_seg_no       := :new.nm_seg_no;                
             memrec.nm_true         := :new.nm_true;                    
             memrec.nm_end_slk      := :new.nm_end_slk;             
             memrec.nm_end_true     := :new.nm_end_true;            
        
             if inserting
             then  -- Create a new membership record providing that one does not exist.
                 NM3INS.INS_NM_ALL(memrec);
                 xodot_members_state.newRows(i).nm_ne_id_in     := ea_ne_id;            
                 xodot_members_state.newRows(i).nm_ne_id_of     := :new.nm_ne_id_of;            
                 xodot_members_state.newRows(i).nm_type         := 'G';              
                 xodot_members_state.newRows(i).nm_begin_mp     := :new.nm_begin_mp;            
                 xodot_members_state.newRows(i).nm_start_date   := :new.nm_start_date;          
                 xodot_members_state.newRows(i).nm_end_date     := null;           
                 xodot_members_state.newRows(i).nm_end_mp       := :new.nm_end_mp;              
                 xodot_members_state.newRows(i).nm_slk          := :new.nm_slk;                 
                 xodot_members_state.newRows(i).nm_cardinality  := :new.nm_cardinality;         
                 xodot_members_state.newRows(i).nm_admin_unit   := :new.nm_admin_unit;          
                 xodot_members_state.newRows(i).nm_date_created := :new.nm_date_created;        
                 xodot_members_state.newRows(i).nm_date_modified:= :new.nm_date_modified;       
                 xodot_members_state.newRows(i).nm_modified_by  := :new.nm_modified_by;       
                 xodot_members_state.newRows(i).nm_created_by   := :new.nm_created_by;          
                 xodot_members_state.newRows(i).nm_seq_no       := null;                         
                 xodot_members_state.newRows(i).nm_seg_no       := :new.nm_seg_no;                
                 xodot_members_state.newRows(i).nm_true         := :new.nm_true;                    
                 xodot_members_state.newRows(i).nm_end_slk      := :new.nm_end_slk;             
                 xodot_members_state.newRows(i).nm_end_true     := :new.nm_end_true;
                 xodot_members_state.newRows(i).nm_obj_type     := xodot_asset_type_functions.f$get_asset_group_type(:new.nm_obj_type,'EA_ASSET_GROUP_TYPES');    
           end if;
      end if;
   end if;
   exception
     when others 
     then raise;
END XDOT_ASSET_A_MEMBER;
/
