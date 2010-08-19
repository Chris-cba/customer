create or replace TRIGGER DOC_UPDATE_TRG AFTER
UPDATE OF DOC_COMPL_ACTION
               , DOC_COMPL_CPR_ID
               , DOC_COMPL_USER_ID
               , DOC_STATUS_CODE 
ON DOCS REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW DECLARE         
--         
--         
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/Worcestershire/doc_update_trg.trg-arc   3.0   Aug 19 2010 15:35:26   Mike.Alexander  $
--       Module Name      : $Workfile:   doc_update_trg.trg  $
--       Date into PVCS   : $Date:   Aug 19 2010 15:35:26  $
--       Date fetched Out : $Modtime:   Aug 19 2010 15:34:52  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------   
--         
-- This version produced Thur 15 Dec 2005         
-- doesn't check if old and new values are the same.         
-- file name is doc_update_trgr_Ver4.trg         
--         
--   Author : iturnbull         
--         
--         
-- this version 22 July 2008 (08)         
-- the address of the biztalk web service is the test one!         
-- It will only fire if the doc_user_id is 353 (HUB)         
         
--         
-- This version Monday 19th January 2009          
-- Added more users to the if statement         
-- more comments around the crm url         
--         

--         
-- This version Tuesday 17 august 2010
-- enabled the trigger to fire only of the update columns have new values.
-- Added a check on the database instance and change the CRM url if the db instance is highways
-- added the pem id and crm ref to the error output file.
--         
    
    
--    
-- Removed odd characters from the replace section for Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â£ etc    
-- 'Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â£' changed to 'Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â?Ã?Â£'    
--    
--    
-----------------------------------------------------------------------------         
--    Copyright (c) exor corporation ltd, 2010         
-----------------------------------------------------------------------------         
--         
-- Trigger to create a xml file when columns are updated in the DOCS table         
-- This is for Worcestershire and there link to the CRM using HP.         
-- Creates the file to a directory below product option UTL_DIR called hp_exor_pem         
--         
--         
--exor pem id number  -- doc_id         
--date/time changed   -- to_char(sysdate, 'DD-MON-YYYY HH:MI:SS')         
--action/remarks      -- doc_compl_action         
--priority decription -- doc_compl_cpr_id hig_codes domain = 'COMPLAINT_SOURCE'         
--status description  -- doc_status_code lookup from hig_status_codes domain = 'COMPLAINTS'         
--responsibility of   -- doc_compl_user_id look up to hig_users         
-- <ns0:exortrigger xmlns:ns0="http://IncidentSchemas.eXorTrigger">         
--   <exorpemid>8000</exorpemid>         
--   <datetimechanged>12092005</datetimechanged>         
--   <actionremarks>actionremarks</actionremarks>         
--   <prioritydescription>priority description</prioritydescription>         
--   <statusdescription>status description</statusdescription>         
--   <responsibilityof>responsibility OF</responsibilityof>         
-- </ns0:exortrigger>         
--         
   CURSOR get_priority (c_cpr_id COMPLAINT_PRIORITIES.cpr_id%TYPE)         
   IS         
   SELECT cpr_name         
   FROM  COMPLAINT_PRIORITIES         
   WHERE cpr_id = c_cpr_id;         
--         
   CURSOR get_status (c_status_code HIG_STATUS_CODES.hsc_status_code%TYPE)         
   IS         
   SELECT hsc_status_name         
   FROM HIG_STATUS_CODES         
   WHERE hsc_domain_code = 'COMPLAINTS'         
     AND hsc_status_code = c_status_code;         
--         
   CURSOR get_name (c_hus_user_id HIG_USERS.hus_user_id%TYPE)         
   IS         
   SELECT hus_name         
   FROM HIG_USERS         
   WHERE  hus_user_id = c_hus_user_id;         
--         
   CURSOR c_max_doc_hist (c_doc_id DOCS.doc_id%TYPE)         
   IS         
   SELECT MAX(dhi_date_changed)         
   FROM DOC_HISTORY         
   WHERE dhi_doc_id = c_doc_id;         
