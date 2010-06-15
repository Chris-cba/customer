/**************************************************************************

Product options for wag apex mapping 
  Third Party CLaims TPC 
  Planning APP       PLANAP

-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/tpc/install/WAGApexMapProductOptions.sql-arc   3.0   Jun 15 2010 14:50:50   iturnbull  $
--       Module Name      : $Workfile:   WAGApexMapProductOptions.sql  $
--       Date into PVCS   : $Date:   Jun 15 2010 14:50:50  $
--       Date fetched Out : $Modtime:   Jun 15 2010 14:42:32  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

**************************************************************************/

-- INITZOOM
-- DATASOURCE
-- WMSMAPSTR
-- MAPSRID
-- COPYRIGHT
-- COPYIMG
-- BASEURL
-- BASEMAPSTR

REM INSERTING into hig_products
insert into HIG_PRODUCTS
    (HPR_PRODUCT,HPR_PRODUCT_NAME,HPR_VERSION,HPR_PATH_NAME,HPR_KEY,HPR_SEQUENCE,HPR_IMAGE,HPR_USER_MENU,HPR_LAUNCHPAD_ICON,HPR_IMAGE_TYPE) 
  select
    'WAGTPC','WAG Third Party Claims','4.2.0.0',null,null,null,null,null,null,null
  from DUAL 
  where not exists (select 1 from hig_products where hpr_product = 'WAGTPC');
commit;

insert into HIG_PRODUCTS
    (HPR_PRODUCT,HPR_PRODUCT_NAME,HPR_VERSION,HPR_PATH_NAME,HPR_KEY,HPR_SEQUENCE,HPR_IMAGE,HPR_USER_MENU,HPR_LAUNCHPAD_ICON,HPR_IMAGE_TYPE) 
  select
    'WAGPAP','WAG Planning Application','4.2.0.0',null,null,null,null,null,null,null
  from DUAL 
  where not exists (select 1 from HIG_PRODUCTS where HPR_PRODUCT = 'WAGPAP');
commit;

-- WAGTPC
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCINIZOOM'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'INITZOOM'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCINIZOOM'
                   and B.HOL_PRODUCT = 'WAGTPC');
commit;

insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCDATASRC'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'DATASOURCE'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCDATASRC'
                   and B.HOL_PRODUCT = 'WAGTPC');
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCWMSMAP'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'WMSMAPSTR'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCWMSMAP'
                   and B.HOL_PRODUCT = 'WAGTPC');
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCMAPSRID'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'MAPSRID'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCMAPSRID'
                   and B.HOL_PRODUCT = 'WAGTPC');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCCPYRGHT'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'COPYRIGHT'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCCPYRGHT'
                   and B.HOL_PRODUCT = 'WAGTPC');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCCOPYIMG'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'COPYIMG'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCCOPYIMG'
                   and B.HOL_PRODUCT = 'WAGTPC');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCBASEURL'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'BASEURL'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCBASEURL'
                   and B.HOL_PRODUCT = 'WAGTPC');                   
commit;                   
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'TPCBASEMAP'
      ,'WAGTPC'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'BASEMAPSTR'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'TPCBASEMAP'
                   and B.HOL_PRODUCT = 'WAGTPC');                   
commit;                   
--
--
-- WAGPAP
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPINIZOOM'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'INITZOOM'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPINIZOOM'
                   and B.HOL_PRODUCT = 'WAGPAP');
commit;

insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPDATASRC'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'DATASOURCE'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPDATASRC'
                   and B.HOL_PRODUCT = 'WAGPAP');
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPWMSMAP'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'WMSMAPSTR'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPWMSMAP'
                   and B.HOL_PRODUCT = 'WAGPAP');
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPMAPSRID'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'MAPSRID'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPMAPSRID'
                   and B.HOL_PRODUCT = 'WAGPAP');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPCPYRGHT'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'COPYRIGHT'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPCPYRGHT'
                   and B.HOL_PRODUCT = 'WAGPAP');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPCOPYIMG'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'COPYIMG'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPCOPYIMG'
                   and B.HOL_PRODUCT = 'WAGPAP');                   
commit;
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPBASEURL'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'BASEURL'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPBASEURL'
                   and B.HOL_PRODUCT = 'WAGPAP');                   
commit;                   
insert into HIG_OPTION_LIST
     ( HOL_ID
      ,hol_product
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION)
select 'PAPBASEMAP'
      ,'WAGPAP'
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
from HIG_OPTION_LIST a
where HOL_PRODUCT = 'IM'
and HOL_ID = 'BASEMAPSTR'
and not exists ( select 1 
                  from HIG_OPTION_LIST B 
                 where B.HOL_ID = 'PAPBASEMAP'
                   and B.HOL_PRODUCT = 'WAGPAP');                   
commit;                   

begin 
NM_DEBUG.DEBUG_ON;
end;
/

Insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCCPYRGHT','Copyright ©2008 Exor Corporation Ltd');
Insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCDATASRC','wagtpc');
Insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCINIZOOM','3');
Insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCMAPSRID','262148');
Insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCWMSMAP','wag_wms13');
insert into HIG_OPTION_VALUES (HOV_ID,HOV_VALUE) values ('TPCBASEURL','http://195.188.241.201/mapviewer');

insert into HIG_OPTION_VALUES (HOV_ID, HOV_VALUE)
select HOL_ID, DECODE(HOL_DATATYPE,'VARCHAR2','Enter Value',1)
from HIG_OPTION_LIST where HOL_PRODUCT in( 'WAGPAP')
;

commit;