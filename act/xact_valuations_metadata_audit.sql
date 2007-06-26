DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_valuations_metadata_audit.sql	1.1 03/14/05
--       Module Name      : xact_valuations_metadata_audit.sql
--       Date into SCCS   : 05/03/14 23:11:02
--       Date fetched Out : 07/06/06 14:33:50
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
   c_table_name CONSTANT VARCHAR2(30) := 'NM_INV_ITEMS_ALL';
BEGIN
--
   DELETE FROM nm_audit_key_cols
   WHERE  nkc_table_name = c_table_name;
   DELETE FROM nm_audit_columns
   WHERE  nac_table_name = c_table_name;
   DELETE FROM nm_audit_tables
   WHERE  nat_table_name = c_table_name;
--
   INSERT INTO nm_audit_tables
          (nat_table_name
          ,nat_table_alias
          ,nat_audit_insert
          ,nat_audit_update
          ,nat_audit_delete
          )
   VALUES (c_table_name -- nat_table_name
          ,Null         -- nat_table_alias
          ,'Y'          -- nat_audit_insert
          ,'Y'          -- nat_audit_update
          ,'Y'          -- nat_audit_delete
          );
--
   nm3audit.reset_nac_to_default (c_table_name);
   nm3audit.reset_nkc_to_default (c_table_name);
--
   COMMIT;
--
END;
/
