CREATE OR REPLACE package body xhants_dec_bespoke as

  procedure clear_dec as
  begin
    tab_dec.delete;
  end clear_dec;
  
  procedure process_dec as
  begin
     FOR i IN 1..tab_dec.COUNT LOOP
       if tab_dec(i) is not null then
         update_dec_email(tab_dec(i));
  	 end if;
     end loop;
  end process_dec;
  
  procedure update_dec_email (p_dec_hct_id number) as
      
      cursor get_dec is 
        select dec_hct_id, dec_doc_id,doc_compl_user_id
        from   doc_enquiry_contacts,docs
        where  dec_doc_id = doc_id
        and    dec_hct_id = p_dec_hct_id;
  
  l_tab_dec nm3type.tab_number;       
  decrec get_dec%rowtype;
  RespOf hig_users.hus_username%type;
  def_email  hig_contacts.hct_email%type;
  contact_id hig_contacts.hct_id%type;
  
  begin
  --nm_debug.debug_on;
    l_tab_dec.delete;
    
    open get_dec;
    fetch get_dec into decrec;
   -- if get_dec%found
   -- then close get_dec;
  --nm_debug.debug('resp of id - '||decrec.doc_compl_user_id||' and dec_hct - '||p_dec_hct_id);
    RespOf :=  nm3get.get_hus(decrec.doc_compl_user_id).hus_username;
  --nm_debug.debug('resp of proc call - '||RespOf);
    def_email :=nvl(hig.get_useopt('PEMEMAIL',RespOf),hig.get_sysopt('PEMEMAIL'));
  --nm_debug.debug('def email - '||def_email);
         if nvl(def_email,'?')='?'
         then null; -- something is wrong 
         else update hig_contacts
              set    hct_email = def_email
              where  hct_id = decrec.dec_hct_id
              and    hct_email is null;
         end if;
    --else close get_dec;
    --end if;
  --nm_debug.debug_off;
       EXCEPTION
         WHEN OTHERS THEN
           -- Consider logging the error and then re-raise
       RAISE;
  end;
end xhants_dec_bespoke;
/