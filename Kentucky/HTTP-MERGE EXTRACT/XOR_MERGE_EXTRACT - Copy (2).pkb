CREATE OR REPLACE PACKAGE BODY XOR_merge_extract AS
--
 -- R. Ellis - Sept. 2011
 
 
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';
--
 g_package_name    CONSTANT  varchar2(30)   := 'XOR_merge_extract';
 
 g_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'MERGE_EX';
   g_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(g_this_module);
-----------------------------------------------------------------------------
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
PROCEDURE rep_params IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := g_this_module;
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := g_this_module;

   l_tab_value  nm3type.tab_varchar30;
   l_tab_prompt nm3type.tab_varchar30;
   l_checked    varchar2(8) := ' CHECKED';

BEGIN


  l_tab_value(1)  := 'MERGE';
  l_tab_prompt(1) := 'Merge Extract';
 
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'rep_params');
  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);

  htp.bodyopen;
  nm3web.module_startup(c_this_module);
  
  
   htp.formopen(curl => '' || g_package_name || '.rep_params_2');
     
 -- htp.p('<TD><INPUT TYPE="HIDDEN" NAME="pi_selected_query" VALUE="ROAD"></TD>');
 
 htp.p( 'Use this from to view merge query results or to download them as a CSV file to excel.  <p> 
        You need to create your merge query in the MERGE QUERIES form, then ''run'' the merge query 
        in the MERGE QUERY RESULTS form before using this form to view or download the results.' );
        
        htp.p ('<p>');
        
      htp.p( 'You need to select the Merge Query, and a result set from that query');
        
          htp.p ('<p>');
        
      
      htp.formSelectOpen(cname  => 'pi_selected_query'  ,
                 cprompt  =>    ' Select a Merge Query:   ' )
                 ;
                  HTP.FORMSELECTOPTION(   null, '' );
                  
                   for value in (select distinct NMQ_UNIQUE from nm_mrg_query_results, nm_mrg_query
                                        where nmq_id = nqr_nmq_id
                                        order by NMQ_UNIQUE  )
                      loop
                        HTP.FORMSELECTOPTION(   value.NMQ_UNIQUE, '' );
                      end loop;            
                 
                 
   htp.formSelectClose   ;

    
    htp.formsubmit(cvalue => 'Continue');
   

  htp.formclose;
  
                        

  nm3web.CLOSE;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'rep_params');
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here
  THEN
    raise;
  WHEN others
  THEN
  nm_debug.debug('error');
    nm3web.failure(pi_error => SQLERRM);
END rep_params ;
--

PROCEDURE rep_params_2 (pi_selected_query varchar2) 
 IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE :=  g_this_module;
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := g_module_title ;

   l_tab_value  nm3type.tab_varchar30;
   l_tab_prompt nm3type.tab_varchar30;
   l_checked    varchar2(8) := ' CHECKED';
    l_selected  varchar2(8) ;

BEGIN


 
   
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'rep_params2');
  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);

  
  htp.bodyopen;
  nm3web.module_startup(c_this_module);
  
     
      htp.formopen(curl => '' || g_package_name || '.report');
  
      htp.p('<INPUT TYPE="HIDDEN" NAME="pi_selected_query" VALUE="'  || pi_selected_query ||'">');
      
    
      
      htp.formSelectOpen(cname  => 'pi_selected_result'  ,
                 cprompt  =>    ' Select an ' ||pi_selected_query || ' merge result set: ' );
                
                  
               
                 
                  HTP.FORMSELECTOPTION(   null, '' );
                  
                   l_selected := 'SELECTED';
                  
                   for value in (
                   
                   select distinct NQR_DESCRIPTION, NQR_MRG_JOB_ID  from nm_mrg_query_results, nm_mrg_query
                                        where nmq_id = nqr_nmq_id
                                        and nmq_unique = pi_selected_query
                                        order by NQR_MRG_JOB_ID desc 
                                        
                                         )
                      loop
                 --      HTP.FORMSELECTOPTION(   value.NQR_DESCRIPTION, '' );
                       
                       
                       htp.p ('<option ' ||  l_selected ||' value = "'|| value.NQR_MRG_JOB_ID ||'"> '||  value.NQR_DESCRIPTION ||  ' </option> ');
                        l_selected := '';
                 
                      end loop;            
                 
                 
   htp.formSelectClose   ;
   
   
    htp.p ('<br>  The most resent result sets are listed first  ');

      htp.p(' <p> and select the delimiter you want to use. <br>' );

    htp.formRadio  
        ( 'Pi_delim', 'comma', 'YES' );
        
        htp.p('comma <BR>');
        
    htp.formRadio  
        ( 'Pi_delim', 'bar' );
        
        htp.p('bar <BR> <p> ');
  
     
    htp.formsubmit(cvalue => 'Continue');
   

  htp.formclose;
  
                        

  nm3web.CLOSE;
  
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here
  THEN
    raise;
  WHEN others
  THEN
  nm_debug.debug('error');
    nm3web.failure(pi_error => SQLERRM);
