CREATE OR REPLACE VIEW eam_ft_inv_type_groupings(eftg_id
                                                ,eftg_inv_type
                                                ,eftg_inv_type_descr
                                                ,eftg_table_name
                                                ,eftg_pk_column
                                                ,eftg_fk_column
                                                ,eftg_descr_column
                                                ,eftg_parent_inv_type
                                                ,eftg_parent_inv_type_descr
                                                ,eftg_parent_table_name
                                                ,eftg_parent_pk_col
                                                ,eftg_date_created
                                                ,eftg_date_modified
                                                ,eftg_modified_by
                                                ,eftg_created_by)
AS 
SELECT 
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/icc/eam/admin/vw/eam_ft_inv_type_groupings.vw-arc   1.0   Nov 28 2008 11:02:36   mhuitson  $
--       Module Name      : $Workfile:   eam_ft_inv_type_groupings.vw  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:02:36  $
--       Date fetched Out : $Modtime:   Sep 24 2007 13:14:02  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
          eftg_id                    eftg_id
        , eftg_inv_type              eftg_inv_type
        , ch.nit_descr               eftg_inv_type_descr
        , ch.nit_table_name          eftg_table_name
        , ch.nit_foreign_pk_column   eftg_pk_column
        , eftg_fk_column             eftg_fk_column
        , eftg_descr_column          eftg_descr_column
        , eftg_parent_inv_type       eftg_parent_inv_type
        , pr.nit_descr               eftg_parent_inv_type_descr        
        , pr.nit_table_name          eftg_parent_table_name
        , pr.nit_foreign_pk_column   eftg_parent_pk_col
        , eftg_date_created          eftg_date_created
        , eftg_date_modified         eftg_date_modified
        , eftg_modified_by           eftg_modified_by
        , eftg_created_by            eftg_created_by
FROM  eam_ft_inv_type_groupings_all eftg LEFT OUTER JOIN nm_inv_types pr ON eftg.eftg_parent_inv_type  = pr.nit_inv_type
     ,nm_inv_types ch
WHERE ch.nit_inv_type     = eftg.eftg_inv_type
/
