CREATE OR REPLACE TRIGGER complete_wor_status
AFTER UPDATE
OF    wol_status_code
ON    work_order_lines
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/tfl/IM WO Doc Assocs/compl_wor_status.trg-arc   3.0   Sep 11 2013 14:33:50   Barbara.ODriscoll  $
--       Module Name      : $Workfile:   compl_wor_status.trg  $
--       Date into PVCS   : $Date:   Sep 11 2013 14:33:50  $
--       Date fetched Out : $Modtime:   Sep 11 2013 14:31:20  $
--       Version          : $Revision:   3.0  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------

  l_doc_id docs.doc_id%type;
  l_num number;
  l_status work_order_lines.wol_status_code%type;
--
  cursor get_cur_wor_docs is
    select doc_id
    from   doc_assocs, docs, doc_types
 -- where  das_rec_id = :new.def_defect_id  -- siftikhar log 702699 01/02/2006
    where  das_rec_id = to_char(:new.wol_works_order_no)
      and  das_table_name = 'WORK_ORDERS'
      and  das_doc_id = doc_id
      and  doc_dtp_code = dtp_code
      and  dtp_allow_complaints = 'Y';
--
  cursor get_open_wol_docs is
    select 1
    from   doc_assocs
--  where  das_rec_id = rep_def_defect_id   --siftikhar log 702699 01/02/2006
--    and  das_rec_id = :new.def_defect_id
    where  das_rec_id = to_char(:new.wol_works_order_no)
      and  das_table_name = 'WORK_ORDERS'
      and  das_doc_id = l_doc_id
      and  not exists (select 'exists'
                       from hig_status_codes
                       where hsc_domain_code = 'WORK_ORDER_LINES'
                       and :NEW.wol_status_code = hsc_status_code
                       and hsc_allow_feature3 = 'Y'
                       and sysdate between nvl(hsc_start_date, sysdate)
                       and nvl(hsc_end_date, sysdate));
--
  cursor get_doc_status is
    select hsc_status_code
    from   hig_status_codes
    where  hsc_domain_code = 'COMPLAINTS'
      and  hsc_allow_feature4 = 'Y'
      and  sysdate between nvl(hsc_start_date, sysdate)
                       and nvl(hsc_end_date, sysdate);
--
BEGIN

  if :new.wol_status_code is not null then
     for get_cur_wor_docs_rec in get_cur_wor_docs LOOP
         l_doc_id := get_cur_wor_docs_rec.doc_id;
         open get_open_wol_docs;
         fetch get_open_wol_docs into l_num;
         if get_open_wol_docs%notfound then
            close get_open_wol_docs;
            open get_doc_status;
            fetch get_doc_status into l_status;
            if get_doc_status%found then
               close get_doc_status;
               update docs
               set doc_status_code = l_status,
                   doc_reason = 'Works Order complete',
              doc_compl_complete = sysdate
               where doc_id = l_doc_id;
            else
               close get_doc_status;
            end if;
         else
            close get_open_wol_docs;
         end if;
     end LOOP;
  end if;

END;
/