-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/admin/xsd/remove_exor_mai_ws_schemas.sql-arc   1.2   May 07 2009 17:37:28   mhuitson  $
--       Module Name      : $Workfile:   remove_exor_mai_ws_schemas.sql  $
--       Date into PVCS   : $Date:   May 07 2009 17:37:28  $
--       Date fetched Out : $Modtime:   Apr 07 2009 22:41:08  $
--       Version          : $Revision:   1.2  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
/*
||Delete NSG EToN XML Schemas From XMLDB.
*/
DECLARE
  --
  PROCEDURE delete_schema(pi_schemaurl IN VARCHAR2) IS
  
    ex_not_registered EXCEPTION;
    PRAGMA exception_init(ex_not_registered, -31000);
  BEGIN
    --
    DBMS_XMLSCHEMA.deleteSchema(SCHEMAURL     => pi_schemaurl
                               ,DELETE_OPTION => dbms_xmlschema.DELETE_CASCADE_FORCE);
    --
  EXCEPTION
   WHEN ex_not_registered THEN
     Null;
   WHEN others THEN
     RAISE;        
  END delete_schema;
  --
BEGIN
  --
  delete_schema(pi_schemaurl => 'Exor_mai_ws-v2-0.xsd');
  --
  delete_schema(pi_schemaurl => 'Exor_mai_wsCore-v2-0.xsd');
  --
  delete_schema(pi_schemaurl => 'Exor_mai_ws-v2-1.xsd');
  --
  delete_schema(pi_schemaurl => 'Exor_mai_wsCore-v2-1.xsd');
  --
  delete_schema(pi_schemaurl => 'Exor_mai_ws-v2-2.xsd');
  --
  delete_schema(pi_schemaurl => 'Exor_mai_wsCore-v2-2.xsd');
  --
END;
/
