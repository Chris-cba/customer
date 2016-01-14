/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/scripts/x_im_wo_has_doc.sql-arc   1.0   Jan 14 2016 19:50:16   Sarah.Williams  $
 --       Module Name      : $Workfile:   x_im_wo_has_doc.sql  $
 --       Date into PVCS   : $Date:   Jan 14 2016 19:50:16  $
 --       Date fetched Out : $Modtime:   Jun 25 2012 10:08:36  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
create or replace function x_im_wo_has_doc(pi_woid doc_assocs.das_rec_id%type
                                           ,pi_null varchar2 default null)
return NUMBER
is
   cursor c1
   is
   select 1
from doc_assocs
    , docs 
    , doc_locations
where das_table_name = 'WORK_ORDERS'
and doc_id = das_doc_id
and das_rec_id = pi_woid
and doc_dlc_id = dlc_id
union
select 1
from doc_assocs
    , docs 
    , doc_locations
where das_table_name = 'WORK_ORDER_LINES'
and doc_id = das_doc_id
and das_rec_id in (select to_char(wol_id)
                  from work_order_lines
                  where wol_works_order_no = pi_woid)
and doc_dlc_id = dlc_id
union
select 1
from doc_assocs
    , docs 
    , doc_locations
where das_table_name = 'DEFECTS'
and doc_id = das_doc_id
and das_rec_id in (select to_char(wol_def_defect_id)
                  from work_order_lines
                  where wol_works_order_no = pi_woid)
and doc_dlc_id = dlc_id
;
   
   rtrn number;
begin
  open c1;
  fetch c1 INTO rtrn;
  if c1%found then rtrn := 1;
  else
     rtrn := 0;
  end if;
  close c1;
  return rtrn;
end x_im_wo_has_doc;
/

grant execute on x_im_wo_has_doc to public;





