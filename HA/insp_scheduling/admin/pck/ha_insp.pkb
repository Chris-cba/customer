CREATE OR REPLACE PACKAGE BODY HA_INSP
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/pck/ha_insp.pkb-arc   1.0   Jun 06 2012 16:19:00   Ian.Turnbull  $
--       Module Name      : $Workfile:   ha_insp.pkb  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:19:00  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:31:30  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : PStanton
--
--   %YourObjectName% body
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems ltd, 2012
-----------------------------------------------------------------------------
--
--all global package variables here
   g_source_ne_id     NUMBER;
   g_insp_type        VARCHAR2(16);
   g_asset_type_log   VARCHAR2(4000);
   g_number_of_types  NUMBER DEFAULT 0;
   g_number_of_dates  NUMBER DEFAULT 0;
   g_from_date        DATE;
   g_to_date          DATE;
   g_yes_no           VARCHAR2(1) DEFAULT 'N';
   g_batch_id         NUMBER;
   g_asset_processed  NUMBER DEFAULT 0;
   g_schedule_errors  BOOLEAN DEFAULT FALSE;
   g_asset_error      BOOLEAN DEFAULT FALSE;
   g_asset_loc_error  BOOLEAN DEFAULT FALSE;
   g_csv_errors       BOOLEAN DEFAULT FALSE;
   
   
   g_date_1           DATE DEFAULT NULL;
   g_date_2           DATE DEFAULT NULL;
   g_date_3           DATE DEFAULT NULL;
   g_date_4           DATE DEFAULT NULL;
   g_date_5           DATE DEFAULT NULL;
   g_date_6           DATE DEFAULT NULL;
   g_date_7           DATE DEFAULT NULL;
   g_date_8           DATE DEFAULT NULL;
   g_date_9           DATE DEFAULT NULL;
   g_date_10          DATE DEFAULT NULL;
   
   g_duplicate        BOOLEAN DEFAULT FALSE;
   t_asset_types nm_code_tbl := new nm_code_tbl();
   
   
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

   g_package_name CONSTANT varchar2(30) := 'HA_INSP';
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
Procedure set_params (p_gri_param NUMBER) IS

   CURSOR get_non_asset_params IS
   SELECT * FROM gri_run_parameters
   WHERE grp_job_id = p_gri_param
   AND grp_param <> 'ASSET_TYPE';
 
BEGIN
 
   FOR i IN get_non_asset_params LOOP
     
      IF i.grp_param = 'HA_INSPECTION_TYPE' THEN
        
         g_insp_type := i.grp_value;
      
      ELSIF i.grp_param = 'REGION_OF_INTEREST' THEN
        
         g_source_ne_id := i.grp_value;

      ELSIF i.grp_param = 'FROM_DATE' THEN
        
         g_from_date := i.grp_value;

      ELSIF i.grp_param = 'TO_DATE' THEN
        
         g_to_date := i.grp_value;
        
      ELSIF i.grp_param = 'YES_NO' THEN
      
         g_yes_no := i.grp_value;
         
      ELSIF i.grp_param = 'BATCH_NUM' THEN
      
         g_batch_id := i.grp_value;
         
      END IF;
     
   END LOOP;

END set_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_inv_type ( inv_type IN varchar2 ) 
IS 
BEGIN 

   t_asset_types.EXTEND; 
   t_asset_types(t_asset_types.count) := inv_type;

   -- this bit is for the logging output in MAIN
   IF g_asset_type_log IS NOT NULL THEN
   
      g_asset_type_log := g_asset_type_log||', '||inv_type;
   
   ELSE
   
      g_asset_type_log := inv_type;
   
   END IF;
    
END add_inv_type;
--
-----------------------------------------------------------------------------
--
Procedure set_asset_params (p_gri_param NUMBER) IS

   CURSOR get_asset_params IS
   SELECT * FROM gri_run_parameters
   WHERE grp_job_id = p_gri_param
   AND grp_param = 'INSP_ASSET_TYPE';

   CURSOR gen_asset_list IS
   SELECT itg_parent_inv_type from nm_inv_type_groupings
   WHERE itg_inv_type = 'INSP';
 
BEGIN
   
   FOR i IN get_asset_params LOOP
 
      IF i.grp_value IS NOT NULL  and i.grp_value <> 'ALL' THEN
         
         g_number_of_types := g_number_of_types+1;
         
         add_inv_type(i.grp_value); 
           
      END IF;
      
   END LOOP;

   IF g_number_of_types = 0 THEN
   
      FOR i IN gen_asset_list LOOP
         add_inv_type(i.itg_parent_inv_type);
      END LOOP;
   
   END IF;

END set_asset_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_date ( insp_date IN DATE ) 
IS 
BEGIN 

   IF g_number_of_dates = 1 THEN
         g_date_1  := insp_date;
   ELSIF g_number_of_dates = 2 THEN
      g_date_2  := insp_date;
   ELSIF g_number_of_dates = 3 THEN      
      g_date_3  := insp_date;
   ELSIF g_number_of_dates = 4 THEN
      g_date_4  := insp_date;
   ELSIF g_number_of_dates = 5 THEN
      g_date_5  := insp_date;
   ELSIF g_number_of_dates = 6 THEN
      g_date_6  := insp_date;
   ELSIF g_number_of_dates = 7 THEN
      g_date_7  := insp_date;
   ELSIF g_number_of_dates = 8 THEN
      g_date_8  := insp_date;
   ELSIF g_number_of_dates = 9 THEN
      g_date_9  := insp_date;
   ELSIF g_number_of_dates = 10 THEN
      g_date_10 := insp_date;
   END IF;
    
