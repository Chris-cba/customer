create or replace package body XODOT_OHMS
as

procedure create_extract
as

begin
    create_submit_samples;
	TABLE_UPDATES;
    XODOT_POPULATE_OHMS_SECTIONS;   
	
end create_extract;


procedure create_submit_samples
as
    -- run the merge query
    L_MRG_ID NM_MRG_QUERY.NMQ_ID%TYPE;
    l_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE;

    begin
    
    select NMQ_ID into L_MRG_ID 
    from NM_MRG_QUERY_ALL
    where NMQ_UNIQUE = 'OHMS_EXTRACT';
    
    -- make sure the there are no merge jobs
    
    --  delete all OHMS merge jobs
   
    delete from nm_mrg_query_results_all 
    where NQR_NMQ_ID = L_MRG_ID;
    
    
    -- update the traff and HPPV years
     update  nm_mrg_query_values  
        set NQV_VALUE = (select max(AADT_YR) from v_nm_traf) 
        where NQV_NMQ_ID = L_MRG_ID
        and NQV_NQT_SEQ_NO = ( select   NQA_NQT_SEQ_NO
                                    from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
                                    where NQT_INV_TYPE = 'TRAF'
                                    and NQT_NMQ_ID =  L_MRG_ID
                                    and NQT_SEQ_NO = NQA_NQT_SEQ_NO
                                    and NQA_CONDITION is not null
                             )
        and NQV_ATTRIB_NAME = ( select   NQA_ATTRIB_NAME
                                    from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
                                    where NQT_INV_TYPE = 'TRAF'
                                    and NQT_NMQ_ID =  L_MRG_ID
                                    and NQT_SEQ_NO = NQA_NQT_SEQ_NO
                                    and NQA_CONDITION is not null
                              );
    
    
     update  nm_mrg_query_values  
        set NQV_VALUE = (select max(data_YR) from v_nm_hpms) 
        where NQV_NMQ_ID = L_MRG_ID
        and NQV_NQT_SEQ_NO = ( select   NQA_NQT_SEQ_NO
                                    from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
                                    where NQT_INV_TYPE = 'HPPV'
                                    and NQT_NMQ_ID =  L_MRG_ID
                                    and NQT_SEQ_NO = NQA_NQT_SEQ_NO
                                    and NQA_CONDITION is not null
                             )
        and NQV_ATTRIB_NAME = ( select   NQA_ATTRIB_NAME
                                    from NM_MRG_QUERY_ATTRIBS, NM_MRG_QUERY_TYPES
                                    where NQT_INV_TYPE = 'HPPV'
                                    and NQT_NMQ_ID =  L_MRG_ID
                                    and NQT_SEQ_NO = NQA_NQT_SEQ_NO
                                    and NQA_CONDITION is not null
                              );
                              
      delete from nm_mrg_query_results_all 
        where NQR_NMQ_ID = L_MRG_ID;                         
                              
    -- run merge query
    /*********************************/
    run_merge_all(l_job_id,l_mrg_id );
      
    
      
    
    --Empty the report table
    
      -- process the data into the table or extract
 
    
    delete  OHMS_SUBMIT_SAMPLES;
    
    commit;
    
    insert into OHMS_SUBMIT_SAMPLES
    select NMS_MRG_SECTION_ID SAMPLE_ID,
    END_POINT - BEGIN_POINT SECTION_LENGTH,
    END_POINT,
    BEGIN_POINT,
    nm3net.get_ne_unique(NMS_OFFSET_NE_ID),
    GET_STATE_CODE,
    to_char(sysdate-365, 'YYYY'),
	facl
	
    from    
    (select NMS_MRG_SECTION_ID
    , min(NMS_BEGIN_OFFSET) BEGIN_POINT
    , max(NMS_END_OFFSET) END_POINT
    , NMS_OFFSET_NE_ID
	, FACL_TYP_CD facl
    from
    V_MRG_OHMS_EXTRACT
	Where FACL_typ_cd in (1,2,3)
	and nm3net.get_ne_unique(NMS_OFFSET_NE_ID) not in (select NE_UNIQUE from V_NM_HWY_NT where MILEAGE_TYPE = 'P')
    
	group by 
    NMS_MRG_SECTION_ID
    , NMS_OFFSET_NE_ID
	, FACL_TYP_CD
	);
     
    commit;   
         
    delete v_nm_ohms_nw;
    
    commit; 
    
    insert into v_nm_ohms_nw
    select 
    NMS_MRG_SECTION_ID IIT_NE_ID,
    NMS_MRG_SECTION_ID IIT_PRIMARY_KEY,
    NMS_MRG_SECTION_ID SAMP_ID,
    NSM_NE_ID NE_ID_OF,
    NSM_BEGIN_MP NM_BEGIN_MP,
    NSM_END_MP NM_END_MP,
    to_char(sysdate-365, 'YYYY') Data_yr 
	, FACL_TYP_CD facl
	, nm3net.get_ne_unique(NMS_OFFSET_NE_ID) Route_ID
    from 
    V_MRG_OHMS_EXTRACT
	Where FACL_typ_cd in (1,2,3,6)
	and nm3net.get_ne_unique(NMS_OFFSET_NE_ID) not in (select NE_UNIQUE from V_NM_HWY_NT where MILEAGE_TYPE = 'P')
	;
    
    -- clean up 
	Update_SampleID;
  
    --delete all OHMS merge jobs
   
    delete from nm_mrg_query_results_all 
    where NQR_NMQ_ID = L_MRG_ID;
    
    commit;
    
 
   
    
