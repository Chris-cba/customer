--
-- File:            nbdti_exor_delete_asset_location.SQL
--
-- Purpose:         Remove location memberships and sdo objects
--
--    2832803 fxml
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/NewBrunswick/delete asset/nbdti_exor_delete_asset_location.SQL-arc   1.0   Aug 20 2012 09:16:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   nbdti_exor_delete_asset_location.SQL  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:16:36  $
--       Date fetched Out : $Modtime:   Aug 20 2012 09:16:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2012 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

SET LINESIZE 2000
SET TRIMSPOOL ON
SET PAGESIZE 100

SET DEFINE ON

HOST CLS

PROMPT
ACCEPT var_asset_type PROMPT 'Enter Asset Type: '
PROMPT
ACCEPT var_asset_pk PROMPT 'Enter Primary Key: ' 
PROMPT

DEFINE Base_File_Name = "logs\delete_locations_&var_asset_pk._&var_asset_type."
DEFINE Log_File_Name = &Base_File_Name..log

WHENEVER OSERROR EXIT FAILURE

HOST IF NOT EXIST logs MKDIR logs

WHENEVER OSERROR CONTINUE

PROMPT
PROMPT

COLUMN TYPE FORMAT A5
COLUMN ASSET_PK FORMAT A10
COLUMN ACTIVE FORMAT A12
COLUMN INACTIVE FORMAT A12
COLUMN NBCS FORMAT A8
COLUMN BEG_OFFSET FORMAT 9999990.999
COLUMN END_OFFSET FORMAT 9999990.999

spool &Log_File_Name;


select * from (
SELECT asset.iit_inv_type AS type
      ,asset.iit_primary_key AS asset_pk
      ,TO_CHAR(nbcs_location.nm_start_date,'DD-MON-YYYY') AS ACTIVE
      ,TO_CHAR(nbcs_location.nm_end_date,'DD-MON-YYYY') AS INACTIVE
      ,nbcs.ne_descr nbcs
      ,DECODE(nbcs_location.nm_cardinality, 1, nbcs_location.nm_slk + (greatest(NVL(asset_location.nm_begin_mp,0),nbcs_location.nm_begin_mp))/1000 - nbcs_location.nm_begin_mp/1000,
              nbcs_location.nm_slk + (nbcs_location.nm_end_mp  - least(NVL(asset_location.nm_end_mp,9999), nbcs_location.nm_end_mp))/1000) AS BEG_OFFSET
      ,DECODE(nbcs_location.nm_cardinality, 1, nbcs_location.nm_end_slk - (nbcs_location.nm_end_mp - least(NVL(asset_location.nm_end_mp,9999), nbcs_location.nm_end_mp))/1000,
              nbcs_location.nm_slk + (nbcs_location.nm_end_mp - greatest(NVL(asset_location.nm_begin_mp,0), nbcs_location.nm_begin_mp))/1000) AS END_OFFSET
FROM
      nm_inv_items_all asset
      ,nm_members_all asset_location
      ,nm_elements_all nbcs
      ,nm_members_all nbcs_location
WHERE asset.iit_inv_type = upper('&var_asset_type.')
      AND asset.iit_primary_key = '&var_asset_pk.'
      AND asset.iit_ne_id = asset_location.nm_ne_id_in
      AND nbcs.ne_nt_type = 'NBCS'
      AND nbcs.ne_id = nbcs_location.nm_ne_id_in
      AND asset_location.nm_ne_id_of = nbcs_location.nm_ne_id_of
      AND ((asset_location.nm_begin_mp < nbcs_location.nm_end_mp AND asset_location.nm_end_mp > nbcs_location.nm_begin_mp AND asset_location.nm_begin_mp <> asset_location.nm_end_mp)
             OR (asset_location.nm_begin_mp <= nbcs_location.nm_end_mp AND asset_location.nm_end_mp >= nbcs_location.nm_begin_mp AND asset_location.nm_begin_mp = asset_location.nm_end_mp))
) order by nbcs, beg_offset;


PROMPT
PROMPT
ACCEPT var_delete_loc PROMPT 'WARNING: You are about to permanently delete locations for &var_asset_type. &var_asset_pk..  Continue? (Y/N): '
PROMPT

--delete all locations for asset

delete from nm_members_all 
where nm_ne_id_in = (select iit_ne_id 
                     from nm_inv_items_all 
                     where iit_inv_type = upper('&var_asset_type') and iit_primary_key = '&var_asset_pk')
  and upper('&var_delete_loc.') = 'Y';

--SDO objects are deleted by a trigger on members table


select * from (
SELECT asset.iit_inv_type AS type
      ,asset.iit_primary_key AS asset_pk
      ,TO_CHAR(nbcs_location.nm_start_date,'DD-MON-YYYY') AS ACTIVE
      ,TO_CHAR(nbcs_location.nm_end_date,'DD-MON-YYYY') AS INACTIVE
      ,nbcs.ne_descr nbcs
      ,DECODE(nbcs_location.nm_cardinality, 1, nbcs_location.nm_slk + (greatest(NVL(asset_location.nm_begin_mp,0),nbcs_location.nm_begin_mp))/1000 - nbcs_location.nm_begin_mp/1000,
              nbcs_location.nm_slk + (nbcs_location.nm_end_mp  - least(NVL(asset_location.nm_end_mp,9999), nbcs_location.nm_end_mp))/1000) AS BEG_OFFSET
      ,DECODE(nbcs_location.nm_cardinality, 1, nbcs_location.nm_end_slk - (nbcs_location.nm_end_mp - least(NVL(asset_location.nm_end_mp,9999), nbcs_location.nm_end_mp))/1000,
              nbcs_location.nm_slk + (nbcs_location.nm_end_mp - greatest(NVL(asset_location.nm_begin_mp,0), nbcs_location.nm_begin_mp))/1000) AS END_OFFSET
FROM
      nm_inv_items_all asset
      ,nm_members_all asset_location
      ,nm_elements_all nbcs
      ,nm_members_all nbcs_location
WHERE asset.iit_inv_type = upper('&var_asset_type.')
      AND asset.iit_primary_key = '&var_asset_pk.'
      AND asset.iit_ne_id = asset_location.nm_ne_id_in
      AND nbcs.ne_nt_type = 'NBCS'
      AND nbcs.ne_id = nbcs_location.nm_ne_id_in
      AND asset_location.nm_ne_id_of = nbcs_location.nm_ne_id_of
      AND ((asset_location.nm_begin_mp < nbcs_location.nm_end_mp AND asset_location.nm_end_mp > nbcs_location.nm_begin_mp AND asset_location.nm_begin_mp <> asset_location.nm_end_mp)
             OR (asset_location.nm_begin_mp <= nbcs_location.nm_end_mp AND asset_location.nm_end_mp >= nbcs_location.nm_begin_mp AND asset_location.nm_begin_mp = asset_location.nm_end_mp))
) order by nbcs, beg_offset;




commit;

spool off;