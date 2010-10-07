create or replace package body xhants_pem_bespoke as
  --
  procedure clear_doc_globals is
  begin
    v_doc_id := null;
    v_doc_status_code := null;
    v_doc_source := null;
    v_hct_id     := null;
  end;
  --
  function get_mail_recipient( p_name in nm_mail_users.nmu_name%type
                              ,p_email in nm_mail_users.nmu_email_address%type) return number as
    p_mail_id       nm_mail_users.nmu_id%type;
    p_email_exists  varchar2(1) default 'N';
  begin
    begin
      insert into nm_mail_users (NMU_ID, NMU_NAME, NMU_EMAIL_ADDRESS)
      select nmu_id_seq.nextval,p_email,p_email
      from dual;
      EXCEPTION when others then p_email_exists := 'Y';
    end;
   -- if p_email_exists = 'Y' then
   --   update nm_mail_users set nmu_name = nvl(' '||p_name,p_email) 
   --   where  nmu_email_address = p_email
   --   and    nmu_hus_user_id is null;
   -- end if;
   -- begin
      select nmu_id into p_mail_id from nm_mail_users where nmu_email_address = p_email;
    --  insert into al_debug values ('nmu_id',p_mail_id); 
   --   exception when others then null;
    --end;
    return p_mail_id;
  end;
  --
  --
  procedure set_null_contact_email (p_doc_id     in docs.doc_id%type,
                                    p_resp_user  in docs.doc_compl_user_id%type) is
    l_email hig_contacts.hct_email%type;
    l_contact hig_contacts.hct_id%type;
  begin
    begin
      select hct_email into l_email
      from   hig_contacts
      where  hct_id = p_resp_user;
      --
      select hct_id into l_contact
      from   hig_contacts,
             doc_enquiry_contacts
      where  dec_doc_id = p_doc_id
      and    dec_contact = 'Y'
      and    dec_hct_id = hct_id;
      --
      update hig_contacts set hct_email = l_email where hct_id = l_contact and hct_email is null;
      exception when others then null;
    end;   
  end;
  --
  --
  procedure set_line_auth is
  begin
    for c1 in (select wor_works_order_no from xhants_wol_auth) loop
      update work_order_lines set wol_status_code = 'AUTHORISED' 
      where  wol_works_order_no = c1.wor_works_order_no;
      delete xhants_wol_auth where wor_works_order_no = c1.wor_works_order_no;
    end loop;
  end;
  --
  --
  procedure set_routine (p_defect in work_order_lines.wol_def_defect_id%type,
                         p_wo_no  in work_order_lines.wol_works_order_no%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  l_scheme_type   work_orders.wor_scheme_type%type;
  begin
    select wor_scheme_type into l_scheme_type from work_orders where wor_works_order_no = p_wo_no;
    --
    for c1 in (select das_doc_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect) loop    
      if l_scheme_type = 'RG' then
        update docs set (doc_status_code, doc_reason) = (select 'MG','Passed to Maintenance Gang' from dual) where doc_id = c1.das_doc_id;
      end if;
      if l_scheme_type not in ('RG','EW') then
        update docs set (doc_status_code, doc_reason) = (select 'PC','Work Passed to Contractor' from dual) where doc_id = c1.das_doc_id;
      end if;
      if l_scheme_type = ('EW') then
        update docs set (doc_status_code, doc_reason) = (select 'EM','With Contractor-Emergency Work' from dual) where doc_id = c1.das_doc_id;
      end if;
    end loop;
  end;
  --
  --
  procedure set_authorised (p_defect in work_order_lines.wol_def_defect_id%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  begin
    begin
      select 'Y', das_doc_id into l_exists_in_pem, l_pem_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect;
      exception when others then null;
    end;
    if l_exists_in_pem = 'Y' then
      update docs set doc_status_code = 'PC' where doc_id = l_pem_id;
    end if;
  end;
  --
  --
  procedure set_complete_3rd_party (p_defect in work_order_lines.wol_def_defect_id%type,
                                    p_wo_no  in work_order_lines.wol_works_order_no%type,
                                    p_descr  in work_order_lines.wol_descr%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  l_scheme_type   work_orders.wor_scheme_type%type;
  begin
    select wor_scheme_type into l_scheme_type from work_orders where wor_works_order_no = p_wo_no;
    --
    for c1 in (select das_doc_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect) loop
      if l_scheme_type = 'TP' then
        update docs set (doc_status_code, doc_reason) =  (select 'CTP', p_descr from dual) where doc_id = c1.das_doc_id;
      end if;
      --
      if l_scheme_type != 'TP' then
        update docs set (doc_status_code, doc_reason) =  (select 'WC', p_descr from dual) where doc_id = c1.das_doc_id;
      end if;
    end loop;
  end;
  --
  --
  procedure set_cancelled          (p_defect in work_order_lines.wol_def_defect_id%type,
                                    p_descr  in work_order_lines.wol_descr%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  l_scheme_type   work_orders.wor_scheme_type%type;
  begin
    begin
      select 'Y', das_doc_id into l_exists_in_pem, l_pem_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect;
      exception when others then null;
    end;
    if l_exists_in_pem = 'Y' then
      update docs set (doc_status_code, doc_reason) =  (select 'CA', p_descr from dual) where doc_id = l_pem_id;
    end if;
  end;
  --
  --
  procedure set_no_main_reqd (p_defect in defects.def_defect_id%type,
                              p_reason in defects.def_special_instr%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  begin
    for c1 in (select das_doc_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect) loop
      update docs set (doc_status_code, doc_reason) =  (select 'NM', 'No Maintenance Work Required: '||p_reason from dual) where doc_id = c1.das_doc_id;
    end loop;
  end;
  --
  --
  procedure set_via_defect   (p_defect in defects.def_defect_id%type,
                              p_reason in defects.def_special_instr%type,
                              p_status in defects.def_status_code%type) is
  l_exists_in_pem varchar2(1) default 'N';
  l_pem_id        docs.doc_id%type;
  begin
    for c1 in (select das_doc_id from doc_assocs where das_table_name = 'DEFECTS' and das_rec_id = p_defect) loop
      update docs set (doc_status_code, doc_reason,doc_compl_complete) =  (select case when p_status = 'ROUTINE' then 'MG'
                                                                                       when p_status = 'CONTRACTOR' then 'PC'
                                                                                       when p_status = '3RD PARTY' then 'CTP'
                                                                                       when p_status = 'MADE SAFE' then 'MS'
                                                                                       when p_status = 'PLANNED' then 'PW'
                                                                                       when p_status = 'EMERGENCY' then 'EM'
                                                                                       when p_status = 'COMPLETED' then 'CO'
                                                                                  end,
                                                                                  case when p_status = 'ROUTINE' then 'Passed to Maintenance Gang: '||p_reason
                                                                                       when p_status = 'CONTRACTOR' then 'Work Passed to Contractor: '||p_reason
                                                                                       when p_status = '3RD PARTY' then 'Work Complete for 3rd Party: '||p_reason
                                                                                       when p_status = 'MADE SAFE' then 'Made Safe, further work needed: '||p_reason
                                                                                       when p_status = 'PLANNED' then 'Covered by Planned Work: '||p_reason
                                                                                       when p_status = 'EMERGENCY' then 'With Contractor-Emergency Work: '||p_reason
                                                                                       when p_status = 'COMPLETED' then 'Enquiry Complete'
                                                                                  end,
                                                                                  case when p_status = 'COMPLETED' then sysdate
                                                                                       else null
                                                                                  end
                                                                           from dual) 
      where doc_id = c1.das_doc_id;
    end loop;
  end;
  --
  --
  procedure auto_ackwnowledge_status is
  begin
    if v_doc_source in ('E','EX','P','PX','T','TX','F','S','L','W') then
      update docs set (doc_status_code, doc_reason) = (select 'AK','Enquiry Acknowledged' from dual)
        where doc_id = v_doc_id;
    end if;
  end;
  --
  --
  procedure auto_ackwnowledge_status2 is
  begin
    select doc_id, doc_compl_source into v_doc_id, v_doc_source
    from   doc_enquiry_contacts,
           docs
    where  dec_hct_id = v_hct_id 
    and    dec_doc_id = doc_id
    and    dec_contact = 'Y';
    if v_doc_source in ('E','EX','P','PX','T','TX','F','S','L','W') then
      update docs set (doc_status_code, doc_reason) = (select 'AK','Enquiry Acknowledged' from dual)
        where doc_id = v_doc_id;
    end if;
  end;
  --
  --
  procedure auto_ackwnowledge_status3 is
  begin
    update docs set (doc_status_code, doc_reason) = (select 'AK','Enquiry Acknowledged' from dual)
    where doc_id in (select doc_id from xhants_pem_auto_ack);
    delete xhants_pem_auto_ack;
  end;
  --
  --
  procedure auto_acknowledge_status is
  l_email   hig_contacts.hct_email%type;
  l_source  docs.doc_compl_source%type;
  l_owner   docs.doc_compl_user_id%type;
  l_check   docs.doc_compl_user_type%type;
  l_doc_ref docs.doc_reference_code%type;
  l_descr   docs.doc_descr%type;
  l_loc     docs.doc_compl_location%type;
  l_area    hig_user_options.huo_value%type;
  l_contact hig_contacts.hct_id%type;
  begin
    for c1 in (select doc_id from xhants_pem_auto_ack) loop
      begin
        select doc_compl_source, hct_email, doc_compl_user_id, doc_compl_user_type, doc_reference_code, doc_descr, doc_compl_location  into l_source, l_email, l_owner, l_check, l_doc_ref, l_descr, l_loc
        from   docs,
               doc_enquiry_contacts,
               hig_contacts
        where  doc_id = c1.doc_id
        and    dec_doc_id = doc_id
        and    dec_contact = 'Y'
        and    dec_hct_id = hct_id
        for update nowait;
        --
        if l_source in ('EX','PX','TX','SX','WX') then
          update docs set (doc_status_code, doc_reason) = (select 'AK','Acknowledged / Not Required' from dual) where doc_id = c1.doc_id;
        end if;
        --
        if l_email is not null and l_source not in ('EX','PX','TX','SX','WX') then 
          update docs set (doc_status_code, doc_reason) = (select 'AK','Acknowledged / Not Required' from dual) where doc_id = c1.doc_id;
          xhants_pem_bespoke.mail_auto_ack(c1.doc_id,nvl(l_doc_ref,c1.doc_id),l_descr,l_loc);
        end if;
        --
        if l_email is null and l_check = 'USER' and l_source not in ('EX','PX','TX','SX','WX') then
          begin
            select huo_value into l_area from hig_user_options where huo_hus_user_id = l_owner and huo_id = 'REP_AREA';
            exception when others then l_area := 'Highways and Transport North';
          end;
          --
          if l_area not in ('Highways and Transport East','Highways and Transport South','Highways and Transport West','Highways and Transport North') then
            l_area := 'Highways and Transport North';
          end if;
          if l_area in ('Highways and Transport East','Highways and Transport South','Highways and Transport West','Highways and Transport North') then
          --
            select hct_id into l_contact
            from   hig_contacts,
                   doc_enquiry_contacts
            where  dec_doc_id = c1.doc_id
            and    dec_contact = 'Y'
            and    dec_hct_id = hct_id;
            --
            update hig_contacts 
            set hct_email = case l_area  when 'Highways and Transport East' then 'highways-transport.east@hants.gov.uk'
                                         when 'Highways and Transport South' then 'highways-transport.south@hants.gov.uk'
                                         when 'Highways and Transport West' then 'highways-transport.west@hants.gov.uk'
                                         when 'Highways and Transport North' then 'highways-transport.north@hants.gov.uk'
                            end
            where hct_id = l_contact and hct_email is null;
            --
            if l_source in ('W','P','T','E') then
              update docs set (doc_status_code, doc_reason) = (select 'AK','Acknowledged / Not Required' from dual) where doc_id = c1.doc_id;
            end if;
            --
            if l_source in ('L','F','LX','FX') then
              update docs set (doc_status_code, doc_reason) = (select 'AR','Acknowledgement Required' from dual) where doc_id = c1.doc_id;
              xhants_pem_bespoke.mail_auto_ack(c1.doc_id,nvl(l_doc_ref,c1.doc_id),l_descr,l_loc);
            end if;
          end if;
        end if;
        delete xhants_pem_auto_ack where doc_id = c1.doc_id;
        exception when others then null;
      end;
      --
      --delete xhants_pem_auto_ack where doc_id = c1.doc_id;
    end loop;
  end;
  --
  --
  procedure auto_close_pem is
  l_pem  docs.doc_id%type;
  begin
    for c1 in (select doc_id from xhants_pem_auto_close) loop
      begin
        select doc_id into l_pem from docs where doc_id = c1.doc_id for update nowait;
        update docs set (doc_status_code, doc_reason,doc_compl_complete) = (select 'CO','Enquiry Complete',sysdate from dual)
        where doc_id =c1.doc_id;
        delete xhants_pem_auto_close where doc_id = c1.doc_id;
        exception when others then null;
      end;
    end loop;
  end;
  --
  --
  procedure auto_ready_lines is
  begin
    update work_order_lines set wol_status_code = 'READY' 
    where  wol_works_order_no in (select wol_works_order_no from xhants_wo_line_ready_updates)
    and    wol_status_code != 'READY';
    --
    delete xhants_wo_line_ready_updates;
  end;
  --
  --
  procedure mail_auto_ack (p_pem_id in docs.doc_id%type,
                           p_ref    in docs.doc_reference_code%type,
                           p_description in docs.doc_descr%type,
                           p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    if l_email is not null then
      l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p><b>Enquiry Reference:</b>'||' '||p_ref||'</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>Thank you for your enquiry.</p>'||utl_tcp.crlf;
      --l_tab_varchar(4):='<p><b>Location: </b>'||p_location||'</p>'||utl_tcp.crlf;
      --l_tab_varchar(5):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf;
      l_tab_varchar(4):='<br />'||utl_tcp.crlf;
      l_tab_varchar(5):='<p>We will assess your enquiry as soon as possible. We receive around 70,000 enquiries each year which we prioritise according to the nature of the enquiry.</p>'||utl_tcp.crlf;
      l_tab_varchar(6):='<p>In most cases our staff will need to visit the site to make an assessment, which should be completed within the next 5 working days. This could take a little longer in some circumstances, such as during severe weather conditions or flooding.</p>'||utl_tcp.crlf; 
      l_tab_varchar(7):='<p>We will endeavour to update you following an assessment and/or site visit to identify what works, if any, have been instructed.</p>'||utl_tcp.crlf; 
      l_tab_varchar(8):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf; 
      l_tab_varchar(9):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf; 
      l_tab_varchar(10):='<p>Regards,</p>'||utl_tcp.crlf;
      l_tab_varchar(11):='Hampshire County Highways<br />'||utl_tcp.crlf;
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'Enquiry Acknowledgement - Reference '||p_ref
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
    end if;
  end;
  --
  --
  procedure mail_3rd_party (p_pem_id in docs.doc_id%type,
                            p_ref    in docs.doc_reference_code%type,
                            p_description in docs.doc_descr%type,
                            p_location in docs.doc_compl_location%type,
                            p_new_resp in docs.doc_compl_user_id%type,
                            p_new_resp_type in docs.doc_compl_user_type%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number; 
  l_organisation hig_contacts.hct_surname%type;
  l_address1 varchar2(209);
  l_dep_tfare hig_address.had_dependent_thoroughfare%type;
  l_locality hig_address.HAD_DEPENDENT_LOCALITY_NAME%type;
  l_post_town hig_address.HAD_POST_TOWN%type;
  l_county hig_address.HAD_COUNTY%type;
  l_postcode hig_address.HAD_POSTCODE%type;
  l_3rd_party_email hig_contacts.hct_email%type;
  l_business_phone hig_contacts.hct_work_phone%type;
  l_notes_web hig_contacts.hct_notes%type; -- HCC Will use notes field
  begin
    if p_new_resp_type = 'CONT' then
      select hct_surname,
             had_building_no||' '||had_building_name||' '||had_sub_building_name_no||' '||had_thoroughfare,
             had_dependent_thoroughfare,
             had_dependent_locality_name,
             had_post_town,
             had_county,
             had_postcode,
             hct_work_phone,
             hct_email,
             hct_notes
      into   l_organisation,
             l_address1,
             l_dep_tfare,
             l_locality,
             l_post_town,
             l_county,
             l_postcode,
             l_business_phone,
             l_3rd_party_email,
             l_notes_web
      from   hig_contacts,
             hig_contact_address,
             hig_address
      where  hct_id = p_new_resp
      and    hct_id = hca_hct_id
      and    hca_had_id = had_id;
    end if;  
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p><b>Enquiry Reference:</b>'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>Thank you for your enquiry.</p>'||utl_tcp.crlf;
    --l_tab_varchar(4):='<p><b>Location: </b>'||p_location||'</p>'||utl_tcp.crlf;
    --l_tab_varchar(5):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf;
    l_tab_varchar(4):='<br />'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>The organisation responsible for this enquiry is:</p>'||utl_tcp.crlf; 
    l_tab_varchar(6):='<p>'||l_organisation||'</p>'||utl_tcp.crlf;
    l_tab_varchar(7):=l_address1||'<br />'||case when l_dep_tfare is not null then l_dep_tfare||'<br />' end||
                         case when l_locality is not null then l_locality||'<br />' end||
                         case when l_post_town is not null then l_post_town||'<br />' end||
                         case when l_county is not null then l_county||'<br />' end||
                         case when l_postcode is not null then l_postcode||'<br />' end||'<br />'||utl_tcp.crlf;
    l_tab_varchar(8):='<p>'||l_business_phone||'</p>'||utl_tcp.crlf;
    l_tab_varchar(9):='<p>'||l_3rd_party_email||'</p>'||utl_tcp.crlf;
    l_tab_varchar(10):='<p>'||l_notes_web||'</p>'||utl_tcp.crlf;
    l_tab_varchar(11):='<p>Details of your enquiry have been forwarded to them for action. You may wish to contact them directly, as your personal contact details have not been sent.</p>'||utl_tcp.crlf;
    l_tab_varchar(12):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf; 
    l_tab_varchar(13):='<p>Information about services offered by Hampshire County Council can be found on our website.</p>'||utl_tcp.crlf; 
    l_tab_varchar(14):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(15):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_unknown_3rd_party (p_pem_id in docs.doc_id%type,
                                    p_ref    in docs.doc_reference_code%type,
                                    p_description in docs.doc_descr%type,
                                    p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p><b>Enquiry Reference:</b>'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>Thank you for your enquiry.</p>'||utl_tcp.crlf;
    --l_tab_varchar(4):='<p><b>Location: </b>'||p_location||'</p>'||utl_tcp.crlf;
    --l_tab_varchar(5):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf;
    l_tab_varchar(4):='<br />'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>Following investigation it has become apparent that Hampshire County Council is not responsible for enquiries of this nature and unfortunately,  in this case we have been unable to establish who the responsible party is.</p>'||utl_tcp.crlf; 
    l_tab_varchar(6):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='<p>Information about services offered by Hampshire County Council services can be found on our website.</p>'||utl_tcp.crlf;      
    l_tab_varchar(8):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(9):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_olg_3rd_party (p_pem_id in docs.doc_id%type,
                                    p_ref    in docs.doc_reference_code%type,
                                    p_description in docs.doc_descr%type,
                                    p_location in docs.doc_compl_location%type,
                                p_new_resp in docs.doc_compl_user_id%type,
                                p_new_resp_type in docs.doc_compl_user_type%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number; 
  l_organisation hig_contacts.hct_surname%type;
  l_address1 varchar2(209);
  l_dep_tfare hig_address.had_dependent_thoroughfare%type;
  l_locality hig_address.HAD_DEPENDENT_LOCALITY_NAME%type;
  l_post_town hig_address.HAD_POST_TOWN%type;
  l_county hig_address.HAD_COUNTY%type;
  l_postcode hig_address.HAD_POSTCODE%type;
  l_3rd_party_email hig_contacts.hct_email%type;
  l_business_phone hig_contacts.hct_work_phone%type;
  l_notes_web hig_contacts.hct_notes%type; -- HCC Will use notes field
  begin
    if p_new_resp_type = 'CONT' then
      select hct_surname,
             had_building_no||' '||had_building_name||' '||had_sub_building_name_no||' '||had_thoroughfare,
             had_dependent_thoroughfare,
             had_dependent_locality_name,
             had_post_town,
             had_county,
             had_postcode,
             hct_work_phone,
             hct_email,
             hct_notes
      into   l_organisation,
             l_address1,
             l_dep_tfare,
             l_locality,
             l_post_town,
             l_county,
             l_postcode,
             l_business_phone,
             l_3rd_party_email,
             l_notes_web
      from   hig_contacts,
             hig_contact_address,
             hig_address
      where  hct_id = p_new_resp
      and    hct_id = hca_hct_id
      and    hca_had_id = had_id;
    end if;
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p><b>Enquiry Reference:</b>'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>Thank you for your enquiry. </p>'||utl_tcp.crlf;
    --l_tab_varchar(4):='<p><b>Location: </b>'||p_location||'</p>'||utl_tcp.crlf;
    --l_tab_varchar(5):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf;
    l_tab_varchar(4):='<br />'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>Details of your enquiry have been forwarded to the following team for action:</p>'||utl_tcp.crlf; 
    l_tab_varchar(6):='<p>'||l_organisation||'</p>'||utl_tcp.crlf;
    l_tab_varchar(7):=l_address1||'<br />'||case when l_dep_tfare is not null then l_dep_tfare||'<br />' end||
                         case when l_locality is not null then l_locality||'<br />' end||
                         case when l_post_town is not null then l_post_town||'<br />' end||
                         case when l_county is not null then l_county||'<br />' end||
                         case when l_postcode is not null then l_postcode||'<br />' end||'<br />'||utl_tcp.crlf;
    l_tab_varchar(8):='<p>'||l_business_phone||'</p>'||utl_tcp.crlf;
    l_tab_varchar(9):='<p>'||l_3rd_party_email||'</p>'||utl_tcp.crlf;
    l_tab_varchar(10):='<p>'||l_notes_web||'</p>'||utl_tcp.crlf;
    l_tab_varchar(11):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(12):='<p>Information about services offered by Hampshire County Council services can be found on our website.</p>'||utl_tcp.crlf; 
    l_tab_varchar(13):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(14):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_maint_gang (p_pem_id in docs.doc_id%type,
                             p_ref    in docs.doc_reference_code%type,
                             p_description in docs.doc_descr%type,
                             p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    --insert into al_debug values ('name and email',l_name||l_email);
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The enquiry you raised has been inspected and does require action.</p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>Defects of this nature are added to our contractors work programme and are normally processed within 2 months. Please note, this could take longer depending on the severity of the issue, and availability of resource which could be affected by severe weather events.</p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(8):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
    exception when others then null;
  end;
  --
  --
  procedure mail_made_safe  (p_pem_id in docs.doc_id%type,
                             p_ref    in docs.doc_reference_code%type,
                             p_description in docs.doc_descr%type,
                             p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The enquiry you raised has been made safe but may require further, more permanent work in due course. </p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_planned_work  (p_pem_id in docs.doc_id%type,
                                p_ref    in docs.doc_reference_code%type,
                                p_description in docs.doc_descr%type,
                                p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The enquiry you raised is already due for repair as part of planned works later in the year. </p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_passed_contractor  (p_pem_id in docs.doc_id%type,
                                     p_ref    in docs.doc_reference_code%type,
                                     p_description in docs.doc_descr%type,
                                     p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The enquiry you raised has been inspected and does require action.</p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>Defects of this nature are added to our contractors work programme and are normally processed within 2 months. Please note, this could take longer depending on the severity of the issue, and availability of resource which could be affected by severe weather events.</p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(8):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_new_resp(p_pem_id in docs.doc_id%type,
                          p_ref    in docs.doc_reference_code%type,
                          p_description in docs.doc_descr%type,
                          p_location in docs.doc_compl_location%type,
                          p_category in docs.doc_dtp_code%type,
                          p_class in docs.doc_dcl_code%type,
                          p_type in docs.doc_compl_type%type,
                          p_remarks in docs.doc_reason%type, 
                          p_new_resp in docs.doc_compl_user_id%type,
                          p_new_resp_type in docs.doc_compl_user_type%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;  
  l_category_descr doc_types.dtp_name%type;
  l_class_descr doc_class.dcl_name%type;
  l_type_descr doc_enquiry_types.det_name%type;
  l_road_associated doc_assocs.das_rec_id%type;
  l_road_unique road_segments_all.rse_unique%type;
  l_road_descr road_segments_all.rse_descr%type default 'No Road Selected';
  l_home_phone hig_contacts.hct_home_phone%type default 'Not Given';
  l_work_phone hig_contacts.hct_work_phone%type default 'Not Given';
  l_mobile_phone hig_contacts.hct_mobile_phone%type default 'Not Given';
  l_address varchar2(200) default 'Not Given';
  l_counter number default 27;
  begin
    if p_new_resp_type = 'USER' then
      select nmu_id into l_rcp_id from nm_mail_users where nmu_hus_user_id = p_new_resp;
      select dtp_name into l_category_descr from doc_types where dtp_code = p_category;
      select dcl_name into l_class_descr from doc_class where dcl_code = p_class and dcl_dtp_code = p_category;
      select det_name into l_type_descr from doc_enquiry_types where det_dtp_code = p_category and det_dcl_code = p_class and det_code = p_type;
      --
      begin
        select das_rec_id into l_road_associated from doc_assocs where das_doc_id = p_pem_id and das_table_name = 'ROAD_SEGMENTS_ALL';
        exception when others then null;
      end;
      --
      if l_road_associated is not null then
        select rse_unique, rse_descr into l_road_unique, l_road_descr 
        from   road_segments_all 
        where  rse_he_id = l_road_associated;
      end if;
      --
      select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), 
             hct_email,
             hct_home_phone,
             hct_work_phone,
             hct_mobile_phone
      into   l_name, 
             l_email,
             l_home_phone,
             l_work_phone,
             l_mobile_phone
      from   hig_contacts, 
             doc_enquiry_contacts
      where  p_pem_id = dec_doc_id
      and    dec_hct_id = hct_id
      and    dec_contact = 'Y';
      --
      begin
        select substr(
                 had_building_no||', '||
                 had_building_name||', '|| 
                 had_sub_building_name_no||', '||
                 had_thoroughfare||', '|| 
                 had_dependent_locality_name||', '|| 
                 had_post_town||','|| 
                 had_county,
               1,200)
        into   l_address
        from   hig_address,
               hig_contact_address,
               hig_contacts, 
               doc_enquiry_contacts
        where  p_pem_id = dec_doc_id
        and    dec_hct_id = hct_id
        and    dec_contact = 'Y'
        and    hct_id = hca_hct_id
        and    hca_had_id = had_id;
        exception when others then null;
      end;
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p>This Email was generated by the Exor system.</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>You have been assigned  PEM No: '||p_pem_id||' associated to Lagan No '||p_ref||'</p>'||utl_tcp.crlf;
      l_tab_varchar(4):='<b><u>Enquiry Cat/Class/Type</b></u><br />'||utl_tcp.crlf;
      l_tab_varchar(5):='<b>Category: </b>'||l_category_descr||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(6):='<b>Class: </b>'||l_class_descr||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(7):='<b>Type: </b>'||l_type_descr||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(8):='<br />'||utl_tcp.crlf; 
      l_tab_varchar(9):='<b><u>Enquiry Location</b></u><br />'||utl_tcp.crlf;
      l_tab_varchar(10):='<b>Location: </b>'||p_location||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(11):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(12):='<b>Action / Remarks: </b>'||p_remarks||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(13):='<b>Road ID: </b>'||l_road_unique||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(14):='<b>Road Name: </b>'||l_road_descr||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(15):='<br />'||utl_tcp.crlf; 
      l_tab_varchar(16):='<b><u>Enquirer Details</b></u><br />'||utl_tcp.crlf;
      l_tab_varchar(17):='<b>Name: </b>'||l_name||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(18):='<b>Address: </b>'||l_address||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(19):='<br />'||utl_tcp.crlf;
      l_tab_varchar(20):='<b><u>Contact</b></u><br />'||utl_tcp.crlf;
      l_tab_varchar(21):='<b>Email: </b>'||l_email||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(22):='<b>Home: </b>'||l_home_phone||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(23):='<b>Work: </b>'||l_work_phone||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(24):='<b>Mobile: </b>'||l_mobile_phone||'<br />'||utl_tcp.crlf;
      l_tab_varchar(25):='<br />'||utl_tcp.crlf;
      l_tab_varchar(26):='<table border="1"><tr><th>Date</th><th>Action / Remarks</th><th>New Status</th><th>Initials</th></tr>'||utl_tcp.crlf;
      --
      for c1 in (select dhi_date_changed, dhi_reason, dhi_status_code, dhi_changed_by
                 from   doc_history
                 where  dhi_doc_id = p_pem_id
                 order by dhi_date_changed)
      loop
        l_tab_varchar(l_counter):='<tr><td>'||c1.dhi_date_changed||'</td><td>'||c1.dhi_reason||'</td><td>'||c1.dhi_status_code||'</td><td>'||c1.dhi_changed_by||'</td></tr>'||utl_tcp.crlf;
        l_counter := l_counter + 1;
      end loop;
      --
      l_tab_varchar(l_counter):='<tr><td><br /><br /><br /></td><td><br /><br /><br /></td><td><br /><br /><br /></td><td><br /><br /><br /></td></tr>'||utl_tcp.crlf;
      --
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'PEM Enquiry - Reference '||p_pem_id
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
    end if;
  end;
  --
  --
  procedure mail_new_ext_resp(p_pem_id in docs.doc_id%type,
                              p_ref    in docs.doc_reference_code%type,
                              p_description in docs.doc_descr%type,
                              p_location in docs.doc_compl_location%type,
                              p_category in docs.doc_dtp_code%type,
                              p_class in docs.doc_dcl_code%type,
                              p_type in docs.doc_compl_type%type,
                              p_remarks in docs.doc_reason%type, 
                              p_new_resp in docs.doc_compl_user_id%type,
                              p_new_resp_type in docs.doc_compl_user_type%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;  
  l_category_descr doc_types.dtp_name%type;
  l_class_descr doc_class.dcl_name%type;
  l_type_descr doc_enquiry_types.det_name%type;
  l_road_associated doc_assocs.das_rec_id%type;
  l_road_unique road_segments_all.rse_unique%type;
  l_road_descr road_segments_all.rse_descr%type default 'No Road Selected';
  l_home_phone hig_contacts.hct_home_phone%type default 'Not Given';
  l_work_phone hig_contacts.hct_work_phone%type default 'Not Given';
  l_mobile_phone hig_contacts.hct_mobile_phone%type default 'Not Given';
  l_address varchar2(200) default 'Not Given';
  l_counter number default 27;
  begin
    if p_new_resp_type = 'CONT' then
      select hct_email into l_email from hig_contacts where hct_id = p_new_resp;
    end if;  
    if l_email is not null then
      l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_email,l_email);
    end if;
    select dtp_name into l_category_descr from doc_types where dtp_code = p_category;
    select dcl_name into l_class_descr from doc_class where dcl_code = p_class and dcl_dtp_code = p_category;
    select det_name into l_type_descr from doc_enquiry_types where det_dtp_code = p_category and det_dcl_code = p_class and det_code = p_type;
    --
    begin
      select das_rec_id into l_road_associated from doc_assocs where das_doc_id = p_pem_id and das_table_name = 'ROAD_SEGMENTS_ALL';
      exception when others then null;
    end;
    --
    if l_road_associated is not null then
      select rse_unique, rse_descr into l_road_unique, l_road_descr 
      from   road_segments_all 
      where  rse_he_id = l_road_associated;
    end if;
    --
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), 
           hct_email,
           hct_home_phone,
           hct_work_phone,
           hct_mobile_phone
    into   l_name, 
           l_email,
           l_home_phone,
           l_work_phone,
           l_mobile_phone
    from   hig_contacts, 
           doc_enquiry_contacts
    where  p_pem_id = dec_doc_id
    and    dec_hct_id = hct_id
    and    dec_contact = 'Y';
    --
    begin
      select substr(
               had_building_no||', '||
               had_building_name||', '|| 
               had_sub_building_name_no||', '||
               had_thoroughfare||', '|| 
               had_dependent_locality_name||', '|| 
               had_post_town||','|| 
               had_county,
             1,200)
      into   l_address
      from   hig_address,
             hig_contact_address,
             hig_contacts, 
             doc_enquiry_contacts
      where  p_pem_id = dec_doc_id
      and    dec_hct_id = hct_id
      and    dec_contact = 'Y'
      and    hct_id = hca_hct_id
      and    hca_had_id = had_id;
      exception when others then null;
    end;
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Dear Sirs</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p><b>Enquiry Reference:</b>'||' '||p_pem_id||'</p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>The following enquiry was received by Hampshire County Highways which has been forwarded to you as we believe the enquiry falls under your responsibility.  Any supporting documentation will be sent to you separately, if appropriate. </p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<b><u>Enquiry Cat/Class/Type</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(6):='<b>Category: </b>'||l_category_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(7):='<b>Class: </b>'||l_class_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(8):='<b>Type: </b>'||l_type_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(9):='<br />'||utl_tcp.crlf; 
    l_tab_varchar(10):='<b><u>Enquiry Location</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(11):='<b>Location: </b>'||p_location||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(12):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(13):='<b>Action / Remarks: </b>'||p_remarks||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(14):='<b>Road ID: </b>'||l_road_unique||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(15):='<b>Road Name: </b>'||l_road_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(16):='<br />'||utl_tcp.crlf; 
    l_tab_varchar(17):='<b><u>Enquirer Details</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(18):='<b>Name: </b>'||l_name||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(19):='<b>Address: </b>'||l_address||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(20):='<br />'||utl_tcp.crlf;
    l_tab_varchar(21):='<b><u>Contact</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(22):='<b>Email: </b>'||l_email||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(23):='<b>Home: </b>'||l_home_phone||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(24):='<b>Work: </b>'||l_work_phone||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(25):='<b>Mobile: </b>'||l_mobile_phone||'<br />'||utl_tcp.crlf;
    l_tab_varchar(26):='<br />'||utl_tcp.crlf;
    l_tab_varchar(27):='<p>Please investigate and respond directly to the enquirer</p>'||utl_tcp.crlf;
    l_tab_varchar(28):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(29):='<p>If you need to contact us, please visit our website or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(30):='<p>Yours sincerely,</p>'||utl_tcp.crlf;
    l_tab_varchar(31):='Hampshire County Highways'||utl_tcp.crlf;
    --
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Highways Enquiry - Reference '||p_pem_id
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_inform_3rd  (p_pem_id in docs.doc_id%type,
                              p_ref    in docs.doc_reference_code%type,
                              p_description in docs.doc_descr%type,
                              p_location in docs.doc_compl_location%type,
                              p_category in docs.doc_dtp_code%type,
                              p_class in docs.doc_dcl_code%type,
                              p_type in docs.doc_compl_type%type,
                              p_remarks in docs.doc_reason%type, 
                              p_new_resp in docs.doc_compl_user_id%type,
                              p_new_resp_type in docs.doc_compl_user_type%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;  
  l_category_descr doc_types.dtp_name%type;
  l_class_descr doc_class.dcl_name%type;
  l_type_descr doc_enquiry_types.det_name%type;
  l_road_associated doc_assocs.das_rec_id%type;
  l_road_unique road_segments_all.rse_unique%type;
  l_road_descr road_segments_all.rse_descr%type default 'No Road Selected';
  l_home_phone hig_contacts.hct_home_phone%type default 'Not Given';
  l_work_phone hig_contacts.hct_work_phone%type default 'Not Given';
  l_mobile_phone hig_contacts.hct_mobile_phone%type default 'Not Given';
  l_address varchar2(200) default 'Not Given';
  l_counter number default 27;
  begin
    if p_new_resp_type = 'CONT' then
      select hct_email into l_email from hig_contacts where hct_id = p_new_resp;
    end if;  
    if l_email is not null then
      l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_email,l_email);
    end if;
    select dtp_name into l_category_descr from doc_types where dtp_code = p_category;
    select dcl_name into l_class_descr from doc_class where dcl_code = p_class and dcl_dtp_code = p_category;
    select det_name into l_type_descr from doc_enquiry_types where det_dtp_code = p_category and det_dcl_code = p_class and det_code = p_type;
    --
    begin
      select das_rec_id into l_road_associated from doc_assocs where das_doc_id = p_pem_id and das_table_name = 'ROAD_SEGMENTS_ALL';
      exception when others then null;
    end;
    --
    if l_road_associated is not null then
      select rse_unique, rse_descr into l_road_unique, l_road_descr 
      from   road_segments_all 
      where  rse_he_id = l_road_associated;
    end if;
    --
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), 
           hct_email,
           hct_home_phone,
           hct_work_phone,
           hct_mobile_phone
    into   l_name, 
           l_email,
           l_home_phone,
           l_work_phone,
           l_mobile_phone
    from   hig_contacts, 
           doc_enquiry_contacts
    where  p_pem_id = dec_doc_id
    and    dec_hct_id = hct_id
    and    dec_contact = 'Y';
    --
    begin
      select substr(
               had_building_no||', '||
               had_building_name||', '|| 
               had_sub_building_name_no||', '||
               had_thoroughfare||', '|| 
               had_dependent_locality_name||', '|| 
               had_post_town||','|| 
               had_county,
             1,200)
      into   l_address
      from   hig_address,
             hig_contact_address,
             hig_contacts, 
             doc_enquiry_contacts
      where  p_pem_id = dec_doc_id
      and    dec_hct_id = hct_id
      and    dec_contact = 'Y'
      and    hct_id = hca_hct_id
      and    hca_had_id = had_id;
      exception when others then null;
    end;
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Dear Sirs</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p><b>Enquiry Reference:</b>'||' '||p_pem_id||'</p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>The following enquiry was received by Hampshire County Highways which has been forwarded to you as we believe the enquiry falls under your responsibility.  Any supporting documentation will be sent to you separately, if appropriate. </p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<b><u>Enquiry Cat/Class/Type</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(6):='<b>Category: </b>'||l_category_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(7):='<b>Class: </b>'||l_class_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(8):='<b>Type: </b>'||l_type_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(9):='<br />'||utl_tcp.crlf; 
    l_tab_varchar(10):='<b><u>Enquiry Location</b></u><br />'||utl_tcp.crlf;
    l_tab_varchar(11):='<b>Location: </b>'||p_location||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(12):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(13):='<b>Action / Remarks: </b>'||p_remarks||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(14):='<b>Road ID: </b>'||l_road_unique||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(15):='<b>Road ID: </b>'||l_road_descr||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(16):='<br />'||utl_tcp.crlf; 
    l_tab_varchar(17):='<p>Please investigate and take appropriate action.</p>'||utl_tcp.crlf;
    l_tab_varchar(18):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(19):='<p>If you need to contact us, please visit our website or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(20):='<p>Yours sincerely</p>'||utl_tcp.crlf;
    l_tab_varchar(21):='Hampshire County Highways'||utl_tcp.crlf;
    --
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Highways Enquiry - Reference '||p_pem_id
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_no_work_reqd  (p_pem_id in docs.doc_id%type,
                                p_ref    in docs.doc_reference_code%type,
                                p_description in docs.doc_descr%type,
                                p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The enquiry you raised has been inspected and does not present a hazard to highway users and does not require action at this time. </p>'||utl_tcp.crlf;
    l_tab_varchar(4):='<p>Adopted roads in Hampshire are routinely inspected at regular intervals.  The issue will be monitored and any future maintenance requirements will be identified as part of this process. </p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>Further information on our routine inspection policy can be found by clicking on the link below:</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p><a href="http://www3.hants.gov.uk/roads/highways-policy/highway-inspections-2.htm">Highway Inspection Policy</a></p>'||utl_tcp.crlf; 
    l_tab_varchar(7):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(8):='<p>If you need to contact us, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(9):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(10):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_no_def_found  (p_pem_id in docs.doc_id%type,
                                p_ref    in docs.doc_reference_code%type,
                                p_description in docs.doc_descr%type,
                                p_location in docs.doc_compl_location%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select substr(initcap(hct_title)||' '||initcap(hct_first_name)||' '||initcap(hct_surname),1,100), hct_email into l_name, l_email
    from hig_contacts, 
         doc_enquiry_contacts
    where p_pem_id = dec_doc_id
    and   dec_hct_id = hct_id
    and   dec_contact = 'Y';
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_name,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Further to your enquiry reference'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>Unfortunately, we have been unable to identify the issue you reported.</p>'||utl_tcp.crlf;
    --l_tab_varchar(4):='<b>Location: </b>'||p_location||'<br />'||utl_tcp.crlf; 
    --l_tab_varchar(5):='<b>Description: </b>'||p_description||'<br />'||utl_tcp.crlf; 
    l_tab_varchar(4):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(5):='<p>To provide further information that may help us to identify the defect, please visit our <a href="http://www3.hants.gov.uk/roads">website</a> or call Hantsdirect on 0845 6035633 and quote the above reference number in any correspondence relating to this enquiry.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='Hampshire County Highways<br />'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Enquiry Update - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
  end;
  --
  --
  procedure mail_rejected_wo   (p_wol_id in work_order_lines.wol_id%type,
                                p_road  in work_order_lines.wol_rse_he_id%type,
                                p_wo_ref in work_order_lines.wol_works_order_no%type,
                                p_defect in work_order_lines.wol_def_defect_id%type) is
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_rcp_id number;
  l_road   nm_elements.ne_unique%type;
  l_road_name nm_elements.ne_descr%type;
  l_location docs.doc_compl_location%type;
  l_description docs.doc_descr%type;
  begin
    begin
      select nmu_id into l_rcp_id 
      from   nm_mail_users, 
             work_orders
      where  wor_works_order_no = p_wo_ref
      and    nmu_hus_user_id = wor_peo_person_id;
      --
      exception when others then null;
    end;
    --
    if l_rcp_id is not null then
      begin
        select ne_unique, ne_descr into l_road, l_road_name from nm_elements_all where ne_id = p_road;
        --
        exception when others then null;
      end;
      --
      begin
        select doc_compl_location, doc_descr 
        into   l_location, l_description 
        from   docs, doc_assocs 
        where  das_table_name = 'DEFECTS' and das_rec_id = p_defect and das_doc_id = doc_id;
        --
        exception when others then null;
      end;
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p>Works Order - Line rejected</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>The following line item has been rejected from the order. Please review and action as appropriate.</p>'||utl_tcp.crlf;
      l_tab_varchar(4):='<b>Works Order Number :</b>'||p_wo_ref||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(5):='<br />'||utl_tcp.crlf; 
      l_tab_varchar(6):='<b>Line Number: </b>'||p_wol_id||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(7):=l_road||'/'||l_road_name||'<br />'||utl_tcp.crlf;
      l_tab_varchar(8):=l_location||'/'||l_description||'<br />'||utl_tcp.crlf;
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'WO Line Rejected'
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
    end if;
  end; 
  --
  --
  procedure mail_ready_auth    (p_wol_id in work_order_lines.wol_id%type,
                                p_road  in work_order_lines.wol_rse_he_id%type,
                                p_wo_ref in work_order_lines.wol_works_order_no%type,
                                p_defect in work_order_lines.wol_def_defect_id%type) is
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_rcp_id number;
  l_road   nm_elements.ne_unique%type;
  l_road_name nm_elements.ne_descr%type;
  l_location docs.doc_compl_location%type;
  l_description docs.doc_descr%type;
  l_scheme_type work_orders.wor_scheme_type%type;
  begin
    begin
      select nmu_id, wor_scheme_type into l_rcp_id, l_scheme_type 
      from   nm_mail_users, 
             work_orders
      where  wor_works_order_no = p_wo_ref
      and    nmu_hus_user_id = wor_peo_person_id;
      --
      exception when others then null;
    end;
    --
    if l_rcp_id is not null and l_scheme_type != 'RG' then
      begin
        select ne_unique, ne_descr into l_road, l_road_name from nm_elements_all where ne_id = p_road;
        --
        exception when others then null;
      end;
      --
      begin
        select doc_compl_location, doc_descr 
        into   l_location, l_description 
        from   docs, doc_assocs 
        where  das_table_name = 'DEFECTS' and das_rec_id = p_defect and das_doc_id = doc_id;
        --
        exception when others then null;
      end;
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p>Works Order - Authorisation Required</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>The following works order has been raised and now requires authorisation</p>'||utl_tcp.crlf;
      l_tab_varchar(4):='<b>Works Order Number :</b>'||p_wo_ref||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(5):='<br />'||utl_tcp.crlf; 
      l_tab_varchar(6):='<b>Line Number: </b>'||p_wol_id||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(7):=l_road||'/'||l_road_name||'<br />'||utl_tcp.crlf;
      l_tab_varchar(8):=l_location||'/'||l_description||'<br />'||utl_tcp.crlf;
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'WO Line Ready for Auth'
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
    end if;
    --
    if l_scheme_type = 'RG' then
      insert into xhants_wo_line_ready_updates values (p_wo_ref);
    end if;
  end; 
  --
  --
  procedure mail_queried_wo    (p_wol_id in work_order_lines.wol_id%type,
                                p_road  in work_order_lines.wol_rse_he_id%type,
                                p_wo_ref in work_order_lines.wol_works_order_no%type,
                                p_defect in work_order_lines.wol_def_defect_id%type,
                                p_descr in work_order_lines.wol_descr%type,
                                p_locn_descr in work_order_lines.wol_locn_descr%type) is
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_rcp_id number;
  l_rcp_id_2 number;
  l_road   nm_elements.ne_unique%type;
  l_road_name nm_elements.ne_descr%type;
  l_location docs.doc_compl_location%type;
  l_description docs.doc_descr%type;
  begin
    -- Get Creator
    begin
      select nmu_id into l_rcp_id 
      from   nm_mail_users, 
             work_orders
      where  wor_works_order_no = p_wo_ref
      and    nmu_hus_user_id = wor_peo_person_id;
      --
      exception when others then null;
    end;
    -- Get Authorisor
    begin
      select nmu_id into l_rcp_id_2 
      from   nm_mail_users, 
             work_orders
      where  wor_works_order_no = p_wo_ref
      and    nmu_hus_user_id = wor_mod_by_id;
      --
      exception when others then null;
    end;
    --
    if l_rcp_id is not null then
      begin
        select ne_unique, ne_descr into l_road, l_road_name from nm_elements_all where ne_id = p_road;
        --
        exception when others then null;
      end;
      --
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p>Works Order - Line item queried</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>The following line item has been queried on the order. Please review and action as appropriate.</p>'||utl_tcp.crlf;
      l_tab_varchar(4):='<b>Works Order Number :</b>'||p_wo_ref||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(5):='<br />'||utl_tcp.crlf; 
      l_tab_varchar(6):='<b>Line Number: </b>'||p_wol_id||'<br />'||utl_tcp.crlf; 
      l_tab_varchar(7):=l_road||'/'||l_road_name||'<br />'||utl_tcp.crlf;
      l_tab_varchar(8):=p_locn_descr||'/'||p_descr||'<br />'||utl_tcp.crlf;
      l_tab_varchar(9):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
      l_tab_varchar(10):='<p>Regards,</p>'||utl_tcp.crlf;
      l_tab_varchar(11):='Hampshire County Highways<br />'||utl_tcp.crlf;
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'Works Order Query - '||p_wo_ref
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
      -- If Auth and Creator are same get errors so split out for now
      p_tab_to(1).rcpt_id:=l_rcp_id_2;
      if l_rcp_id_2 != l_rcp_id then
        nm3mail.write_mail_complete (p_from_user        => 38898
                                    ,p_subject          => 'Works Order Query - '||p_wo_ref
                                    ,p_html_mail        => TRUE
                                    ,p_tab_to           => p_tab_to
                                    ,p_tab_cc           => p_tab_cc
                                    ,p_tab_bcc          => p_tab_cc
                                    ,p_tab_message_text => l_tab_varchar
                                    );
      end if;
    end if;
  end; 
  --
  --
  procedure mail_poss_recharge (p_pem_id in docs.doc_id%type,
                                p_ref    in docs.doc_reference_code%type,
                                p_user_id in docs.doc_compl_user_id%type) as
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;    
  begin
    select case huo_value when 'Highways and Transport East' then 'highways-transport.east@hants.gov.uk'
                                         when 'Highways and Transport South' then 'highways-transport.south@hants.gov.uk'
                                         when 'Highways and Transport West' then 'highways-transport.west@hants.gov.uk'
                                         when 'Highways and Transport North' then 'highways-transport.north@hants.gov.uk'
                            end into l_email
    from hig_user_options
    where p_user_id = huo_hus_user_id
    and   huo_id = 'REP_AREA'
    and   huo_value in ('Highways and Transport East','Highways and Transport South','Highways and Transport West','Highways and Transport North');
    --
    l_rcp_id := xhants_pem_bespoke.get_mail_recipient(l_email,l_email);
    -- Constuct Email
    l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
    l_tab_varchar(2):='<p>Enquiry Reference:'||' '||p_ref||'</p>'||utl_tcp.crlf;
    l_tab_varchar(3):='<p>The above enquiry may involve damage to highways property by a third party which requires investigation to consider whether costs incurred can be recovered. </p>'||utl_tcp.crlf; 
    l_tab_varchar(4):='<p>Please review and action as appropriate.</p>'||utl_tcp.crlf; 
    l_tab_varchar(5):='<p>This email has been automatically generated so please do not reply to this message.</p>'||utl_tcp.crlf;
    l_tab_varchar(6):='<p>Regards,</p>'||utl_tcp.crlf;
    l_tab_varchar(7):='<p>Hampshire County Highways</p>'||utl_tcp.crlf;
    p_tab_to(1).rcpt_id:=l_rcp_id;
    p_tab_to(1).rcpt_type:='USER';
    --
    nm3mail.write_mail_complete (p_from_user        => 38898
                                ,p_subject          => 'Rechargeable Item - Reference '||p_ref
                                ,p_html_mail        => TRUE
                                ,p_tab_to           => p_tab_to
                                ,p_tab_cc           => p_tab_cc
                                ,p_tab_bcc          => p_tab_cc
                                ,p_tab_message_text => l_tab_varchar
                                );
    exception when others then null;
  end;
  --
  --
  procedure email_job_alert as
  l_error varchar2(1) default 'N';
  p_tab_to nm3mail.tab_recipient;
  p_tab_cc nm3mail.tab_recipient;
  l_tab_varchar nm3type.tab_varchar32767;
  l_name varchar2(100);
  l_email hig_contacts.hct_email%type;
  l_rcp_id number;   
  begin
    begin
      select distinct 'Y' into l_error from user_jobs where broken = 'Y';
      exception when others then l_error := 'N';
    end;
    --
    if l_error = 'Y' then
      l_rcp_id := xhants_pem_bespoke.get_mail_recipient('DBMS Job Error','ITCSDSJS@hants.gov.uk');
      -- Constuct Email
      l_tab_varchar(1):=const_email_header||utl_tcp.crlf;
      l_tab_varchar(2):='<p>Exor Jobs are reported as broken.</p>'||utl_tcp.crlf;
      l_tab_varchar(3):='<p>This may be affecting the CSI processes.  Log in as the highways owner in sql and run ''select * from user_jobs'' to start investigations. </p>'||utl_tcp.crlf; 
      l_tab_varchar(4):='<p>This email has been system generated. </p>'||utl_tcp.crlf;
      p_tab_to(1).rcpt_id:=l_rcp_id;
      p_tab_to(1).rcpt_type:='USER';
      --
      nm3mail.write_mail_complete (p_from_user        => 38898
                                  ,p_subject          => 'Exor Jobs Are Broken'
                                  ,p_html_mail        => TRUE
                                  ,p_tab_to           => p_tab_to
                                  ,p_tab_cc           => p_tab_cc
                                  ,p_tab_bcc          => p_tab_cc
                                  ,p_tab_message_text => l_tab_varchar
                                  );
    end if;
  end;
  --
  procedure set_via_linked_defect  (p_defect in defects.def_defect_id%type,
                                    p_pem    in docs.doc_id%type) is
  --
  l_defect_status  defects.def_status_code%type;
  l_pem_type       docs.doc_dtp_code%type;
  l_reason         defects.def_special_instr%type;
  --
  begin
    select def_status_code, def_special_instr into l_defect_status, l_reason from defects where def_defect_id = p_defect;
    --
    select doc_dtp_code into l_pem_type from docs where doc_id = p_pem;
    --
    if l_pem_type = 'HDEF' and l_defect_status in ('ROUTINE', 
                                                   'CONTRACTOR', 
                                                   '3RD PARTY',
                                                   'MADE SAFE', 
                                                   'PLANNED', 
                                                   'EMERGENCY', 
                                                   'COMPLETED')
    then
      update docs set (doc_status_code, doc_reason,doc_compl_complete) =  (select case when l_defect_status = 'ROUTINE' then 'MG'
                                                                                       when l_defect_status = 'CONTRACTOR' then 'PC'
                                                                                       when l_defect_status = '3RD PARTY' then 'CTP'
                                                                                       when l_defect_status = 'MADE SAFE' then 'MS'
                                                                                       when l_defect_status = 'PLANNED' then 'PW'
                                                                                       when l_defect_status = 'EMERGENCY' then 'EM'
                                                                                       when l_defect_status = 'COMPLETED' then 'CO'
                                                                                       when l_defect_status = 'AVAILABLE' then 'DR'
                                                                                  end,
                                                                                  case when l_defect_status = 'ROUTINE' then 'Passed to Maintenance Gang: '||l_reason
                                                                                       when l_defect_status = 'CONTRACTOR' then 'Work Passed to Contractor: '||l_reason
                                                                                       when l_defect_status = '3RD PARTY' then 'Work Complete for 3rd Party: '||l_reason
                                                                                       when l_defect_status = 'MADE SAFE' then 'Made Safe, further work needed: '||l_reason
                                                                                       when l_defect_status = 'PLANNED' then 'Covered by Planned Work: '||l_reason
                                                                                       when l_defect_status = 'EMERGENCY' then 'With Contractor-Emergency Work: '||l_reason
                                                                                       when l_defect_status = 'COMPLETED' then 'Enquiry Complete'
                                                                                       when l_defect_status = 'AVAILABLE' then 'Defect Found, awaiting action.'
                                                                                  end,
                                                                                  case when l_defect_status = 'COMPLETED' then sysdate
                                                                                       else null
                                                                                  end
                                                                           from dual) 
      where doc_id = p_pem;
   end if;
  end;
end xhants_pem_bespoke;