--         
   CURSOR c_get_reason(c_doc_id DOCS.doc_id%TYPE         
                      ,c_dhi_date_changed DOC_HISTORY.dhi_date_changed%TYPE)         
   IS         
   SELECT dhi_reason         
   FROM DOC_HISTORY         
   WHERE dhi_doc_id = c_doc_id         
     AND dhi_date_changed = c_dhi_date_changed;         
--         
   l_xml VARCHAR2(4000);         
   l_priority VARCHAR2(100);         
   l_status VARCHAR2(100);         
   l_name VARCHAR2(100);         
   l_doc_compl_action DOCS.doc_compl_action%TYPE;         
   l_reason DOC_HISTORY.dhi_reason%TYPE;         
   l_date  DOC_HISTORY.dhi_date_changed%TYPE;         
--         
   l_http_req UTL_HTTP.REQ;         
   l_http_resp UTL_HTTP.RESP;         
   l_url VARCHAR2(100);         
--         
   l_location VARCHAR2(4000) := NVL(hig.get_useopt('UTL_DIR',USER),hig.get_sysopt('UTL_DIR'));         
   l_filename VARCHAR2(100);         
   l_file UTL_FILE.FILE_TYPE;         
--         
   l_err_num NUMBER;         
   l_err_msg VARCHAR2(1000);         
