
/***************************************************************************/

set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** HIG_PRODUCTS **********--
SET TERM ON
PROMPT hig_products
SET TERM OFF

--
--



--********** HIG_MODULES **********--
SET TERM ON
PROMPT hig_modules
SET TERM OFF
--

--

delete from HIG_MODULES where HMO_MODULE = 'XKY_VIEW';

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
   SELECT 'XKY_VIEW', 'Create KY Views', 'XKY_VIEW.rep_params', 'WEB', NULL, 
    'N', 'N', 'AST', NULL FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                      WHERE HMO_MODULE = 'XKY_VIEW');
                      





COMMIT;
--


delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD =  'XKY_VIEW';

update HIG_STANDARD_FAVOURITES set HSTF_ORDER =  HSTF_ORDER + 3 where HSTF_ORDER  > 6
and HSTF_PARENT = 'NET_QUERIES';


INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'XKY_VIEW'
       , 'Create KY Views'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'XKY_VIEW')
                    

                    ;
                                            
----------------------
--
COMMIT;    

--

--


--
--
--********** HIG_MODULE_ROLES **********--
SET TERM ON
PROMPT hig_module_roles
SET TERM OFF
--

--
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 select 'XKY_VIEW', 'NET_USER', 'NORMAL' from dual
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'XKY_VIEW'
                   AND HMR_ROLE = 'NET_USER');               
                


commit;

set feedback on
set define on                   
--
-------------------------------
-- END OF METADATA --
-------------------------------
--
