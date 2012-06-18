create or replace function x_im_wo_has_doc(pi_woid doc_assocs.das_rec_id%type)
return NUMBER
is
/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/IM WO Doc Assocs/x_im_wo_has_doc.sql-arc   1.0   Jun 18 2012 13:08:02   Ian.Turnbull  $
 --       Module Name      : $Workfile:   x_im_wo_has_doc.sql  $
 --       Date into PVCS   : $Date:   Jun 18 2012 13:08:02  $
 --       Date fetched Out : $Modtime:   Jun 18 2012 13:05:58  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
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





