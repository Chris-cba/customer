DROP TRIGGER NHCC_PEM_X_TRG;

CREATE OR REPLACE TRIGGER NHCC_PEM_X_TRG 
AFTER INSERT OR UPDATE ON DOCS for each row
DECLARE
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid                     : $Header:   //vm_latest/archives/customer/northants/admin/trg/NHCC_PEM_X_TRG.trg-arc   1.0   Jun 05 2013 08:23:26   Ian.Turnbull  $
--       Module Name                : $Workfile:   NHCC_PEM_X_TRG.trg  $
--       Date into PVCS             : $Date:   Jun 05 2013 08:23:26  $
--       Date fetched Out           : $Modtime:   Jun 05 2013 08:22:56  $
--       PVCS Version               : $Revision:   1.0  $
--       Based on SCCS version      :
--
--   Author : H.Buckley
--
--   nhcc_pem_source_trg
--
--   Create new PEM mail trigger
--   on change of PEM Status where SOURCE = 'W' OR 'C' AND FLAG = 'EM'
--
-- Dear [AAAAA]
--
-- There has been an update to your Street Doctor report, reference number [BBBBBB]
--
-- The report has been updated with the following information
-- [CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC]
--
-- You will receive another email when the report is updated again.
--
-- Thank you for contacting the Street Doctor at Northamptonshire County Council
--
-- Stephen,
--
-- During the last meeting, we discussed that you needed a new mail trigger as follows:
--
-- On change of status AND (source = `web¿ OR `call centre¿) AND flag = `Mail Required¿ then send a change of status mail.
--
-- Can you confirm that the attached is the text to be sent by this trigger?
--
-- The mail includes three data fields as follows:
--
-- Dear      xxxxx      PEM Contact First Name?
-- Reference xxxxx	PEM ID
-- Xxxxxxxxxxxxxxxx	?? What PEM field goes in this `updated information¿?
--
--
-- Updated June 2013 by Aileen heal to slighty modify the text of the update trigger.
--
-----------------------------------------------------------------------------
-- Copyright (c) Bentley Systems Ltd, 2013
-----------------------------------------------------------------------------
--
--
   -- **********************************************************************
   -- Here we need to obtain an email and name for the contacts
   -- of the document. Only if the contact has an email address will we
   -- send an email to the customer.
   -- **********************************************************************
   cursor GetCustomerName( doc_id in docs.doc_id%type)
   is select *
      from   hig_contacts
      ,      doc_enquiry_contacts
      where  dec_doc_id=doc_id
      and    dec_hct_id=hct_id
      and    hct_email is not null;

   custrec GetCustomerName%rowtype;

   cursor GetAction( doc_id     in docs.doc_id%type
                 ,   doc_status in docs.doc_status_code%type )
   is select dhi_reason
      from   doc_history
      where  dhi_doc_id=doc_id
      and    dhi_status_code=doc_status;

   actionrec GetAction%rowtype;

   --
   l_from_name      varchar2(100):='streetdoctor@northamptonshire.gov.uk';
   l_from_user      varchar2(100):='System Administrator';
   l_customer_name  varchar2(100):='Street doctor';
   l_subject        varchar2(100):='Transport, Highways and Infrastructure';
-- l_subject        varchar2(100):='A Source change has occured for PEM : '||to_char(:new.doc_id);
   l_status         hig_status_codes.hsc_status_name%TYPE;
   l_customer_email hig_contacts.hct_email%type:='streetdoctor@northamptonshire.gov.uk';
   l_msg            nm3type.tab_varchar32767;
   v_mail_host      hig_options.hop_value%type:=hig.get_sysopt('SMTPSERVER');
   v_mail_port      hig_options.hop_value%type:=hig.get_sysopt('SMTPPORT');
   v_mail_conn      utl_smtp.connection;
   crlf             varchar2(2):=chr(13)||chr(10);
   j integer:=1;
   additional_address_info boolean:=true;

--
   PROCEDURE ins_doc_history (pi_text in VARCHAR2)
   IS
   BEGIN
      INSERT INTO doc_history
                  (dhi_doc_id
                  ,dhi_date_changed
                  ,dhi_changed_by
                  ,dhi_reason)
           VALUES (:NEW.doc_id
                  , SYSDATE + .00001
                  ,USER
                  ,pi_text);   -- Needs to  add a second so it does not
   END ins_doc_history;        -- clash with the standard doc_history in

   procedure send_header ( name   in varchar2
                       ,   header in varchar2 )
   as
   begin
     utl_smtp.write_data(v_mail_conn,name||': '||header||utl_tcp.crlf);
   end;
--

