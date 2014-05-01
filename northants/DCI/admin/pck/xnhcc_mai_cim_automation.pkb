CREATE OR REPLACE PACKAGE BODY xnhcc_mai_cim_automation
AS
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/northants/DCI/admin/pck/xnhcc_mai_cim_automation.pkb-arc   1.0   May 01 2014 09:59:00   Mike.Huitson  $
--       Module Name      : $Workfile:   xnhcc_mai_cim_automation.pkb  $
--       Date into PVCS   : $Date:   May 01 2014 09:59:00  $
--       Date fetched Out : $Modtime:   Apr 24 2014 17:12:14  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$ $';

  g_package_name CONSTANT varchar2(30) := 'xnhcc_mai_cim_automation';
  l_failed       Varchar2(1) ;
  l_found        Varchar2(1);
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
PROCEDURE run_batch(pi_batch_type Varchar2)
IS
--
   l_file_name  Varchar2(100);
   l_continue_rec    hig_ftp_connections%ROWTYPE;
   l_conn       utl_tcp.connection;
   l_arc_conn   utl_tcp.connection;
   l_cnt        Number;
   l_file_tab   nm3ftp.t_string_table ;
   l_flist      nm3file.file_list;
   l_tmp        Varchar2(100);
   l_path       varchar2(100) ; 
   l_error      Varchar2(32767);
   l_er_error   interface_erroneous_records.ier_error%TYPE;
   l_ih_id      interface_headers.ih_id%TYPE;   
   l_err_no     Integer;
   l_process_id Number := hig_process_api.get_current_process_id;   
   l_msg        Varchar2(500) ;
   l_ih_rec     interface_headers%ROWTYPE ;
   l_wor_count  Number ;
   l_continue   Boolean ;
   l_hpal_rec   hig_process_alert_log%ROWTYPE;
   l_hp_rec     hig_processes%ROWTYPE;   
   CURSOR c_get_dir_path
   IS
   SELECT hdir_path 
   FROM   hig_directories
   WHERE  hdir_name = 'CIM_DIR';  
   CURSOR c_con_details(qp_contractor_id Varchar2)
   IS
   SELECT oun_org_id
         ,oun_name
         ,con_code
         ,con_name
         ,oun_contractor_id
         ,nau_unit_code
         ,nau_admin_unit
         ,con_id
   FROM  org_units 
        ,contracts
        ,nm_admin_units 
   WHERE oun_contractor_id = qp_contractor_id
   AND   oun_org_id        = con_contr_org_id 
   AND   con_admin_org_id = nau_admin_unit;
   l_con_details_rec c_con_details%ROWTYPE;   
   CURSOR c_get_ih (qp_ih_id interface_headers.ih_id%TYPE)
   IS
   SELECT * 
   FROM   interface_headers
   WHERE  ih_id = qp_ih_id ;
   PROCEDURE run_comp_file(pi_contractor_id Varchar2
                          ,pi_file_name     Varchar2)
   IS   
   --
      l_ih_id     interface_headers.ih_id%TYPE;
      l_error     Varchar2(32767);
	  l_continue  boolean := TRUE;
      l_er_error  interface_erroneous_records.ier_error%TYPE;
   --
   BEGIN
   --
      hig_process_api.log_it(pi_process_id => l_process_id
                            ,pi_message    => 'Loading File '||pi_file_name);
      OPEN  c_con_details(pi_contractor_id) ;
      FETCH c_con_details INTO l_con_details_rec;
      CLOSE c_con_details ;
      xnhcc_interfaces.completion_file_ph1(pi_contractor_id
                                    ,Null
                                    ,Null
                                    ,pi_file_name
                                    ,l_error); 
      IF Sys_Context('NM3SQL','CIM_IH_ID') IS NOT NULL
      THEN
          l_ih_id := Sys_Context('NM3SQL','CIM_IH_ID') ;
          xnhcc_interfaces.auto_load_file(l_ih_id
                                   ,Null
                                   ,l_er_error);
          hig_process_api.set_process_internal_reference(pi_internal_reference => l_ih_id);
          OPEN  c_get_ih(l_ih_id);
          FETCH c_get_ih INTO l_ih_rec ;
          CLOSE c_get_ih ;
          SELECT Count(0) INTO l_wor_count
          FROM interface_completions_all WHERE ic_ih_id = l_ih_id ;
          hig_process_api.log_it(pi_process_id   => l_process_id
                                ,pi_message      => 'Total Defects Processed : '||l_wor_count
                                ,pi_summary_flag => 'Y' );
          SELECT Count(0) INTO l_wor_count
          FROM interface_completions WHERE ic_ih_id = l_ih_id ;
          IF Nvl(l_wor_count,0) > 0
          THEN 
              hig_process_api.log_it(pi_process_id   => l_process_id
                                    ,pi_message      => 'Total Defects Rejected :'||l_wor_count
                                    ,pi_message_type => 'E'
                                    ,pi_summary_flag => 'Y' );
          END IF ;
          FOR i IN (SELECT * FROM interface_completions WHERE ic_ih_id = l_ih_id )
          LOOP
              hig_process_api.log_it(pi_process_id   => l_process_id
                                    ,pi_message      => i.ic_defect_id||' : '||i.ic_error
                                    ,pi_message_type => 'E'
                                    ,pi_summary_flag => 'N' );
          END LOOP;
          FOR i IN (SELECT * FROM interface_erroneous_records WHERE ier_ih_id = l_ih_id )
          LOOP
              hig_process_api.log_it(pi_process_id   => l_process_id
                                    ,pi_message      => i.ier_record_text||' : '||i.ier_error
                                    ,pi_message_type => 'E'
                                    ,pi_summary_flag => 'N' );
          END LOOP;
          IF  l_ih_rec.ih_status IS NULL
          THEN
              l_msg := 'Loading file '||pi_file_name||' : Completed Successfully';
          ELSE
              l_msg := 'Loading file '||pi_file_name||' failed '|| l_ih_rec.ih_error;
              l_failed := 'Y' ;
          END IF ;
      ELSE  
          IF l_error IS NOT NULL	
          THEN		  
             l_msg :=     'Error while loading file '||pi_file_name;
             l_failed := 'Y' ;
		  END IF;
      END IF ;      
      hig_process_api.log_it(pi_process_id   => l_process_id
                            ,pi_message      => l_msg
                            ,pi_summary_flag => 'Y' );
      -- clb 12102011 Task 0111514 nm3file.move_file(pi_file_name,'CIM_DIR',pi_file_name,'CIM_ARC',null,TRUE,l_err_no,l_error);
	  BEGIN
		  nm3file.copy_file( pi_source_dir => 'CIM_DIR' 
						   , pi_source_file => pi_file_name 
						   , pi_destination_dir => 'CIM_ARC' 
						   , pi_destination_file => pi_file_name 
						   , pi_overwrite => TRUE 
						   , pi_leave_original => TRUE );

	      nm3file.delete_file (nm3file.get_path('CIM_DIR'),pi_file_name); 

	  EXCEPTION
		  WHEN OTHERS THEN
			  l_continue  := FALSE ;	  
			  l_failed    := 'Y' ;
			  hig_process_api.log_it(pi_process_id   => l_process_id
									,pi_message      => 'Following error occurred while archiving the WC file '||pi_file_name||' '||sqlerrm
									,pi_message_type => 'E'
									,pi_summary_flag => 'Y' );  
      END;
	  
      IF l_continue
	  THEN
          hig_process_api.log_it(pi_process_id => l_process_id
                                ,pi_message    => 'WC file '||pi_file_name||' archived on the Database server');
      END IF ;

   --
   END run_comp_file;
   --
   PROCEDURE run_claim_file(pi_contractor_id Varchar2
                           ,pi_file_name     Varchar2)
   IS
   --
      CURSOR c_col_claim_val (p_wol_id interface_claims_wol_all.icwol_wol_id%TYPE,
                              p_ih_id interface_claims_wor_all.icwor_ih_id%TYPE) 
      IS
      SELECT icwol_claim_value  
      FROM   interface_claims_wol_all
      WHERE  icwol_wol_id = p_wol_id
        AND  icwol_ih_id = p_ih_id;
        
      lv_wol_act             work_order_lines.wol_act_cost%TYPE;
      lv_icwol_claim_value   interface_claims_wor_all.icwor_works_order_no%TYPE;
      l_error                Varchar2(32767);
	  l_continue             boolean := TRUE;
      l_fd_file              Varchar2(200) ;   
   --
   BEGIN
   --

      hig_process_api.log_it(pi_process_id => l_process_id
                            ,pi_message    => 'Loading File '||pi_file_name); 
      interfaces.claim_file_ph1(pi_contractor_id
                               ,Null
                               ,Null
                               ,pi_file_name
                               ,l_error);
      OPEN  c_con_details(pi_contractor_id) ;
      FETCH c_con_details INTO l_con_details_rec;
      CLOSE c_con_details ;      
      IF Sys_Context('NM3SQL','CIM_WI_IH_ID') IS NOT NULL
      THEN
      
          l_ih_id := Sys_Context('NM3SQL','CIM_WI_IH_ID') ;
      
          interfaces.claim_file_ph2(l_ih_id , l_fd_file, l_error);

          hig_process_api.set_process_internal_reference(pi_internal_reference => l_ih_id);
          OPEN  c_get_ih(l_ih_id);
          FETCH c_get_ih INTO l_ih_rec ;
          CLOSE c_get_ih ;
          SELECT Count(0) INTO l_wor_count
          FROM interface_claims_wor_all WHERE icwor_ih_id = l_ih_id ;
          hig_process_api.log_it(pi_process_id   => l_process_id
                                ,pi_message      => 'Total Work Orders Processed : '||l_wor_count
                                ,pi_summary_flag => 'Y' );
          SELECT Count(0) INTO l_wor_count
          FROM interface_claims_wor WHERE icwor_ih_id = l_ih_id ;
          IF Nvl(l_wor_count,0) > 0
          THEN 
              hig_process_api.log_it(pi_process_id   => l_process_id
                                    ,pi_message      => 'Total Work Orders Rejected :'||l_wor_count
                                    ,pi_message_type => 'E'
                                    ,pi_summary_flag => 'Y' );
          END IF ;
          FOR i IN (SELECT * FROM interface_claims_wor WHERE icwor_ih_id = l_ih_id )
          LOOP
              hig_process_api.log_it(pi_process_id   => l_process_id
                                    ,pi_message      => i.icwor_works_order_no||' : '||i.icwor_error
                                    ,pi_message_type => 'E'
                                    ,pi_summary_flag => 'N' );
          END LOOP;
          IF  l_ih_rec.ih_status IS NULL
          THEN
              l_msg := 'Loading file '||pi_file_name||' : Completed Successfully';
          ELSE
              l_msg := 'Loading file '||pi_file_name||' failed '|| l_ih_rec.ih_error;
              l_failed := 'Y' ;
          END IF ;
      ELSE    
          l_msg :=     'Error while loading file '||pi_file_name;
          l_failed := 'Y' ;
      END IF ;
      hig_process_api.log_it(pi_process_id   => l_process_id
                            ,pi_message      => l_msg
                            ,pi_summary_flag => 'Y' ); 
      -- clb 12102011 Task 0111514 nm3file.move_file(pi_file_name,'CIM_DIR',pi_file_name,'CIM_ARC',null,TRUE,l_err_no,l_error);
	  BEGIN
		  nm3file.copy_file( pi_source_dir => 'CIM_DIR' 
						   , pi_source_file => pi_file_name 
						   , pi_destination_dir => 'CIM_ARC' 
						   , pi_destination_file => pi_file_name 
						   , pi_overwrite => TRUE 
						   , pi_leave_original => TRUE );

	      nm3file.delete_file (nm3file.get_path('CIM_DIR'),pi_file_name); 
	  EXCEPTION
		  WHEN OTHERS THEN
			  l_continue  := FALSE ;	  
			  l_failed    := 'Y' ;
			  hig_process_api.log_it(pi_process_id   => l_process_id
									,pi_message      => 'Following error occurred while archiving the WI file '||pi_file_name||' '||sqlerrm
									,pi_message_type => 'E'
									,pi_summary_flag => 'Y' );                                     
      END;
	  
	  IF l_continue
	  THEN
          hig_process_api.log_it(pi_process_id => l_process_id
                                ,pi_message    => 'WI file '||pi_file_name||' archived on the Database server');
      END IF ;
   --
   END run_claim_file ;