END add_date;
--
-----------------------------------------------------------------------------
--
Procedure set_date_params (p_gri_param NUMBER) IS

   CURSOR get_date_params IS
   SELECT * FROM gri_run_parameters
   WHERE grp_job_id = p_gri_param
   AND grp_param = 'FROM_DATE';

   
BEGIN
   
   FOR i IN get_date_params LOOP
 
     g_number_of_dates := g_number_of_dates+1;
         
     add_date(i.grp_value); 
      
   END LOOP;

  
END set_date_params;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_date (p_interval intervals.int_code%type, DATE_IN DATE) RETURN DATE IS

   date_out date;
   
BEGIN

   date_out := hig.date_due(date_in,p_interval,FALSE);

   return date_out;

END get_next_date;
--
-----------------------------------------------------------------------------
--
function create_inspection (p_admin_unit      IN     nm_inv_items_all.iit_admin_unit%TYPE
                           ,pf_insp_type      IN     nm_inv_items_all.iit_chr_attrib26%TYPE
                           ,pf_insp_source    IN     nm_inv_items_all.iit_chr_attrib27%TYPE
                           ,pf_asset_type     IN     nm_inv_items_all.iit_chr_attrib31%TYPE
                           ,pf_insp_date_due  IN     nm_inv_items_all.iit_date_attrib86%TYPE
                           ,pf_insp_parent_id IN     nm_inv_items_all.iit_foreign_key%TYPE
                           ,pf_module         IN     VARCHAR2
               ) RETURN nm_inv_items_all.iit_ne_id%TYPE IS

   l_asset_id         nm_inv_items_all.iit_ne_id%TYPE;
   parent_mem_loc_det nm_members_all%ROWTYPE;
   parent_ele_loc_det nm_elements_all%ROWTYPE;

   CURSOR get_mem_parent_loc_det(p_asset_id nm_inv_items_all.iit_ne_id%TYPE) IS
   SELECT * FROM nm_members
   WHERE nm_ne_id_in = p_asset_id
   AND  nm_seq_no  = 1
   AND ROWNUM = 1;

   CURSOR get_ele_parent_loc_det (p_asset_id nm_inv_items_all.iit_ne_id%TYPE) IS
   SELECT * FROM nm_elements_all
   WHERE ne_id = (SELECT nm_ne_id_of FROM nm_members
                 WHERE nm_ne_id_in = p_asset_id
                 AND  nm_seq_no =1
                 AND ROWNUM = 1);
                 
   CURSOR chk_for_duplicates(p_parent_id nm_inv_items_all.iit_foreign_key%TYPE
                            ,p_insp_type nm_inv_items_all.iit_chr_attrib26%TYPE
                            ,p_source    nm_inv_items_all.iit_chr_attrib27%TYPE
                            ,p_date       nm_inv_items_all.iit_date_attrib86%TYPE) IS
   SELECT '1' FROM v_nm_insp
   WHERE insp_parent_id = p_parent_id
   AND insp_type = p_insp_type
   AND insp_source = p_source
   AND insp_date_due = p_date;
   
   l_duplicate NUMBER DEFAULT 0;
   
BEGIN

   -- Reset error flags
   g_asset_error     := FAlSE;
   g_asset_loc_error := FALSE;
   
   OPEN chk_for_duplicates(pf_insp_parent_id,pf_insp_type,pf_insp_source,pf_insp_date_due);
   FETCH chk_for_duplicates INTO l_duplicate;
   CLOSE chk_for_duplicates;
   
   IF l_duplicate = 1 THEN
   
       --Inspection alraedy exists do not create another identica one
       hig_process_api.log_it(pi_message =>'An Inspection Already Exists For '||pf_insp_type||' On Asset '||pf_insp_parent_id||' On Date '||pf_insp_date_due);
       
   ELSE
      
      BEGIN
      
         -- Create new Inspection asset
         l_asset_id:= nm3api_inv_insp.ins (p_admin_unit      => p_admin_unit
                                          ,pf_insp_type      => pf_insp_type
                                          ,pf_insp_source    => pf_insp_source
                                          ,pf_asset_type     => pf_asset_type
                                          ,pf_insp_date_due  => pf_insp_date_due
                                          ,pf_insp_parent_id => pf_insp_parent_id
                                          );

         commit;
         
               
      EXCEPTION WHEN OTHERS THEN
        
         g_schedule_errors := TRUE;
         g_asset_error     := TRUE;
        
      END;
 
      -- get parents location details
      OPEN get_mem_parent_loc_det(pf_insp_parent_id);
      FETCH get_mem_parent_loc_det INTO parent_mem_loc_det;
      CLOSE get_mem_parent_loc_det;

      OPEN get_ele_parent_loc_det(pf_insp_parent_id);
      FETCH get_ele_parent_loc_det INTO parent_ele_loc_det;
      CLOSE get_ele_parent_loc_det;
   
      BEGIN
   
         nm3api_inv.locate_item(p_iit_ne_id                => l_asset_id
                               ,p_element_ne_unique        => parent_ele_loc_det.ne_unique
                               ,p_element_ne_nt_type       => parent_ele_loc_det.ne_nt_type
                               ,p_element_begin_mp         => parent_mem_loc_det.nm_begin_mp
                              );
   
         commit;
   
      EXCEPTION WHEN OTHERS THEN
      
         g_schedule_errors := TRUE;      --Not likely to fail since to even get into create inspection the parent must be located
         g_asset_loc_error    := TRUE;   -- but might as well cater for all eventualities
   
      END;
   
      IF g_asset_error = TRUE THEN
           
         hig_process_api.log_it(pi_message =>'Inspection Due On '||pf_insp_date_due||'. Inspection Asset Failed to Create. Contact Your Adminstrator'
                               ,pi_message_type => 'E');
 
      ELSE
         
         IF pf_module = 'MAI3700' THEN
         
            hig_process_api.log_it('Inspection Due On '||pf_insp_date_due||'. Inspection Asset - '||l_asset_id||' created');
         
         ELSIF pf_module = 'MAI3710' THEN
         
            hig_process_api.log_it(pi_message =>'Inspection '||l_asset_id||' Created for '||pf_asset_type||' '||pf_insp_parent_id||' Date Due '||pf_insp_date_due);
            
         END IF; 
         
         IF g_asset_loc_error = TRUE THEN 
           
            hig_process_api.log_it(pi_message =>'Inspection Asset '||l_asset_id||' Failed to Locate. Contact Your Adminstrator'
                                  ,pi_message_type => 'E');     
                      
         END IF;
           
      END IF;
           
   END IF;
   