begin

    IF INSERTING
    THEN
       if  :new.doc_status_code <> :old.doc_status_code
       and :new.doc_compl_source in ('C','W')
       then     l_subject:='A new PEM has arrived: ['||to_char(:new.doc_id)||']';
                v_mail_conn:=utl_smtp.open_connection(v_mail_host,v_mail_port);
                utl_smtp.helo(v_mail_conn,v_mail_host);
                utl_smtp.mail(v_mail_conn,l_from_name);
                utl_smtp.rcpt(v_mail_conn,l_customer_email);
                utl_smtp.open_data(v_mail_conn);
                send_header('Date',to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS'));
                send_header('From','<SystemAdministrator@Northamptonshire.gov.uk>');
                send_header('Subject',l_subject);
                send_header('To'  ,'<'||l_customer_email||'>');
	          l_msg(1):='';
                l_msg(2):= 'Dear Street Doctor';
                l_msg(3):=' ';
	          l_msg(4):='A new PEM has arrived; ['||to_char(:new.doc_id)||'] via the external web portal.';
                l_msg(5):=' ';
	          l_msg(6):=' ';
	          l_msg(7):=' ';
                l_msg(8):='Thank you for contacting the Street Doctor at Northamptonshire County Council';
	          l_msg(9):=' ';
                l_msg(10):=' ';
                l_msg(11):=' ';
                if additional_address_info
                then
                    l_msg(12):=' ';
                    l_msg(13):=' ';
                    l_msg(14):=' ';
                    l_msg(15):=' ';
                    l_msg(16):='Northamptonshire County Council';
                    l_msg(17):='Highways, Transport & Infrastructure';
                    l_msg(18):='Riverside House';
	              l_msg(19):='Riverside Way';
	              l_msg(20):='Bedford Road';
	              l_msg(21):='Northampton';
                    l_msg(22):='NN1 5NX';
                    l_msg(23):='Web: www.northamptonshire.gov.uk';
                end if;

                if additional_address_info
                then  loop  utl_smtp.write_data(v_mail_conn,utl_tcp.crlf||l_msg(j));
                      exit when j=23;
                           j:=j+1;
                      end loop;
                else  loop utl_smtp.write_data(v_mail_conn,utl_tcp.crlf||l_msg(j));
                      exit when j=11;
                           j:=j+1;
                      end loop;
                end if;

                utl_smtp.close_data(v_mail_conn);
                utl_smtp.quit(v_mail_conn);
        end if;

    ELSIF UPDATING
    THEN
       if  :new.doc_status_code <> :old.doc_status_code
       and :new.doc_compl_source in ('C','W')
       then for i in GetCustomerName(:new.doc_id)
            loop
              if i.hct_vip = 'EM' and nvl(i.hct_email,'X')<>'X' and instr(i.hct_email,'@')>0
              then

                open GetAction(:new.doc_id
                            ,  :new.doc_status_code);
                fetch GetAction into actionrec;
                close GetAction;

                l_customer_name :=initcap(i.hct_title||' '||i.hct_surname);
                l_customer_email:=lower(i.hct_email);
                l_subject:='Your Street Doctor Report';
                v_mail_conn:=utl_smtp.open_connection(v_mail_host,v_mail_port);
                     utl_smtp.helo(v_mail_conn,v_mail_host);
                     utl_smtp.mail(v_mail_conn,l_from_name);
                     utl_smtp.rcpt(v_mail_conn,l_customer_email);
                     utl_smtp.open_data(v_mail_conn);
                       send_header('Date',to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS'));
                       send_header('From','<SystemAdministrator@Northamptonshire.gov.uk>');
                       send_header('Subject',l_subject);
                       send_header('To'  ,'<'||l_customer_email||'>');

	            l_msg(1):='';
			    l_msg(2):= '*This is not a monitored e-mail address so please do not reply to this e-mail.*';
	            l_msg(3):='';
                l_msg(4):= 'Dear '||l_customer_name;
                l_msg(5):=' ';
	            l_msg(6):='There has been an update to your Street Doctor report, reference number ['||to_char(:new.doc_id)||']';
                l_msg(7):=' ';
                l_msg(8):='The report has been updated with the following information -';
                l_msg(9):= actionrec.dhi_reason;
	            l_msg(10):=' ';
	            l_msg(11):=' ';
                l_msg(12):='Thank you for contacting the Street Doctor at Northamptonshire County Council';
	            l_msg(13):=' ';

              -- ******************************************************************************************
              -- Here I have been informe ha we need to bulk up the email. We need to do this so that
              -- relay mail servers do not believe the email to be SPAM and reject the email
              -- ******************************************************************************************
                if additional_address_info
                then
                    l_msg(14):=' ';
                    l_msg(15):=' ';
                    l_msg(16):=' ';
                    l_msg(17):=' ';
                    l_msg(18):='Northamptonshire County Council';
                    l_msg(19):='Web: www.northamptonshire.gov.uk';
                end if;

                if additional_address_info
                then  loop  utl_smtp.write_data(v_mail_conn,utl_tcp.crlf||l_msg(j));
                      exit when j=19;
                           j:=j+1;
                      end loop;
                else  loop utl_smtp.write_data(v_mail_conn,utl_tcp.crlf||l_msg(j));
                      exit when j=13;
                           j:=j+1;
                      end loop;
                end if;

                utl_smtp.close_data(v_mail_conn);
                utl_smtp.quit(v_mail_conn);
                --ins_doc_history (pi_text => 'email sent on change of source');

              end if;
           end loop;
           --utl_smtp.quit(v_mail_conn);
    end if;
  END IF;
exception
when utl_smtp.transient_error or utl_smtp.permanent_error
then raise_application_error(-20000,'Unable to send mail: '||sqlerrm);
end;
/
