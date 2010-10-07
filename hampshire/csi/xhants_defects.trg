create or replace trigger xhants_defects
after update 
on     defects
for    each row
--
declare
--
begin
  if :new.def_status_code = 'NO ACTION' and  :old.def_status_code != 'NO ACTION' then
    xhants_pem_bespoke.set_no_main_reqd(:new.def_defect_id, :new.def_special_instr);
  end if;
  if :new.def_status_code in ('ROUTINE','CONTRACTOR','3RD PARTY','MADE SAFE','PLANNED','EMERGENCY','COMPLETED') and
     :new.def_status_code != :old.def_status_code  then
    xhants_pem_bespoke.set_via_defect(:new.def_defect_id, :new.def_special_instr, :new.def_status_code);
  end if;
end;