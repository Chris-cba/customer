CREATE OR REPLACE TRIGGER xhants_def_status_post_stm_trg
AFTER INSERT
ON defects
begin
  if xhants_def_status.tab_defects.COUNT>0 then
    xhants_def_status.process_defects;
    xhants_def_status.clear_defects;
  end if;
end xhants_def_status_post_stm_trg;
/ 
