-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/admin/xsd/register_exor_mai_ws_schemas.sql-arc   1.0   Dec 12 2008 13:38:50   mhuitson  $
--       Module Name      : $Workfile:   register_exor_mai_ws_schemas.sql  $
--       Date into PVCS   : $Date:   Dec 12 2008 13:38:50  $
--       Date fetched Out : $Modtime:   Dec 08 2008 15:17:58  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------

/*
||Get the path to the XSD files from the user.
*/
set define on;
undefine xsd_path
prompt
prompt
ACCEPT xsd_path prompt "Please enter the full path to the directory containing the exor_mai_ws xsd files : "

/*
||Register exor_mai_ws XML Schemas In XMLDB
||For Use In XML Validation.
||
*/
DECLARE
  --
  PROCEDURE register_xsd_from_file(pi_schemaurl IN VARCHAR2
                                  ,pi_oradir    IN VARCHAR2
                                  ,pi_filename  IN VARCHAR2) IS

  ex_already_registered EXCEPTION;
  PRAGMA exception_init(ex_already_registered, -31085);

  BEGIN
    --
    DBMS_XMLSCHEMA.REGISTERSCHEMA(schemaurl => pi_schemaurl
                                 ,schemadoc => bfilename(pi_oradir,pi_filename)
                                 ,local     => TRUE
                                 ,gentypes  => FALSE
                                 ,genbean   => FALSE
                                 ,gentables => FALSE
                                 ,force     => FALSE
                                 ,owner     => USER);
 EXCEPTION
   WHEN ex_already_registered THEN
     Null;
   WHEN others THEN
     RAISE;                                 
    --
  END register_xsd_from_file;
  --
  PROCEDURE create_directory IS
    --
    lv_path nm3type.max_varchar2;
    lv_sql  nm3type.max_varchar2;
    --
  BEGIN
    --
    SELECT '&xsd_path'
      INTO lv_path
      FROM DUAL
         ;
    --
    lv_sql := 'create or replace directory MAI_XSD_DIRECTORY as '||nm3flx.string(lv_path);
    --
    nm_debug.debug_on;
    nm_debug.debug(lv_sql);
    execute immediate lv_sql;
    nm_debug.debug_off;
    --
  END create_directory;
  --
BEGIN
  /*
  ||Create The Oracle Directory To Read The Files From.
  */
  create_directory;
  --
  register_xsd_from_file(pi_schemaurl => 'Exor_mai_wsCore-v2-0.xsd'
                        ,pi_oradir    => 'MAI_XSD_DIRECTORY'
                        ,pi_filename  => 'Exor_mai_wsCore-v2-0.xsd');
                          
  --
  register_xsd_from_file(pi_schemaurl => 'Exor_mai_ws-v2-0.xsd'
                        ,pi_oradir    => 'MAI_XSD_DIRECTORY'
                        ,pi_filename  => 'Exor_mai_ws-v2-0.xsd');
  --
END;
/
