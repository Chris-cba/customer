CREATE OR REPLACE TRIGGER xhants_def_status_pre_row_trg
BEFORE INSERT
ON defects
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

begin
IF :new.def_priority = 'B' THEN
  xhants_def_status.tab_defects(xhants_def_status.tab_defects.count+1):=(:NEW.def_defect_id);
END IF;
END xhants_def_status_pre_row_trg;
/

