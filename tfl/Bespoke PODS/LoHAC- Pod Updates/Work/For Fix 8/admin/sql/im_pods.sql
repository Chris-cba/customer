SET DEFINE OFF;
MERGE INTO HIGHWAYS.HIG_MODULES A USING
 (SELECT
  'IM41016d' as HMO_MODULE,
  'EOT Request Report (EOP) - TOR' as HMO_TITLE,
  'IM41016d' as HMO_FILENAME,
  'WEB' as HMO_MODULE_TYPE,
  NULL as HMO_FASTPATH_OPTS,
  'Y' as HMO_FASTPATH_INVALID,
  'N' as HMO_USE_GRI,
  'IM' as HMO_APPLICATION,
  NULL as HMO_MENU
  FROM DUAL) B
ON (A.HMO_MODULE = B.HMO_MODULE)
WHEN NOT MATCHED THEN 
INSERT (
  HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
  HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
VALUES (
  B.HMO_MODULE, B.HMO_TITLE, B.HMO_FILENAME, B.HMO_MODULE_TYPE, B.HMO_FASTPATH_OPTS, 
  B.HMO_FASTPATH_INVALID, B.HMO_USE_GRI, B.HMO_APPLICATION, B.HMO_MENU)
WHEN MATCHED THEN
UPDATE SET 
  A.HMO_TITLE = B.HMO_TITLE,
  A.HMO_FILENAME = B.HMO_FILENAME,
  A.HMO_MODULE_TYPE = B.HMO_MODULE_TYPE,
  A.HMO_FASTPATH_OPTS = B.HMO_FASTPATH_OPTS,
  A.HMO_FASTPATH_INVALID = B.HMO_FASTPATH_INVALID,
  A.HMO_USE_GRI = B.HMO_USE_GRI,
  A.HMO_APPLICATION = B.HMO_APPLICATION,
  A.HMO_MENU = B.HMO_MENU;

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.HIG_MODULE_ROLES A USING
 (SELECT
  'IM41016d' as HMR_MODULE,
  'HIG_USER' as HMR_ROLE,
  'NORMAL' as HMR_MODE
  FROM DUAL) B
ON (A.HMR_MODULE = B.HMR_MODULE and A.HMR_ROLE = B.HMR_ROLE)
WHEN NOT MATCHED THEN 
INSERT (
  HMR_MODULE, HMR_ROLE, HMR_MODE)
VALUES (
  B.HMR_MODULE, B.HMR_ROLE, B.HMR_MODE)
WHEN MATCHED THEN
UPDATE SET 
  A.HMR_MODE = B.HMR_MODE;

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_PODS A USING
 (SELECT
  108 as IP_ID,
  'IM41016d' as IP_HMO_MODULE,
  'EOT Request Report (EOP) - TOR' as IP_TITLE,
  'extension of price has been  requested' as IP_DESCR,
  'IM41015' as IP_PARENT_POD_ID,
  'Y' as IP_DRILL_DOWN,
  'Table' as IP_TYPE,
  NULL as IP_GROUP,
  NULL as IP_HEADER,
  NULL as IP_FOOTER,
  0 as IP_CACHE_TIME
  FROM DUAL) B
ON (A.IP_ID = B.IP_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, 
  IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_HEADER, IP_FOOTER, 
  IP_CACHE_TIME)
VALUES (
  B.IP_ID, B.IP_HMO_MODULE, B.IP_TITLE, B.IP_DESCR, B.IP_PARENT_POD_ID, 
  B.IP_DRILL_DOWN, B.IP_TYPE, B.IP_GROUP, B.IP_HEADER, B.IP_FOOTER, 
  B.IP_CACHE_TIME)
WHEN MATCHED THEN
UPDATE SET 
  A.IP_HMO_MODULE = B.IP_HMO_MODULE,
  A.IP_TITLE = B.IP_TITLE,
  A.IP_DESCR = B.IP_DESCR,
  A.IP_PARENT_POD_ID = B.IP_PARENT_POD_ID,
  A.IP_DRILL_DOWN = B.IP_DRILL_DOWN,
  A.IP_TYPE = B.IP_TYPE,
  A.IP_GROUP = B.IP_GROUP,
  A.IP_HEADER = B.IP_HEADER,
  A.IP_FOOTER = B.IP_FOOTER,
  A.IP_CACHE_TIME = B.IP_CACHE_TIME;

COMMIT;
