create or replace type
--<TYPE>
-----------------------------------------------------------------------------
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/intren/admin/typ/intren_marker_rec.sql-arc   3.0   Jan 18 2011 12:38:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   intren_marker_rec.sql  $
--       Date into PVCS   : $Date:   Jan 18 2011 12:38:14  $
--       Date fetched Out : $Modtime:   Sep 08 2010 15:54:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : iturnbull
--
--
-----------------------------------------------------------------------------
-- Copyright (c) bentley systems, 2010
-----------------------------------------------------------------------------
  intren_marker_rec as object
      (marker_id varchar(50)
      ,easting   varchar2(50)
      ,northing  varchar2(50)
      ,date_installed varchar2(50)
      ,date_decomissioned varchar2(50)
      ,contractor_organisation varchar2(200)
      ,street_name varchar2(50)
      ,nature_of_asset varchar2(200)
      ,material varchar2(50)
      ,domain_owner varchar2(50)
      ,job_reference               varchar2(50)
      ,job_type                    varchar2(50)
      ,town                        varchar2(50)
      ,depth                       varchar2(50)
      ,kerb_offset                 varchar2(50)
      ,shape_of_asset              varchar2(50)
      ,dim_of_asset                varchar2(50)
      ,fitting_type                varchar2(50)
      ,construction_type           varchar2(50)
      ,ubo_in_trench               varchar2(50)
      ,ubo_asset_type              varchar2(50)
      ,photo_type                  varchar2(50)
      ,previuos_marker             varchar2(50)
      ,geographic_location         varchar2(50)
      ,survey_job_no               varchar2(50)
      ,survey_method               varchar2(50)
      ,images                      intren_image_list
      );
/