--
BEGIN
--
   --Get oracle dir path into varibale
   OPEN  c_get_dir_path;
   FETCH c_get_dir_path INTO l_path;
   CLOSE c_get_dir_path;
   --loop through all the CIM contractors   
--nm_debug.debug_on;
   l_hp_rec := hig_process_framework.get_process(l_process_id);
   FOR oun IN (SELECT *
               FROM   org_units
               WHERE  oun_electronic_orders_flag = 'Y'
               AND    oun_org_id                 = Nvl(l_hp_rec.hp_area_id,oun_org_id)
               AND    oun_contractor_id IS NOT NULL)
   LOOP       
       IF pi_batch_type ='WO'
       THEN            
           BEGIN
           --
              SELECT Count(0)
              INTO   l_cnt
              FROM   interface_wor
                    ,contracts
                    ,org_units
              WHERE  iwor_con_code     = con_code
              AND    iwor_wo_run_number IS NULL
              AND    con_contr_org_id  = oun_org_id
              AND    oun_contractor_id = oun.oun_contractor_id ;              
              IF l_cnt > 0
              THEN
                  -- Create WO file      
                  l_found := 'Y' ;
                  OPEN  c_con_details(oun.oun_contractor_id) ;
                  FETCH c_con_details INTO l_con_details_rec;
                  CLOSE c_con_details ;
                  BEGIN
                     --                       
                     l_file_name := interfaces.write_wor_file(oun.oun_contractor_id,Null,Null);
                     IF l_file_name is NULL
                     THEN 
                         l_continue := False;
                         l_failed := 'Y' ;
                         hig_process_api.log_it(pi_process_id   => l_process_id
                                               ,pi_message      => sys_context('NM3SQL','CIM_ERROR_TEXT')
                                               ,pi_message_type => 'E');
                     ELSE                         
                         l_continue  := True ;
                         hig_process_api.log_it(pi_process_id => l_process_id
                                               ,pi_message    => 'Work Order Extract file '||l_file_name||' created  for Contractor '||oun.oun_contractor_id);
                     END IF ; 
                  --
                  Exception 
                      WHEN OTHERS THEN
                          l_continue  := False ;
                          hig_process_api.log_it(pi_process_id   => l_process_id
                                                ,pi_message      => 'Error while generating WO file for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                ,pi_message_type => 'E'
                                                ,pi_summary_flag => 'Y' );    
                  END ;
                  -- Check for FTP setp            
                  FOR ftp IN (SELECT ftp.* 
                              FROM   hig_process_conns_by_area ,hig_ftp_connections ftp
                              WHERE  hptc_process_type_id = l_hp_rec.hp_process_type_id 
                              AND    hptc_area_id_value   = Nvl(l_hp_rec.hp_area_id,oun.oun_org_id)
                              AND    hfc_id               = hptc_ftp_connection_id)
                  LOOP    
                      --l_continue_rec := get_ftp_details('CIM',oun.oun_contractor_id);
                  --IF  l_continue_rec.hfc_nau_unit_code IS NOT NULL
                  --AND l_continue  
                      IF l_continue
                      THEN
                         BEGIN
                         --
                            nm3ctx.set_context('NM3FTPPASSWORD','Y');
                            BEGIN
                               --
                               l_conn := nm3ftp.login(ftp.hfc_ftp_host,ftp.hfc_ftp_port,ftp.hfc_ftp_username,nm3ftp.get_password(ftp.hfc_ftp_password));
                               l_continue  := True ;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    l_continue  := False ;
                                    l_failed    := 'Y' ; 
                                    hig_process_api.log_it(pi_process_id   => l_process_id
                                                          ,pi_message      => 'Error while connecting to the FTP server for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                          ,pi_message_type => 'E'
                                                          ,pi_summary_flag => 'Y' );
                            END ;

							/*--------------------------
							|| Look for any WO files that may have failed transfer last time
							---------------------------*/
					        IF l_continue 
                            THEN
								BEGIN
								   -- 
									  l_flist := nm3file.get_wildcard_files_in_dir (l_path,'WO*.'||Upper(oun.oun_contractor_id));
								   --
								EXCEPTION
								   WHEN OTHERS THEN
									   hig_process_api.log_it(pi_process_id => l_process_id
															 ,pi_message    => 'Error while identifying WO files for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
															 ,pi_summary_flag => 'Y' ); 
							    END ;
							END IF;

							IF l_continue 
                            THEN
								FOR i IN 1..l_flist.Count
								LOOP
								   BEGIN
								       --
									   IF l_file_name != Trim(l_flist(i)) 
									   THEN
										   hig_process_api.log_it(pi_process_id => l_process_id
																 ,pi_message    => 'Re-attempting FTP transfer of Work Order Extract file '||Trim(l_flist(i)));
										   --   
									   END IF;
									   nm3ftp.put(l_conn,'CIM_DIR',Trim(l_flist(i)) ,ftp.hfc_ftp_out_dir||Trim(l_flist(i)) );
									   hig_process_api.log_it(pi_process_id => l_process_id
																 ,pi_message    => 'Work Order Extract file '||Trim(l_flist(i)) ||' copied to FTP location');
									   l_continue  := True ;
									EXCEPTION
										WHEN OTHERS THEN
											l_continue  := False ; 
											l_failed    := 'Y' ;
											hig_process_api.log_it(pi_process_id   => l_process_id
																  ,pi_message      => 'Following error occurred while copying the WO file to the FTP location for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
																  ,pi_message_type => 'E'
																  ,pi_summary_flag => 'Y' ); 
									END  ;            
									IF l_continue 
									THEN
										BEGIN
										   --                                       
										   -- clb 12102011 Task 0111514 nm3file.move_file(Trim(l_flist(i)) ,'CIM_DIR',Trim(l_flist(i)) ,'CIM_ARC',null,TRUE,l_err_no,l_error);
										   nm3file.copy_file( pi_source_dir => 'CIM_DIR' 
											 			    , pi_source_file => Trim(l_flist(i)) 
														    , pi_destination_dir => 'CIM_ARC' 
														    , pi_destination_file => Trim(l_flist(i)) 
														    , pi_overwrite => TRUE 
														    , pi_leave_original => TRUE );

	                                       nm3file.delete_file (nm3file.get_path('CIM_DIR'),Trim(l_flist(i))); 
										   
										 EXCEPTION
											WHEN OTHERS THEN
                                                l_continue := FALSE;
											    l_failed    := 'Y' ;
												hig_process_api.log_it(pi_process_id   => l_process_id
																	  ,pi_message      => 'Following error occurred while archiving the WO file '||Trim(l_flist(i)) ||' for Contractor '||oun.oun_contractor_id||' '||sqlerrm
																	  ,pi_message_type => 'E'
																	  ,pi_summary_flag => 'Y' );    
                                         END;
                                         										 
										 IF l_continue
										 THEN
											 hig_process_api.log_it(pi_process_id => l_process_id
																   ,pi_message    => 'Work Order Extract file '||Trim(l_flist(i)) ||' archived');
										 END IF ;
										 --
									END IF ;
								END LOOP;
                            END IF ;
                         --
                         EXCEPTION
                         WHEN OTHERS
                         THEN
                             nm3ftp.logout(l_conn);                             
                             Raise_Application_Error(-20001,'Error '||Sqlerrm);
                         END ;
                      END IF ;
                  END LOOP; -- Ftp Loop
                  nm3ftp.logout(l_conn);
              END IF ; 
           EXCEPTION
               WHEN OTHERS THEN
                   Raise_Application_Error(-20001,'Error '||Sqlerrm);
           END ; 
       ELSIF pi_batch_type ='WC'
       THEN
           l_file_name := Null ;
           l_tmp       := Null ;
           IF Nvl(l_hp_rec.hp_polling_flag,'N')= 'Y'
           THEN
               FOR ftp IN (SELECT ftp.* 
                           FROM   hig_process_conns_by_area ,hig_ftp_connections ftp
                           WHERE  hptc_process_type_id = l_hp_rec.hp_process_type_id 
                           AND    hptc_area_id_value   = Nvl(l_hp_rec.hp_area_id,oun.oun_org_id)
                           AND    hfc_id               = hptc_ftp_connection_id)
               LOOP
                   ---l_continue_rec := get_ftp_details('CIM',oun.oun_contractor_id);
                   --IF l_continue_rec.hfc_nau_unit_code IS NOT NULL
                   --THEN
                   BEGIN
                   --
                      nm3ctx.set_context('NM3FTPPASSWORD','Y');
                      BEGIN
                         --
                         l_conn := nm3ftp.login(ftp.hfc_ftp_host,ftp.hfc_ftp_port,ftp.hfc_ftp_username,nm3ftp.get_password(ftp.hfc_ftp_password));
                         l_continue := True;
                         --
                      EXCEPTION
                          WHEN OTHERS THEN
                              l_found := 'Y' ; 
                              l_continue := False;
                              hig_process_api.log_it(pi_process_id => l_process_id
                                                    ,pi_message    => 'Error while connecting to the FTP server for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                    ,pi_summary_flag => 'Y' ); 
                      END ;
                      IF l_continue 
                      THEN
                          nm3ftp.list(l_conn,ftp.hfc_ftp_in_dir, l_file_tab);
                          FOR i IN 1..l_file_tab.Count
                          LOOP
                              l_tmp := Null ; 
                              l_file_name := Null ; 
                              IF l_file_tab(i) IS NOT NULL
                              THEN
                                  l_tmp := Upper(l_file_tab(i)) ;
                                  IF l_tmp Like Upper('%WC%.'||oun.oun_contractor_id)
                                  THEN
                                      l_file_name := Substr(l_tmp,1,Instr(l_tmp,'.'||Upper(oun.oun_contractor_id),1,1)-1);
                                      l_file_name := Substr(l_file_name,Instr(l_file_name,' ',-1,1))||'.'||Upper(oun.oun_contractor_id);
                                  END IF ;
                              END IF;
                              IF l_file_name IS NOT NULL                          
                              THEN
                                  l_file_name := Trim(l_file_name);
                                  l_found := 'Y' ;
                                  BEGIN
                                     -- 
                                     nm3ftp.get(l_conn,ftp.hfc_ftp_in_dir||l_file_name,'CIM_DIR',l_file_name);
                                     nm3ftp.delete(l_conn,ftp.hfc_ftp_in_dir||l_file_name);
                                     l_continue := True;
                                     --
                                  EXCEPTION
                                      WHEN OTHERS THEN
                                          l_continue := False;
                                          hig_process_api.log_it(pi_process_id => l_process_id
                                                                ,pi_message    => 'Error while getting file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                ,pi_summary_flag => 'Y' ); 
                                  END ;
                                  IF l_continue 
                                  THEN                         
                                      BEGIN
                                         -- 
                                          run_comp_file(oun.oun_contractor_id,l_file_name);
                                          l_continue := True;
                                          --
                                      EXCEPTION
                                          WHEN OTHERS THEN
                                              l_continue := False;
                                              hig_process_api.log_it(pi_process_id => l_process_id
                                                                    ,pi_message    => 'Error while loading file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                    ,pi_summary_flag => 'Y' ); 
                                      END ;
                                  END IF ;
                                  IF l_continue
                                  THEN
                                      -- archive the file
                                      IF  ftp.hfc_ftp_arc_password IS NOT NULL
                                      AND ftp.hfc_ftp_arc_host IS NOT NULL
                                      AND ftp.hfc_ftp_arc_port IS NOT NULL
                                      AND ftp.hfc_ftp_arc_username IS NOT NULL
                                      AND ftp.hfc_ftp_arc_in_dir   IS NOT NULL
                                      THEN
                                      --
                                          IF ftp.hfc_ftp_arc_host      = ftp.hfc_ftp_host
                                          AND ftp.hfc_ftp_port         = ftp.hfc_ftp_arc_port
                                          AND ftp.hfc_ftp_arc_username = ftp.hfc_ftp_username
                                          THEN
                                              BEGIN
                                              --
                                                 IF l_continue
                                                 THEN   
                                                     nm3ftp.put(l_conn,'CIM_ARC',l_file_name,ftp.hfc_ftp_arc_in_dir||l_file_name);
                                                     l_continue := True;
                                                     hig_process_api.log_it(pi_process_id => l_process_id
                                                                           ,pi_message    => 'WC file '||l_file_name||' archived on the FTP server');
                                                 END IF ;
                                              --
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                      l_continue := False;
                                                      hig_process_api.log_it(pi_process_id => l_process_id
                                                                            ,pi_message    => 'Error while archiving file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                            ,pi_summary_flag => 'Y' ); 
                                              END ;
                                          ELSE
                                              BEGIN 
                                              --
                                                 nm3ctx.set_context('NM3FTPPASSWORD','Y');
                                                 BEGIN
                                                 --
                                                    l_arc_conn := nm3ftp.login(ftp.hfc_ftp_arc_host,ftp.hfc_ftp_arc_port,ftp.hfc_ftp_arc_username,nm3ftp.get_password(ftp.hfc_ftp_arc_password));
                                                    l_continue  := True ;
                                                    IF l_continue
                                                    THEN   
                                                        nm3ftp.put(l_arc_conn,'CIM_ARC',l_file_name,ftp.hfc_ftp_arc_in_dir||l_file_name);
                                                        l_continue := True;
                                                        hig_process_api.log_it(pi_process_id => l_process_id
                                                                              ,pi_message    => 'WC file '||l_file_name||' archived on the FTP server');
                                                    END IF ;
                                                    --
                                                 EXCEPTION
                                                     WHEN OTHERS THEN
                                                         l_continue := False;
                                                         hig_process_api.log_it(pi_process_id => l_process_id
                                                                               ,pi_message    => 'Error while archiving file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                               ,pi_summary_flag => 'Y' ); 
                                                 END ;    
                                                 nm3ftp.logout(l_arc_conn);
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                  l_continue  := False ;
                                                  l_failed    := 'Y' ; 
                                                  hig_process_api.log_it(pi_process_id   => l_process_id
                                                                        ,pi_message      => 'Error while connecting to the archiving FTP server for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                        ,pi_message_type => 'E'
                                                                        ,pi_summary_flag => 'Y' );
                                              END ;
                                          END IF ; 
                                      END IF ;                              
                                  END IF ;
                              END IF ; -- file name not null
                          END LOOP; -- loop through all the files in the ftp folder
                          nm3ftp.logout(l_conn);                 
                      END IF ; -- Valid connection 
                   --
                   EXCEPTION
                   WHEN OTHERS
                   THEN
                       nm3ftp.logout(l_conn);
                       Raise_Application_Error(-20001,'Error '||Sqlerrm);
                   END ;    
               END LOOP;
           ELSE
               BEGIN
               -- 
                  l_flist := nm3file.get_wildcard_files_in_dir (l_path,'WC*.'||Upper(oun.oun_contractor_id));
                  l_continue := True;
               --
               EXCEPTION
                   WHEN OTHERS THEN
                       l_continue := False;
                       hig_process_api.log_it(pi_process_id => l_process_id
                                             ,pi_message    => 'Error while searhing WC file for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                             ,pi_summary_flag => 'Y' ); 
               END ;
               IF l_continue 
               THEN
                   FOR i IN 1..l_flist.Count
                   LOOP
                       IF Trim(l_flist(i)) IS NOT NULL
                       THEN
                          l_found := 'Y' ;                        
                           BEGIN
                           --
                              run_comp_file(oun.oun_contractor_id,Trim(l_flist(i)));
                           --
                           EXCEPTION
                               WHEN OTHERS THEN
                               hig_process_api.log_it(pi_process_id => l_process_id
                                                     ,pi_message    => 'Error while loading file '||Trim(l_flist(i))||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                     ,pi_summary_flag => 'Y' ); 
                           END ;                            
                       END IF ;
                   END LOOP;
               END IF ;
           END IF; -- Ftp Setup available for Contractor
       ELSIF pi_batch_type = 'WI'
       THEN
           l_file_name := Null ;
           l_tmp       := Null ;
           IF Nvl(l_hp_rec.hp_polling_flag,'N')= 'Y'
           THEN
               FOR ftp IN (SELECT ftp.* 
                           FROM   hig_process_conns_by_area ,hig_ftp_connections ftp
                           WHERE  hptc_process_type_id = l_hp_rec.hp_process_type_id 
                           AND    hptc_area_id_value   = Nvl(l_hp_rec.hp_area_id,oun.oun_org_id)
                           AND    hfc_id               = hptc_ftp_connection_id)
               LOOP
               --l_continue_rec := get_ftp_details('CIM',oun.oun_contractor_id);
               --IF l_continue_rec.hfc_nau_unit_code IS NOT NULL
               --THEN
                   BEGIN
                   --
                      nm3ctx.set_context('NM3FTPPASSWORD','Y');
                      BEGIN
                         --
                         l_conn := nm3ftp.login(ftp.hfc_ftp_host,ftp.hfc_ftp_port,ftp.hfc_ftp_username,nm3ftp.get_password(ftp.hfc_ftp_password));
                         l_continue := True;
                         --
                      EXCEPTION
                          WHEN OTHERS THEN
                              l_found := 'Y' ;
                              l_continue := False;
                              hig_process_api.log_it(pi_process_id => l_process_id
                                                    ,pi_message    => 'Error while connecting to the FTP server for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                    ,pi_summary_flag => 'Y' );
                      END ;
                      IF l_continue 
                      THEN
                          nm3ftp.list(l_conn,ftp.hfc_ftp_in_dir, l_file_tab);
                          FOR i IN 1..l_file_tab.Count
                          LOOP
                              l_tmp := Null ; 
                              l_file_name := Null ;
                              IF l_file_tab(i) IS NOT NULL
                              THEN
                                  l_tmp := Upper(l_file_tab(i)) ;
                                  IF l_tmp Like Upper('%WI%.'||oun.oun_contractor_id)
                                  THEN
                                      l_file_name := Substr(l_tmp,1,Instr(l_tmp,'.'||Upper(oun.oun_contractor_id),1,1)-1);
                                      l_file_name := Substr(l_file_name,Instr(l_file_name,' ',-1,1))||'.'||Upper(oun.oun_contractor_id);
                                  END IF ;
                              END IF;
                              IF l_file_name IS NOT NULL
                              THEN
                                  l_file_name := Trim(l_file_name); 
                                  l_found := 'Y' ;
                                  BEGIN
                                  --
                                     nm3ftp.get(l_conn,ftp.hfc_ftp_in_dir||l_file_name,'CIM_DIR',l_file_name);      
                                     nm3ftp.delete(l_conn,ftp.hfc_ftp_in_dir||l_file_name);                    
                                     l_continue := True;
                                  --
                                  EXCEPTION
                                     WHEN OTHERS THEN
                                         l_continue := False;
                                         hig_process_api.log_it(pi_process_id => l_process_id
                                                               ,pi_message    => 'Error while getting file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                               ,pi_summary_flag => 'Y' );
                                  --
                                  END ;
                                  IF l_continue
                                  THEN
                                      BEGIN
                                      --  
                                         run_claim_file(oun.oun_contractor_id,l_file_name);    
                                         l_continue := True;
                                      --
                                      EXCEPTION
                                         WHEN OTHERS THEN
                                             l_continue := False;
                                             hig_process_api.log_it(pi_process_id => l_process_id
                                                                   ,pi_message    => 'Error while loading file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                   ,pi_summary_flag => 'Y' );
                                      --
                                      END ;
                                  END IF ;
                                  IF l_continue
                                  THEN
                                      -- archive the file
                                      IF  ftp.hfc_ftp_arc_password IS NOT NULL
                                      AND ftp.hfc_ftp_arc_host IS NOT NULL
                                      AND ftp.hfc_ftp_arc_port IS NOT NULL
                                      AND ftp.hfc_ftp_arc_username IS NOT NULL
                                      AND ftp.hfc_ftp_arc_in_dir   IS NOT NULL
                                      THEN
                                      --
                                          IF ftp.hfc_ftp_arc_host      = ftp.hfc_ftp_host
                                          AND ftp.hfc_ftp_port         = ftp.hfc_ftp_arc_port
                                          AND ftp.hfc_ftp_arc_username = ftp.hfc_ftp_username
                                          THEN
                                          --
                                              BEGIN
                                              --
                                                 IF l_continue
                                                 THEN   
                                                     nm3ftp.put(l_conn,'CIM_ARC',l_file_name,ftp.hfc_ftp_arc_in_dir||l_file_name);
                                                     l_continue := True;
                                                     hig_process_api.log_it(pi_process_id => l_process_id
                                                                           ,pi_message    => 'WI file '||l_file_name||' archived on the FTP server');
                                                 END IF ;
                                                 --
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                      l_continue := False;
                                                      hig_process_api.log_it(pi_process_id => l_process_id
                                                                            ,pi_message    => 'Error while archiving file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                            ,pi_summary_flag => 'Y' );
                                              END ;
                                          ELSE                                     
                                              BEGIN 
                                              --
                                                 nm3ctx.set_context('NM3FTPPASSWORD','Y');
                                                 BEGIN
                                                 --
                                                    l_arc_conn := nm3ftp.login(ftp.hfc_ftp_arc_host,ftp.hfc_ftp_arc_port,ftp.hfc_ftp_arc_username,nm3ftp.get_password(ftp.hfc_ftp_arc_password));
                                                    l_continue  := True ;
                                                    IF l_continue
                                                    THEN   
                                                        nm3ftp.put(l_arc_conn,'CIM_ARC',l_file_name,ftp.hfc_ftp_arc_in_dir||l_file_name);
                                                        l_continue := True;
                                                        hig_process_api.log_it(pi_process_id => l_process_id
                                                                              ,pi_message    => 'WI file '||l_file_name||' archived on the FTP server');
                                                    END IF ;
                                                    --
                                                 EXCEPTION
                                                     WHEN OTHERS THEN
                                                         l_continue := False;
                                                         hig_process_api.log_it(pi_process_id => l_process_id
                                                                               ,pi_message    => 'Error while archiving file '||l_file_name||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                               ,pi_summary_flag => 'Y' ); 
                                                 END ;   
                                                 nm3ftp.logout(l_arc_conn); 
                                              EXCEPTION
                                                  WHEN OTHERS THEN
                                                  l_continue  := False ;
                                                  l_failed    := 'Y' ; 
                                                  hig_process_api.log_it(pi_process_id   => l_process_id
                                                                        ,pi_message      => 'Error while connecting to the archiving FTP server for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                                        ,pi_message_type => 'E'
                                                                        ,pi_summary_flag => 'Y' );
                                              END ;
                                          END IF ;
                                      END IF ;
                                  END IF ;
                              END IF;
                          END LOOP; 
                          nm3ftp.logout(l_conn);                 
                      END IF ;  
                   --
                   EXCEPTION
                   WHEN OTHERS
                   THEN
                       nm3ftp.logout(l_conn);
                       Raise_Application_Error(-20001,'Error '||Sqlerrm);
                   END ;    
               END LOOP;
           ELSE
               BEGIN
               --
                  l_flist := nm3file.get_wildcard_files_in_dir (l_path,'WI*.'||Upper(oun.oun_contractor_id));
                  l_continue := True;
               --
               EXCEPTION
                   WHEN OTHERS THEN
                       l_continue := False;
                       hig_process_api.log_it(pi_process_id => l_process_id
                                             ,pi_message    => 'Error while searhing WI file for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                             ,pi_summary_flag => 'Y' ); 
               END ;
               IF l_continue 
               THEN
                   FOR i IN 1..l_flist.Count
                   LOOP
                       IF Trim(l_flist(i)) IS NOT NULL
                       THEN
                           l_found := 'Y' ;
                           BEGIN
                           --
                              run_claim_file(oun.oun_contractor_id,Trim(l_flist(i)));
                           --
                           EXCEPTION
                               WHEN OTHERS THEN
                               hig_process_api.log_it(pi_process_id => l_process_id
                                                     ,pi_message    => 'Error while loading file '||Trim(l_flist(i))||' for Contractor '||oun.oun_contractor_id||' '||Sqlerrm 
                                                     ,pi_summary_flag => 'Y' ); 
                           END ; 
                       END IF ;
                   END LOOP;
               END IF; 
           END IF ;
       END IF ; -- Batch Type 
   END LOOP;
   IF   Nvl(l_found,'N') = 'N'
   THEN
       hig_process_api.drop_execution;
   END IF ;
   IF   Nvl(l_failed,'N') ='Y'
   AND  l_process_id IS NOT NULL
   THEN
       hig_process_api.process_execution_end('N'); 
   END IF ;
--
END run_batch;
--
--FUNCTION get_ftp_details(pi_ftp_type Varchar2
--                        ,pi_contractor_id org_units.oun_contractor_id%TYPE)
--RETURN hig_ftp_connections%ROWTYPE 
--IS
---
--   CURSOR c_get_ftp_details
--   IS
--   SELECT hfc.*
--   FROM   hig_ftp_types hft
--         ,hig_ftp_connections hfc
--   WHERE  hfc_hft_id        = hft_id
--   AND    hft_type          = pi_ftp_type 
--   AND    hfc_nau_unit_code = pi_contractor_id ;
--
--   l_continue_rec hig_ftp_connections%ROWTYPE;
--
--BEGIN
--
--   OPEN  c_get_ftp_details;
--   FETCH c_get_ftp_details INTO l_continue_rec;
--   CLOSE c_get_ftp_details;

--   RETURN l_continue_rec ;
--
--END get_ftp_details ;
--
END xnhcc_mai_cim_automation;
/