RETURN l_asset_id;

END create_inspection;
--
-----------------------------------------------------------------------------
--
FUNCTION create_gaz_query RETURN NUMBER IS

   l_job_id         NUMBER  := nm3ddl.sequence_nextval('RTG_JOB_ID_SEQ');
   l_gaz_query_id   NUMBER;
   l_seq_no         NUMBER DEFAULT 0;

   CURSOR param_asset_list IS
   SELECT itg_parent_inv_type from nm_inv_type_groupings
   WHERE itg_inv_type = 'INSP'
   AND itg_parent_inv_type in (select column_value from table (cast(t_asset_types as nm_code_tbl)));
  
BEGIN
   
   INSERT INTO nm_gaz_query
   (ngq_id, ngq_source_id, ngq_source, ngq_open_or_closed, ngq_items_or_area, ngq_query_all_items)
   VALUES
   (l_job_id, g_source_ne_id, 'ROUTE','C','I','N');
   
   commit;
      
   FOR i IN param_asset_list LOOP
   
      l_seq_no := l_seq_no+1;
      INSERT INTO nm_gaz_query_types
      (ngqt_ngq_id, ngqt_seq_no, ngqt_item_type_type, ngqt_item_type)
      VALUES
      (l_job_id, l_seq_no, 'I', i.itg_parent_inv_type);
      
      --nm_debug.debug('inserted '||l_seq_no||' and '||i.itg_parent_inv_type);
         
   END LOOP;
   commit;

--Run the query
   l_gaz_query_id := nm3gaz_qry.perform_query (l_job_id);
   commit;
--
   RETURN l_gaz_query_id;

END create_gaz_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_interval(p_int_code VARCHAR2) RETURN VARCHAR2 IS

   CURSOR get_int_descr IS
   SELECT int_descr FROM INTERVALS
   WHERE int_code = p_int_code;
 
   l_int_descr intervals.int_descr%TYPE;
 
BEGIN

   OPEN get_int_descr;
   FETCH get_int_descr INTO l_int_descr;
   CLOSE get_int_descr;
   
   RETURN l_int_descr;

END get_interval;
--
-----------------------------------------------------------------------------
--
PROCEDURE mai3700 (p_gri_id NUMBER) IS

  l_gaz_query_id  NUMBER ;
  l_int_code      intervals.int_code%type;
  due_date        DATE;
  next_date       DATE;
  last_date       DATE;
  l_insp_id       nm_inv_items_all.iit_ne_id%TYPE;


  CURSOR get_valid_assets (p_gaz_query_id number )IS
  SELECT * FROM (
  SELECT iit_ne_id
       ,iit_inv_type
       ,iit_admin_unit
       ,iit_chr_attrib30 insp_int_type_1
       ,iit_chr_attrib31 insp_int_type_2
       ,iit_chr_attrib32 insp_int_type_3
       ,iit_chr_attrib33 insp_int_type_4
       ,iit_chr_attrib34 insp_int_type_5
       ,iit_chr_attrib35 insp_int_type_6
       ,iit_chr_attrib36 insp_int_type_7
       ,iit_chr_attrib37 insp_int_type_8
       ,iit_chr_attrib38 insp_int_type_9
       ,iit_chr_attrib39 insp_int_type_10
       ,iit_date_attrib86 last_inspected_1
       ,iit_date_attrib87 last_inspected_2
       ,iit_date_attrib88 last_inspected_3
       ,iit_date_attrib89 last_inspected_4
       ,iit_date_attrib90 last_inspected_5
       ,iit_date_attrib91 last_inspected_6
       ,iit_date_attrib92 last_inspected_7
       ,iit_date_attrib93 last_inspected_8
       ,iit_date_attrib94 last_inspected_9
       ,iit_date_attrib95 last_inspected_10
   FROM nm_gaz_query_item_list, nm_inv_items
   WHERE iit_ne_id = ngqi_item_id
   AND ngqi_job_id = p_gaz_query_id)
   WHERE insp_int_type_1 IS NOT NULL
   OR insp_int_type_2 IS NOT NULL
   OR insp_int_type_3 IS NOT NULL
   OR insp_int_type_4 IS NOT NULL
   OR insp_int_type_5 IS NOT NULL
   OR insp_int_type_6 IS NOT NULL
   OR insp_int_type_7 IS NOT NULL
   OR insp_int_type_8 IS NOT NULL
   OR insp_int_type_9 IS NOT NULL
   OR insp_int_type_10 IS NOT NULL;
 
