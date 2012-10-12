CREATE OR REPLACE package body xlbe_def_status as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/pck/xlbe_def_status.pkb-arc   1.0   Oct 12 2012 12:21:54   Ian.Turnbull  $
--       Module Name      : $Workfile:   xlbe_def_status.pkb  $
--       Date into PVCS   : $Date:   Oct 12 2012 12:21:54  $
--       Date fetched Out : $Modtime:   Oct 05 2012 16:42:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : Garry Bleakley
--
--   xlbe_def_status body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

  g_package_name CONSTANT varchar2(30) := '%YourObjectName%';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--

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
end process_defects;

procedure update_def_status (p_def_id number) as
--

cursor c1 is
select def_defect_id
from defects
where def_defect_id=p_def_id;
--
cursor c2 (p_def_status_id number) is
select def_date_compl,def_serial_no,def_status_code,def_notify_org_id
from defects
where def_defect_id=p_def_status_id;
--
cursor get_status (p_status_code varchar2) is
select hsc_status_code
from hig_status_codes
where hsc_domain_code = 'COMPLAINTS'
and hsc_status_code = p_status_code;
--

l_tab_defects nm3type.tab_number;
l_pem_status hig_status_codes.hsc_status_code%type;
l_def_status hig_status_codes.hsc_status_code%type;
l_compl date;
l_serial_no varchar2(9);
l_notify number;

begin
  l_tab_defects.delete;
    
  open c1;
  fetch c1 bulk collect into  l_tab_defects;
  close c1;
  

  for i in 1..l_tab_defects.count loop
    open c2(l_tab_defects(i));
    fetch c2 into l_compl,l_serial_no,l_def_status,l_notify;
    close c2;
    open get_status(l_def_status);
    fetch get_status into l_pem_status;
    close get_status;

     if l_notify is not null then
       update docs
       set doc_status_code = 'NOTIFIED',
           doc_reason      = 'Defect '||l_tab_defects(i)||' Status Changed to NOTIFIED'
       where doc_id = l_serial_no;
      elsif l_def_status = l_pem_status then
        if l_def_status = 'COMPLETED' then
	      UPDATE docs
	      SET    doc_status_code = l_pem_status,
	             doc_compl_complete = l_compl,
	             doc_reason      =  'Defect '||l_tab_defects(i)||' Status Changed to '||l_def_status
	             WHERE  doc_id = l_serial_no;
	else
	      UPDATE docs
	      SET    doc_status_code = l_pem_status,
	             doc_reason      =  'Defect '||l_tab_defects(i)||' Status Changed to '||l_def_status
	             WHERE  doc_id = l_serial_no;
	end if;
      end if;

  end loop;
end update_def_status;

procedure clear_wols as
begin
  tab_wols.delete;
end clear_wols;

procedure process_wols as

begin
 

   FOR i IN 1..tab_wols.COUNT LOOP
     if tab_wols(i) is not null then
       update_wol_status(tab_wols(i));
	 end if;
  end loop;
  nm_debug.debug_off;  
end process_wols;

procedure update_wol_status (p_wol_def_id number) as
--

cursor c1 is
select wol_def_defect_id
from work_order_lines
where wol_def_defect_id=p_wol_def_id;
--
cursor c2 (p_wol_status_id number) is
select def_serial_no,def_notify_org_id
from defects
where def_defect_id=p_wol_status_id;
--
cursor get_status is
select hsc_status_code
from hig_status_codes
where hsc_domain_code = 'COMPLAINTS'
and hsc_status_code = 'ACTIONED';


l_tab_wols nm3type.tab_number;
l_pem_status hig_status_codes.hsc_status_code%type;
l_serial_no varchar2(9);
l_notify number;

begin
  l_tab_wols.delete;
    
  open c1;
  fetch c1 bulk collect into  l_tab_wols;
  close c1;
  

  for i in 1..l_tab_wols.count loop
    open c2(l_tab_wols(i));
    fetch c2 into l_serial_no,l_notify;
    close c2;
    open get_status;
    fetch get_status into l_pem_status;
    close get_status;

    if l_notify is null then
     if l_pem_status = 'ACTIONED' then
       update docs
       set doc_status_code = 'ACTIONED',
           doc_reason      = 'Defect '||l_tab_wols(i)||' Status Changed to ACTIONED'
       where doc_id = l_serial_no;
     end if;
    end if;

  end loop;
end update_wol_status;

end xlbe_def_status;
/

