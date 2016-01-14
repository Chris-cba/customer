create or replace
PACKAGE BODY IM_CHART_GEN 
as
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/scripts/im_chart_gen_3_10v45.pkb-arc   1.0   Jan 14 2016 19:49:20   Sarah.Williams  $
--       Module Name      : $Workfile:   im_chart_gen_3_10v45.pkb  $
--       Date into PVCS   : $Date:   Jan 14 2016 19:49:20  $
--       Date fetched Out : $Modtime:   Sep 10 2012 15:20:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  G_BODY_SCCSID  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

  G_PACKAGE_NAME CONSTANT varchar2(30) := 'im_chart_gen';

--
-----------------------------------------------------------------------------
--
FUNCTION GET_VERSION RETURN varchar2 IS
begin
   RETURN G_SCCSID;
  
END GET_VERSION;
--
-----------------------------------------------------------------------------
--
FUNCTION GET_BODY_VERSION RETURN varchar2 IS
BEGIN
   RETURN G_BODY_SCCSID;
END GET_BODY_VERSION;
--
-----------------------------------------------------------------------------
--
PROCEDURE MAP_source;
procedure chart_source(pi_page_id varchar2
                      ,PI_USER_ID VARCHAR2
                      ,pi_position varchar2);

procedure plsql_source(PI_PAGE_ID varchar2
                      ,PI_USER_ID varchar2
                      ,PI_POSITION varchar2);

function pod_source(pi_page_id varchar2
                      ,pi_user_id varchar2
                      ,pi_position varchar2)
return varchar2  
is 
   l_rtrn varchar2(4000);
begin 
   for crec in ( select * 
                 from im_pod_sql a
                      ,im_user_pods b
                  where 
                    a.ips_ip_id = b.iup_ip_id
                  and
                    b.iup_it_id = (select it_id from im_tabs where it_page_id = pi_page_id)
                  and 
                    b.iup_hus_username = pi_user_id
                  and
                    b.iup_pod_position = pi_position  )
    loop
       l_rtrn :=  crec.ips_source_code;
   end loop;
   return l_rtrn;

end pod_source; -- function 


procedure pod_source(pi_page_id varchar2
                      ,pi_user_id varchar2
                      ,pi_position varchar2)
IS 
   pod_rec im_pods%rowtype;
BEGIN 
   for crec in ( select a.*
    from im_pods a
        ,im_user_pods b
    where 
      a.ip_id = b.iup_ip_id
    and
      b.iup_it_id = (select it_id from im_tabs where it_page_id = pi_page_id)
    and 
      b.iup_hus_username = pi_user_id
    AND
      B.IUP_POD_POSITION = PI_POSITION)
  LOOP
    pod_rec := crec;
  end loop;
      
  if pod_rec.ip_type = 'Map'
   then 
    MAP_SOURCE;
  ELSIF POD_REC.IP_TYPE = 'PL/SQL'
   then 
     plsql_source(pi_page_id 
                ,PI_USER_ID 
                ,pi_position );
  else
    CHART_SOURCE(pi_page_id 
                ,pi_user_id 
                ,pi_position );
  end if;  
end pod_source;

procedure plsql_source(PI_PAGE_ID varchar2
                      ,pi_user_id varchar2
                      ,PI_POSITION varchar2)                    
is 
    strs nm3type.tab_varchar4000;
begin 
    SELECT IPS_SOURCE_CODE
    bulk collect into strs
    from im_pod_sql a
        ,im_user_pods b
    where 
      a.ips_ip_id = b.iup_ip_id
    and
      b.iup_it_id = (select it_id from im_tabs where it_page_id = pi_page_id)
    and 
      b.iup_hus_username = pi_user_id
    and
      B.IUP_POD_POSITION = PI_POSITION
    order by TO_NUMBER(IPS_SEQ)  ;    

    for series in 1..strs.count
     loop
      begin      
            execute immediate strs(series) ;
      exception when others then raise; --raise_application_error(-20400,str);
      end;  
    end loop;
    
    
    
end plsql_source;