BEGIN
nm_debug.debug_on;
-- Get Gri Params and set the globals
   set_params(p_gri_id);
 
   set_asset_params(p_gri_id);
   
   hig_process_api.log_it('Generating Inspection Schedule Initiated By '||user||' Based On The Following Parameters:');
   hig_process_api.log_it('Assets Types: '||g_asset_type_log);
   hig_process_api.log_it('Inspection Type: '||g_insp_type);
   hig_process_api.log_it('Region of Interest: '||nm3net.get_ne_unique( p_ne_id => g_source_ne_id) );
   hig_process_api.log_it('From Date: '||g_from_date);
   hig_process_api.log_it('To Date: '||g_to_date);
  
-- Create and run the gaz query so we can loop through potential assets 
   l_gaz_query_id := create_gaz_query;


   FOR i in get_valid_assets(l_gaz_query_id) loop            -- Loop throught the valid assets looking for inspections that need creating
  
     
      IF i.insp_int_type_1 IS NOT NULL AND g_insp_type = 'TYPE 1' THEN
       
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 1 - Last Inspected Date - '||nvl(to_char(i.last_inspected_1),'No last inspected Date')||'. Interval - '||get_interval(p_int_code => i.insp_int_type_1));

          IF i.last_inspected_1 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 1'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_1,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_1,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 1'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
    
      IF i.insp_int_type_2 IS NOT NULL AND g_insp_type = 'TYPE 2' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 2 - Last Inspected Date - '||nvl(to_char(i.last_inspected_2),'No last inspected Date')||'. Interval - '||get_interval(p_int_code => i.insp_int_type_2));


         IF i.last_inspected_2 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 2'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_2,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_2,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 2'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;


      IF i.insp_int_type_3 IS NOT NULL AND g_insp_type = 'TYPE 3' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 3 - Last Inspected Date - '||nvl(to_char(i.last_inspected_3),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_3));

         IF i.last_inspected_3 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 3'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_3,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_3,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 3'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
     
      IF i.insp_int_type_4 IS NOT NULL AND g_insp_type = 'TYPE 4' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 4 - Last Inspected Date - '||nvl(to_char(i.last_inspected_4),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_4));

         IF i.last_inspected_4 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 4'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_4,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_4,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 4'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
      
      IF i.insp_int_type_5 IS NOT NULL AND g_insp_type = 'TYPE 5' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 5 - Last Inspected Date - '||nvl(to_char(i.last_inspected_5),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_5));

         IF i.last_inspected_5 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 5'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_5,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_5,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 5'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
      
      IF i.insp_int_type_6 IS NOT NULL AND g_insp_type = 'TYPE 6' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 6 - Last Inspected Date - '||nvl(to_char(i.last_inspected_6),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_6));

         IF i.last_inspected_6 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 6'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_6,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_6,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 6'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                            
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
      
      IF i.insp_int_type_7 IS NOT NULL AND g_insp_type = 'TYPE 7' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 7 - Last Inspected Date - '||nvl(to_char(i.last_inspected_7),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_7));

         IF i.last_inspected_7 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 7'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_7,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_7,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 7'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;
        
      END IF;
      
      IF i.insp_int_type_8 IS NOT NULL AND g_insp_type = 'TYPE 8' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 8 - Last Inspected Date - '||nvl(to_char(i.last_inspected_8),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_8));

         IF i.last_inspected_8 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 8'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
                                          
            
         END IF;
         
         last_date := nvl(i.last_inspected_8,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_8,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 8'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;
       
      END IF;
      
      IF i.insp_int_type_9 IS NOT NULL AND g_insp_type = 'TYPE 9' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 9 - Last Inspected Date - '||nvl(to_char(i.last_inspected_9),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_9));

         IF i.last_inspected_9 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 9'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_9,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_9,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 9'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
      
      IF i.insp_int_type_10 IS NOT NULL AND g_insp_type = 'TYPE 10' THEN
        
         hig_process_api.log_it('Asset - '||i.iit_ne_id||'. Inspection Type 10 - Last Inspected Date - '||nvl(to_char(i.last_inspected_10),'No last inspected Date')||'. Interval - '|| get_interval(p_int_code =>i.insp_int_type_10));

         IF i.last_inspected_10 IS NULL AND g_from_date >= trunc(sysdate) THEN  --- If last inpsected date is null and from date is 
                                                                                ---today or later then create an inspection on the from date
            
            l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit
                                           ,pf_insp_type      => 'TYPE 10'
                                           ,pf_insp_source    => 'SCHEDULED'
                                           ,pf_asset_type     => i.iit_inv_type
                                           ,pf_insp_date_due  => g_from_date
                                           ,pf_insp_parent_id => i.iit_ne_id
                                           ,pf_module         => 'MAI3700');
            
         END IF;
         
         last_date := nvl(i.last_inspected_10,g_from_date);
         WHILE last_date < g_to_date
         LOOP

            next_date := get_next_date(SUBSTR(i.insp_int_type_10,1,3),last_date);                         --- Keep adding to last date incrementing by the 
                                                                                                         --- inspection type interval
            IF next_date <= g_to_date AND next_date >= g_from_date AND next_date >= trunc(sysdate)THEN   --- Only create an inspection if it fallson or 
                                                                                                         --- betweenthe to and from dates 
               l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                     --- and is in greater = sysdate
                                              ,pf_insp_type      => 'TYPE 10'
                                              ,pf_insp_source    => 'SCHEDULED'
                                              ,pf_asset_type     => i.iit_inv_type
                                              ,pf_insp_date_due  => next_date
                                              ,pf_insp_parent_id => i.iit_ne_id
                                              ,pf_module         => 'MAI3700');
                                
            END IF;
           
            last_date := next_date;

         END LOOP;


      END IF;
      
      g_asset_processed := g_asset_processed+1;
    
    
   END LOOP;

   COMMIT;

