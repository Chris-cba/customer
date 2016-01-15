-- script to install GASB34 triggers.


CREATE OR REPLACE package TRANSINFO.xodot_elements_state
as
    type fldArray is table of nm_elements_all%rowtype index by binary_integer;
    newRows fldArray;
    empty   fldArray;
end;
/


CREATE OR REPLACE TRIGGER TRANSINFO.xodot_ins_b_elements
before update ON TRANSINFO.NM_ELEMENTS_ALL 
    -- clean out the package variables
    -- see xodot_upd_trnf_grp_mem_attribs and xodot_upd_a_elements_trans

begin
   xodot_elements_state.newRows := xodot_elements_state.empty;
end;
/


CREATE OR REPLACE TRIGGER xodot_upd_trnf_grp_mem_attribs
before UPDATE 
   ON NM_ELEMENTS_ALL REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
   --  to avoid a mutating trigger, this 
   -- this is the trigger that puts values in a package array so that 
   -- xodot_upd_a_elements_trans can update them
   
   declare
   i integer:=xodot_elements_state.newRows.count+1;

BEGIN

   If :new.ne_gty_group_type='TRNF'
    and :old.NE_NAME_2  is null 
    and  :new.NE_NAME_2 is not null
    then
    
        xodot_elements_state.newRows(i).ne_id := :new.ne_id;
        xodot_elements_state.newRows(i).ne_name_2 := :new.NE_VERSION_NO ;
        xodot_elements_state.newRows(i).NE_GROUP :=  :new.NE_NSG_REF  ;
                     
    end if;
    
end xodot_upd_trnf_grp_mem_attribs;


CREATE OR REPLACE TRIGGER TRANSINFO.xodot_upd_a_elements_trans
after update ON TRANSINFO.NM_elements_ALL 

begin
  --
  -- Here we need to create the rows contained within the pl/sql array.
 
 for i in 1..xodot_elements_state.newRows.count
 loop

       update nm_elements_all  set 
          ne_name_2 = xodot_elements_state.newRows(i).NE_name_2-- reason for change
        , NE_GROUP = xodot_elements_state.newRows(i).NE_GROUP -- document ID
        where ne_type = 'S'
        and ne_id in (
            select nm_ne_id_of
            from nm_members where
            nm_obj_type = 'TRNF'
            and nm_ne_id_in = xodot_elements_state.newRows(i).ne_id);
              
  end loop;
end;
/