end create_submit_samples;


PROCEDURE run_merge_all(p_job_id OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE,
                        p_mrg_id NM_MRG_QUERY.NMQ_ID%TYPE
                       ) IS


  l_sqlcount    pls_integer;
  l_mrg_job_id  integer;
  l_longops_rec nm3sql.longops_rec;
 -- l_mrg_id     nm_mrg_query.nmq_id%TYPE;
  
begin

  nm3dbg.debug_on; nm3dbg.timing_on;
  
      
  nm3bulk_mrg.load_all_network_datums(p_group_type => 'HWY'
                                      ,p_sqlcount   => l_sqlcount);

  
  nm3bulk_mrg.ins_route_connectivity(
     p_criteria_rowcount  => l_sqlcount
    ,p_ignore_poe         => false
  );
  
 -- select NMQ_ID into l_mrg_id from nm_mrg_query
 --   where NMQ_UNIQUE = 'BIKE_PED_MRG';

 delete from nm_mrg_query_results where nqr_nmq_id = p_mrg_id;
    commit;
 
  nm3bulk_mrg.std_run(
     p_nmq_id         => p_mrg_id
    ,p_nqr_admin_unit => 3
    ,p_nmq_descr      => 'All Network'
    ,p_ignore_POE => TRUE
    ,p_criteria_rowcount => l_sqlcount
    ,p_mrg_job_id     => l_mrg_job_id
    ,p_longops_rec    => l_longops_rec
  );
  commit;

  p_job_id := l_mrg_job_id;

END run_merge_all;


PROCEDURE ohms_report IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'OHMS_EXTRACT';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

  c_nl varchar2(1) := CHR(10);
  l_qry nm3type.max_varchar2;

  i number:=0;

  l_rec_nuf               nm_upload_files%ROWTYPE;
  l_rec_nuf2               nm_upload_files%ROWTYPE;
  c_mime_type    CONSTANT varchar2(30) := 'application/OHMS';
  c_sysdate      CONSTANT date         := SYSDATE;
  c_content_type CONSTANT varchar2(4)  := 'BLOB';
  c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
  v_clob clob;
  v_tmp_clob clob;
  v_clob2 clob;
  v_tmp_clob2 clob;

  l_tab             nm3type.tab_varchar32767;
  l_tab2             nm3type.tab_varchar32767;


BEGIN

nm_debug.debug('in the second procedure');
  --nm_debug.proc_start(p_package_name   => g_package_name
  --                   ,p_procedure_name => 'ohms_report');

  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);
  htp.bodyopen;
  nm3web.module_startup(pi_module => c_this_module);


  l_rec_nuf.mime_type              := c_mime_type;
  l_rec_nuf.dad_charset            := c_dad_charset;
  l_rec_nuf.last_updated           := c_sysdate;
  l_rec_nuf.content_type           := c_content_type;
  l_rec_nuf.doc_size               := 0;

  l_rec_nuf2.mime_type              := c_mime_type;
  l_rec_nuf2.dad_charset            := c_dad_charset;
  l_rec_nuf2.last_updated           := c_sysdate;
  l_rec_nuf2.content_type           := c_content_type;
  l_rec_nuf2.doc_size               := 0;


    l_rec_nuf.name                   := 'OHMS_SAMPLES'||to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS')||'.csv';
	--  Adding Column Headers
	l_tab(l_tab.count+1):='SAMPLE_ID' 
						  ||','|| 'SECTION_LENGTH' 
						  ||','|| 'END_POINT' 
						  ||','||'BEGIN_POINT' 
						  ||','||'ROUTE_ID' 
						  ||','|| 'STATE_CODE' 
						  ||','||'YEAR_RECORD'
						  ||chr(10);
    l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
	
    for c1rec in
      (select SAMPLE_ID 
      ||','|| SECTION_LENGTH 
      ||','|| END_POINT 
      ||','||BEGIN_POINT 
      ||','||ROUTE_ID 
      ||','|| STATE_CODE 
      ||','||YEAR_RECORD
         v_row
    from OHMS_SUBMIT_SAMPLES
    --where rownum<10
    ) loop
       l_tab(l_tab.count+1):=c1rec.v_row||chr(10);
       l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
    end loop;

 l_rec_nuf2.name                   := 'OHMS_SUBMIT_SECTIONS'||to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS')||'.csv';
    -- Adding Column Headers
	       l_tab2(l_tab2.count+1):='YEAR_RECORD'
								  ||','|| 'STATE_CODE'
								  ||','|| 'ROUTE_ID'
								   ||','|| 'BEGIN_POINT'
								   ||','|| 'END_POINT'
								   ||','|| 'DATA_ITEM'
								   ||','|| 'SECTION_LENGTH'
								   ||','|| 'VALUE_NUMERIC'
								   ||','|| 'VALUE_TEXT'
								   ||','|| 'VALUE_DATE'
								   ||','|| 'COMMENTS'
								   ||chr(10);
       l_rec_nuf2.doc_size  := l_rec_nuf2.doc_size+length(l_tab2(l_tab2.count));
	
	for c1rec2 in
      (select YEAR_RECORD
      ||','|| STATE_CODE
      ||','|| ROUTE_ID
       ||','|| BEGIN_POINT
       ||','|| END_POINT
       ||','|| DATA_ITEM
       ||','|| SECTION_LENGTH
       ||','|| VALUE_NUMERIC
       ||','|| VALUE_TEXT
       ||','|| VALUE_DATE
       ||','|| COMMENTS
             v_row2
    from OHMS_SUBMIT_SECTIONS
    --where rownum<10
    ) loop
       l_tab2(l_tab2.count+1):=c1rec2.v_row2||chr(10);
       l_rec_nuf2.doc_size  := l_rec_nuf2.doc_size+length(l_tab2(l_tab2.count));
    end loop;


       --nm_debug.debug_clob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));


    -- l_rec_nuf.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));

        for a in  1 .. l_tab.count
        loop
            v_tmp_clob :=   l_tab(a);
            v_clob := v_clob || v_tmp_clob;
        end loop;

        l_rec_nuf.blob_content           := nm3clob.clob_to_blob(v_clob);

        delete from nm_upload_files
        where name= l_rec_nuf.name;

         nm3ins.ins_nuf (l_rec_nuf);
         COMMIT;


        for a in  1 .. l_tab2.count
        loop
            v_tmp_clob2 :=   l_tab2(a);
            v_clob2 := v_clob2 || v_tmp_clob2;
        end loop;

        l_rec_nuf2.blob_content           := nm3clob.clob_to_blob(v_clob2);

        delete from nm_upload_files
        where name= l_rec_nuf2.name;

         nm3ins.ins_nuf (l_rec_nuf2);
         COMMIT;