END mai3700;
--
-----------------------------------------------------------------------------
--
PROCEDURE mai3710 (p_gri_id NUMBER) IS

  l_gaz_query_id  NUMBER ;
  l_insp_id       nm_inv_items_all.iit_ne_id%TYPE;


  CURSOR get_valid_assets (p_gaz_query_id number )IS
  SELECT * FROM (
  SELECT iit_ne_id
       ,iit_inv_type
       ,iit_admin_unit 
   FROM nm_gaz_query_item_list, nm_inv_items
   WHERE iit_ne_id = ngqi_item_id
   AND ngqi_job_id = p_gaz_query_id);
   
BEGIN
nm_debug.debug_on;
-- Get Gri Params and set the globals
   
   set_params(p_gri_id);
   
   set_asset_params(p_gri_id);
   
   set_date_params(p_gri_id);
   
   hig_process_api.log_it('Generating Inspections By Date. Initiated By '||user||' Based On The Following Parameters:');
   hig_process_api.log_it('Assets Types: '||g_asset_type_log);
   hig_process_api.log_it('Inspection Type: '||g_insp_type);
   hig_process_api.log_it('Region of Interest: '||nm3net.get_ne_unique( p_ne_id => g_source_ne_id) );
   hig_process_api.log_it('For Dates: '||g_date_1||'  '||g_date_2||'  '||g_date_3||'  '||g_date_4||'  '||g_date_5||'  '||g_date_6||'  '||g_date_7||'  '||g_date_8||'  '||g_date_9||'  '||g_date_10);
   
  
-- Create and run the gaz query so we can loop through potential assets 
   l_gaz_query_id := create_gaz_query;
   
   FOR i IN get_valid_assets(l_gaz_query_id) LOOP
      
      IF g_date_1 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_1
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');
         
      END IF;                                        
      
     IF g_date_2 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_2
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_3 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_3
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_4 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_4
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_5 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_5
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_6 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_6
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_7 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_7
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_8 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_8
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
      
      IF g_date_9 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_9
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');
      END IF;
      
      IF g_date_10 IS NOT NULL THEN
      
         l_insp_id := create_inspection (p_admin_unit      => i.iit_admin_unit                    
                                        ,pf_insp_type      => g_insp_type
                                        ,pf_insp_source    => 'SCHEDULED'
                                        ,pf_asset_type     => i.iit_inv_type
                                        ,pf_insp_date_due  => g_date_10
                                        ,pf_insp_parent_id => i.iit_ne_id
                                        ,pf_module         => 'MAI3710');

      END IF;
   
   END LOOP;
   
    
END mai3710; 
--
-----------------------------------------------------------------------------
--  
PROCEDURE mai3720 (p_gri_id NUMBER) IS

   l_gaz_query_id  NUMBER ;
 
  CURSOR get_valid_assets (p_gaz_query_id NUMBER
                          ,p_insp_type VARCHAR2 )IS
  SELECT b.iit_inv_type, b.iit_ne_id parent_id, C.INSP_TYPE, C.IIT_NE_ID insp_id, c.insp_date_due
   FROM nm_gaz_query_item_list a, nm_inv_items b, v_nm_insp c 
   WHERE b.iit_ne_id = a.ngqi_item_id
   AND a.ngqi_job_id = p_gaz_query_id 
   and b.iit_ne_id = c.insp_parent_id
   and c.insp_type = p_insp_type
   and c.insp_batch_id is NULL;
 
BEGIN
nm_debug.debug_on;
-- Get Gri Params and set the globals
   set_params(p_gri_id);
 
   set_asset_params(p_gri_id);
   
   hig_process_api.log_it('Generating Inspection Batches Initiated By '||user||' Based On The Following Parameters:');
   hig_process_api.log_it('Assets Types: '||g_asset_type_log);
   hig_process_api.log_it('Inspection Type: '||g_insp_type);
   hig_process_api.log_it('Region of Interest: '||nm3net.get_ne_unique( p_ne_id => g_source_ne_id) );
   hig_process_api.log_it('From Date: '||g_from_date);
   hig_process_api.log_it('To Date: '||g_to_date);
   hig_process_api.log_it('Download Immediately: '||g_yes_no);
  
-- Create and run the gaz query so we can loop through potential assets 
   l_gaz_query_id := create_gaz_query;

   select ASSET_INSP_BATCH_SEQ.nextval INTO g_batch_id from dual;
   
   FOR i in get_valid_assets(l_gaz_query_id,g_insp_type) loop   -- Loop throught the valid assets looking for inspections that should be part of the batch
   
      
      IF i.insp_date_due >= g_from_date AND i.insp_date_due <= g_to_date THEN
      
         -- add to batch
         add_to_batch (p_insp_id => i.insp_id);
         
         hig_process_api.log_it('Parent Asset:'||i.iit_inv_type||' '||i.parent_id||' Inspection '||i.insp_type||' '||i.insp_id||' Due On '||i.insp_date_due||' Added To Batch '||g_batch_id);      
         
      
      END IF;
   
     
   END LOOP;

   IF g_yes_no = 'Y' THEN
       
      hig_process_api.log_it('Downloading Inspection Batch');
      
      create_mci_files (p_batch_id => g_batch_id);
   
   END IF;
      
