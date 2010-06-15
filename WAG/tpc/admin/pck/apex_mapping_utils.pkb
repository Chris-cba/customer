create or replace
package body apex_mapping_utils as
--<PACKAGE>
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/pck/apex_mapping_utils.pkb-arc   3.0   Jun 15 2010 14:49:00   iturnbull  $
--       Module Name      : $Workfile:   apex_mapping_utils.pkb  $
--       Date into PVCS   : $Date:   Jun 15 2010 14:49:00  $
--       Date fetched Out : $Modtime:   Jun 15 2010 14:36:12  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--</PACKAGE>
--
-----------------------------------------------------------------------------
--
procedure get_map_variables(pi_product hig_products.hpr_product%type)
is
BEGIN
   OWA_UTIL.mime_header ('text/xml', FALSE);
   HTP.p ('Cache-Control: no-cache');
   HTP.p ('Pragma: no-cache');
   OWA_UTIL.HTTP_HEADER_CLOSE;  
   HTP.prn ('<RECORDS>');

   FOR c IN ( select hov_id param_name
                   , hov_value param_value
                from HIG_OPTION_VALUES
                    ,HIG_OPTION_LIST
               where HOL_PRODUCT = pi_product
                 and HOL_ID = HOV_ID
            )
   LOOP
      HTP.prn ('<PARAM_NAME value="' || c.param_name   || '"></PARAM_NAME>');
      HTP.prn ('<PARAM_VALUE value="' || dbms_xmlgen.convert(c.param_value) || '"></PARAM_VALUE>');
   END LOOP;

   HTP.PRN ('</RECORDS>');
END get_map_variables;
--
-----------------------------------------------------------------------------
--
procedure GETMAPCENTERXY
is

 l_x number;
 l_y number;
begin
  L_X := GET_COOKIE(PI_NAME => 'POINTX');
  L_Y := GET_COOKIE(PI_NAME => 'POINTY');
  if L_X is null 
     or 
     l_y is null
   then
     MAPVIEWER.SET_CENT_SIZE_THEME;
     select GETX X, GETY Y
     into L_X, L_Y
     from dual;
  end if;
  
  owa_util.mime_header('text/xml',FALSE);
  htp.p('Cache-Control: no-cache');
  htp.p('Pragma: no-cache');
  owa_util.http_header_close;
  htp.prn('<RECORDS>');
  
    htp.prn(
             '<X value="' ||
             l_x ||
             '">' ||
             '</X>'||
             '<Y value="' ||
             l_y ||
             '">' ||
             '</Y>'
    );
  htp.prn('</RECORDS>');
end getmapcenterxy;
--
-----------------------------------------------------------------------------
--
  procedure SAVE_COOKIE(PI_NAME VARCHaR2
                     ,pi_value       varchar2)
is
begin
   owa_util.mime_header('text/html', FALSE);
   OWA_COOKIE.SEND(
                   name=> PI_NAME
                  ,value=>PI_VALUE
                  ,expires => sysdate + 365); 

exception
   when OTHERS then
      null;
end SAVE_COOKIE;
--
-----------------------------------------------------------------------------
--
function GET_COOKIE(PI_NAME varchar2)
return VARChar2
is
   c owa_cookie.cookie;
begin 
   C := OWA_COOKIE.GET(PI_NAME);
   return c.vals(1);
exception
   when OTHERS then
      return null;
end get_cookie;
--
-----------------------------------------------------------------------------
--
function GET_MAX_ZOOM
return varchar2
is
  rtrn number := 0;
begin 
   for VREC in 
   (select SUBSTR(extract(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels'),
          INSTR(extract(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"')+1,
          INSTR(extract(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"',1,2) - INSTR(extract(NM3XML.CLOB_TO_XML(DEFINITION), '/map_tile_layer/zoom_levels') ,'"')-1) zoomlevel
   from USER_SDO_CACHED_MAPS
   where name = UPPER(NVL(HIG.GET_USER_OR_SYS_OPT('BASEMAPSTR'), HIG.GET_USER_OR_SYS_OPT('WMSMAPSTR'))))
   LOOP 
      RTRN := VREC.ZOOMLEVEL;
   end loop;
   return (rtrn-1);
end GET_MAX_ZOOM;
--
-----------------------------------------------------------------------------
--
procedure get_max_zoom
is
begin 
   htp.prn(get_max_zoom);
end get_max_zoom;
--
-----------------------------------------------------------------------------
--

function get_cookie_value(pi_name varchar2)
return varchar2
is
  l_cookie owa_cookie.cookie;
  /*
  type cookie is RECORD
   (
      name     varchar2(4096),
      vals     vc_arr,
      num_vals integer
   );
  */
begin
  l_cookie := owa_cookie.get( name=>pi_name);
   return l_cookie.vals(1);
end get_cookie_value;
--
-----------------------------------------------------------------------------
--
end apex_mapping_utils;