END rep_params_2 ;
-----------------------------------------------------------------------------
--
PROCEDURE report (pi_selected_result number,
                pi_selected_query  varchar2 ,
                pi_delim varchar2) IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'MERGE_EX';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

  c_nl varchar2(1) := CHR(10);
  l_qry nm3type.max_varchar2;

  i number:=0;
  l number;

  l_rec_nuf               nm_upload_files%ROWTYPE;
  c_mime_type    CONSTANT varchar2(30) := 'application/EXOR';
  c_sysdate      CONSTANT date         := SYSDATE;
  c_content_type CONSTANT varchar2(4)  := 'BLOB';
  c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
  v_clob clob;
  v_tmp_clob clob;
 

  l_tab        nm3type.tab_varchar32767;
  l_tab_value  nm3type.tab_varchar80;
  l_tab_prompt nm3type.tab_varchar80;
  
  
 -- l_report_ea varchar2(200);
  
  vCursor sys_refcursor;

  csql nm3type.max_varchar2;
  v_row nm3type.max_varchar2;
  l_title nm3type.max_varchar2;
   l_header nm3type.max_varchar2;
   l_cols nm3type.max_varchar2; 
   l_table varchar2(30);
   l_where nm3type.max_varchar2;
   l_result_name nm3type.max_varchar2;
   l_delim varchar2(10);
   h_delim varchar2(10);

BEGIN




nm_debug.debug('in the second procedure');
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'report');


  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);
  htp.bodyopen;
  
  nm3web.module_startup(pi_module => c_this_module);


  l_rec_nuf.mime_type              := c_mime_type;
  l_rec_nuf.dad_charset            := c_dad_charset;
  l_rec_nuf.last_updated           := c_sysdate;
  l_rec_nuf.content_type           := c_content_type;
  l_rec_nuf.doc_size               := 0;

  l_rec_nuf.name                   := 'Merge_extract_'||pi_selected_result || '_' ||pi_selected_query || '_' ||to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS')||'.csv'  ;
  
   select distinct NQR_DESCRIPTION into l_result_name  from nm_mrg_query_results, nm_mrg_query
                                        where nqr_mrg_job_id = pi_selected_result;
                                        
 l_delim :=  case pi_delim
            when 'bar' then  '||''|'''
            when 'comma' then   '||'','''
            end;                                      
                                       
                   