END mai3720; 
--
-----------------------------------------------------------------------------
--  
PROCEDURE mai3730 (p_gri_id NUMBER) IS

  
BEGIN
nm_debug.debug_on;
-- Get Gri Params and set the globals
   set_params(p_gri_id);
 
      
   hig_process_api.log_it('Downloading Inspection Batches Initiated By '||user||' Based On The Following Parameters:');
   hig_process_api.log_it('Batch ID: '||g_batch_id);
   
   create_mci_files (p_batch_id => g_batch_id);
   
   
END mai3730; 
--
-----------------------------------------------------------------------------
--  
PROCEDURE initialise IS

   l_tab_process_params      hig_process_api.tab_process_params;
   l_gri_value VARCHAR2(20);
   l_module    VARCHAR2(20);

BEGIN

   -- get the gri param
   l_tab_process_params := hig_process_api.get_current_process_params;
  
   IF l_tab_process_params.COUNT > 0 THEN
    
      l_gri_value     := l_tab_process_params(1).hpp_param_value;
      l_module        := l_tab_process_params(2).hpp_param_value;
   
   END IF;
  
   -- call main body
   IF l_module = 'MAI3700' THEN
      
      MAI3700(l_gri_value);
   
      IF g_asset_processed = 0 THEN
      
         hig_process_api.log_it('No Inspections Generated Based On The Criteria Provided');
   
      END IF;
   
      IF g_schedule_errors THEN

         hig_process_api.log_it('ERRORS OCCURRED DURING INSPECTION SCHEDULE GENERATION');
         hig_process_api.log_it('Review The Log For Details');
         --hig_process_api.process_execution_end(pi_success_flag => 'N');    -- Need to speak tp Colin abou this, do we want o flag as fail if only one out of 100 has failed to create?

      ELSE

         hig_process_api.log_it('Inspection Schedule Successfully Generated.');

      END IF;
      
   ELSIF l_module = 'MAI3710' THEN
     
      MAI3710(l_gri_value);

   ELSIF l_module = 'MAI3720' THEN
     
      MAI3720(l_gri_value);
      
   ELSIF l_module = 'MAI3730' THEN 
   
      MAI3730(l_gri_value);
         
   END IF;
   
   
END initialise;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_inspections (p_insp_rec v_ha_upd_insp%ROWTYPE) IS

   upd_insp_rec_data    v_ha_upd_insp%ROWTYPE;
   static_insp_rec_data v_nm_insp%ROWTYPE;

   l_chk number;

   CURSOR chk_insp_rec (p_insp_id v_nm_insp.iit_ne_id%TYPE
                       ,p_parent_id v_nm_insp.insp_parent_id%TYPE ) IS
   SELECT * FROM v_nm_insp
   WHERE iit_ne_id = p_insp_id
   AND insp_parent_id = p_parent_id;
   
   parent_or_insp_not_exist    EXCEPTION;
--
--THis is the update procedure called when a file is loaded using the INSPECTIONS_UPDATE csv loader
--
BEGIN

   upd_insp_rec_data := p_insp_rec;
  
   -- Lets check the data

   -- Check the parent and inspection id's combination is valid
   OPEN chk_insp_rec(upd_insp_rec_data.insp_primary_key, upd_insp_rec_data.parent_id);
   FETCH chk_insp_rec INTO static_insp_rec_data;
   IF chk_insp_rec%NOTFOUND THEN
   
      close chk_insp_rec;
      RAISE parent_or_insp_not_exist;
   
   END IF;
   CLOSE chk_insp_rec;

   -- If we've got this far it's ok to update the Inspection
   nm3api_inv_insp.upd_attr (pf_insp_def_found_flag    => upd_insp_rec_data.insp_def_found_yn
                            ,pf_insp_inspected_flag    => upd_insp_rec_data.insp_inspected_yn
                            ,pf_insp_condition         => upd_insp_rec_data.insp_condition
                            ,pf_insp_not_insp_reason   => upd_insp_rec_data.insp_reason_not_insp
                            ,pf_insp_condition_comment => upd_insp_rec_data.insp_cond_comment
                            ,pf_insp_date_inspected    => upd_insp_rec_data.insp_date_inspected
                            -- The above attributes need updating with the supplied Inspection data
                           --The next set are the current values of the record, if not passed the update would set them to null
                            ,p_iit_ne_id               => static_insp_rec_data.iit_ne_id
                            ,pf_insp_parent_id         => static_insp_rec_data.insp_parent_id
                            ,pf_insp_type              => static_insp_rec_data.insp_type
                            ,pf_insp_source            => static_insp_rec_data.insp_source
                            ,pf_asset_type             => static_insp_rec_data.asset_type
                            ,pf_insp_date_due          => static_insp_rec_data.insp_date_due
                            ,pf_insp_batch_id          => static_insp_rec_data.insp_batch_id
                           );
                   

    hig_process_api.log_it('Inspection '||upd_insp_rec_data.insp_primary_key||' details updated');
    -- Now lets update the Parents inspected date
    -- IF inspected flag is Y then update the parent
    IF upd_insp_rec_data.insp_inspected_yn = 'Y' THEN

       IF static_insp_rec_data.insp_type = 'TYPE 1' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB86 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;

       ELSIF static_insp_rec_data.insp_type = 'TYPE 2' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB87 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;

       ELSIF static_insp_rec_data.insp_type = 'TYPE 3' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB88 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
          
       ELSIF static_insp_rec_data.insp_type = 'TYPE 4' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB89 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;

       ELSIF static_insp_rec_data.insp_type = 'TYPE 5' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB90 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;

       ELSIF static_insp_rec_data.insp_type = 'TYPE 6' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB91 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
          
       ELSIF static_insp_rec_data.insp_type = 'TYPE 7' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB92 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
          
       ELSIF static_insp_rec_data.insp_type = 'TYPE 8' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB93 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
          
       ELSIF static_insp_rec_data.insp_type = 'TYPE 9' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB94 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
       
       ELSIF static_insp_rec_data.insp_type = 'TYPE 10' THEN

          UPDATE nm_inv_items_all
          SET IIT_DATE_ATTRIB95 = upd_insp_rec_data.insp_date_inspected
          WHERE iit_ne_id  = upd_insp_rec_data.parent_id
          AND iit_inv_type = static_insp_rec_data.asset_type;
                 
       END IF;
   
       hig_process_api.log_it(static_insp_rec_data.asset_type||' Asset '||upd_insp_rec_data.parent_id||' Last Date Inspected Updated '||upd_insp_rec_data.insp_date_inspected);
   
   END IF;