/*.

  htp.p('<div align="center">');
      nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => l_qry));
  htp.p('</div>');
*/
  --line
 -- htp.tablerowopen(calign=> 'center');
 --   htp.p('<TD colspan="2">');
 --   htp.p(htf.hr);
    htp.p('  Click <a href=docs/'||l_rec_nuf.name||'> HERE </a> to download and save your Submit Samples CSV file <br> <br>' );
    htp.p('  Click <a href=docs/'||l_rec_nuf2.name||'> HERE </a> to download and save your Submit Sections CSV file');

--    htp.p('</TD>');

--  htp.tablerowclose;

  nm3web.CLOSE;
--  nm_debug.proc_end(p_package_name   => g_package_name
 --                  ,p_procedure_name => 'results');

EXCEPTION
  WHEN others
  THEN
    nm3web.failure(pi_error => SQLERRM);
--    nm3web.failure(pi_error => l_qry);
END ohms_report;
--

PROCEDURE Update_SampleID AS 


	t_base varchar2(16);



	BEGIN
	  
	  for C1RECORD in (select
						  SAMPLE_ID
						  ,SECTION_LENGTH
						  ,END_POINT
						  , BEGIN_POINT
						  ,ROUTE_ID
						  ,STATE_CODE
						  ,YEAR_RECORD
						  , DECODE(SIGN(BEGIN_POINT),
								-1 ,'X' || TRIM(TO_CHAR(ABS(replace(TO_CHAR(BEGIN_POINT ,'0000.00'), '.','')), '00000'))
								, trim(TO_CHAR(replace(to_char(BEGIN_POINT ,'0000.00'), '.',''), '000000'))) MP
						  , rowid
						from OHMS_SUBMIT_SAMPLES)
						
		LOOP

			
			update OHMS_SUBMIT_SAMPLES
			  set SAMPLE_ID = C1RECORD.ROUTE_ID || C1RECORD.MP
						
			  where rowid = C1RECORD.rowid ;
			
			
			
		
		
		end loop;
		commit;
  
END Update_SampleID;

PROCEDURE TABLE_UPDATES AS

	cursor CUR_TABLES is
		select ITEM_NAME a
		FROM OHMS_OBJECTS
		where Update_SQL = 1
			and Item_Type = 'TABLE'
		ORDER BY Item_ID;
		
	  c_row varchar2(100);

		begin          
				  open CUR_TABLES;
				  
				  LOOP
					  FETCH CUR_TABLES into C_ROW;
					  EXIT when CUR_TABLES%NOTFOUND;
					  XODOT_OHMS_UPDATE_TA(C_ROW); 
				  end loop;     
				close CUR_TABLES;
			

		
	END TABLE_UPDATES;
	   
end XODOT_OHMS;
/

drop public synonym XODOT_OHMS;
create public synonym XODOT_OHMS for XODOT_OHMS;

