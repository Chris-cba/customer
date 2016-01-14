create or replace package body  xky_view as

  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';
--
g_package_name    CONSTANT  varchar2(30)   := 'xky_view';

 g_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'xKY_VIEW';
 g_module_title CONSTANT hig_modules.hmo_title%TYPE  := 'Some Title'; --hig.get_module_title(g_this_module);

	procedure create_view (v_name varchar2) is

		s_columns 		varchar2 (32767);
		s_tables    	varchar2 (32767);
		s_where      	varchar2 (32767);
		s_sql         	varchar2 (32767);

	begin
			null;
		
	end create_view;
	
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
  
  
   htp.formopen(curl => 'EXOR.' || g_package_name || '.rep_params_2');
     
 -- htp.p('<TD><INPUT TYPE="HIDDEN" NAME="pi_selected_query" VALUE="ROAD"></TD>');

 htp.p( 'Use this form to add "KY" style views to any asset that has had the
			V_NM_<span style="font-style: italic;">assest</span>_NW
			views created.<br>
			<br>
			Select an asset from the dropSelect an asset from the drop down list
			and select create, only asssets without an exist KY view will show in
			the list.
			' );
        
       htp.p('<br><br>')
        
              
      
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
end xky_view;
/