COMMIT;

EXCEPTION WHEN parent_or_insp_not_exist THEN

   g_csv_errors := TRUE;

   hig_process_api.log_it(pi_message =>'Inspection/Parent ID Combination Is Invalid. Check Log files For Details'
                         ,pi_message_type => 'E');
   
   RAISE_APPLICATION_ERROR(-20001,'Inspection/Parent ID combination is invalid');
                            
                       
WHEN OTHERS THEN
   
   g_csv_errors := TRUE;   
   
   hig_process_api.log_it(pi_message =>'Record Failed To Update. Please Review'
                         ,pi_message_type => 'E');
   
   RAISE_APPLICATION_ERROR(-20001,'Record Failed To Update.  Check Log files For Details'); 
                       

END update_inspections;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_batch (p_insp_id v_nm_insp.iit_ne_id%TYPE) IS

   CURSOR get_insp_rec (pc_insp_id v_nm_insp.iit_ne_id%TYPE
                        ) IS
   SELECT * FROM v_nm_insp
   WHERE iit_ne_id = pc_insp_id;
   
   static_insp_rec_data v_nm_insp%ROWTYPE;
    
BEGIN

   
   OPEN get_insp_rec(p_insp_id);
   FETCH get_insp_rec INTO static_insp_rec_data;
   CLOSE get_insp_rec;

   -- If we've got this far it's ok to update the Inspection
   nm3api_inv_insp.upd_attr (pf_insp_batch_id          => g_batch_id
                           -- The above attributes need updating with the supplied Inspection data
                           --The next set are the current values of the record, if not passed the update would set them to null
                            ,p_iit_ne_id               => static_insp_rec_data.iit_ne_id
                            ,pf_insp_parent_id         => static_insp_rec_data.insp_parent_id
                            ,pf_insp_type              => static_insp_rec_data.insp_type
                            ,pf_insp_source            => static_insp_rec_data.insp_source
                            ,pf_asset_type             => static_insp_rec_data.asset_type
                            ,pf_insp_date_due          => static_insp_rec_data.insp_date_due
                            ,pf_insp_def_found_flag    => static_insp_rec_data.insp_def_found_flag
                            ,pf_insp_inspected_flag    => static_insp_rec_data.insp_inspected_flag
                            ,pf_insp_condition         => static_insp_rec_data.insp_condition
                            ,pf_insp_not_insp_reason   => static_insp_rec_data.insp_not_insp_reason
                            ,pf_insp_condition_comment => static_insp_rec_data.insp_condition_comment
                            ,pf_insp_date_inspected    => static_insp_rec_data.insp_date_inspected                            
                           );

   commit;
   
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_mci_files (p_batch_id NUMBER) IS

   l_session_id NUMBER;

   CURSOR get_batch_items(p_batch_id NUMBER) IS
   SELECT * FROM v_nm_insp
   WHERE insp_batch_id = p_batch_id;

BEGIN

   l_session_id := higgis.get_session_id;

   FOR i IN get_batch_items(p_batch_id) LOOP
   
          --insert data into interface table
      INSERT INTO gis_data_objects
      (
      gdo_session_id,
      gdo_pk_id,
      gdo_theme_name
      )      
      VALUES
      (
      l_session_id
      ,i.iit_ne_id
      ,'V_MCP_EXTRACT_INSP'
      );
   
   END LOOP;

   commit;
         
   nm3mcp_sde.locator_extract ( l_session_id );  
   
    hig_process_api.log_it('Inspection Batch Download Files Created');          