h_delim :=  case pi_delim
            when 'bar' then  '|'
            when 'comma' then   ','
            end;                                      
                                 
                                 
     
  l_title :=  'Merge Query: ' || pi_selected_query|| ' Result Set: ' ||l_result_name ;
   l_table := 'V_MRG_'|| pi_selected_query ||'_SVL';
   l_where := ' where NQR_MRG_JOB_ID = ' || pi_selected_result;
       

       csql :=   'Select
                             ''"''  || nm3net.get_ne_unique(NMS_OFFSET_NE_ID) || ''"'''  
                             || l_delim || '|| NMS_BEGIN_OFFSET'  
                             || l_delim || '|| NMS_END_OFFSET' 
                             || l_delim || '||''"''' || '|| NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID' || '||''"'''
                             || l_delim || '|| NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID'
                             || l_delim || '||''"''' || '|| NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID '   || '||''"'''
                             || l_delim || '|| NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID'
                             || l_delim || '|| NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID'
                             || l_delim ;
                        
                        
      l_header := null;


 for n in 
        (
        
        select before || a || after  C , A D  from 
   (      
 select column_name a
        , decode (data_type, 'VARCHAR2'
                                                        , '||''"''||'
                                                        , '||' 
                                                          ) before
         , decode (data_type, 'VARCHAR2'
                                                        , '||''"''',
                                                         ' ' 
                                                          ) after
            from  dba_tab_columns
            where table_name =  upper( L_TABLE)
            and column_name not like '%QRY_COUNT'
            and column_name  not in ('NQR_MRG_JOB_ID', 'NMS_MRG_SECTION_ID', 'NMS_OFFSET_NE_ID', 'NMS_BEGIN_OFFSET', 'NMS_END_OFFSET', 'NQR_DATE_CREATED', 'NQR_SOURCE_ID', 'NQR_SOURCE', 'NQR_DESCRIPTION', 'NQR_ADMIN_UNIT', 'PNT_OR_CONT', 'NMS_NE_ID_FIRST', 'NMS_BEGIN_MP_FIRST', 'NMS_NE_ID_LAST', 'NMS_END_MP_LAST')
            order by column_name
                        ) 
        
        )


        loop

                 l_header := l_header || n.d || h_delim ;
                 csql  := csql ||  n.c || ''|| l_delim || '';
                 l_cols := l_cols || n.d || ',' ;
    
        end loop; 
        
 

        l :=  length(csql);
        l_header := substr(l_header, 1, length(l_header) - 1);
          l_cols := substr(l_cols, 1, length(l_cols) - 1);
        
        csql  := substr( csql, 1, l-5 ) || ' from ' || l_table || l_where ;

                
        --l_qry := 'Select nm3net.get_ne_unique(NMS_OFFSET_NE_ID) Road_Unique, NMS_BEGIN_OFFSET BEGIN_OFFSET, NMS_END_OFFSET  END_OFFSET, ' ; 
		l_qry := 'Select  ' ; 
        
        
        -- For RMS only
        
		/*
          l_qry := l_qry || 'XRTA_MRG_EXTRACT.GET_NMS_NE_UNIQUE_FIRST (NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID) S_UNIQ 
                        , XRTA_MRG_EXTRACT.GET_NMS_BEGIN_MP_FIRST (NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID) SLDI
                        ,  XRTA_MRG_EXTRACT.GET_NMS_NE_UNIQUE_LAST (NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID) E_UNIQ
                       ,  XRTA_MRG_EXTRACT.GET_NMS_END_MP_LAST (NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID) ELDI
                       , XRTA_MRG_EXTRACT.GET_MRG_SECTION_LENGTH (NQR_MRG_JOB_ID,NMS_MRG_SECTION_ID) SEG_LENGTH
                       , ' ;
					   */
           ------
		   
        l_qry := l_qry ||
          l_cols || ' from ' || l_table || l_where ;
        
        

 select  l_title
    into       
        v_row
    from dual;
    
    l_tab(l_tab.count+1):= v_row||chr(13)||chr(10);  --Changed from a LF(10) to a CRLF as requested
       l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
  
    
    
    -- for RMS Only
    
    --l_header := 'S_UNIQ' || h_delim || 'SLDI' || h_delim || 'E_UNIQ' || h_delim || 'ELDI' || h_delim || 'SEG_LENGTH' || h_delim || l_header ;
    --
    
   -- htp.p( 'select ''ROAD_UNIQUE'' ' || h_delim || '''BEGIN_OFFSET''' || h_delim || '''END_OFFSET''' || h_delim || l_header || '       
   --    into v_row
    --  from dual;' );
      /*
    
     'ROAD_UNIQUE' || h_delim || 'BEGIN_OFFSET' || h_delim || 'END_OFFSET' || h_delim || l_header || ''       
       into v_row
      from dual;
    */
    
    v_row :=  'ROAD_UNIQUE' || h_delim || 'BEGIN_OFFSET' || h_delim || 'END_OFFSET' || h_delim || l_header || '';
    
    l_tab(l_tab.count+1):= v_row||chr(13)||chr(10);  --Changed from a LF(10) to a CRLF as requested
       l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
       
       
     --  htp.p(v_row);
 

    htp.p('<table> <tr> <td> <h3>  <a href=docs/'||l_rec_nuf.name||'>
     <b> Download </b> </a> as a CSV file </h3> </td><td></tr>
     <tr><td><A HREF="nm3web.run_module?pi_module='  ||  g_this_module || '"> Return to the Report List </A></td></tr></table>');
--    htp.p('</TD>');
--  htp.tablerowclose

  --- Debugging
  
htp.p(' <p> ');


htp.p('csql = ' ||  csql ); -- debug


htp.p('<p>');

htp.p('l_header = ' ||l_header ); -- debug

htp.p('<p>');

htp.p('l_qry= ' ||  l_qry ); -- debug





l_qry := 'select * from dual';  -- debug
csql := 'select * from dual';  -- debug

  -- End Debugging

  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'results');
 


  open vCursor for csql ;
        
          
    loop
        fetch vCursor into v_row;
        exit when vCursor%notfound;
       l_tab(l_tab.count+1):= v_row||chr(13)||chr(10);  --Changed from a LF(10) to a CRLF as requested
       l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
       
    end loop;


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


 htp.p('<h2> ' || l_title || '</h2>');
 
    if l_tab.count > 100 then
        htp.p('There are ' ||( l_tab.count - 2) || ' rows in the result set so the full data set is not listed here. <P>  Only the
       first 100 rows are listed below and the full set is contained in the CSV file. <p> <p>');
 
    l_qry := l_qry || ' and rownum < 101 ';
    
    end if;
 
 --htp.p('l_qry = ' ||l_qry || '<p>'); -- debug
 
     nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => l_qry));
	 
	 --nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => 'select 0000 hi from dual'));
htp.p('</div>');
 


  nm3web.CLOSE;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'results');
 



EXCEPTION
  WHEN others
  THEN
     nm3web.failure(pi_error => SQLERRM);
   --nm3web.failure(pi_error => 'l_qry= '  || l_qry);
END report;
--

END XOR_merge_extract;
/