procedure map_source
is
begin 
   HTP.P('<div id="mappod">
<div id="map" style="left:1px; top:1px; width:99%; height:399px; margin:1px;padding:0px;border:0px solid #CFE0F1"></div>
</div>');
end map_source;

procedure DEL_PAGE6(pi_user_id varchar2)
is
begin 
  delete IM_USER_PODS
  where IUP_IT_ID = 6
    and IUP_HUS_USERNAME = PI_USER_ID
    and iup_source_seq = apex_custom_auth.get_session_id;
end DEL_PAGE6;


procedure ins_page6(pi_page_id varchar2
                      ,PI_USER_ID varchar2
                      ,PI_POSITION varchar2)
is
begin 
DEL_PAGE6(pi_user_id => pi_user_id);
     insert into IM_USER_PODS (IUP_IP_ID,
    IUP_HUS_USERNAME,
    IUP_IT_ID,
    IUP_POD_POSITION,
    IUP_SOURCE_SEQ) 
    select 
       IP_ID
      ,PI_USER_ID
      ,PI_PAGE_ID
      ,1
      , apex_custom_auth.get_session_id
    from IM_PODS
    where IP_HMO_MODULE = APEX_UTIL.FETCH_APP_ITEM('MODULE_ID') ;
commit;
end ins_page6;   



procedure chart_source(pi_page_id varchar2
                      ,pi_user_id varchar2
                      ,pi_position varchar2)
is 
  L_CHART_REC IM_POD_CHART%ROWTYPE;                        
  
  
begin
 
  if PI_PAGE_ID = 6 
   then      
     INS_PAGE6( PI_PAGE_ID => PI_PAGE_ID
               ,PI_USER_ID => PI_USER_ID
               ,pi_position => pi_position);     
  end if;
  

  FOR CREC IN (SELECT A.*
    from im_pod_chart a
        ,im_user_pods b
    where 
      a.ip_id = b.iup_ip_id
    and
      (B.IUP_IT_ID = (select IT_ID from IM_TABS where IT_PAGE_ID = PI_PAGE_ID)
       or
      b.iup_it_id = 6 AND iup_source_seq = apex_custom_auth.get_session_id)
    and 
      b.iup_hus_username = pi_user_id
    AND
      b.iup_pod_position = pi_position )
   LOOP
    L_CHART_REC := CREC;
  END LOOP;
 
  HTP.P('<div class="chartcontainer'||PI_POSITION||'">');
 
  htp.p('<object class="mychart" id="c5188815604017627" 
  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
  classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
  align="top" height="'||l_chart_rec.chart_height||'" width="'||l_chart_rec.chart_width||'" >
	<param value="high" name="quality"/>
	<param value="sameDomain" name="allowScriptAccess"/>
	<param value="all" name="allowNetworking"/>
	<param value="noscale" name="scale"/>
  <param id="mymovie" name="movie" value="/i/flashchart/swf/AnyChart.swf"/>
	<param value="transparent" name="wmode"/>');
	 
  htp.p('<param id="myflashvar" class="myflashvar" name="FlashVars" value="XMLFile=http://'||owa_util.get_cgi_env('HTTP_HOST')||trim(owa_util.get_cgi_env('SCRIPT_NAME')));
  if pi_position != '200'
   then 
  htp.p('/im_chart_gen.simple_xml?pi_page_id='||pi_page_id||'&pi_user_id='||pi_user_id||'&pi_position='||pi_position||'"/> ');
  else
  HTP.P('/im_chart_gen.get_dial_100"/> ');
  END IF;
	htp.p('<embed pluginspage="http://www.macromedia.com/go/getflashplayer" wmode="transparent" type="application/x-shockwave-flash" allownetworking="all" allowscriptaccess="sameDomain" scale="noscale" name="c5188815604017627" '||
  'quality="high" flashvars="XMLFile=http://'||owa_util.get_cgi_env('HTTP_HOST')||trim(owa_util.get_cgi_env('SCRIPT_NAME')));
  if pi_position != '200'
   then 
  htp.p('/im_chart_gen.simple_xml?pi_page_id='||pi_page_id||'&pi_user_id='||pi_user_id||'&pi_position='||pi_position||'" ');
  else
  htp.p('/im_chart_gen.get_dial_100" ');
  END IF;
  htp.p('src="http://'||owa_util.get_cgi_env('HTTP_HOST')||'/i/flashchart/swf/AnyChart.swf" align="" height="'||l_chart_rec.chart_height||'" width="'||l_chart_rec.chart_width||'"/></object>');

  
  htp.p('</div>');

end chart_source;


procedure xget_series(pi_page_id varchar2 default null
                      ,pi_user_id varchar2 default null
                      ,pi_position varchar2 default null
                      ,pi_chart_details im_pod_chart%rowtype)
is
  str varchar2(4000) ;
  strs nm3type.tab_varchar4000;
  plink nm3type.tab_varchar4000;
  pname nm3type.tab_varchar4000;
  pvalue  nm3type.tab_number;
  STYPE NM3TYPE.TAB_VARCHAR80;
  SHAPE NM3TYPE.TAB_VARCHAR80;
  ips_name NM3TYPE.TAB_VARCHAR80;
  
  
  i number;
  C NUMBER;
  tab dbms_sql.desc_tab2;
  BEGIN     
    SELECT IPS_SOURCE_CODE, NVL(IPS_TYPE,'Bar'), NVL(IPS_SHAPE_TYPE,'Bar'), dbms_xmlgen.convert(IPS_NAME)
    bulk collect into strs, stype, shape, ips_name
    from im_pod_sql a
        ,im_user_pods b
    where 
      a.ips_ip_id = b.iup_ip_id
    and
      b.iup_it_id = (select it_id from im_tabs where it_page_id = pi_page_id)
    and 
      b.iup_hus_username = pi_user_id
    and
      B.IUP_POD_POSITION = PI_POSITION
    order by to_number(ips_seq)  ;    

   htp.p('<data>');

    for series in 1..strs.count
     loop
      str := strs(series);
      
      str := replace(str,'<APEX_USER>',pi_user_id);
      i := dbms_sql.open_cursor;
      dbms_sql.parse(i,str,dbms_sql.native);
     
      dbms_sql.describe_columns2(c => i
                    , col_cnt => c,
                                 desc_t => tab);    
begin      
      execute immediate str 
        BULK COLLECT INTO PLINK, PNAME, PVALUE;
exception when others then raise; --raise_application_error(-20400,str);
END;  
      IF PLINK.COUNT > 0
       THEN 
        --htp.p('<series name="'||to_char(tab(3).col_name)||'" type="'||stype(series)||'" shape_type="'||shape(series) ||'" >');                                
        htp.p('<series name="'||ips_name(series)||'" type="'||stype(series)||'" shape_type="'||shape(series) ||'" >');                                
        
        for j in 1..plink.count
         Loop
           htp.p( '<point name="' ||pname(j)||'" y="'||trim(to_char(pvalue(j),'9999999.00'))||'" >' );     
           HTP.P(' <actions>');
           htp.p('<action type="navigateToURL" url="'||dbms_xmlgen.convert(plink(j)) ||'" target="_top" />');
           htp.p('</actions>');
           HTP.P('</point>');                          
        end loop;
        HTP.P('</series>');
      ELSE
        --HTP.P('<series name="'||TO_CHAR(TAB(3).COL_NAME)||'" type="'||STYPE(SERIES)||'" shape_type="'||SHAPE(SERIES) ||'" >');                                
        HTP.P('<series name="'||ips_name(series)||'" type="'||STYPE(SERIES)||'" shape_type="'||SHAPE(SERIES) ||'" >');                                
        htp.p( '<point name="no_data" y="0" >' );     
        HTP.P('</point>');                          
       HTP.P('</series>');
      end if;  
    end loop;  
    HTP.P('</data>');
end xget_series;

PROCEDURE GET_RESULTS( PI_STR VARCHAR2
                      ,PI_USER_ID VARCHAR2
                      ,PI_IP_ID VARCHAR2
                      ,pi_name varchar2)
IS
  type RESULT_REC_TYPE IS RECORD
     (  IPCR_LINK varchar2(1000),
        IPCR_LABEL varchar2(1000),
        IPCR_V1 varchar2(4000),
        IPCR_V2 varchar2(4000),
        IPCR_V3 varchar2(4000),
        IPCR_V4 varchar2(4000),
        IPCR_V5 varchar2(4000),
        IPCR_V6 varchar2(4000),
        IPCR_V7 varchar2(4000),
        IPCR_V8 varchar2(4000),
        IPCR_V9 varchar2(4000),
        IPCR_V10 varchar2(4000),
        IPCR_V11 varchar2(4000),
        IPCR_V12 varchar2(4000),
        IPCR_V13 varchar2(4000),
        IPCR_V14 varchar2(4000),
        IPCR_V15 varchar2(4000),
        IPCR_V16 varchar2(4000),
        IPCR_V17 varchar2(4000),
        IPCR_V18 varchar2(4000),
        IPCR_V19 VARCHAR2(4000),
        IPCR_V20 varchar2(4000));

  TYPE RESULT_RECS_TYPE IS TABLE OF RESULT_REC_TYPE INDEX BY BINARY_INTEGER;
  l_res  result_recs_type ;
  
BEGIN      
   execute IMMEDIATE pi_str BULK COLLECT INTO l_res;
   
   FOR I IN 1..L_RES.COUNT
   loop
     INSERT INTO IM_POD_CHART_RESULTS
     VALUES
     (PI_USER_ID, PI_IP_ID, SYSDATE,I,PI_NAME
     ,L_RES(I).IPCR_LINK
     ,L_RES(I).IPCR_LABEL
     ,L_RES(I).IPCR_V1
     ,L_RES(I).IPCR_v2
     ,L_RES(I).IPCR_v3
     ,L_RES(I).IPCR_v4
     ,L_RES(I).IPCR_V5
     ,L_RES(I).IPCR_v6
     ,L_RES(I).IPCR_V7
     ,L_RES(I).IPCR_V8
     ,L_RES(I).IPCR_V9
     ,L_RES(I).IPCR_V10
     ,L_RES(I).IPCR_V11
     ,L_RES(I).IPCR_V12
     ,L_RES(I).IPCR_v13
     ,L_RES(I).IPCR_V14
     ,L_RES(I).IPCR_V15
     ,L_RES(I).IPCR_V16
     ,L_RES(I).IPCR_V17
     ,L_RES(I).IPCR_V18
     ,L_RES(I).IPCR_V19
     ,L_RES(I).IPCR_V20
     );
  END LOOP;    
  
   
--      EXECUTE IMMEDIATE PI_STR ;        
--EXCEPTION when OTHERS then RAISE_APPLICATION_ERROR(-20400,PI_STR);

--STR := SUBSTR(STR,1, INSTR(STR,'select')-1) || 'insert into IM_POD_CHART_RESULTS select '''||PI_USER_ID||''','||IP_IDS(SERIES)||',sysdate,1, '''||IPS_NAME(SERIES)||''','||SUBSTR(STR,INSTR(STR,'select')+6);

end;  

function GET_SERIES_COLOURS(PI_COLOURS NM3TYPE.TAB_VARCHAR4000
                          ,PI_SEQ IM_POD_SQL.IPS_SEQ%type       
                          ,pi_index number default 1
                          )
return varchar2
is
  COLOR_LIST  wwv_flow_global.vc_arr2;
  
  rtrn varchar2(50);
begin
  COLOR_LIST := APEX_UTIL.STRING_TO_TABLE(PI_COLOURS(PI_SEQ));
  
  --if COLOR_LIST.COUNT = 1
  -- then 
  --   rtrn := 'color="'||COLOR_LIST(1)||'"';
  --ELSIF COLOR_LIST.COUNT > 1
  -- then 
     RTRN := 'color="'||COLOR_LIST(PI_INDEX)||'"';     
  --END IF;

  return RTRN;
  
  EXCEPTION when OTHERS 
  then 
    return null;
end get_series_colours;    

procedure get_series(pi_page_id varchar2 default null
                      ,pi_user_id varchar2 default null
                      ,pi_position varchar2 default null
                      ,pi_chart_details im_pod_chart%rowtype)
is
  str varchar2(4000) ;
  strs nm3type.tab_varchar4000;
  plink nm3type.tab_varchar4000;
  pname nm3type.tab_varchar4000;
  PVALUE  NM3TYPE.TAB_NUMBER;
  STYPE NM3TYPE.TAB_VARCHAR80;
  SHAPE NM3TYPE.TAB_VARCHAR80;
  IPS_NAME NM3TYPE.TAB_VARCHAR80;
  IP_IDS NM3TYPE.TAB_NUMBER;
  IP_cache im_pods.ip_cache_time%type;

  i number;
  C NUMBER;
  tab dbms_sql.desc_tab2;
  
  l_nulls varchar2(4000);
  L_CUR NM3TYPE.REF_CURSOR   ;
  L_IPCR_REC IM_POD_CHART_RESULTS%ROWTYPE;
  imcr wwv_flow_global.vc_arr2;
  
  TYPE imcr_tab_type IS TABLE OF wwv_flow_global.vc_arr2 INDEX BY binary_INTEGER;
  imcr_strs NM3TYPE.TAB_VARCHAR4000;
  imcr_tab imcr_tab_type;
  
  colours nm3type.tab_varchar4000;
  
  begin     
  
  -- NM_DEBUG.DEBUG_ON;
  -- nm_debug.delete_debug;
   
   --nvl(IP_CACHE_TIME,(60/1440))
  
    SELECT IPS_IP_ID, IPS_SOURCE_CODE, NVL(IPS_TYPE,'Bar'), NVL(IPS_SHAPE_TYPE,'Bar'), DBMS_XMLGEN.CONVERT(IPS_NAME) 
    bulk collect into ip_ids, strs, stype, shape, ips_name
    from im_pod_sql a
        ,im_user_pods b
    where 
      a.ips_ip_id = b.iup_ip_id
    and
      b.iup_it_id = (select it_id from im_tabs where it_page_id = pi_page_id)
    and 
      b.iup_hus_username = pi_user_id
    and
      B.IUP_POD_POSITION = PI_POSITION
    ORDER BY TO_NUMBER(IPS_SEQ)  ;    
   
   SELECT NVL(IP_CACHE_TIME,0)
   into ip_cache
   FROM IM_PODS
   where ip_id = ip_ids(1);

   select ipcc_colour
   bulk collect into colours
   from IM_POD_CHART_COLOURS
   where IPCC_IP_ID = IP_IDS(1)
   order by IPCC_IPS_SEQ;
   


   htp.p('<data>');

    for series in 1..strs.count
     loop
      str := strs(series);
      
      str := replace(str,'<APEX_USER>',pi_user_id);
      i := dbms_sql.open_cursor;
      dbms_sql.parse(i,str,dbms_sql.native);
     
      dbms_sql.describe_columns2(c => i
                    , COL_CNT => C
                    , desc_t => tab);    
                                 
      L_NULLS := null;
      for I in C..21 LOOP
        l_nulls := l_nulls || ',null';
      end LOOP;
       
      STR := replace(STR,'FROM','from');      
      str := replace(str,'From','from');      
      STR := replace(STR,'SELECT','select');      
      STR := replace(STR,'Select','select');      
      
      
  
      STR := SUBSTR(STR,1, INSTR(STR,'from')-1) ||' '|| L_NULLS || ' from '||SUBSTR(STR,INSTR(STR,'from')+4);
     -- INSERT INTO IAN VALUES (STR);      COMMIT;
    --  STR := SUBSTR(STR,1, INSTR(STR,'select')-1) || 'insert into IM_POD_CHART_RESULTS select '''||PI_USER_ID||''','||IP_IDS(SERIES)||',sysdate,1, '''||IPS_NAME(SERIES)||''','||SUBSTR(STR,INSTR(STR,'select')+6);
      
     
      -- do pod results exist
      open l_cur for 'select * 
                     from IM_POD_CHART_RESULTS
                    where IPCR_POD_ID = ' ||IP_IDs(SERIES)||
                      'and IPCR_USERNAME =  '''||PI_USER_ID||''''||
                      'and ipcr_series_name = '''||ips_name(series)||'''';
       FETCH L_CUR into L_IPCR_REC;
     
       IF L_CUR%FOUND THEN 
        if sysdate > L_IPCR_REC.IPCR_START_DATE_time + ip_cache -- (60/1440) -- the results are more than 1 hour old
         then
          delete IM_POD_CHART_RESULTS -- delete them 
           where IPCR_POD_ID = IP_IDS(SERIES)
             and IPCR_USERNAME = PI_USER_ID
             and ipcr_series_name = ips_name(series);
          GET_RESULTS(PI_STR => STR
                     ,PI_USER_ID => PI_USER_ID
                     ,PI_IP_ID => IP_IDS(SERIES)
                     ,pi_name => IPS_NAME(SERIES)); -- and refresh
        end if;
       else
        GET_RESULTS(PI_STR => STR
                     ,PI_USER_ID => PI_USER_ID
                     ,PI_IP_ID => IP_IDS(SERIES)
                     ,pi_name => IPS_NAME(SERIES)); -- no previous results create them
      end if;
      close L_CUR;
      
      IMCR_STRS.DELETE;
      IMCR_TAB.DELETE;
      
      SELECT IPCR_USERNAME||'~'||
                      IPCR_POD_ID||'~'||
                      IPCR_START_DATE_TIME||'~'||
                      IPCR_LINK||'~'||
                      nvl(IPCR_LABEL,'none')||'~'||
                      IPCR_V1||'~'||
                      IPCR_V2||'~'||
                      IPCR_V3||'~'||
                      IPCR_V4||'~'||
                      IPCR_V5||'~'||
                      IPCR_V6||'~'||
                      IPCR_V7||'~'||
                      IPCR_V8||'~'||
                      IPCR_V9||'~'||
                      IPCR_V10||'~'||
                      IPCR_V11||'~'||
                      IPCR_V12||'~'||
                      IPCR_V13||'~'||
                      IPCR_V14||'~'||
                      IPCR_V15||'~'||
                      IPCR_V16||'~'||
                      IPCR_V17||'~'||
                      IPCR_V18||'~'||
                      IPCR_V19||'~'||
                      IPCR_V20 ipcr 
      bulk collect into imcr_strs
         from IM_POD_CHART_RESULTS
        where IPCR_POD_ID = IP_IDS(SERIES)
          AND IPCR_USERNAME = PI_USER_ID
          AND IPCR_SERIES_NAME = IPS_NAME(SERIES)
      order by ipcr_SEQ;
          
      for i in 1..imcr_strs.count 
       loop
        imcr_tab(i) := APEX_UTIL.STRING_TO_TABLE ( P_STRING    => imcr_strs(i),
                                              P_SEPARATOR => '~');
      end loop;
      
      if imcr_strs.count > 0 then
      
        if C = 3 then
          htp.p('<series name="'||ips_name(series)||'" type="'||STYPE(SERIES)||'" shape_type="'||SHAPE(SERIES) ||'" '||get_series_colours(colours,series) ||' >');                                
          FOR i IN 1..imcr_tab.count
           LOOP
            htp.p( '<point name="' ||imcr_tab(i)(5)||'" y="'||trim(to_char(imcr_tab(i)(6),'9999999.00'))||'" '||get_series_colours(colours,series,i) ||' >' );     
            htp.p(' <actions>');
            htp.p('<action type="navigateToURL" url="'||dbms_xmlgen.convert(imcr_tab(i)(4)) ||'" target="_top" />');
            htp.p('</actions>');
            htp.p('</point>');
          END loop;
          htp.p('</series>');
        ELSE
         FOR j IN 3..c
            LOOP
              htp.p('<series name="'||tab(j).col_name||'" type="'||STYPE(SERIES)||'" shape_type="'||SHAPE(SERIES) ||'" '||get_series_colours(colours,series) ||' >');                                
              FOR i IN 1..imcr_tab.count
               LOOP
                htp.p( '<point name="' ||imcr_tab(i)(5)||'" y="'||trim(to_char(imcr_tab(i)(3+j),'9999999.00'))||'" '||get_series_colours(colours,series,i) ||' >' );     
                htp.p(' <actions>');
                htp.p('<action type="navigateToURL" url="'||dbms_xmlgen.convert(imcr_tab(i)(4)) ||'" target="_top" />');
                htp.p('</actions>');
                htp.p('</point>');
              END loop;
              htp.p('</series>');
           end loop;
        end if;
      else
        htp.p('<series name="'||ips_name(series)||'" type="'||stype(series)||'" shape_type="'||shape(series) ||'"  >');
       for i in 1..imcr_tab.count
           LOOP                                          
            htp.p( '<point name="' ||imcr_tab(i)(5)||'" y="'||'0'||'" '||get_series_colours(colours,series,i) ||' >' );     
            htp.p(' <actions>');
            htp.p('<action type="navigateToURL" url="'||dbms_xmlgen.convert(imcr_tab(i)(4)) ||'" target="_top" />');
            htp.p('</actions>');
            htp.p('</point>');
          end loop;
          htp.p('</series>');      
      end if;
      
    end loop;  
    htp.p('</data>');
END GET_SERIES;


procedure get_series_settings(pi_chart_rec im_pod_chart%rowtype)
is
    l_chart_rec im_pod_chart%rowtype;
    l_font wwv_flow_global.vc_arr2;
    l_settings wwv_flow_global.vc_arr2;
begin 
    l_chart_rec := pi_chart_rec ;
    l_font := apex_util.string_to_table(l_chart_rec.hints_font);
    l_settings := apex_util.string_to_table(l_chart_rec.display_attr);

    if l_settings(1) = 'Y' 
     then 
      HTP.P('<tooltip_settings enabled="true">');
      htp.p('<format><![CDATA[{%Name}{enabled:False} - {%Value}{numDecimals:'||nvl(l_chart_rec.y_axis_decimal_place,0)||'}]]></format>');
              htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');
      htp.p('<position anchor="Float" valign="Top" padding="10" /> ');
      htp.p('</tooltip_settings>');
    end if;
    
    if l_settings(2) = 'Y'
    then 
      HTP.P('<label_settings enabled="true" mode="Outside" multi_line_align="Center">');
      htp.p('<format><![CDATA[{%Value}{numDecimals:'||nvl(l_chart_rec.y_axis_decimal_place,0)||'}]]></format>');
      htp.p('<background enabled="false"/>');    
      htp.p('<font family="Arial" size="10" color="0x000000" />');
      htp.p('</label_settings>');
    end if;
    htp.p('<line_style>');
    htp.p('<line enabled="true" thickness="1" opacity="1" />');
    htp.p('</line_style>');
    
    htp.p('<marker_settings enabled="True" >');
    htp.p('<marker type="'||l_chart_rec.marker_type||'" />');
    htp.p('</marker_settings>');
    
    HTP.P('<pie_style>');
  --  HTP.P('<fill color="#003366" />');
    HTP.P('</pie_style>');
    
   
    
end get_series_settings;

procedure get_scroll_settings(pi_settings wwv_flow_global.vc_arr2
                           ,pi_axis varchar2)
is
 l_settings wwv_flow_global.vc_arr2;
begin 
   l_settings := pi_settings;
   /*case     
     when l_settings(14) = pi_axis then htp.prn('<zoom enabled="true"  /> ');
     when l_settings(14) = 'B' then htp.prn('<zoom enabled="true" />');
   end case; 
   */
end get_scroll_settings;

procedure get_grid_settings(pi_settings wwv_flow_global.vc_arr2
                           ,pi_axis varchar2)
is
   l_settings wwv_flow_global.vc_arr2;
begin 
   l_settings := pi_settings;
   if l_settings(5)is null -- Major ticks default is enabled
    then 
       htp.prn('<major_tickmark  enabled="False" />');
   end if;
   if l_settings(6) is null -- Minor ticks default is enabled
    then 
       htp.prn('<minor_tickmark  enabled="False" />');
   end if;
   
   case     
     when l_settings(15) = pi_axis then htp.prn('<major_grid  enabled="True" /><minor_grid  enabled="True" /> ');
     when l_settings(15) = 'B' then htp.prn('<major_grid  enabled="True" /> <minor_grid  enabled="True" />');
     else htp.prn('<major_grid  enabled="False" /> <minor_grid  enabled="False" />');
   end case; 
  
end get_grid_settings;

procedure simple_xml(pi_page_id varchar2 default null
                      ,pi_user_id varchar2 default null
                      ,PI_POSITION varchar2 default null                     
                      ,XMLCALLDATE IN NUMBER DEFAULT NULL)  
AS
  l_chart_rec im_pod_chart%rowtype;       
  l_font wwv_flow_global.vc_arr2; 
  
  l_enabled varchar2(10);
  l_inverted varchar2(50);
  l_legend_layout varchar2(20);
  l_position varchar2(20);
  
   l_settings wwv_flow_global.vc_arr2;
  
BEGIN
   Nm3security.Set_User(p_Username => upper(pi_user_id));

  
    FOR CREC IN (SELECT A.*
      from im_pod_chart a
          ,im_user_pods b
      where 
        a.ip_id = b.iup_ip_id
      and
        (B.IUP_IT_ID = (select IT_ID from IM_TABS where IT_PAGE_ID = PI_PAGE_ID)
         or
      b.iup_it_id = PI_PAGE_ID)
      and 
        b.iup_hus_username = pi_user_id
      AND
        b.iup_pod_position = pi_position )
     LOOP
      l_chart_rec := crec;
    end loop; 
  
  

  l_settings := apex_util.string_to_table(l_chart_rec.display_attr);

    /* TODO implementation required */
       owa_util.mime_header('text/xml', FALSE, 'utf-8');
        
        owa_util.http_header_close;
        
        htp.p('');
      htp.p('<anychart>
  <settings>
    <animation enabled="true"/>
    <no_data show_waiting_animation="False">
      <label>
        <text></text>
        <font family="Verdana" bold="yes" size="10"/>
      </label>
    </no_data>
  </settings>
  <margin left="0" top="" right="0" bottom="0" />
  <charts>');
    htp.p('<chart plot_type="'||L_CHART_REC.CHART_TYPE||'" name="chart_179496829097239565"> ');
     htp.p(' <chart_settings>');
      IF L_CHART_REC.CHART_TITLE IS NULL
       THEN 
        htp.p('<title enabled="False"/>');
      ELSE 
        htp.p('<title enabled="True" text_align="Center" position="Top" >');
        htp.p('  <text>'||L_CHART_REC.CHART_TITLE||'</text>');
        
         l_font := apex_util.string_to_table(l_chart_rec.chart_title_font);
            htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');
            
        htp.p('</title>');
      end if;
        htp.p('<chart_background>');
      case 
      when l_chart_rec.bgtype = 'T' then 
        htp.p('<fill enabled="true" opacity="2"/>');
      when l_chart_rec.bgtype = 'S' then   
          htp.p('<fill type="Solid" color="'||l_chart_rec.bgcolor1||'" opacity="1" />');
      when l_chart_rec.bgtype = 'G' then 
          htp.p('<fill type="Gradient" color="'||l_chart_rec.bgcolor1||'" opacity="1" >');
          htp.p('<gradient angle="'||l_chart_rec.gradient_rotation ||'">');
          htp.p('<key color="'||l_chart_rec.bgcolor1 ||'" />');
          htp.p('<key color="'||l_chart_rec.bgcolor2 ||'" />');
          htp.p('</gradient>');
          htp.p('</fill>');
      else
          htp.p('<fill enabled="true" opacity="2"/>');
      end case;    
        htp.p('<border enabled="false"/>');
        htp.p('<corners type="Square"/>');
        htp.p('</chart_background>');
        htp.p('<data_plot_background>');

        htp.p('</data_plot_background>');
        htp.p('<axes>');
        htp.p('  <y_axis >');
        --htp.p('    <scale   mode="Normal"    />');
        l_inverted := null;
        if l_settings(10) = 'Y'
         then 
           l_inverted := ' inverted="True" ' ;
        end if;
        htp.p('<scale mode="'||l_chart_rec.cmode||'"'||l_inverted ||'/>');
        if l_chart_rec.y_axis_title is null         
         then 
           htp.p(' <title enabled="False">');
              htp.p('<text>y title</text>');
              htp.p('<font family="Tahoma" size="14" color="0x000000" />');
            htp.p('</title>');
        else
          l_font := apex_util.string_to_table(l_chart_rec.y_axis_title_font);
           htp.p(' <title enabled="true">');
              htp.p('<text>'||l_chart_rec.y_axis_title||'</text>');
              htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');
              
            htp.p('</title>');
        end if;
            htp.p('<labels enabled="true" position="Outside" rotation="'||l_chart_rec.values_rotation||'">');
            l_font := apex_util.string_to_table(l_chart_rec.values_font);
            Htp.P('<font family="'||L_Font(1)||'" size="'||L_Font(2)||'" color="'||L_Font(3)||'" />');
            htp.p('<format>'||l_chart_rec.Y_AXIS_PREFIX||'<![CDATA[{%Value}{numDecimals:'||nvl(l_chart_rec.y_axis_decimal_place,0)||'}]]>'||l_chart_rec.y_axis_postfix||'</format>');              
            htp.p('</labels>');
            
            if l_chart_rec.y_axis_min is not null 
               or 
               l_chart_rec.y_axis_max is not null 
             then 
                htp.p('<scale');
                  if l_chart_rec.y_axis_min is not null 
                   then 
                    htp.p(' minimum="'||l_chart_rec.y_axis_min||'"');
                  end if;
                  if l_chart_rec.y_axis_max is not null 
                   then 
                    htp.p(' maximum="'||l_chart_rec.y_axis_max||'"');             
                  end if;
                htp.p('/>');
            end if;
            get_grid_settings(pi_settings => l_settings,pi_axis => 'Y');
            get_scroll_settings(pi_settings => l_settings,pi_axis => 'Y');
          htp.p('</y_axis>');
          
        htp.p('  <x_axis >');
       l_inverted := null;
        if l_settings(9) = 'Y'
         then 
           l_inverted := ' inverted="True" ' ;
        end if;
        
        htp.p('<scale mode="'||l_chart_rec.cmode||'"'||l_inverted ||'/>');
        
        if l_chart_rec.x_axis_title is null         
         then 
           htp.p(' <title enabled="False">');
              htp.p('<text>x title</text>');
              htp.p('<font family="Tahoma" size="14" color="0x000000" />');
            htp.p('</title>');
        else
          l_font := apex_util.string_to_table(l_chart_rec.x_axis_title_font);
           htp.p(' <title enabled="true">');
              htp.p('<text>'||l_chart_rec.x_axis_title||'</text>');
              htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');              
            htp.p('</title>');
        end if;   
        
        if l_settings(3) = 'Y'
         THEN 
        htp.p('<labels enabled="true"  rotation="'||l_chart_rec.names_rotation||'" position="Outside">');
        l_font := apex_util.string_to_table(l_chart_rec.names_font);
        htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');
        htp.p('<format>'||l_chart_rec.x_AXIS_PREFIX||'<![CDATA[{%Value}{numDecimals:'||l_chart_rec.x_axis_decimal_place||'}]]>'||l_chart_rec.x_axis_postfix||'</format>');              
        htp.p('</labels>');
        else
        htp.p('<labels enabled="false" />');
        end if;
            
            if l_chart_rec.x_axis_min is not null 
               or 
               l_chart_rec.x_axis_max is not null 
             then 
                htp.p('<scale');
                  if l_chart_rec.x_axis_min is not null 
                   then 
                    htp.p(' minimum="'||l_chart_rec.x_axis_min||'"');
                  end if;
                  if l_chart_rec.x_axis_max is not null 
                   then 
                    htp.p(' maximum="'||l_chart_rec.x_axis_max||'"');             
                  end if;
                htp.p('/>');
            end if;
            get_grid_settings(pi_settings => l_settings,pi_axis => 'X');
            get_scroll_settings(pi_settings => l_settings,pi_axis => 'X');
          htp.p('</x_axis>');
        htp.p('</axes>');

       
        l_enabled := 'true';
        case 
          when l_chart_rec.show_legend = 'N' then  l_enabled := 'false';
          when l_chart_rec.show_legend = 'L' then  l_position := 'Left';
          when l_chart_rec.show_legend = 'R' then  l_position := 'Right';
          when l_chart_rec.show_legend = 'T' then  l_position := 'Top';
          when l_chart_rec.show_legend = 'B' then  l_position := 'Bottom';
          when l_chart_rec.show_legend = 'F' then  l_position := 'Float';          
        end case;
        
        case 
         when l_chart_rec.legend_layout = 'V' then l_legend_layout := 'Vertical';
         when l_chart_rec.legend_layout = 'H' then l_legend_layout := 'Horizontal';
        end case;
        
        htp.p('<legend enabled="'||l_enabled||'" position="'||l_position||'" align="Near" elements_layout="'||l_legend_layout||'" anchor="RightTop">');
          htp.p('<title enabled="False"/>');
          if l_chart_rec.legend_title is null         
         then 
           htp.p(' <title enabled="False">');
              htp.p('<text>x title</text>');
              htp.p('<font family="Tahoma" size="14" color="0x000000" />');
            htp.p('</title>');
        else
          l_font := apex_util.string_to_table(l_chart_rec.legend_font);
           htp.p(' <title enabled="true">');
              htp.p('<text>'||l_chart_rec.legend_title||'</text>');
              htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');              
            htp.p('</title>');
        end if;      
          htp.p('<font family="'||l_font(1)||'" size="'||l_font(2)||'" color="'||l_font(3)||'" />');              
        htp.p('</legend>');


        htp.p('<chart_animation type="'||l_chart_rec.chart_animation||'" interpolation_type="Quadratic" show_mode="OneByOne"/>');
        htp.p('</chart_settings>');
        htp.p('<data_plot_settings enable_3d_mode="'||l_chart_rec.enable_3d||'" >');
        htp.p('<line_series>');
          get_series_settings(pi_chart_rec => l_chart_rec);
        htp.p('</line_series>');
        htp.p('<bar_series>');
          get_series_settings(pi_chart_rec => l_chart_rec);          
        htp.p('</bar_series>');
        
        htp.p('<pie_series>');
          get_series_settings(pi_chart_rec => l_chart_rec);          
        htp.p('</pie_series>');

        
      htp.p('</data_plot_settings>');

     get_series(pi_page_id 
               ,pi_user_id 
               ,pi_position
               ,l_chart_rec);
      
      htp.p('</chart>
  </charts>
</anychart>');
 
end simple_xml;
  
  
procedure get_dial_100
is
begin 
    owa_util.mime_header('text/xml', FALSE, 'utf-8');
    
    owa_util.http_header_close;
    
    htp.p('');
    htp.p('<anychart>
  <gauges>
    <gauge>
      <chart_settings>
        <title>
          <text>MPH Speedometer</text>
        </title>
      </chart_settings>
      <circular>
        <axis radius="50" start_angle="90" sweep_angle="180">
          <scale minimum="0" maximum="120" major_interval="20" minor_interval="5" />
        </axis>
      </circular>
    </gauge>
  </gauges>
</anychart>
');
END GET_DIAL_100;

FUNCTION POD_DRILLDOWN(PI_MODULE  VARCHAR2)
return varchar2
IS
   l_rtrn varchar2(4000);
begin 
   for crec in ( select * 
                 from im_pod_sql a
                      ,im_pods b
                  where 
                    A.IPS_IP_ID = B.IP_ID
                   AND
                    b.ip_hmo_module= pi_module)
    loop
       l_rtrn :=  crec.ips_source_code;
   end loop;
   return l_rtrn;

END POD_DRILLDOWN;

FUNCTION POD_DRILLDOWN_IR( PI_MODULE  VARCHAR2
                         , PI_PARAM1 VARCHAR2 DEFAULT NULL
                         , PI_PARAM2 VARCHAR2 DEFAULT NULL
                         , PI_PARAM3 VARCHAR2 DEFAULT NULL
                         , PI_PARAM4 VARCHAR2 DEFAULT NULL
                         , PI_PARAM5 varchar2 default null
                         , PI_PARAM6 VARCHAR2 DEFAULT NULL
                         , PI_PARAM7 varchar2 default null
                         , PI_PARAM8 varchar2 default null
                         , PI_PARAM9 varchar2 default null
                         , PI_PARAM10 VARCHAR2 DEFAULT NULL
                         , PI_PARAM11 varchar2 default null
                         , PI_PARAM12 varchar2 default null
                         , PI_PARAM13 varchar2 default null
                         , PI_PARAM14 varchar2 default null
                         , PI_PARAM15 VARCHAR2 DEFAULT NULL
                         )
return varchar2
IS
   l_rtrn varchar2(4000);
   
   L_PARAM1  varchar2(4000) default null;
   L_PARAM2  varchar2(4000) default null;
   L_PARAM3  varchar2(4000) default null;
   L_PARAM4  varchar2(4000) default null;
   L_PARAM5  varchar2(4000) default null;
   L_PARAM6  varchar2(4000) default null;
   L_PARAM7  varchar2(4000) default null;
   L_PARAM8  varchar2(4000) default null;
   L_PARAM9  varchar2(4000) default null;
   L_PARAM10 varchar2(4000) default null;
   L_PARAM11 varchar2(4000) default null;
   l_PARAM12 varchar2(4000) default null;
   L_PARAM13 varchar2(4000) default null;
   L_PARAM14 varchar2(4000) default null;
   l_PARAM15 varchar2(4000) default null;
                         
   
begin 
   for crec in ( select * 
                 from im_pod_sql a
                      ,im_pods b
                  where 
                    A.IPS_IP_ID = B.IP_ID
                   AND
                    b.ip_hmo_module= pi_module)
    loop
       l_rtrn :=  crec.ips_source_code;
   END LOOP;
   
   if PI_PARAM1 is null then 
      L_PARAM1 := 'null' ;
   else
      l_param1 := NM3FLX.STRING(PI_PARAM1);
   end if;  
   if PI_PARAM2 is null then 
      L_PARAM2 := 'null' ;
   else
      l_param2 := NM3FLX.STRING(PI_PARAM2);
   end if;  
   if PI_PARAM3 is null then 
      L_PARAM3 := 'null' ;
   else
      l_param3 := NM3FLX.STRING(PI_PARAM3);
   end if;  
   if PI_PARAM4 is null then 
      L_PARAM4 := 'null' ;
   else
      l_param4 := NM3FLX.STRING(PI_PARAM4);
   end if;  
   if PI_PARAM5 is null then 
      L_PARAM5 := 'null' ;
   else
      l_param5 := NM3FLX.STRING(PI_PARAM5);
   end if;  
   if PI_PARAM6 is null then 
      L_PARAM6 := 'null' ;
   else
      l_param6 := NM3FLX.STRING(PI_PARAM6);
   end if;  
   if PI_PARAM7 is null then 
      L_PARAM7 := 'null' ;
   else
      l_param7 := NM3FLX.STRING(PI_PARAM7);
   end if;  
   if PI_PARAM8 is null then 
      L_PARAM8 := 'null' ;
   else
      l_param8 := NM3FLX.STRING(PI_PARAM8);
   end if;  
   if PI_PARAM9 is null then 
      L_PARAM9 := 'null' ;
   else
      l_param9 := NM3FLX.STRING(PI_PARAM9);
   end if;  
   if PI_PARAM10 is null then 
      L_PARAM10 := 'null' ;
   else
      l_param10 := NM3FLX.STRING(PI_PARAM10);
   end if;  
   if PI_PARAM11 is null then 
      L_PARAM11 := 'null' ;
   else
      l_param11 := NM3FLX.STRING(PI_PARAM11);
   end if;  
   if PI_PARAM12 is null then 
      L_PARAM12 := 'null' ;
   else
      l_param12 := NM3FLX.STRING(PI_PARAM12);
   end if;  
   if PI_PARAM13 is null then 
      L_PARAM13 := 'null' ;
   else
      L_PARAM13 := NM3FLX.STRING(PI_PARAM13);
   end if;  
   if PI_PARAM14 is null then 
      L_PARAM14 := 'null' ;
   else
      L_PARAM14 := NM3FLX.STRING(PI_PARAM14);
   end if;  
   if PI_PARAM15 is null then 
      L_PARAM15 := 'null' ;
   else
      l_param15 := NM3FLX.STRING(PI_PARAM15);
   end if;  
   
   L_RTRN := replace(L_RTRN,':P6_PARAM15',l_PARAM15);
   L_RTRN := replace(L_RTRN,':P6_PARAM14',l_PARAM14);
   L_RTRN := replace(L_RTRN,':P6_PARAM13',l_PARAM13);
   L_RTRN := replace(L_RTRN,':P6_PARAM12',l_PARAM12);
   L_RTRN := replace(L_RTRN,':P6_PARAM11',l_PARAM11);
   L_RTRN := replace(L_RTRN,':P6_PARAM10',l_PARAM10);
   L_RTRN := REPLACE(L_RTRN,':P6_PARAM1',l_PARAM1);
   L_RTRN := REPLACE(L_RTRN,':P6_PARAM2',l_PARAM2);
   L_RTRN := REPLACE(L_RTRN,':P6_PARAM3',l_PARAM3);
   L_RTRN := REPLACE(L_RTRN,':P6_PARAM4',l_PARAM4);
   L_RTRN := replace(L_RTRN,':P6_PARAM5',l_PARAM5);   
   L_RTRN := replace(L_RTRN,':P6_PARAM6',l_PARAM6);   
   L_RTRN := replace(L_RTRN,':P6_PARAM7',l_PARAM7);   
   L_RTRN := replace(L_RTRN,':P6_PARAM8',l_PARAM8);   
   L_RTRN := replace(L_RTRN,':P6_PARAM9',l_PARAM9);   
   
   L_RTRN := replace(L_RTRN, '&APP_ID.','1000');
L_RTRN := replace(L_RTRN, '&APP_SESSION.',v('APP_SESSION'));
   
   return l_rtrn;

end POD_DRILLDOWN_IR;

FUNCTION COL_NAMES_FROM_QUERY(PI_QUERY VARCHAR2)
RETURN wwv_flow_global.vc_arr2
is
  C           NUMBER;
  D           NUMBER;
  COL_CNT     NUMBER;
  rec_tab     DBMS_SQL.DESC_TAB2;
  
  l_cols wwv_flow_global.vc_arr2;

begin 
  c := DBMS_SQL.OPEN_CURSOR;

  DBMS_SQL.PARSE(c, PI_QUERY, DBMS_SQL.NATIVE);
 
  d := DBMS_SQL.EXECUTE(c);
 
  DBMS_SQL.DESCRIBE_COLUMNS2(C, COL_CNT, REC_TAB);
  
  
  FOR I IN 1..REC_TAB.COUNT
   LOOP
    l_cols(i) :=replace(initcap(rec_tab(i).col_name),'_',chr(32));
  END LOOP;
  
  DBMS_SQL.CLOSE_CURSOR(C);
  
  return l_cols;
END COL_NAMES_FROM_QUERY;


end im_chart_gen;
/