End create_mci_files;
--
-----------------------------------------------------------------------------
--
PROCEDURE csv_update_processing IS

   t_insp_files   nm3file.file_list;
   t_log_files    nm3file.file_list;
   t_bad_files    nm3file.file_list;
   l_batch_no     NUMBER;
   l_errno        NUMBER;
   l_errmess      VARCHAR2(2000) ;

   FUNCTION get_load_file_id(p_nlf_unique nm_load_files.nlf_unique%TYPE) RETURN NUMBER IS
   
      CURSOR get_data (p_unique VARCHAR2)IS
      SELECT nlf_id FROM nm_load_files
      WHERE nlf_unique = p_unique;
      
      l_nlf_id nm_load_files.nlf_id%TYPE;
      
   BEGIN
   
     OPEN get_data(p_nlf_unique);
     FETCH get_data INTO l_nlf_id;
     CLOSE get_data;
    
     RETURN l_nlf_id;
   
   END get_load_file_id;
      
BEGIN

   t_insp_files := nm3file.get_wildcard_files_in_dir(nm3file.get_true_dir_name('ASSET_INSPECTIONS_UPLOAD', TRUE ), '*.csv');

   IF t_insp_files.COUNT > 0 THEN
   
      FOR i IN 1..t_insp_files.COUNT LOOP
         
         -- Start the csv load. This moves the file into the holding table         
         l_batch_no := nm3load.transfer_to_holding (p_nlf_id       => get_load_file_id('INSPECTIONS_UPDATE')
                                                   ,p_file_name    => t_insp_files(i)
                                                   ,p_batch_source => 'S'
                                                   );
         
         hig_process_api.log_it('Batch Number: '||l_batch_no);                                           
         hig_process_api.log_it('Processing File: '||t_insp_files(i));
         
         --Now lets actully load the data    
         nm3load.load_batch (p_batch_no => l_batch_no);
         
         IF g_csv_errors = TRUE THEN
            -- Produce the log and bad files
            nm3load.produce_log_files ( p_nlb_batch_no  => l_batch_no);
            
            -- NOw move the files to faild folder
            -- Starting with the original csv - appended with the batch number                            
            nm3file.move_file ( pi_from_file  => t_insp_files(i)
                              , pi_from_loc   => 'ASSET_INSPECTIONS_UPLOAD'
                              , pi_to_file    => l_batch_no||'_'||t_insp_files(i)      -- rename the file with the batch id
                              , pi_to_loc     => 'ASSET_INSPECTIONS_FAILED'
                              , pi_use_hig    => true
                              , po_err_no     => l_errno
                              , po_err_mess   => l_errmess
                              );    
            
            IF l_errno IS NOT NULL THEN
               hig_process_api.log_it(l_errno);
               hig_process_api.log_it(l_errmess);
            END IF;
           
            ---Now lets move the log file 
            t_log_files := nm3file.get_wildcard_files_in_dir(nm3file.get_true_dir_name('ASSET_INSPECTIONS_UPLOAD', TRUE ), '*.log');
            
            FOR i IN 1..t_log_files.COUNT LOOP
            
               nm3file.move_file ( pi_from_file  => t_log_files(i)
                              , pi_from_loc   => 'ASSET_INSPECTIONS_UPLOAD'
                              , pi_to_file    => t_log_files(i)
                              , pi_to_loc     => 'ASSET_INSPECTIONS_FAILED'
                              , pi_use_hig    => true
                              , po_err_no     => l_errno
                              , po_err_mess   => l_errmess
                              );    
            
               IF l_errno IS NOT NULL THEN
                  hig_process_api.log_it(l_errno);
                  hig_process_api.log_it(l_errmess);
               END IF;
               
               hig_process_api.log_it('Log File '||t_log_files(i)||' Generated');
               
            END LOOP;
               
            ---Now lets move the bad file 
            t_bad_files := nm3file.get_wildcard_files_in_dir(nm3file.get_true_dir_name('ASSET_INSPECTIONS_UPLOAD', TRUE ), '*.bad');
            
            FOR i IN 1..t_bad_files.COUNT LOOP
            
               nm3file.move_file ( pi_from_file  => t_bad_files(i)
                              , pi_from_loc   => 'ASSET_INSPECTIONS_UPLOAD'
                              , pi_to_file    => t_bad_files(i)
                              , pi_to_loc     => 'ASSET_INSPECTIONS_FAILED'
                              , pi_use_hig    => true
                              , po_err_no     => l_errno
                              , po_err_mess   => l_errmess
                              );    
            
               IF l_errno IS NOT NULL THEN
                  hig_process_api.log_it(l_errno);
                  hig_process_api.log_it(l_errmess);
               END IF;
            
               hig_process_api.log_it('Bad file '||t_bad_files(i)||' Generated');
               
            END LOOP; 
            
            g_csv_errors := FALSE; -- Reset failure flag
         
         ELSE
            
            nm3file.move_file ( pi_from_file  => t_insp_files(i)
                              , pi_from_loc   => 'ASSET_INSPECTIONS_UPLOAD'
                              , pi_to_file    => l_batch_no||'_'||t_insp_files(i)      -- rename the file with the batch id
                              , pi_to_loc     => 'ASSET_INSPECTIONS_PROCESSED'
                              , pi_use_hig    => true
                              , po_err_no     => l_errno
                              , po_err_mess   => l_errmess
                              );    
      
            IF l_errno IS NOT NULL THEN
               hig_process_api.log_it(l_errno);
               hig_process_api.log_it(l_errmess);
            END IF;
            
         END IF;
                          
      END LOOP;
   
   ELSE
   
      hig_process_api.log_it('No Files To Process');
             
   END IF;
    

END csv_update_processing;
--
-----------------------------------------------------------------------------
--
END HA_INSP;
/