CREATE OR REPLACE PACKAGE XOR_merge_extract AS
--
-- R. Ellis - Sept. 2011

 
  g_sccsid  CONSTANT varchar2(2000) :='"$Revision:  4.2 NOT IN PVCS  $"';
--
-- g_package_name    CONSTANT  varchar2(30)   := 'XOR_merge_extract';
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2
;
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2;
-----------------------------------------------------------------------------
PROCEDURE rep_params ;

PROCEDURE rep_params_2 (pi_selected_query varchar2) ;

PROCEDURE report (pi_selected_result number,
                pi_selected_query  varchar2 ,
                pi_delim varchar2) ;
END XOR_merge_extract;
/
