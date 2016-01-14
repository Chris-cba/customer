SET DEFINE OFF;
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('WOWT001', 'Work Orders to Instruct', 'WOWT001', 'WEB', 
    'Y', 'N', 'IM');
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('WOWT002', 'Re-Submitted Work Orders', 'WOWT002', 'WEB', 
    'Y', 'N', 'IM');
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('WOWT003', 'Work Orders - Draft Status', 'WOWT003', 'WEB', 
    'Y', 'N', 'IM');
COMMIT;


SET DEFINE OFF;
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('WOWT001', 'HIG_USER', 'NORMAL');
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('WOWT002', 'HIG_USER', 'NORMAL');
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('WOWT003', 'HIG_USER', 'NORMAL');
COMMIT;


SET DEFINE OFF;
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (489, 'WOWT002', 'Re-Submitted Work Orders', 
    'Y', 'Chart', 'WOWT', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (490, 'WOWT003', 'Work Orders - Draft Status', 
    'Y', 'Chart', 'WOWT', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (460, 'WOWT001', 'Work Orders to Instruct', 'Displays work orders waiting to be instructed', 
    'Y', 'Chart', 'WOWT', 0);
COMMIT;


SET DEFINE OFF;
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1154, 489, 2, 'SELECT LINK, DAYS, "1A"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS
', '1A', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1121, 460, 2, 'SELECT LINK, DAYS, "1A"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS', '1A', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1122, 460, 3, 'SELECT LINK, DAYS, "2H"
from (
select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS 

', '2H', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1123, 460, 4, 'SELECT LINK, DAYS, "2M"
from (select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS', '2M', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1124, 460, 5, 'SELECT LINK, DAYS, "2L"
from (
select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS', '2L', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1160, 490, 1, 'select link, DAYS, "LS"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''||''0-2''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''0-2'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''0-2'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''||''3-5''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''3-5'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''3-5'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''|| ''6-30''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''6-30'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''6-30'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''|| ''>30''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''>30'' DAYS,  count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''>30'' and work_order_number = works_order_number)
ORDER BY DAYS', 'Lump Sum', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1157, 489, 5, 'SELECT LINK, DAYS, "2L"
from (
select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS', '2L', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1155, 489, 3, 'SELECT LINK, DAYS, "2H"
from (
select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS ', '2H', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1156, 489, 4, 'SELECT LINK, DAYS, "2M"
from (select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS', '2M', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1158, 489, 1, 'SELECT LINK, DAYS, NON
from ( select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''NON'' and work_order_number = works_order_number
 UNION
 SELECT ''javascript:showWOWTDrillDown(512.,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' AS LINK, ''2-7'' DAYS, COUNT(*) "NON" FROM X_WO_TFL_WORK_TRAY_IM511002,X_IM511002_WO_VW  WHERE DAYS = ''2-7'' AND DEF_PRI = ''NON'' AND WORK_ORDER_NUMBER = WORKS_ORDER_NUMBER
 UNION
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''NON'' and work_order_number = works_order_number)
ORDER BY DAYS', 'Non Defective', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1159, 490, 2, 'select link, DAYS, "Non LS"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''||''0-2''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''0-2'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''0-2'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''||''3-5''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''3-5'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''3-5'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''|| ''6-30''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''6-30'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''6-30'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''|| ''>30''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''>30'' DAYS,  count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''>30'' and work_order_number = works_order_number)
ORDER BY DAYS', 'Non Lump Sum', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1120, 460, 1, 'SELECT LINK, DAYS, NON
from ( select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''NON'' and work_order_number = works_order_number
 UNION
 SELECT ''javascript:showWOWTDrillDown(512.,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' AS LINK, ''2-7'' DAYS, COUNT(*) "NON" FROM X_WO_TFL_WORK_TRAY_IM511001,X_IM511001_WO_VW  WHERE DAYS = ''2-7'' AND DEF_PRI = ''NON'' AND WORK_ORDER_NUMBER = WORKS_ORDER_NUMBER
 UNION
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''NON'' and work_order_number = works_order_number)
ORDER BY DAYS
', 'Non Defective', 
    'Bar', 'Box');
COMMIT;

SET DEFINE OFF;
Insert into IM_POD_CHART
   (IP_ID, CHART_TYPE, CHART_WIDTH, CHART_HEIGHT, CHART_ANIMATION, MARKER_TYPE, DISPLAY_ATTR, MARGINS, CUSTOM_COLORS, BGTYPE, X_AXIS_GROUP_SEP, Y_AXIS_GROUP_SEP, NAMES_FONT, NAMES_ROTATION, VALUES_FONT, VALUES_ROTATION, HINTS_FONT, LEGEND_FONT, CHART_TITLE_FONT, X_AXIS_TITLE_FONT, Y_AXIS_TITLE_FONT, SHOW_LEGEND, LEGEND_LAYOUT, CMODE, ENABLE_3D)
 Values
   (489, 'CategorizedVertical', '95%', '300', 
    'Appear', 'None', 'Y::Y::Y:Y::::::V:T:N:N:', ':::', 
    'Y:Y:Y:Y', 'T', 
    'Y', 'Y', 'Arial:10:', 0, 'Arial:10:#000000', 0, 'Arial:10:', 'Arial:10:#000000', 'Arial:10:', 'Arial:10:#000000', 'Arial:10:#000000', 'R', 'V', 'Stacked', 'True');
Insert into IM_POD_CHART
   (IP_ID, CHART_TYPE, CHART_WIDTH, CHART_HEIGHT, CHART_ANIMATION, MARKER_TYPE, DISPLAY_ATTR, MARGINS, CUSTOM_COLORS, BGTYPE, X_AXIS_GROUP_SEP, Y_AXIS_GROUP_SEP, NAMES_FONT, NAMES_ROTATION, VALUES_FONT, VALUES_ROTATION, HINTS_FONT, LEGEND_FONT, CHART_TITLE_FONT, X_AXIS_TITLE_FONT, Y_AXIS_TITLE_FONT, SHOW_LEGEND, LEGEND_LAYOUT, CMODE, ENABLE_3D)
 Values
   (490, 'CategorizedHorizontal', '95%', '300', 
    'Appear', 'None', 'Y::Y::Y:Y::::::V:T:N:N:', ':::', 
    'Y:Y:Y:Y', 'T', 
    'Y', 'Y', 'Arial:10:', 0, 'Arial:10:#000000', 0, 'Arial:10:', 'Arial:10:#000000', 'Arial:10:', 'Arial:10:#000000', 'Arial:10:#000000', 'R', 'V', 'Normal', 'False');
Insert into IM_POD_CHART
   (IP_ID, CHART_TYPE, CHART_WIDTH, CHART_HEIGHT, CHART_ANIMATION, MARKER_TYPE, DISPLAY_ATTR, MARGINS, CUSTOM_COLORS, BGTYPE, X_AXIS_GROUP_SEP, Y_AXIS_GROUP_SEP, NAMES_FONT, NAMES_ROTATION, VALUES_FONT, VALUES_ROTATION, HINTS_FONT, LEGEND_FONT, CHART_TITLE_FONT, X_AXIS_TITLE_FONT, Y_AXIS_TITLE_FONT, SHOW_LEGEND, LEGEND_LAYOUT, CMODE, ENABLE_3D)
 Values
   (460, 'CategorizedVertical', '95%', '300', 
    'Appear', 'None', 'Y:Y:Y::Y:Y::::::V:T:N:B:', ':::', 
    'Y:Y:Y:Y', 'T', 
    'Y', 'Y', 'Arial:10:', 0, 'Arial:10:#000000', 0, 'Arial:10:', 'Arial:10:#000000', 'Arial:10:', 'Arial:10:#000000', 'Arial:10:#000000', 'R', 'V', 'Stacked', 'True');
COMMIT;
