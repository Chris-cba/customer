CREATE OR REPLACE TRIGGER x_dorset_def_pem_status_link
  AFTER INSERT OR UPDATE OF def_status_code, def_special_instr  ON defects
  FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Dorset/def_pem_link/admin/sql/x_dorset_def_pem_status_link.trg-arc   1.2   Nov 07 2011 10:32:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_dorset_def_pem_status_link.trg  $
--       Date into PVCS   : $Date:   Nov 07 2011 10:32:30  $
--       Date fetched Out : $Modtime:   Nov 04 2011 15:45:20  $
--       PVCS Version     : $Revision:   1.2  $
--
--
--   Author : PStanton
--
--    x_dorset_def_pem_status_link
--
--  Bespoke Trigger to link defects to pems when not created via PEM from
--  Trigger will create association on insert of defect, subsequnet updates to the defect status will be reflected in 
--  the pem, using the data in  x_def_pem_status table. 
--   
--  version 2 - Added defect id to the history record 
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
l_pem_id        VARCHAR2(6);
n_error_value NUMBER; 
l_error_text    VARCHAR2(5000); 
instr_number_chars VARCHAR2(11):= '0123456789';

CURSOR pem_id_chk (p_pem_id NUMBER) IS
Select '*' from docs
where doc_id = p_pem_id;

CURSOR pem_assoc_chk (p_pem_id NUMBER, p_def_id NUMBER) IS
Select '*' from doc_assocs
where das_table_name = 'DEFECTS'
and das_doc_id = p_pem_id
and das_rec_id = p_def_id;

CURSOR get_old_pem_status (p_pem_id NUMBER) IS
SELECT '*' FROM docs
WHERE doc_id = p_pem_id
AND doc_status_code <> 'CO';

CURSOR get_new_pem_status (p_def_status VARCHAR2) IS
SELECT pem_status FROM x_def_pem_status
WHERE defect_status = p_def_status;

BEGIN

--- get the pem ID

      IF INSTR(UPPER(:new.def_special_instr),'PEM') <> 0 THEN
     
         l_pem_id := (substr(:new.def_special_instr,INSTR(UPPER(:new.def_special_instr),'PEM')+3,6));
    
          IF (TRANSLATE (l_pem_id,CHR(1) || instr_number_chars,CHR(1)) IS NULL) THEN
            l_pem_id := to_number(l_pem_id);
          ELSE
            l_pem_id := null;
          END IF;
      
      END IF;


   IF INSERTING THEN
 
      IF l_pem_id IS NOT NULL THEN
     
         -- Create the link
          FOR i IN pem_id_chk (l_pem_id) LOOP
           
             INSERT INTO doc_assocs
             VALUES
             ('DEFECTS',:new.def_defect_id,l_pem_id);
             
             PEM.update_enquiry ( ce_doc_id    => l_pem_id
                                           ,  ce_status    => 'DR'
                                           ,  ce_status_reason => 'Automatic Defect Raised - Defect Id - '||:new.def_defect_id
                                           ,  error_value => n_error_value 
                                           ,  error_text => l_error_text 
                                           ) ;
             
         END LOOP;
    
        
      END IF;
   
   ELSIF UPDATING THEN
 
      FOR i IN get_old_pem_status (l_pem_id) LOOP
      
        -- keep the status up to date
         FOR i2 IN pem_assoc_chk (l_pem_id , :new.def_defect_id) LOOP

            IF :old.def_status_code <> 'CLOSED' THEN
            
                -- get new PEM status
                FOR i3 IN  get_new_pem_status (:new.def_status_code) LOOP
                   
                   IF i3.pem_status IS NOT NULL THEN
                   
                      PEM.update_enquiry ( ce_doc_id    => l_pem_id
                                                    ,  ce_status    => i3.pem_status
                                                    ,  ce_status_reason => 'Defect Status changed - Defect Id - '||:new.def_defect_id  
                                                    ,  error_value => n_error_value 
                                                    ,  error_text => l_error_text 
                                                   ) ;
                
                   END IF;
                      
                END LOOP;
                          
            END IF;
            
        END LOOP;
        
       END LOOP;
      
   END IF;


END x_dorset_def_pem_status_link;
/