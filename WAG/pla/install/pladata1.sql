-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pladata1.sql-arc   3.0   Jul 08 2009 14:16:02   smarshall  $
--       Module Name      : $Workfile:   pladata1.sql  $
--       Date into PVCS   : $Date:   Jul 08 2009 14:16:02  $
--       Date fetched Out : $Modtime:   Jul 08 2009 14:15:30  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
--
--
insert into hig_products
   (hpr_product
   ,hpr_product_name
   ,hpr_version
   ,hpr_path_name
   ,hpr_key
   ,hpr_sequence
   ,hpr_image
   ,hpr_user_menu
   ,hpr_launchpad_icon
   ,hpr_image_type)
 select 'PLA'
      , 'enquiry manager planning app'
      , '4.0.5.2'
      , NULL
      , ''
      , 5
      , ''
      , NULL
      , 'UNKNOWN'
      , 'TIFF'
  from dual
 where not exists (select 1
                     from hig_products
                    where hpr_product = 'PLA')
/
--
insert into hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
select 'LANGUAGE'
      ,'PLA'
      ,'Enquiry NLPG Language'      
      ,'Current options for NLPG Languages are ''ENG'' and ''CYM''.'
      ,null
      ,'VARCHAR2'
      ,'N'
      ,'N'
  from dual
 where not exists (select 1
                     from hig_option_list
                    where hol_id = 'LANGUAGE')
/
--
insert into hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
select 'RADIUS'
      ,'PLA'
      ,'Enquiry NLPG Search radius'      
      ,'Radius of NLPG search'
      ,null
      ,'VARCHAR2'
      ,'N'
      ,'N'
  from dual
 where not exists (select 1
                     from hig_option_list
                    where hol_id = 'RADIUS')
/
--
insert into hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
select 'PLAURL'
      ,'PLA'
      ,'Planning Application URL'      
      ,'Planning Application URL'
      ,null
      ,'VARCHAR2'
      ,'Y'
      ,'N'
  from dual
 where not exists (select 1
                     from hig_option_list
                    where hol_id = 'PLAURL')
/
--
insert into hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
select 'PLACATE'
      ,'PLA'
      ,'Planning Enquiry Category'      
      ,'Holds the Enquiry Category which triggers the Planning system'
      ,null
      ,'VARCHAR2'
      ,'N'
      ,'N'
  from dual
 where not exists (select 1
                     from hig_option_list
                    where hol_id = 'PLACATE')
/
--
insert into hig_option_values
      (hov_id
      ,hov_value)
select 'LANGUAGE'
      ,'ENG'
  from dual
 where not exists (select 1
                     from hig_option_values
                    where hov_id = 'LANGUAGE')
/
insert into hig_option_values
      (hov_id
      ,hov_value)
select 'RADIUS'
      ,'100'
  from dual
 where not exists (select 1
                     from hig_option_values
                    where hov_id = 'RADIUS')
/
insert into hig_option_values
      (hov_id
      ,hov_value)
select 'PLACATE'
      ,'PLAN'
  from dual
 where not exists (select 1
                     from hig_option_values
                    where hov_id = 'PLACATE')
/
--
--
COMMIT;
--
set feedback on
set define on
--
--
