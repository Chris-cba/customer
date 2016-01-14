-- R. Ellis - Sept. 2011

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

delete from HIG_MODULES where HMO_MODULE = 'MERGE_EX';

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
   SELECT 'MERGE_EX', 'Auto Merge Extract', 'xor_merge_extract.rep_params', 'WEB', NULL, 
    'N', 'N', 'AST', NULL FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                      WHERE HMO_MODULE = 'MERGE_EX');
                      





COMMIT;
--


delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD =  'MERGE_EX';

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
       ,'MERGE_EX'
       , 'Automatic Merge Extract'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'MERGE_EX')
                    

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
 select 'MERGE_EX', 'NET_USER', 'NORMAL' from dual
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'MERGE_EX'
                   AND HMR_ROLE = 'NET_USER');               
                


commit;

set feedback on
set define on                   
--
-------------------------------
-- END OF METADATA --
-------------------------------
--
