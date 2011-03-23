CREATE OR REPLACE package body xhants_def_status as

procedure clear_defects as
begin
  tab_defects.delete;
end clear_defects;

procedure process_defects as

begin
 

   FOR i IN 1..tab_defects.COUNT LOOP
     if tab_defects(i) is not null then
       update_def_status(tab_defects(i));
	 end if;
  end loop;
  nm_debug.debug_off;  
end process_defects
;

procedure update_def_status (p_def_id number) as
--

cursor c1 is
select def_defect_id
from defects
where def_defect_id=p_def_id;
--
cursor c2 (p_def_status_id number) is
select def_date_compl
from defects
where def_defect_id=p_def_status_id;


l_tab_defects nm3type.tab_number;
l_def_status varchar2(200);
l_status varchar2(400);
l_return varchar2(100);
l_action varchar2(10):='NO ACTION';

l_compl date;

begin

  l_tab_defects.delete;
    
  open c1;
  fetch c1 bulk collect into  l_tab_defects;
  close c1;
  

  for i in 1..l_tab_defects.count loop
    open c2(l_tab_defects(i));
    fetch c2 into l_compl;
    close c2;

    l_return:=hcc_mai_def_api.update_defect_status(l_tab_defects(i),l_compl,l_action);
--    l_status:='hcc_mai_def_api.update_defect_status('''||l_tab_defects(i)||''','''||l_compl||''','''||l_action||''');';
--    'update defects set def_special_instr='''||l_rep_descr||''' where def_defect_id='||l_tab_defects(i);
--    execute immediate(l_si_descr);
  end loop;
end update_def_status;

end xhants_def_status;
/

