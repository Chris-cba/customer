CREATE OR REPLACE TRIGGER ins_nm_members
       BEFORE  INSERT OR UPDATE
       ON      NM_MEMBERS_ALL
       FOR     EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/ins_nm_members.trg-arc   3.3   Jan 24 2011 10:53:24   Chris.Strettle  $
--       Module Name      : $Workfile:   ins_nm_members.trg  $
--       Date into PVCS   : $Date:   Jan 24 2011 10:53:24  $
--       Date fetched Out : $Modtime:   Jan 24 2011 10:53:00  $
--       PVCS Version     : $Revision:   3.3  $
--       Norfolk Specific Based on Main Branch revision : 2.0
--
--   Author : Chris Strettle
--
-- TRIGGER ins_nm_members
--       BEFORE  INSERT OR UPDATE
--       ON      NM_MEMBERS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
   --
   -- checks that the parent record exists
   -- if it doesn't exist raise
   --      -20001, 'Parent not found''
   -- If not of type G Group or I Inventory then raise
   --      -20001 'Unknown member type''
   -- Checks that the start/end date of the child are
   -- between the start/end dates of the parent
   -- only checks end date if it is not null
   -- raises the following
   --      -20981, 'Member start date out of range'
   --      -20982, 'Member end date out of range'
   --      -20983, 'End date must be greater than start date'
   --
   l_mode VARCHAR2(9);
--
BEGIN
--
   IF    UPDATING
    THEN
      l_mode := nm3type.c_updating;
   ELSE
      l_mode := nm3type.c_inserting;
   END IF;
--
   nm3nwval.check_members (p_old_nm_ne_id_in   => :old.nm_ne_id_in
                          ,p_old_nm_ne_id_of   => :old.nm_ne_id_of
                          ,p_old_nm_start_date => :old.nm_start_date
                          ,p_old_nm_obj_type   => :old.nm_obj_type
                          ,p_new_nm_ne_id_in   => :new.nm_ne_id_in
                          ,p_new_nm_ne_id_of   => :new.nm_ne_id_of
                          ,p_new_nm_type       => :new.nm_type
                          ,p_new_nm_obj_type   => :new.nm_obj_type
                          ,p_new_nm_start_date => :new.nm_start_date
                          ,p_new_nm_end_date   => :new.nm_end_date
                          ,p_new_nm_begin_mp   => :new.nm_begin_mp
                          ,p_new_nm_end_mp     => :new.nm_end_mp
                          ,p_mode              => l_mode
                          );
--
--ensure the herm_xsp table is consistet with thehermis memberships  
--
if :new.nm_obj_type = 'SECT' then

  IF UPDATING and :old.nm_cardinality != :new.nm_cardinality then
    update herm_xsp
    set hxo_herm_dir_flag = decode( hxo_herm_dir_flag, :NEW.nm_cardinality, hxo_herm_dir_flag, hxo_herm_dir_flag * (-1)),
        hxo_offset = decode( hxo_herm_dir_flag, :NEW.nm_cardinality, hxo_offset, hxo_offset * (-1) )
    where hxo_ne_id_of = :NEW.nm_ne_id_of;
--
    insert into xncc_herm_xsp_temp
    values ( :new.nm_ne_id_of );
--
  elsif INSERTING then
    begin
    --
    
    xncc_herm_xsp.populate_herm_xsp( p_ne_id_in       => :new.nm_ne_id_in 
                                   , p_ne_id_of       => :new.nm_ne_id_of
                                   , p_nm_cardinality => :new.nm_cardinality
                                   , p_effective_date => :new.nm_start_date );
    --
    insert into xncc_herm_xsp_temp
    values ( :new.nm_ne_id_of );
--  
    exception
      when others then 
        nm_debug.debug(sqlerrm);
    end;                                     
  END IF;    
end if;
--
END ins_nm_members;
/