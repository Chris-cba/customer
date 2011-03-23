create or replace trigger xhants_defects
after update 
on     defects
for    each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_defects.trg-arc   1.2   Mar 23 2011 18:07:56   Ian.Turnbull  $
--       Module Name      : $Workfile:   xhants_defects.trg  $
--       Date into PVCS   : $Date:   Mar 23 2011 18:07:56  $
--       Date fetched Out : $Modtime:   Oct 07 2010 21:37:52  $
--       PVCS Version     : $Revision:   1.2  $
--       Based on SCCS version :
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

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