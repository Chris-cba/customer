-
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/sql/nm_load_destinations.sql-arc   1.0   Jun 06 2012 16:19:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   nm_load_destinations.sql  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:19:30  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:32:46  $
--       PVCS Version     : $Revision:   1.0  $
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
end;
/


