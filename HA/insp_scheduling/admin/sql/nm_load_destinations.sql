-
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/admin/sql/nm_load_destinations.sql-arc   1.1   Jan 27 2016 12:07:42   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_load_destinations.sql  $
--       Date into PVCS   : $Date:   Jan 27 2016 12:07:42  $
--       Date fetched Out : $Modtime:   Jan 25 2016 15:23:14  $
--       PVCS Version     : $Revision:   1.1  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2012
-----------------------------------------------------------------------------
--

 ----------------------------------------------------------------------------------------
-- NM_LOAD_DESTINATIONS
--
-- select * from nm3_metadata.nm_load_destinations
-- order by nld_id
--
----------------------------------------------------------------------------------------
DECLARE

CURSOR get_id IS
select NLD_ID_SEQ.nextval from dual;

l_id number;

BEGIN

  OPEN get_id;
  FETCH get_id INTO l_id;
  CLOSE get_id;
  
  INSERT INTO NM_LOAD_DESTINATIONS
         (NLD_ID
         ,NLD_TABLE_NAME
         ,NLD_TABLE_SHORT_NAME
         ,NLD_INSERT_PROC
         ,NLD_VALIDATION_PROC
         )
  SELECT 
          l_id
         ,'V_HA_UPD_INSP'
         ,'V_INP'
         ,'HA_INSP.UPDATE_INSPECTIONS'
         ,'' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                     WHERE NLD_ID = l_id
                     or nld_table_name = 'V_HA_UPD_INSP');
  
  OPEN get_id;
  FETCH get_id INTO l_id;
  CLOSE get_id;
                     
  INSERT INTO NM_LOAD_DESTINATIONS
         (NLD_ID
         ,NLD_TABLE_NAME
         ,NLD_TABLE_SHORT_NAME
         ,NLD_INSERT_PROC
         ,NLD_VALIDATION_PROC
         )
  SELECT 
          l_id
         ,'V_NM_INSP'
         ,'VINSP'
         ,'nm3api_inv_insp.insert_rowtype'
         ,'nm3api_inv_insp.validate_rowtype' FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                     WHERE NLD_ID = l_id
                     or nld_table_name = 'V_NM_INSP');  
  
  OPEN get_id;
  FETCH get_id INTO l_id;
  CLOSE get_id;
                     
  INSERT INTO NM_LOAD_DESTINATIONS
          (NLD_ID
          ,NLD_TABLE_NAME
          ,NLD_TABLE_SHORT_NAME
          ,NLD_INSERT_PROC
          ,NLD_VALIDATION_PROC
          )
   SELECT 
           l_id
          ,'V_HA_INS_INSL'
          ,'V_INL'
          ,'HA_INSP.CREATE_PARTIAL_INSPECTION'
          ,'' FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM NM_LOAD_DESTINATIONS
                      WHERE NLD_ID = l_id
                      or nld_table_name = 'V_HA_INS_INSL');

end;
/