--         
BEGIN         
             
    nm_debug.debug_on;         
    IF :NEW.doc_user_id in ( 353                             
                            ,634                             
                            ,643                             
                            ,635                             
                            ,636                             
                            ,637                             
                            ,638                             
                            ,639                             
                            ,640                             
                            ,641                             
                            ,642)         
      THEN         
      IF --TRUE -- allways call this block         
          :NEW.doc_compl_action != nvl(:OLD.doc_compl_action,'~')         
         OR         
          :NEW.doc_compl_cpr_id != nvl(:OLD.doc_compl_cpr_id,'~')         
         OR         
          :NEW.doc_status_code != nvl(:OLD.doc_status_code,'~')         
         OR         
          :NEW.doc_compl_user_id != nvl(:OLD.doc_compl_user_id,'~')         
     THEN         
   --         
         OPEN c_max_doc_hist( :NEW.doc_id);         
         FETCH c_max_doc_hist INTO l_date;         
         CLOSE c_max_doc_hist;         
   --         
         OPEN c_get_reason( :NEW.doc_id, l_date);         
         FETCH c_get_reason INTO l_reason;         
         CLOSE c_get_reason;         
   --         
         OPEN get_priority(:NEW.doc_compl_cpr_id);         
         FETCH get_priority INTO l_priority;         
         CLOSE get_priority;         
   --         
         OPEN get_status(:NEW.doc_status_code);         
         FETCH get_status INTO l_status;         
         CLOSE get_status;         
   --         
         OPEN get_name(:NEW.doc_compl_user_id);         
         FETCH get_name INTO l_name;         
         CLOSE get_name;         
   --         
         l_doc_compl_action := :NEW.doc_compl_action;         
   --         
        l_doc_compl_action := REPLACE(l_doc_compl_action,'<','lt');         
        l_doc_compl_action := REPLACE(l_doc_compl_action,'>','gt');         
        l_reason := REPLACE(l_reason,'<','lt');         
        l_reason := REPLACE(l_reason,'>','gt');         
         
         
         l_xml := '<ns0:eXorTrigger xmlns:ns0="http://IncidentSchemas.eXorTrigger">';         
         l_xml := l_xml || '<eXorPEMId>'||:OLD.doc_id||'</eXorPEMId>' ;         
         l_xml := l_xml || '<DateTimeChanged>'||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') ||'</DateTimeChanged>' ;         
         l_xml := l_xml || '<ActionRemarks>'||l_doc_compl_action||'</ActionRemarks>' ;         
         l_xml := l_xml || '<PriorityDescription>'||l_priority||'</PriorityDescription>' ;         
         l_xml := l_xml || '<StatusDescription>'||l_status||'</StatusDescription>' ;         
         l_xml := l_xml || '<ResponsibilityOf>'||l_name||'</ResponsibilityOf>' ;         
         l_xml := l_xml || '<HistoryRecord>'||l_reason||'</HistoryRecord>' ;         
         l_xml := l_xml || '</ns0:eXorTrigger>' ;         
   --         
          
   --           
        l_xml := REPLACE(l_xml,'&','+');            
        l_xml := REPLACE(l_xml, '£' ,'pound');    
        l_xml := REPLACE(l_xml, chr(163) ,'pound');    
         
        l_xml := REPLACE(l_xml,'''','apos');            
        l_xml := REPLACE(l_xml,'¬','squiggle');            
        l_xml := REPLACE(l_xml,'¿','euro');            
        l_xml := replace(l_xml,'¿','euro');            
        l_xml := REPLACE(l_xml,'¦','squiggle');            
         
        l_xml := REPLACE(l_xml,chr(39),'apos');            
        l_xml := REPLACE(l_xml,chr(96),'apos');                    
    --         
    -- This is the live eShop URL                           
 --        l_url := 'http://biz/WCC_ExorTrigger_Receive/BTSHTTPReceive.dll';         
             
   -- This is the eShop Development         
   -- l_url := 'http://172.17.17.68/WCC_ExorTrigger_Receive/BTSHTTPReceive.dll';         
        
-- This is the oneserver production system         
 --   l_url := 'http://172.17.16.219/WCC_ExorTrigger_Receive/BTSHTTPReceive.dll';        

--dev url
l_url := 'http://172.17.17.80/WCC_ExorTrigger_Receive/BTSHTTPReceive.dll';
     for crec in ( select instance_name from v$instance)
     loop
        if lower(crec.instance_name) = 'highways'
         then 
            l_url := 'http://172.17.16.219/WCC_ExorTrigger_Receive/BTSHTTPReceive.dll';  
        end if;
     end loop;
     
         
        /* DO NOT request that exceptions are raised for error Status Codes */         
         UTL_HTTP.SET_RESPONSE_ERROR_CHECK ( ENABLE => FALSE );         
   --         
         /* DO NOT  allow testing for exceptions like Utl_Http.Http_Server_Error */         
         --UTL_HTTP.SET_DETAILED_EXCP_SUPPORT ( ENABLE => FALSE );         
         UTL_HTTP.SET_DETAILED_EXCP_SUPPORT ( ENABLE => FALSE );         
   --         
            l_location := l_location || 'hp_exor_pem';         
         l_http_req := UTL_HTTP.BEGIN_REQUEST(l_url, 'POST','HTTP/1.0');         
         UTL_HTTP.SET_HEADER(l_http_req, 'Content-Type', 'text/xml');         
         UTL_HTTP.SET_HEADER(l_http_req, 'Content-Length', LENGTH(l_xml));         
         UTL_HTTP.WRITE_TEXT(l_http_req, l_xml);         
   --         
   --    HP Addition Dont't end the request or we can't ask for a response.         
   --      UTL_HTTP.END_REQUEST( l_http_req );         
         
         l_http_resp := UTL_HTTP.GET_RESPONSE ( r => l_http_req );         
                  
         
nm_debug.debug('PEM:'||:old.doc_id||' - status_code ' ||l_http_resp.status_code );                 
         
                  
         IF l_http_resp.status_code != 200         
          THEN         
         
            -- remove the trailing space, if it exists         
            IF SUBSTR(l_location,-1,1) = '\' -- dos         
              OR         
               SUBSTR(l_location,-1,1) = '/' -- unix         
             THEN         
               l_location := SUBSTR(l_location,1,LENGTH(l_location)-1);         
            END IF;         
      --         
            l_filename := 'pem_upd_'||DBMS_UTILITY.GET_TIME||'.txt';         
      --         
            l_file := UTL_FILE.FOPEN(l_location, l_filename, 'W', 1023);         
      --         
            UTL_FILE.PUT_LINE(l_file, l_xml);         
      --         
            UTL_FILE.FCLOSE(l_file);         
         END IF;         
      -- HP addition. Now we need to end the response.         
         UTL_HTTP.END_RESPONSE( l_http_resp );         
      END IF;         
   END IF;         
EXCEPTION         
   WHEN UTL_HTTP.request_failed THEN         
   nm_debug.debug('request failed');         
     l_err_msg :=  'Request_Failed: ' || UTL_HTTP.GET_DETAILED_SQLERRM ;         
      l_filename := 'ERROR_pem_upd_'||DBMS_UTILITY.GET_TIME||'.txt';         
      l_file := UTL_FILE.FOPEN(l_location, l_filename, 'W', 1023);         
--         
      UTL_FILE.PUT_LINE(l_file, 'doc update trigger has raised an error '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH:MI:SS'));         
      utl_file.put_line(l_file, 'PEM_ID : ' || :OLD.doc_id || ' REF : '|| :old.doc_reference_code);
      UTL_FILE.PUT_LINE(l_file, l_err_msg);         
--         
      UTL_FILE.FCLOSE(l_file);         
         
   /* raised by URL http://xxx.oracle.com/ */         
   WHEN UTL_HTTP.HTTP_SERVER_ERROR THEN         
   nm_debug.debug('request server error');         
     l_err_msg :=   'Http_Server_Error: ' || UTL_HTTP.GET_DETAILED_SQLERRM;         
      l_filename := 'ERROR_pem_upd_'||DBMS_UTILITY.GET_TIME||'.txt';         
      l_file := UTL_FILE.FOPEN(l_location, l_filename, 'W', 1023);         
--         
      UTL_FILE.PUT_LINE(l_file, 'doc update trigger has raised an error '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH:MI:SS'));         
      utl_file.put_line(l_file, 'PEM_ID : ' || :OLD.doc_id || ' REF : '|| :old.doc_reference_code);
      UTL_FILE.PUT_LINE(l_file, l_err_msg);         
--         
      UTL_FILE.FCLOSE(l_file);         
         
   /* raised by URL /xxx */         
   WHEN UTL_HTTP.HTTP_CLIENT_ERROR THEN         
   nm_debug.debug('client error');         
     l_err_msg :=   'Http_Client_Error: ';-- || UTL_HTTP.GET_DETAILED_SQLERRM ;         
      l_filename := 'ERROR_pem_upd_'||DBMS_UTILITY.GET_TIME||'.txt';         
      l_file := UTL_FILE.FOPEN(l_location, l_filename, 'W', 1023);         
--         
      UTL_FILE.PUT_LINE(l_file, 'doc update trigger has raised an error '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH:MI:SS'));     
      utl_file.put_line(l_file, 'PEM_ID : ' || :OLD.doc_id || ' REF : '|| :old.doc_reference_code);
      UTL_FILE.PUT_LINE(l_file, l_err_msg);         
--         
      UTL_FILE.FCLOSE(l_file);         
         
   WHEN OTHERS         
    THEN         
      l_err_num := SQLCODE;         
      l_err_msg := SUBSTR(SQLERRM, 1, 1000);         
--         
      l_filename := 'ERROR_pem_upd_'||DBMS_UTILITY.GET_TIME||'.txt';         
      l_file := UTL_FILE.FOPEN(l_location, l_filename, 'W', 1023);         
--         
      UTL_FILE.PUT_LINE(l_file, 'doc update trigger has raised an error '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH:MI:SS'));       
      utl_file.put_line(l_file, 'PEM_ID : ' || :OLD.doc_id || ' REF : '|| :old.doc_reference_code);
      UTL_FILE.PUT_LINE(l_file, l_err_msg);         
--         
      UTL_FILE.FCLOSE(l_file);         
--         
END;
/    
